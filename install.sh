#!/usr/bin/sh
cp -r hypr nvim waybar ~/.config/
cp zshrc ~/.zshrc

[ -d ~/.config/kitty ]              \
  && cp kitty.conf ~/.config/kitty  \
  || ( mkdir ~/.config/kitty && cp kitty.conf ~/.config/kitty )
