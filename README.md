```
# Install and setup 1Password
# Install iTerm
export MACHINE_NAME=<whatever you want to call your machine>
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo hostname $MACHINE_NAME

./install.sh
# Set iTerm's settings to be pulled from config file
```

Add your git user details to `~/.gitconfig.local`:

```
[user]
  email = <email>
  name = <name>
```
