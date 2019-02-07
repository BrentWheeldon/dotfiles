parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch

loopy() {
  for i in {1..10}; do $1; done
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export CLICOLOR=1
export EDITOR=nvim
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--preview="rougify -t monokai.sublime {}"'
export GPG_TTY=$(tty)
export HISTCONTROL=ignoredups
export HISTFILESIZE=5000
export LSCOLORS=ExFxCxDxBxegedabagacad
export PS1="\[\e[00;32m\]\h\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]\[\e[01;36m\]\W\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\$(parse_git_branch)\[\e[0m\]\[\e[00;37m\]\$ \[\e[0m\]"

alias gitprune="git remote prune origin && git prune"
alias dails="docker/run spring rails"
alias dixstructure="git reset db/structure.sql && dails \"db:migrate db:test:prepare\" && git add db/structure.sql && git rebase --continue"
alias dspec="docker/run spring rspec"
alias dododo="gpr && docker/run \"bundle && spring stop && spring rails db:migrate db:test:prepare\""
alias fixit="git add . -A && git commit --amend -CHEAD"
alias fixstructure="git reset db/structure.sql && sails db:migrate db:test:prepare && git add db/structure.sql && git rebase --continue"
alias gogogo="gpr && bundle && spring stop && sails db:migrate db:test:prepare"
alias got=git
alias gpr="git fetch && git rebase origin/master"
alias gtx=gitx
alias gut=git
alias heroky=heroku
alias ll="ls -alh"
alias shutupvim="rm /var/tmp/*.swp"
alias sails="spring rails"
alias sspec="spring rspec"
alias wipit="git add . && git commit --no-verify -m wip"

if [ -f ~/.profile ]; then
  . ~/.profile
fi

if [ -f ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export GPG_TTY=$(tty)
