#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

if [ "$(uname)" == "Darwin" ]; then
  brew bundle
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  apt-get update && apt-get install -y git neovim bash-completion ripgrep fzf curl
fi

mkdir -p $HOME/bin

git clone https://github.com/git/git.git --single-branch $HOME/git
cd $HOME/git/contrib/diff-highlight
make
mv diff-highlight $HOME/bin/
cd -

git clone https://github.com/VundleVim/Vundle.vim.git --single-branch $HOME/.vim/bundle/Vundle.vim

ln -sf {`pwd`/,$HOME/.}bash_profile
ln -sf {`pwd`/,$HOME/.}gitconfig
ln -sf {`pwd`/,$HOME/.}inputrc
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.vim-tmp/backup
ln -sf {`pwd`/,$HOME/.config/nvim/}init.vim
ln -sf {`pwd`/,$HOME/.config/nvim/}plugins.vim
ln -sf {`pwd`/,$HOME/.}vimrc
ln -sf {`pwd`/,$HOME/.}gemrc
ln -sf {`pwd`/,$HOME/.}psqlrc
nvim -u plugins.vim -c "PluginInstall" -c "qa"

touch $HOME/.gitconfig.local
touch $HOME/.bash_profile.local
touch $HOME/
