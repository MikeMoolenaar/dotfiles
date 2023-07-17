echo "Still in progress, do not use lol"
exit 1

ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/vim/.vimrc ~/.vimrc

mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
