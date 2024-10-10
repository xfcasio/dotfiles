#!/usr/bin/bash
source helper.sh

HERE="/home/$USER/dotfiles"

# Comment out what you need not be installed:
dots-install::desktop
dots-install::shell
dots-install::neovim
dots-install::applications
dots-install::matrix-iamb
dots-install::fonts
