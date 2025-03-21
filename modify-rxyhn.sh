#!/usr/bin/env bash

find "/home/$USER/.local/share/nvim/" -type f -exec sed -i 's/131e22/020d11/g' '{}' \;
find "/home/$USER/.local/share/nvim/" -type f -exec sed -i 's/D9D7D6/A9A9A9/g' '{}' \;
