dots-install::hyprland() {
  echo "* creating hyprland symbolic link"
  ln -fs "$HERE/hypr" "/home/$USER/.config/"
}

dots-install::wallpaper() {
  echo "* creating wallpaper symlink"
  $SUDO ln -fs "$1" /usr/share/hypr/wall0.png
}

dots-install::waybar() {
  echo "* creating waybar symbolic link"
  ln -fs "$HERE/waybar" "/home/$USER/.config/"
}

dots-install::fabric() {
  echo "* creating fabric symbolic link"
  ln -fs "$HERE/fabric" "/home/$USER/.config/"
}

dots-install::neovim() {
  echo "* creating neovim symbolic link"
  ln -fs "$HERE/nvim" "/home/$USER/.config/"
}

dots-install::shell() {
  echo "* creating zshrc symbolic link"
  ln -fs "$HERE/zshrc" "/home/$USER/.zshrc"
}

dots-install::applications() {
  echo "* creating application symbolic links"
  mkdir -p ~/.config/kitty
  ln -fs "$HERE/kitty.conf" "/home/$USER/.config/kitty/kitty.conf"

  mkdir -p ~/.config/alacritty
  ln -fs "$HERE/alacritty.toml" "/home/$USER/.config/alacritty/alacritty.toml"

  ln -fs "$HERE/rofi" "/home/$USER/.config/"

  mkdir -p ~/.config/Vencord/themes
  ln -fs "$HERE/Vencord/themes/rxyhn.theme.css" "/home/$USER/.config/Vencord/themes/rxyhn.theme.css"
}

dots-install::neofetch() {
  echo "* creating neofetch symbolic link"
  ln -fs "$HERE/neofetch" "/home/$USER/.config/"
}

dots-install::matrix-iamb() {
  echo "* creating iamb config symbolic links"
  ln -fs "$HERE/iamb" "/home/$USER/.config/"
}

dots-install::fonts() {
  echo "* installing fonts in /usr/share/fonts"
  $SUDO cp -r "$HERE/fonts/"* /usr/share/fonts
  echo "* reloading font cache"
  fc-cache -fv > /dev/null
}

dots-install::bins() {
  echo "* installing bin/* to /usr/local/bin/"
  $SUDO find bin -type f -exec ln -fs "$HERE/"{} "/usr/local/bin" \;
}
