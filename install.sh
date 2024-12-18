#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1

set -e
set -x

if [ "$(uname)" == "Darwin" ]; then
  export MAC=1

  if [[ "$(/usr/bin/uname -m)" == "arm64" ]]
  then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export LINUX=1
fi

if [ -n "${MAC}" ]; then
  # Initialize sudo (which is required by homebrew install
  sudo hostname
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
  defaults write com.apple.desktopservices DSDontWriteNetworkStores true

  (brew info > /dev/null) || (NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

  DIFF_HIGHLIGHT_PATH=$(brew --prefix)/share/git-core/contrib/diff-highlight/
  BIN_PATH=/usr/local/bin/
  LAZYGIT_CONFIG_DIR=$HOME/Library/Application\ Support/lazygit/

  brew bundle
  brew link --overwrite node@16

  curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
  kubectl completion bash >$(brew --prefix)/etc/bash_completion.d/kubectl
elif [ -n "${LINUX}" ]; then
  DIFF_HIGHLIGHT_PATH=/usr/share/doc/git/contrib/diff-highlight/
  BIN_PATH=/usr/bin/
  LAZYGIT_CONFIG_DIR=$HOME/.config/lazygit/

  sudo apt-get update && sudo apt-get install -y git bash-completion ripgrep curl tmux

  BINARY_DOWNLOADS_PATH=~/binary-downloads
  mkdir -p $BINARY_DOWNLOADS_PATH
  cd $BINARY_DOWNLOADS_PATH

  curl -L -o lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.29/lazygit_0.29_Linux_x86_64.tar.gz
  tar -xzf lazygit.tar.gz
  sudo ln -sf $(pwd)/lazygit $BIN_PATH
  curl -L -o neovim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
  tar -xzf neovim.tar.gz
  sudo ln -sf $(pwd)/nvim-linux64/bin/nvim $BIN_PATH

  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs

  cd -
fi

cd $DIFF_HIGHLIGHT_PATH
sudo make
sudo cp -f diff-highlight $BIN_PATH
sudo chmod +x $BIN_PATH/diff-highlight
cd -

rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

BASE_DIRECTORY=$(readlink -f $(dirname "${BASH_SOURCE[0]}"))

ln -sf {$BASE_DIRECTORY/,$HOME/.}bashrc
ln -sf {$BASE_DIRECTORY/,$HOME/.}bash_profile
ln -sf {$BASE_DIRECTORY/,$HOME/.}bash-preexec.sh
ln -sf {$BASE_DIRECTORY/,$HOME/.}gitconfig
ln -sf {$BASE_DIRECTORY/,$HOME/.}gitignore_global
ln -sf {$BASE_DIRECTORY/,$HOME/.}inputrc
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.vim-tmp/backup
ln -sf {$BASE_DIRECTORY/,$HOME/.config/nvim/}init.vim
ln -sf {$BASE_DIRECTORY/,$HOME/.config/nvim/}plugins.vim
ln -sf {$BASE_DIRECTORY/,$HOME/.config/nvim/}coc-settings.json
ln -sf {$BASE_DIRECTORY/,$HOME/.}vimrc
ln -sf {$BASE_DIRECTORY/,$HOME/.}gemrc
ln -sf {$BASE_DIRECTORY/,$HOME/.}psqlrc
ln -sf {$BASE_DIRECTORY/,$HOME/.}tmux.conf
ln -sf {$BASE_DIRECTORY/,$HOME/.}tmux-overmind.conf
mkdir -p "$LAZYGIT_CONFIG_DIR"
ln -sf {$BASE_DIRECTORY/lazygit_,"$LAZYGIT_CONFIG_DIR"}config.yml

nvim -u $HOME/.config/nvim/plugins.vim --headless -c "PlugInstall | qa"
nvim -u $HOME/.config/nvim/plugins.vim --headless -c "TSInstall! elixir | qa"
nvim -u $HOME/.config/nvim/plugins.vim --headless -c "CocInstall coc-solargraph | qa"

touch $HOME/.gitconfig.local
touch $HOME/.bash_profile.local
touch $HOME/.bashrc.local

mkdir -p $HOME/.ssh/sockets/

if [ -n "${MAC}" ]; then
  grep -q "$HOMEBREW_PREFIX/bin/bash" /etc/shells || sudo sh -c "echo \"$HOMEBREW_PREFIX/bin/bash\" >> /etc/shells"
  chsh -s $HOMEBREW_PREFIX/bin/bash
  grep -q "helper = osxkeychain" ~/.gitconfig.local || echo -e "[credential]\n  helper = osxkeychain" >> ~/.gitconfig.local
fi
