dots-install::hyprland() {
  echo "* creating hyprland symbolic link"
  ln -s "$HERE/hypr" "/home/$USER/.config/"
}

dots-install::wallpaper() {
  echo "* creating wallpaper symlink"
  $SUDO rm -f /usr/share/hypr/wall0.png
  $SUDO ln -s "$1" /usr/share/hypr/wall0.png
}

dots-install::waybar() {
  echo "* creating waybar symbolic link"
  ln -s "$HERE/waybar" "/home/$USER/.config/"
}

dots-install::fabric() {
  echo "* creating fabric symbolic link"
  ln -s "$HERE/fabric" "/home/$USER/.config/"
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

dots-install::neofetch() {
  echo "* creating neofetch symbolic link"
  ln -s "$HERE/neofetch" "/home/$USER/.config/"
}

dots-install::matrix-iamb() {
  echo "* creating iamb config symbolic links"
  ln -s "$HERE/iamb" "/home/$USER/.config/"
}

dots-install::fonts() {
  echo "* installing fonts in /usr/share/fonts"
  $SUDO cp -r "$HERE/fonts/"* /usr/share/fonts
  echo "* reloading font cache"
  fc-cache -fv > /dev/null
}

dots-install::bins() {
  echo "* installing bin/* to /usr/local/bin/"
  $SUDO find bin -type f -exec ln -s "$HERE/"{} "/usr/local/bin" \;
}
