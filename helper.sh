dots-install::desktop() {
  echo "* creating hyprland+waybar symbolic links"
  ln -s "$HERE/hypr" "/home/$USER/.config/hypr"
  ln -s "$HERE/waybar" "/home/$USER/.config/waybar"
}

dots-install::neovim() {
  echo "* creating neovim symbolic link"
  ln -s "$HERE/nvim" "/home/$USER/.config/"
}

dots-install::shell() {
  echo "* creating zshrc symbolic link"
  ln -s "$HERE/zshrc" "/home/$USER/.zshrc"
}

dots-install::applications() {
  echo "* creating application symbolic links"
  mkdir -p ~/.config/kitty
  ln -s "$HERE/kitty.conf" "/home/$USER/.config/kitty/kitty.conf"

  mkdir -p ~/.config/alacritty
  ln -s "$HERE/alacritty.toml" "/home/$USER/.config/alacritty/alacritty.toml"

  ln -s "$HERE/rofi" "/home/$USER/.config/"

  mkdir -p ~/.config/Vencord/themes
  ln -s "$HERE/Vencord/themes/midnight.theme.css" "/home/$USER/.config/Vencord/themes/midnight.theme.css"
}

dots-install::fonts() {
  echo "* installing fonts in /usr/share/fonts"
  sudo mv fonts/* /usr/share/fonts
  echo "* reloading font cache"
  fc-cache -fv > /dev/null
}

