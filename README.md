```
export MACHINE_NAME=<whatever you want to call your machine>
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo hostname $MACHINE_NAME

brew bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/BrentWheeldon/dotfiles
ln -sf {`pwd`/dotfiles/,~/.}bash_profile
ln -s {`pwd`/dotfiles/,~/.}gitconfig
ln -s {`pwd`/dotfiles/,~/.}inputrc
mkdir -p ~/.config/nvim
ln -s {`pwd`/dotfiles/,~/.config/nvim/}init.vim
ln -s {`pwd`/dotfiles/,~/.}vimrc
ln -s {`pwd`/dotfiles/,~/.}gemrc
ln -s {`pwd`/dotfiles/,~/.}psqlrc
nvim +PluginInstall +qall
```

Add your git user details to `~/.gitconfig.local`:

```
[user]
  email = <email>
  name = <name>
```
