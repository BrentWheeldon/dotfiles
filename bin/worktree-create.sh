#!/bin/bash
# Generic git worktree creation for Claude worktree sessions (used by the
# `worktmux` bashrc function). Handles everything that's the same across
# every repo; anything repo-specific (ports, env files, DB provisioning...)
# belongs in that repo's own ./.local/worktree-setup.sh, which is run here
# if present.
#
# Usage: worktree-create.sh <name> [git-root] [options...]
# Any options (e.g. --skip-db) are forwarded verbatim to worktree-setup.sh
# for it to interpret. Prints the worktree path on success.

set -e

NAME="$1"
if [[ -z "$NAME" ]]; then
  echo "Usage: worktree-create.sh <name> [git-root] [options...]" >&2
  exit 1
fi
shift

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [[ $# -gt 0 && "$1" != -* ]]; then
  GIT_ROOT="$1"
  shift
fi
# Remaining args are options to forward to worktree-setup.sh

cd "$GIT_ROOT"
WORKTREE_DIR="$GIT_ROOT/.claude/worktrees"
WORKTREE_PATH="$WORKTREE_DIR/$NAME"
BRANCH_NAME="$(whoami)/$NAME"

if [[ -d "$WORKTREE_PATH" ]]; then
  # Already set up (e.g. after a reboot) — nothing to do.
  echo "$WORKTREE_PATH"
  exit 0
fi

mkdir -p "$WORKTREE_DIR"

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  echo "Reusing existing branch: $BRANCH_NAME" >&2
  git worktree add "$WORKTREE_PATH" "$BRANCH_NAME" >&2
else
  BASE=$(git rev-parse --abbrev-ref HEAD)
  echo "Creating branch $BRANCH_NAME from $BASE" >&2
  git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" HEAD >&2
fi

# Share settings.local.json from the git root so permissions granted in any
# worktree session are immediately visible in all others.
if [[ -f "$GIT_ROOT/.claude/settings.local.json" ]]; then
  mkdir -p "$WORKTREE_PATH/.claude"
  ln -sf "$GIT_ROOT/.claude/settings.local.json" "$WORKTREE_PATH/.claude/settings.local.json"
fi

# Process .worktreeinclude: copy files so each worktree can override them
# independently; symlink directories (e.g. node_modules).
if [[ -f "$GIT_ROOT/.worktreeinclude" ]]; then
  while IFS= read -r item || [[ -n "$item" ]]; do
    [[ -z "$item" ]] && continue
    src="$GIT_ROOT/$item"
    [[ ! -e "$src" ]] && continue
    mkdir -p "$WORKTREE_PATH/$(dirname "$item")"
    if [[ -d "$src" ]]; then
      rm -rf "$WORKTREE_PATH/$item"
      ln -s "$src" "$WORKTREE_PATH/$item"
      # Skip-worktree any tracked files under this directory so they don't show as deleted
      git -C "$WORKTREE_PATH" ls-files "$item" | while IFS= read -r tracked; do
        git -C "$WORKTREE_PATH" update-index --skip-worktree "$tracked"
      done
      # Exclude the symlink itself from git status (written to common git dir, not committed)
      git_common_dir=$(git -C "$WORKTREE_PATH" rev-parse --git-common-dir)
      mkdir -p "$git_common_dir/info"
      grep -qsF "/$item" "$git_common_dir/info/exclude" || echo "/$item" >> "$git_common_dir/info/exclude"
    else
      cp "$src" "$WORKTREE_PATH/$item"
    fi
  done < "$GIT_ROOT/.worktreeinclude"
fi

# Repo-specific setup: ports, env files, DB provisioning, etc.
SETUP_HOOK="$GIT_ROOT/.local/worktree-setup.sh"
if [[ -x "$SETUP_HOOK" ]]; then
  WORKTREE_NAME="$NAME" WORKTREE_PATH="$WORKTREE_PATH" GIT_ROOT="$GIT_ROOT" BRANCH_NAME="$BRANCH_NAME" \
    "$SETUP_HOOK" "$@" >&2
fi

echo "$WORKTREE_PATH"
