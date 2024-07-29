if [ -f ~/.profile ]; then
  . ~/.profile
fi

if [ -f ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi
source <(kubectl completion bash)
