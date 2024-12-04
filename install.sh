#!/usr/bin/bash
source helper.sh

HERE="/home/$USER/dotfiles"

# I prefer doas
SUDO=$(which doas 2> /dev/null)
[ $? -eq 1 ] && SUDO=sudo

HYPR_WALL="$HERE/Wallpapers/hut.png"

# Comment out what you need not be installed:
dots-install::hyprland                # yes
dots-install::wallpaper $HYPR_WALL    # installed to hyprland's default wall0.png (/usr/share/hypr)
dots-install::fabric                  # isntall my fabric configuration for my bar and widgets
dots-install::shell                   # install my zsh configuration to ~/.zshrc
dots-install::neovim                  # install my neovim configuration
dots-install::applications            # install configs for rofi, alacritty, kitty, vencord
dots-install::neofetch                # install neofetch config
dots-install::matrix-iamb             # my iamb configuration
dots-install::fonts                   # fonts I use for software
dots-install::bins                    # some utility scripts I often use (installed to /usr/local/bin)
