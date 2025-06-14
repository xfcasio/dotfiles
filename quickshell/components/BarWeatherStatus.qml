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
  width: 28
  height: 52
  color: "#111A1F"
  radius: innerModulesRadius

  property real temperature: 0

  Process {
    id: weatherProcess
    running: true
    command: [ "curl", "-s", "wttr.in/?format=%t" ]

    stdout: SplitParser {
      onRead: temp => { temperature = parseFloat(temp.replace(/[^\d.-]/g, '')); }
    }
  }

  Timer {
    interval: 100000
    running: true
    repeat: true
    onTriggered: { weatherProcess.running = true }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 1

    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      height: 20
      Image {
        anchors.centerIn: parent
        width: 20
        height: 20
        source: `file:///home/${username}/.config/quickshell/svg/weather.svg`
      }
    }

    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      Layout.leftMargin: 5
      height: 20
      Text {
        anchors.centerIn: parent
        text: `${temperature}°`
        color: "#E9967E"
        font.family: "Cartograph CF Heavy Italic"
        font.pixelSize: 11
      }
    }
  }
}
