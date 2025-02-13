#!/usr/bin/bash

############# DEBUG #############
# SET TO `true` TO SEE ERRORS
DEBUG=true
#################################

$DEBUG \
  && REDIRECT_TARGET='/dev/stderr' \
  || REDIRECT_TARGET='/dev/null'

{
  source helper.sh
  
  HERE="/home/$USER/dotfiles"
  
  # I prefer doas
  SUDO=$(which doas 2> /dev/null)
  [ $? -eq 1 ] && SUDO=sudo
  
  HYPR_WALL="$HERE/Wallpapers/monstera.png"
  
  # NOTE: #######################################################
  #  for the bar to actually display your profile picture,      #
  #  make sure to put your JPEG profile picture in ~/.face.jpg  #
  #  and make sure It's between 23x23 to 25x25 pixels.          #
  ############################################################# #
  
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
} 2>$REDIRECT_TARGET
