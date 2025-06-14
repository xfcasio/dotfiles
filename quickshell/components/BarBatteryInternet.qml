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
  height: 64
  color: "#111A1F"
  radius: innerModulesRadius

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 0

    // Battery Module
    QtObject {
      id: batteryModule
      property real batteryLevel: 0

      function getBatteryColor(percent) {
        if (percent === 100) return "#78B8a2"
        if (percent >= 30) return "#78B892"
        if (percent >= 15) return "#ECD28B"
        return "#DF5B61"
      }
    }

    Item {
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: 2
      width: 28
      height: 34

      Process {
        id: batteryProcess
        running: true
        command: [ "cat", "/sys/class/power_supply/BAT1/capacity" ]
        stdout: SplitParser {
          onRead: percent => batteryModule.batteryLevel = percent
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
            color: "#A3AEB0"
          }

          Rectangle {
            width: 14
            height: 24
            radius: 1
            color: "#041011"
            border.color: "#A3AEB0"
            border.width: 2

            Rectangle {
              anchors.centerIn: parent
              anchors.bottom: parent.bottom
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottomMargin: 2
              anchors.leftMargin: 2
              anchors.rightMargin: 2
              width: parent.width - 6
              height: Math.max(0, (parent.height - 6) * (batteryModule.batteryLevel / 100))
              radius: 0.3
              color: batteryModule.getBatteryColor(batteryModule.batteryLevel)
            }
          }
        }
      }
    }

    // Internet Module
    QtObject {
      id: internetModule
      property bool internetConnected: false
    }

    Item {
      Layout.alignment: Qt.AlignHCenter
      width: 28
      height: 22

      Process {
        id: internetProcess
        running: true
        command: [ "ping", "-c1", "1.0.0.1" ]

        property string fullOutput: ""

        stdout: SplitParser {
          onRead: out => {
            internetProcess.fullOutput += out + "\n"
            if (out.includes("0% packet loss")) internetModule.internetConnected = true
          }
        }

        onExited: {
          internetModule.internetConnected = fullOutput.includes("0% packet loss")
          fullOutput = ""
        }
      }

      Timer {
        id: updateTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
          internetProcess.running = true
        }
      }

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: 23
        height: 23
        source: `file:///home/${username}/.config/quickshell/svg/${internetModule.internetConnected ? 'connected' : 'disconnected'}.svg`
      }
    }
  }
}
