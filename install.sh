#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1

set -e
set -x

if [ "$(uname)" == "Darwin" ]; then
  export MAC=1
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export LINUX=1
fi

brew info > /dev/null || (NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

if [ -n "${MAC}" ]; then
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

  BIN_PATH=/usr/local/bin/
  LAZYGIT_CONFIG_DIR=$HOME/Library/Application\ Support/lazygit/

  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -n "${LINUX}" ]; then
  BIN_PATH=/usr/bin/
  LAZYGIT_CONFIG_DIR=$HOME/.config/lazygit/

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle
brew link --overwrite node@16

cd $(brew --prefix)/share/git-core/contrib/diff-highlight/
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
ln -sf {$BASE_DIRECTORY/,$HOME/.}gitconfig
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

touch $HOME/.gitconfig.local
touch $HOME/.bash_profile.local
touch $HOME/.bashrc.local

mkdir -p $HOME/.ssh/sockets/

if [ -n "${MAC}" ]; then
  grep -q "/usr/local/bin/bash" /etc/shells || sudo sh -c 'echo "/usr/local/bin/bash" >> /etc/shells'
  chsh -s /usr/local/bin/bash
  grep -q "helper = osxkeychain" ~/.gitconfig.local || echo -e "[credential]\n  helper = osxkeychain" >> ~/.gitconfig.local
fi
