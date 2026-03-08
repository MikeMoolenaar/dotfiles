# dotfiles
My personal Arch Linux dotfiles with installation script.

- **Window system** Wayland
- **Compsitor** Hyprland
- **Terminal** Alacritty
- **Shell** Zsh (with Oh My Zsh)
- **File manager** Ranger
- **Text editor** Neovim

## Installation

### Install Arch
Install using `archinstall`:
- Choose the desktop profile with `hyprland`
- Make sure you don't create a separate partition for /home (this may lead to storage problems with many pacman packages and docker images).

### Execute the install script
(optional) update pacman config with `sudo vim /etc/pacman.conf`:
- Uncomment `Color`
- Add `ILoveCandy`

Get and run the install script (WARNING: this will delete the `.config` folder!)
```sh
wget https://raw.githubusercontent.com/MikeMoolenaar/dotfiles/main/install.sh
chmod +x install.sh
bash install.sh
```

### Post-install steps
- Install the user.js settings file for Firefox (Firefox has to be started at least once before this works):
- [Setup Github authentication](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key), the connection can be tested using `ssh -T git@github.com`
- When multiple browsers are installed, setup the default one: `xdg-settings set default-web-browser firefox.desktop`
- Download a nice wallpaper and put it here: `~/backgrounds/main.jpg`
