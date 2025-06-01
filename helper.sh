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

dots-install::zsh() {
  echo "* creating zshrc symbolic link"
  ln -fs "$HERE/zshrc" "/home/$USER/.zshrc"
}

dots-install::nushell() {
  echo "* creating nushell symbolic link"
  mkdir -p "/home/$USER/.config/nushell"
  ln -fs "$HERE/nushell/env.nu" "/home/$USER/.config/nushell/env.nu"
  ln -fs "$HERE/nushell/config.nu" "/home/$USER/.config/nushell/config.nu"
  ln -fs "$HERE/nushell/git-status.nu" "/home/$USER/.config/nushell/git-status.nu"
}

dots-install::applications() {
  echo "* creating application symbolic links"
  mkdir -p ~/.config/kitty
  ln -fs "$HERE/kitty.conf" "/home/$USER/.config/kitty/kitty.conf"

  mkdir -p ~/.config/alacritty
  ln -fs "$HERE/alacritty.toml" "/home/$USER/.config/alacritty/alacritty.toml"

  ln -fs "$HERE/rofi" "/home/$USER/.config/"

  mkdir -p ~/.config/Vencord/themes
  ln -fs "$HERE/Vencord/themes/midnight-darker.theme.css" "/home/$USER/.config/Vencord/themes/midnight-darker.theme.css"
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

dots-install::cargo-config() {
  echo "* installing .cargo/config.toml to ~"
  mkdir -p ~/.cargo
  ln -fs "$HERE/.cargo/config.toml" "/home/$USER/.cargo/config.toml"
}

dots-install::fzf() {
  if ! command -v zsh &>/dev/null; then
    echo "[!] zsh isn't found, so can't set up fzf for it... skipping this module."
    return
  fi

  echo '* checking whether fzf is installed'

  if command -v fzf &>/dev/null; then
    [[ -f ~/.fzf.zsh ]] && return

    echo "fzf is installed but no ~/.fzf.zsh is found!"

    while true; do
      read -p "[?] Should I set it up automatically? (y/n): " answer
      case "$answer" in
        [Yy])
          echo "Generating ~/.fzf.zsh ..."
          if fzf --zsh > ~/.fzf.zsh; then
            echo '[+] Successfully set up ~/.fzf.zsh'
          else
            echo '[!] Failed to generate ~/.fzf.zsh'
          fi
          break
          ;;
        [Nn])
          echo "Skipping..."
          break
          ;;
        *)
          echo "Invalid option. Please pick either 'y' or 'n'."
          ;;
      esac
    done
  else
    echo ">>> fzf is not installed, fzf+zsh shell autocompletion will be missing."
  fi
}
