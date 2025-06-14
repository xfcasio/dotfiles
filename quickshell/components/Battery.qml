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
  property real batteryLevel: 0

  function getBatteryColor(percent) {
    if (percent === 100) return "#78B8a2"
    if (percent >= 30) return "#78B892"
    if (percent >= 15) return "#ECD28B"
    return "#DF5B61"
  }

  Layout.alignment: Qt.AlignHCenter
  width: 28
  height: 40
  radius: innerModulesRadius
  color: "#111A1F"

  Process {
    id: batteryProcess
    running: true
    command: [ "cat", "/sys/class/power_supply/BAT1/capacity" ]
    stdout: SplitParser {
      onRead: percent => batteryLevel = percent
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: { batteryProcess.running = true }
  }

  Rectangle {
    anchors.centerIn: parent
    width: 16
    height: 28
    color: "transparent"

    ColumnLayout {
      anchors.centerIn: parent
      spacing: 0

      Rectangle {
        Layout.alignment: Qt.AlignHCenter
        width: 10
        height: 2
        radius: 1
        color: "#A9B9B9"
      }

      Rectangle {
        width: 14
        height: 24
        radius: 1
        color: "#041011"
        border.color: "#A9B9B9"
        border.width: 0.5

        Rectangle {
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottomMargin: 2
          anchors.leftMargin: 2
          anchors.rightMargin: 2
          width: parent.width - 4
          height: Math.max(0, (parent.height - 4) * (batteryLevel / 100))
          radius: 0.3
          color: getBatteryColor(batteryLevel)
        }
      }
    }
  }
}
