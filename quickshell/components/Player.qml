import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects

Rectangle {
  Layout.alignment: Qt.AlignHCenter
  implicitHeight: playing ? 120 : 24
  width: 24
  radius: 2
  color: "#111A1F"

  property bool playing: false
  property string artUrl: ''

  Process {
    id: statusUpdater
    running: true
    command: [ "playerctl", "status" ]
    stdout: SplitParser {
      onRead: s => {
        if (s === "Playing") playing = true
        else playing = false
      }
    }
  }

  Process {
    id: artUrlUpdater
    running: true
    command: [ "playerctl", "metadata", "mpris:artUrl" ]
    stdout: SplitParser {
      onRead: art => {
        if (art && art.trim() !== "") artUrl = art.trim();
      }
    }
  }

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 1000
      easing.type: Easing.InOutQuart
    }
  }

  Timer {
    interval: 600
    running: true
    repeat: true
    onTriggered: {
      artUrlUpdater.running = true
      statusUpdater.running = true
    }
  }

  Rectangle {
    id: topHalf
    visible: height > 0
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 24
    anchors.left: parent.left
    anchors.right: parent.right
    height: playing ? 96 : 0
    radius: 2
    clip: true

    Behavior on height {
      NumberAnimation {
        duration: 1000
        easing.type: Easing.InOutQuart
      }
    }

    Image {
      anchors.fill: parent
      source: artUrl
      fillMode: Image.PreserveAspectCrop
      horizontalAlignment: Image.AlignHCenter
      verticalAlignment: Image.AlignVCenter
      cache: false

      Rectangle {
        anchors.fill: parent
        gradient: Gradient {
          GradientStop { position: 0.0; color: "#00000000" }
          GradientStop { position: 0.94; color: "#131B1F" }
        }
      }
    }
  }

  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: 24
    radius: 2
    color: "#111A1F"

    Image {
      anchors.centerIn: parent
      width: 12
      height: 12
      source: `file:///home/${username}/.config/quickshell/svg/headphones.svg`
    }
  }
}
