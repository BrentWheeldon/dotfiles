if [ "$(uname)" == "Darwin" ]; then
  export MAC=1

  if [[ "$(/usr/bin/uname -m)" == "arm64" ]]
  then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export LINUX=1
fi

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch

loopy() {
  local command="$1"
  local count="${2:-10}"

  for ((i=0;i<$count;i++)); do
    $command
  done
}

newtmux() {
  session_name="${1:-$(sed 's/\./-/g' <<<"$(basename `pwd`)")}"
  tmux attach-session -t "$session_name" && return
  tmux new-session -d -s "$session_name"
  tmux new-window -d -n vim "nvim; $SHELL"
  tmux new-window -d -n lazygit "lazygit; $SHELL"
  tmux attach-session -d -t "$session_name"
}

if [ -n "${MAC}" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export CLICOLOR=1
export DOCKER_SCAN_SUGGEST=false
export EDITOR=nvim
export ERL_AFLAGS="-kernel shell_history enabled"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow -g '!{.git,sorbet,vendor/cache}/*'"
export FZF_DEFAULT_OPTS='--preview="rougify -t monokai.sublime {}"'
export GPG_TTY=$(tty)
export HISTCONTROL=ignoreboth
export HISTFILESIZE=50000
export HISTSIZE=50000
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export LSCOLORS=ExFxCxDxBxegedabagacad
export PATH="$PATH:$HOME/node_modules/.bin:$HOME/bin"
export PS1="\[\e[00;32m\]\h\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]\[\e[01;36m\]\W\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\$(parse_git_branch)\[\e[0m\]\[\e[00;37m\]\$ \[\e[0m\]"

alias gitprune="git remote prune origin && git prune"
alias fixit="git add . -A && git commit --amend -CHEAD"
alias fixstructure="git reset db/structure.sql && sails db:migrate db:test:prepare && git add db/structure.sql && git rebase --continue"
alias gogogo="gpr && bundle && spring stop && sails db:migrate db:test:prepare"
alias got=git
alias gpr="default_branch=\$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'); git fetch origin \$default_branch && git rebase origin/\$default_branch"
alias gut=git
alias ll="ls -alh"
alias t="mix test"
alias wipit="git add . && git commit --no-verify -m wip"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

eval "$(atuin init bash)"

if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "/opt/homebrew/opt/asdf/libexec/asdf.sh"

. "/opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash"

eval "$(direnv hook bash)"
