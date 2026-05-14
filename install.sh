#!/bin/bash
set -e

sudo pacman -Syu

# Install base-devel and paru
if ! builtin type -p 'paru' >/dev/null 2>&1; then
  CWD=`pwd`
  tmpdir="$(command mktemp -d)"
  command cd "${tmpdir}" || return 1
  sudo pacman -Sy --needed --noconfirm base base-devel git
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd $CWD
fi

rm -rf ~/.config
git clone git@github.com:MikeMoolenaar/dotfiles.git ~/.config

# Setup dependencies
vim ~/.config/dependencies.sh

mapfile -t packages < <(grep -v ^\# ~/.config/dependencies.sh)

echo "Will install ${#packages[@]} dependencies:"
for line in "${packages[@]}"; do
    echo "$line"
done

read -p "\nContinue? (y/n): " response
if [ "$response" = "n" ] || [ "$response" = "N" ]; then
	exit 0
fi

for i in "${packages[@]}"; do paru -S --noconfirm $i; done

# Setup services
sudo systemctl enable bluetooth
if [[ $(which docker) ]]; then
    sudo systemctl enable docker.service
fi

chsh -s /bin/fish

# Setup Alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Install JetBrains Mono Nerd Font (patched with icons used in starship)
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d jetbrainsmono-temp
mv jetbrainsmono-temp/*.ttf ~/.local/share/fonts/
rm JetBrainsMono.zip
rm -r jetbrainsmono-temp
fc-cache -fv

# Git stuff
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global user.email "mmoolenaar9@gmail.com"
git config --global user.name "MikeMoolenaar"

# Install NodeJS
source /usr/share/nvm/init-nvm.sh
nvm install node

echo -e "\n\nAll done! Don't forget to update the monitor lines in '.config/hypr/hyprland.conf' and Waybar settings for the main monitor, then reboot."
