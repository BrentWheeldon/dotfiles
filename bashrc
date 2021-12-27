if [ "$(uname)" == "Darwin" ]; then
  export MAC=1
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export LINUX=1
fi

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch

loopy() {
  for i in {1..10}; do $1; done
}

newtmux() {
  session_name="${1:-$(sed 's/\./-/g' <<<"$(basename `pwd`)")}"
  tmux new-session -d -s "$session_name"
  tmux new-window -d -n vim "nvim; $SHELL"
  tmux new-window -d -n lazygit "lazygit; $SHELL"
  tmux attach-session -d -t "$session_name"
}

if [ -n "${MAC}" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

shopt -s histappend
PROMPT_COMMAND="history -a"

export CLICOLOR=1
export EDITOR=nvim
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--preview="rougify -t monokai.sublime {}"'
export GPG_TTY=$(tty)
export HISTCONTROL=ignoredups
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
alias gpr="git fetch && git rebase origin/HEAD"
alias gtx=gitx
alias gut=git
alias heroky=heroku
alias ll="ls -alh"
alias moarcommits="git fetch --unshallow 2> /dev/null || true"
alias shutupvim="rm /var/tmp/*.swp"
alias wipit="git add . && git commit --no-verify -m wip"

if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
