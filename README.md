# dotfiles
My personal Arch Linux dotfiles with an install script.

## Installation

### 1 - Install Arch
Install using `archinstall` and choose the desktop profile with i3-wm.  
Also make sure you don't create a seperate partition for /home (this may lead to storage problems with many pacman packages and docker images).

### 2 - Execute the install script
(optional) update pacman config with `sudo vim /etc/pacman.conf`:
- Uncomment `Color`
- Uncomment `ParallelDownloads = 5`
- Add `ILoveCandy`

Get and run the install script (WARNING: this will delete the `.config` folder!)
```sh
wget https://raw.githubusercontent.com/MikeMoolenaar/dotfiles/main/install.sh
chmod +x install.sh
bash install.sh
```

### Post-install steps
- Install the user.js settings file for Firefox (Firefox has to be started at least once before this works):
```sh
ln -s ~/.config/firefox/user.js ~/.mozilla/firefox/*default-release
```
- [Setup Github authentication](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key), the connection can be tested using `ssh -T git@github.com`
