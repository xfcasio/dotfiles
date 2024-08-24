#!/usr/bin/sh
cp -r hypr nvim waybar ~/.config/
cp zshrc ~/.zshrc

mkdir -p ~/.config/kitty
cp kitty.conf ~/.config/kitty

mkdir -p ~/.config/alacritty
cp alacritty.toml ~/.config/alacritty/

mkdir -p ~/.config/rofi
cp -r rofi ~/.config/
