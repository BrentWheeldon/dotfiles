#!/bin/bash
# Generic git worktree teardown (used by the `rmworktree` bashrc function).
# Runs the repo's own ./.local/worktree-teardown.sh (if present) while the
# worktree still exists, so it can do things like drop per-worktree
# databases, then removes the git worktree and its branch.
#
# Usage: worktree-remove.sh <name> [git-root]

set -e

NAME="$1"
GIT_ROOT="${2:-$(git rev-parse --show-toplevel)}"

if [[ -z "$NAME" ]]; then
  echo "Usage: worktree-remove.sh <name> [git-root]" >&2
  exit 1
fi

WORKTREE_PATH="$GIT_ROOT/.claude/worktrees/$NAME"
BRANCH_NAME="$(whoami)/$NAME"

TEARDOWN_HOOK="$GIT_ROOT/.local/worktree-teardown.sh"
if [[ -x "$TEARDOWN_HOOK" && -d "$WORKTREE_PATH" ]]; then
  WORKTREE_NAME="$NAME" WORKTREE_PATH="$WORKTREE_PATH" GIT_ROOT="$GIT_ROOT" BRANCH_NAME="$BRANCH_NAME" \
    "$TEARDOWN_HOOK" || echo "Warning: worktree-teardown.sh failed" >&2
fi

if git -C "$GIT_ROOT" worktree list | grep -q "$WORKTREE_PATH"; then
  git -C "$GIT_ROOT" worktree remove "$WORKTREE_PATH" --force
  echo "Removed worktree: $WORKTREE_PATH"
fi

if git -C "$GIT_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  git -C "$GIT_ROOT" branch -D "$BRANCH_NAME"
  echo "Deleted branch: $BRANCH_NAME"
fi
