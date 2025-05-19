#!/bin/env python
import argparse

parser = argparse.ArgumentParser()

group = parser.add_mutually_exclusive_group()
group.add_argument('--laptop', action='store_true', help='map all hyprland workspaces to laptop monitor')
group.add_argument('--hdmi', action='store_true', help='map all hyprland workspaces to hdmi connected monitor')

args = parser.parse_args()

hdmi_to_laptop_map = {
    "./hypr/hyprland.conf": {
        "monitor = HDMI-A-1, 1366x768@59.79Hz, auto, 1\n": "monitor = , 1920x1080, auto, 1\n",

        "workspace = 1, monitor:HDMI-A-1\n": "workspace = 1, monitor:eDP-1\n",
        "workspace = 2, monitor:HDMI-A-1\n": "workspace = 2, monitor:eDP-1\n",
        "workspace = 3, monitor:HDMI-A-1\n": "workspace = 3, monitor:eDP-1\n",
        "workspace = 4, monitor:HDMI-A-1\n": "workspace = 4, monitor:eDP-1\n",
        "workspace = 5, monitor:HDMI-A-1\n": "workspace = 5, monitor:eDP-1\n",
        "workspace = 6, monitor:HDMI-A-1\n": "workspace = 6, monitor:eDP-1\n",
        "workspace = 7, monitor:HDMI-A-1\n": "workspace = 7, monitor:eDP-1\n",
        "workspace = 8, monitor:HDMI-A-1\n": "workspace = 8, monitor:eDP-1\n",
        "workspace = 9, monitor:HDMI-A-1\n": "workspace = 9, monitor:eDP-1\n",
        "workspace = 10, monitor:HDMI-A-1\n": "workspace = 10, monitor:eDP-1\n",

        "monitor=eDP-1,disable\n": "monitor=HDMI-A-1,disable\n"
    },

    "./alacritty.toml": {
        "size = 8.3\n": "size = 12\n"
    }
}


if args.laptop:
    for file in hdmi_to_laptop_map.keys():
        print(f'modifying {file}')
        with open(file, 'r') as f: lines = f.readlines()
        with open(file, 'w') as f:
            for line in lines: f.write(hdmi_to_laptop_map[file].get(line, line))
elif args.hdmi:
    for file, hl_map in hdmi_to_laptop_map.items():
        print(f'modifying {file}')
        laptop_to_hdmi_map = { v: k for k, v in hl_map.items() }
        with open(file, 'r') as f: lines = f.readlines()
        with open(file, 'w') as f:
            for line in lines: f.write(laptop_to_hdmi_map.get(line, line))
else:
    print('you must pick either --laptop or --hdmi')
    exit(1)
