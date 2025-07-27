# dotfiles
My personal Arch Linux dotfiles with installation script.

- **Window system** Wayland
- **Compsitor** Hyprland
- **Terminal** Alacritty
- **Shell** Zsh (with Oh My Zsh)
- **File manager** Ranger
- **Text editor** Neovim

## Installation

### 1 - Install Arch
Install using `archinstall`:
- Choose the desktop profile with `hyprland`
- Select the "en_US.UTF-8" and "nl_NL.UTF-8" locales
- Make sure you don't create a separate partition for /home (this may lead to storage problems with many pacman packages and docker images).

### 2 - Setup hyprland
Force gdm to list wayland sessions (not sure if both are needed)
```
ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
echo "MUTTER_DEBUG_KMS_THREAD_TYPE=user" >> /etc/environment
```

#### 2.1 - Nvidia steps
Make sure [the kernel is configured correctly](https://wiki.hyprland.org/Nvidia/#drm-kernel-mode-setting).

Steps to make suspend work:
```sh
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

sudo vim /etc/modprobe.d/nvidia.conf
# Add new line: `options nvidia NVreg_PreserveVideoMemoryAllocations=1`

sudo reboot now
```


### 3 - Execute the install script
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
- When multiple browsers are installed, setup the default one: `xdg-settings set default-web-browser firefox.desktop`
- Download a nice wallpaper and put it here: `~/backgrounds/main.jpg`
