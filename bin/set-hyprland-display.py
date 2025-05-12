#!/bin/env python
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('file', help='path to the hyprland.conf file to modify')

group = parser.add_mutually_exclusive_group()
group.add_argument('--laptop', action='store_true', help='map all hyprland workspaces to laptop monitor')
group.add_argument('--hdmi', action='store_true', help='map all hyprland workspaces to hdmi connected monitor')

args = parser.parse_args()

hdmi_to_laptop_map = {
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

    "monitor=eDP-1,disable\n": "## monitor=eDP-1,disable\n"
}

with open(args.file, 'r') as f: lines = f.readlines()

if args.laptop:
    with open(args.file, 'w') as f:
        for line in lines: f.write(hdmi_to_laptop_map.get(line, line))
elif args.hdmi:
    laptop_to_hdmi_map = { v: k for k, v in hdmi_to_laptop_map.items() }
    with open(args.file, 'w') as f:
        for line in lines: f.write(laptop_to_hdmi_map.get(line, line))
else:
    print('you must pick either --laptop or --hdmi')
    exit(1)
