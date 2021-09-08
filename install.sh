#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x


if [ "$(uname)" == "Darwin" ]; then
  DIFF_HIGHLIGHT_PATH=/usr/local/share/git-core/contrib/diff-highlight/
  BIN_PATH=/usr/local/bin/

  brew bundle
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  DIFF_HIGHLIGHT_PATH=/usr/share/doc/git/contrib/diff-highlight/
  BIN_PATH=/usr/bin/

  apt-get update && apt-get install -y git bash-completion ripgrep curl

  BINARY_DOWNLOADS_PATH=~/binary-downloads
  mkdir -p $BINARY_DOWNLOADS_PATH
  cd $BINARY_DOWNLOADS_PATH

  curl -L -o lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.29/lazygit_0.29_Linux_x86_64.tar.gz
  tar -xzf lazygit.tar.gz
  ln -s lazygit $BIN_PATH
  curl -L -o neovim.tar.gz https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-linux64.tar.gz
  tar -xzf neovim.tar.gz
  ln -sf nvim-linux64/bin/nvim $BIN_PATH

  cd -
fi

cd $DIFF_HIGHLIGHT_PATH
make
cp -f diff-highlight $BIN_PATH
cd -

rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

ln -sf {`pwd`/,$HOME/.}bashrc
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
nvim -u plugins.vim --headless -c "PlugInstall | qa"

touch $HOME/.gitconfig.local
touch $HOME/.bash_profile.local
touch $HOME/.bashrc.local
