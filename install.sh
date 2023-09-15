#!/bin/bash

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
git clone https://github.com/MikeMoolenaar/dotfiles.git ~/.config

# Setup dependencies
vim ~/.config/dependencies.sh

mapfile -t packages < <(grep -v "#" ~/.config/dependencies.sh)

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

# Setup zsh and vim
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/vim/.vimrc ~/.vimrc

chsh -s /bin/zsh
vim -c PlugInstall

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Setup Alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Git stuff
git config --global init.defaultBranch main
git config --global pull.rebase false

echo "All done! Don't forget to change the xrandr lines in .config/i3/config and then reboot."
