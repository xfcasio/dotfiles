#!/usr/bin/sh
HERE="/home/toji/dotfiles"

ln -s "$HERE/hypr" /home/toji/.config/hypr
ln -s "$HERE/nvim" /home/toji/.config/nvim
ln -s "$HERE/waybar" /home/toji/.config/waybar

ln -s "$HERE/zshrc" /home/toji/.zshrc

mkdir -p ~/.config/kitty
ln -s "$HERE/kitty.conf" /home/toji/.config/kitty/kitty.conf

mkdir -p ~/.config/alacritty
ln -s "$HERE/alacritty.toml" /home/toji/.config/alacritty/alacritty.toml


mkdir -p ~/.config/rofi
ln -s "$HERE/rofi" /home/toji/.config/rofi

mkdir -p ~/.config/Vencord
mkdir -p ~/.config/Vencord/themes
ln -s "$HERE/Vencord/themes/midnight.theme.css" /home/toji/.config/Vencord/themes/midnight.theme.css
