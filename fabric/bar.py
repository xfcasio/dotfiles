#!/usr/bin/env python3.12
import os, psutil, socket
from getpass import getuser
from os import getcwd
import pulsectl
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.shapes import Corner
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
from fabric.widgets.eventbox import EventBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.system_tray.widgets import SystemTray
from fabric.widgets.circularprogressbar import CircularProgressBar
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import Language, ActiveWindow, Workspaces, WorkspaceButton
from fabric.utils import (
    FormattedString,
    bulk_replace,
    invoke_repeater,
    get_relative_path,
)

AUDIO_WIDGET = True

if AUDIO_WIDGET is True:
    try:
        from fabric.audio.service import Audio
    except Exception as e:
        print(e)
        AUDIO_WIDGET = False


class VolumeWidget(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.audio = Audio()

        self.progress_bar = CircularProgressBar(
            name="volume-progress-bar", pie=True, size=24
        )

        self.event_box = EventBox(
            events="scroll",
            child=Overlay(
                child=self.progress_bar,
                overlays=Label(
                    label="",
                    style="margin: 0px 0px 0px 0px; font-size: 12px",  # to center the icon glyph
                ),
            ),
        )

        self.audio.connect("notify::speaker", self.on_speaker_changed)
        self.event_box.connect("scroll-event", self.on_scroll)
        self.add(self.event_box)

    def on_scroll(self, _, event):
        match event.direction:
            case 0:
                self.audio.speaker.volume += 8
            case 1:
                self.audio.speaker.volume -= 8
        return

    def on_speaker_changed(self, *_):
        if not self.audio.speaker:
            return
        self.progress_bar.value = self.audio.speaker.volume / 100
        self.audio.speaker.bind(
            "volume", "value", self.progress_bar, lambda _, v: v / 100
        )
        return


class StatusBar(Window):
    def __init__(self):
        super().__init__(
            name="bar",
            layer="top",
            anchor="left top right",
            #margin="2px 4px -3px 2px",
            exclusivity="auto",
            visible=False,
            all_visible=False,
        )

        self.pulse = pulsectl.Pulse('volume-manager')
        current_volume = self.pulse.sink_list()[0].volume.value_flat
        
        self.workspaces = Workspaces(
            name="workspaces",
            spacing=4,
            buttons_factory=lambda ws_id: WorkspaceButton(id=ws_id, label=None, orientation="h"),
            orientation = 'h'
        )

        self.battery = Box(
            spacing=4,
            orientation='h',
            style='margin: 2px;',
            children=[
                Box(
                    style="""
                        background-color: #041011;
                        border-color: #2a323a;
                        border-width: 2px 3px 2px 3px;
                        border-style: solid;
                        padding: 1px;
                        margin: 2px;
                    """,
                    children=Box(style=f"""
                        background-image: linear-gradient(#78B8a2, #78B8a2);
                        padding: 1px 0px 1px 25px;
                        margin: -1px 0px -1px -2px;
                        border-radius: 2px;
                        border-style: solid;
                        border-color: #333B3F;
                    """)
                ),
                Box(style="""
                    background-color: #2a323a;
                    margin: 5px 3px 5px -6px;
                    border-radius: 0px 2px 2px 0px;
                """)
            ]
        )

        self.volume = Box(
            name="volume-widget",
            spacing=4,
            orientation='h',
            children=[Box(
                    style=f"""
                        background-image: url("file:///home/{getuser()}/.config/fabric/svg/speaker.svg");
                        background-size: 10px;
                        background-position: center;
                        background-repeat: no-repeat;
                        min-width: 10px;
                        margin: -15px 0px -15px 0px;
                    """
                ), Box(
                    style="background-color: #333B3F",
                    children=[Box(
                        style=f"""
                            background-image: linear-gradient(45deg, #BC83E3, #6791C9);
                            padding: 1px 0px 1px {current_volume * 50/2}px;
                            margin: 0px {50 * (1 - current_volume / 2)}px 0px 0px;
                        """
                    )]
            )]
        )
        
#        self.connect('scroll-event', lambda _, event: self.increase_volume(event))
        self.connect('scroll-event', to_home)

        self.date_time = DateTime(name="date-time", h_align='center', formatters = ("%I:%M"))
        self.system_tray = SystemTray(name="system-tray", spacing=7, icon_size=16, orientation="h")

        self.ram_progress_bar = CircularProgressBar(
            name="ram-progress-bar", radial=True, size=15, line_width=4, spacing=1, padding=10
        )
        self.cpu_progress_bar = CircularProgressBar(
            name="cpu-progress-bar", radial=True, size=15, line_width=4, spacing=1, padding=10
        )

        self.status_container = Box(
            name="widgets-container",
            spacing=4,
            orientation="h",
            children=None
        )

        self.internet_connection = Box(
            style=f"""
                background-image: url("file:///home/{getuser()}/.config/fabric/svg/disconnected.svg");
                background-size: 22px;
                background-position: center;
                padding: 10px 10px 10px 10px;
                margin: -2px 1px -2px 1px;
                min-width: 8px;
                border-radius: 5px;
            """,
            spacing=4,
        )

        #self.status_container.add(VolumeWidget()) if AUDIO_WIDGET is True else None

        self.children = CenterBox(
            orientation="h",
            name="bar-inner",
            start_children = Box(
                name = "start-container",
                spacing=4,
                orientation="h",
                children=[
                    Box(
                        name="pfp-container",
                        children=[Box(
                            name="profile-pic",
                            style=f"""
                                background-image: url(\"file:///home/{getuser()}/.face.jpg\");
                                background-size: 20px;
                                background-position: center;
                                background-repeat: no-repeat;
                                padding: 10px 10px 10px 12px;
                                margin: 0px 0px 0px 1px;
                                border-radius: 7px;
                            """,
                        )]
                    ),
                    self.volume,
                    self.battery
                ]
            ),

            center_children = Box(
                name="middle-container",
                spacing=4,
                orientation="h",
                children=self.workspaces,
            ),

            end_children = Box(
                name="end-container",
                spacing=4,
                orientation="h",
                children=[
                    self.system_tray,
                    self.internet_connection,
                    # Corner(orientation='bottom-right', style='background: #000000;'),
                    Box(
                        name='radial-indicators',
                        spacing=1,
                        orientation="h",
                        children = [self.cpu_progress_bar, self.ram_progress_bar],
                        style = "background: #111A1F;"# padding: 6px 5px 6px 5px; border-radius: 5px; margin: 0px 0px 1px 0px;"
                    ),
                ],
            ),
        )

        invoke_repeater(5000, self.update_internet_status)
        invoke_repeater(5000, self.update_battery)
        invoke_repeater(8000, self.update_progress_bars)

        self.show_all()

    def update_progress_bars(self):
        self.ram_progress_bar.value = psutil.virtual_memory().percent / 100
        self.cpu_progress_bar.value = psutil.cpu_percent() / 100
        return True

    def update_battery(self):
        battery_percent = psutil.sensors_battery().percent

        if battery_percent == 100: battery_color = '#78B8a2'
        elif battery_percent >= 30: battery_color = '#78B892' 
        elif battery_percent >= 15: battery_color = '#ECD28B'
        else: battery_color = '#DF5B61'


        self.battery.children[0].children[0].set_style(f"""
            background-image: linear-gradient({battery_color}, {battery_color});
            padding: 1px 0px 1px {(2.5 * battery_percent / 10) + 1}px;
            margin: 1px {(2.5 * (100 - battery_percent) / 10) + 1}px 1px 1px;
            border-radius: 1px;
            border-style: solid;
            border-color: #333B3F;
        """)

        self.battery.children[0].set_style(f"""
            background-color: #041011;
            border-color: {battery_color};
            border-width: 1.6px 1.6px 1.6px 1.6px;
            border-style: solid;
            border-radius: 2px;
            padding: 1px;
            margin: 2px;
        """)

        self.battery.children[1].set_style(f"""
            background-color: {battery_color};
            margin: 4px 5px 4px -6px;
            border-radius: 0px 1.4px 1.4px 0px;
        """)

        return True

    def update_internet_status(self):
        widget_style = lambda is_connected: f"""
                background-image: url("file:///home/{getuser()}/.config/fabric/svg/{'connected' if is_connected else 'disconnected'}.svg");
                background-size: 22px;
                background-position: center;
                padding: 10px 10px 10px 10px;
                margin: -2px 1px -2px 1px;
                min-width: 8px;
                border-radius: 5px;
            """

        self.internet_connection.set_style(widget_style(is_connected_to_internet()))
        return True
    
    def increase_volume(self, event):
        default_sink = self.pulse.sink_list()[0]

        current_volume = default_sink.volume.value_flat
        scroll_direction = event.direction.as_integer_ratio()[0];
        
        if scroll_direction not in [1, 0]: return

        if scroll_direction == 1: # scroll down
            if current_volume - 0.2 < 0: return
            self.pulse.volume_set_all_chans(default_sink, current_volume - 0.2)
        else: # scroll up
            if current_volume + 0.2 > 2: return
            self.pulse.volume_set_all_chans(default_sink, current_volume + 0.2)
        
        volume = round(default_sink.volume.value_flat * 50 / 2)
        
        volume = 5 if volume < 5 else volume    ## this part is
        volume = 50 if volume > 45 else volume  ## just for aesthetics

        self.volume.children[1].children[0].set_style(f"""
            background-image: linear-gradient(45deg, #BC83E3, #367AED);
            padding: 1px 0px 1px {volume}px;
            margin: 0px {50 - volume}px 0px 0px;
        """)

class MyCorner(Box):
    def __init__(self, corner):
        super().__init__(
            name="corner-container",
            children=Corner(
                name="corner",
                orientation=corner,
                #style = 'margin: 40px;',# if 'right' in corner else 'margin: 0px 0px 0px 0px;',
                size=5,
            ),
        )

class Corners(Window):
    def __init__(self):
        super().__init__(
            name="corners",
            layer="top",
            anchor="top bottom left right",
            exclusivity="normal",
            pass_through=True,
            visible=False,
            all_visible=False,
        )

        self.all_corners = Box(
            name="all-corners",
            orientation="v",
            h_expand=True,
            v_expand=True,
            h_align="fill",
            v_align="fill",
            children=[
                Box(
                    name="top-corners",
                    orientation="h",
                    h_align="fill",
                    children=[
                        MyCorner("top-left"),
                        Box(h_expand=True),
                        MyCorner("top-right"),
                    ],
                ),
                Box(v_expand=True),
                Box(
                    name="bottom-corners",
                    orientation="h",
                    h_align="fill",
                    children=[
                        MyCorner("bottom-left"),
                        Box(h_expand=True),
                        MyCorner("bottom-right"),
                    ],
                ),
            ],
        )

        self.add(self.all_corners)

        self.show_all()

def is_connected_to_internet(host="1.0.0.1", port=53, timeout=3):
    try:
        socket.setdefaulttimeout(timeout)
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect((host, port))
        return True
    except socket.error:
        return False


def to_home(_, _event):
    os.system('hyprctl dispatch workspace 1')
    os.system('playerctl pause')

if __name__ == "__main__":
    bar = StatusBar()
    app = Application("bar", bar)
    corners = Corners()
    app.set_stylesheet_from_file(get_relative_path("bar.css"))

    app.run()
