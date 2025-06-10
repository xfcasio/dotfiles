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
  Layout.fillWidth: true
  Layout.preferredHeight: childrenRect.height + 8
  color: "transparent"

  ColumnLayout {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 2
    spacing: 4

    // Battery widget
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 22
      height: 32
      radius: 2
      color: "#111A1F"

      Rectangle {
        anchors.centerIn: parent
        width: 14
        height: 24
        color: "transparent"

        ColumnLayout {
          anchors.centerIn: parent
          spacing: 0

          Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 8
            height: 2
            radius: 1
            color: getBatteryColor(batteryLevel)
          }

          Rectangle {
            width: 12
            height: 18
            radius: 1
            color: "#041011"
            border.color: getBatteryColor(batteryLevel)
            border.width: 1.2

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

    // CPU and RAM indicators
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 22
      height: 44
      radius: 2
      color: "#111A1F"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        // CPU indicator
        RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: cpuUsage
          indicatorColor: "#78B892"
          backgroundColor: "#333B3F"
          size: 18
        }

        // RAM indicator
        RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: ramUsage
          indicatorColor: "#DF5B61"
          backgroundColor: "#333B3F"
          size: 18
        }
      }
    }

    // Time display (two lines)
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 22
      height: 42
      radius: 2
      color: "#111A1F"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: currentHours
          color: "#78B892"
          font.family: "Cartograph CF Heavy"
          font.pixelSize: 13
        }

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: currentMinutes
          color: "#78B892"
          font.family: "Cartograph CF Heavy"
          font.pixelSize: 13
        }
      }
    }
  }
}
