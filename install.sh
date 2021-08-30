#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x


if [ "$(uname)" == "Darwin" ]; then
  brew bundle
  DIFF_HIGHLIGHT_PATH=/usr/local/share/git-core/contrib/diff-highlight/
  BIN_PATH=/usr/local/bin/
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  apt-get update && apt-get install -y git neovim bash-completion ripgrep curl netcat
  DIFF_HIGHLIGHT_PATH=/usr/share/doc/git/contrib/diff-highlight/
  BIN_PATH=/usr/bin/
fi

cd $DIFF_HIGHLIGHT_PATH
make
mv diff-highlight $BIN_PATH
cd -

rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all
mv $HOME/.fzf/bin/fzf $BIN_PATH

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
