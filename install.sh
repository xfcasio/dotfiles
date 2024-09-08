#!/usr/bin/sh
HERE="/home/$USER/dotfiles"

ln -s "$HERE/hypr" "/home/$USER/.config/hypr"
ln -s "$HERE/nvim" "/home/$USER/.config/nvim"
ln -s "$HERE/waybar" "/home/$USER/.config/waybar"

ln -s "$HERE/zshrc" "/home/$USER/.zshrc"

mkdir -p ~/.config/kitty
ln -s "$HERE/kitty.conf" "/home/$USER/.config/kitty/kitty.conf"

mkdir -p ~/.config/alacritty
ln -s "$HERE/alacritty.toml" "/home/$USER/.config/alacritty/alacritty.toml"


ln -s "$HERE/rofi" "/home/$USER/.config/"

mkdir -p ~/.config/Vencord/themes
ln -s "$HERE/Vencord/themes/midnight.theme.css" "/home/$USER/.config/Vencord/themes/midnight.theme.css"
