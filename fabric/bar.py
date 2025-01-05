#!/usr/bin/python3.12
import os, psutil
from subprocess import check_output
from getpass import getuser
from os import getcwd
from fabric import Application
from fabric.widgets.box import Box
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
            margin="2px 4px -3px 2px",
            exclusivity="auto",
            visible=False,
            all_visible=False,
        )
        self.workspaces = Workspaces(
            name="workspaces",
            spacing=4,
            buttons_factory=lambda ws_id: WorkspaceButton(id=ws_id, label=None, orientation="h"),
            orientation = 'h'
        )
        self.date_time = DateTime(name="date-time", h_align='center', formatters = ("%I:%M"))
        self.system_tray = SystemTray(name="system-tray", spacing=4, icon_size=16, orientation="h")

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
            name="internet-container",
            spacing=4,
        )
        
        self.status_container.add(VolumeWidget()) if AUDIO_WIDGET is True else None

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
                        children=[
                    Box(
                        name="profile-pic",
                        style=f"""
                              background-image: url(\"file:///home/{getuser()}/.face.jpg\");
                              padding: 10px 10px 10px 12px;
                              margin: 0px 0px 0px 1px;
                              border-radius: 7px;
                            """,
                    )
                        ]
                    )
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
                    ### self.internet_connection,
                    ### self.date_time,
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

        self.connect("scroll-event", self.on_scroll)

        #invoke_repeater(1000, self.update_internet_status)
        invoke_repeater(1000, self.update_progress_bars)

        self.show_all()

    def update_progress_bars(self):
        self.ram_progress_bar.value = psutil.virtual_memory().percent / 100
        self.cpu_progress_bar.value = psutil.cpu_percent() / 100
        return True

    def update_internet_status(self):
        print("test")
        ping_result = int(check_output(['ping', '1.0.0.1', '-c1']).decode('utf-8').split('\n')[-3].split(' ')[5][:1])
        if ping_result == 0: self.internet_connection.style = f"background-image: url(\"file://{getcwd()}/svg/connected.svg\")"
        return True
    
    def on_scroll(self, _, event):
        os.system('hyprctl dispatch workspace 1')
        os.system('playerctl pause')



if __name__ == "__main__":
    bar = StatusBar()
    app = Application("bar", bar)
    app.set_stylesheet_from_file(get_relative_path("bar.css"))

    app.run()
