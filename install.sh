#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

if [ "$(uname)" == "Darwin" ]; then
  export MAC=1
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export LINUX=1
fi

if [ -n "${MAC}" ]; then
  DIFF_HIGHLIGHT_PATH=/usr/local/share/git-core/contrib/diff-highlight/
  BIN_PATH=/usr/local/bin/

  brew bundle
elif [ -n "${LINUX}" ]; then
  DIFF_HIGHLIGHT_PATH=/usr/share/doc/git/contrib/diff-highlight/
  BIN_PATH=/usr/bin/

  sudo apt-get update && sudo apt-get install -y git bash-completion ripgrep curl tmux

  BINARY_DOWNLOADS_PATH=~/binary-downloads
  mkdir -p $BINARY_DOWNLOADS_PATH
  cd $BINARY_DOWNLOADS_PATH

  curl -L -o lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.29/lazygit_0.29_Linux_x86_64.tar.gz
  tar -xzf lazygit.tar.gz
  sudo ln -sf $(pwd)/lazygit $BIN_PATH
  curl -L -o neovim.tar.gz https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-linux64.tar.gz
  tar -xzf neovim.tar.gz
  sudo ln -sf $(pwd)/nvim-linux64/bin/nvim $BIN_PATH

  cd -
fi

cd $DIFF_HIGHLIGHT_PATH
make
sudo cp -f diff-highlight $BIN_PATH
sudo chmod +x $BIN_PATH/diff-highlight
cd -

rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

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
ln -sf {`pwd`/,$HOME/.}tmux.conf

nvim -u plugins.vim --headless -c "PlugInstall | qa"

touch $HOME/.gitconfig.local
touch $HOME/.bash_profile.local
touch $HOME/.bashrc.local

if [ -n "${MAC}" ]; then
  grep -q "helper = osxkeychain" ~/.gitconfig.local || echo -e "[credential]\n  helper = osxkeychain" >> ~/.gitconfig.local
fi
