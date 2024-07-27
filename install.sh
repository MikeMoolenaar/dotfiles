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
espanso service register

# Setup zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc

chsh -s /bin/zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Setup Alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Install JetBrains Mono font
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Install FiraCode font to get glyphs used in starship
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip -d firacode-temp
mv firacode-temp/FiraCodeNerdFont-Medium.ttf ~/.local/share/fonts/
rm FiraCode.zip
rm -r firacode-temp

# Git stuff
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global user.email "mmoolenaar9@gmail.com"
git config --global user.name "MikeMoolenaar"

# Install NodeJS
source /usr/share/nvm/init-nvm.sh
nvm install node

echo -e "\n\nAll done!Don't forget to update the xrandr lines in '.config/i3/config' and Polybar settings for the main monitor, then reboot."
