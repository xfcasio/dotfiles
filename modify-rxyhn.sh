#!/usr/bin/env bash

find ~/.local/share/nvim -type f -exec sed -i 's/131e22/020d11/g' {} +
