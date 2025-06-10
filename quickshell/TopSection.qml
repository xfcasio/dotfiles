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
    anchors.top: parent.top
    anchors.topMargin: 2
    spacing: 4

    // Profile picture
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 24
      height: 24
      radius: 2
      color: "#111A1F"
      clip: true

      Rectangle {
        anchors.centerIn: parent
        radius: 8
        width: 20
        height: 18
        clip: true
        color: "transparent"

        Image {
          anchors.fill: parent
          source: `file:///home/${Qt.application.arguments[0]?.split('/').pop() || 'toji'}/.face.jpg`
          fillMode: Image.PreserveAspectCrop
          scale: 1.2

          layer.enabled: true
          layer.effect: OpacityMask {
            maskSource: Rectangle {
              width: 16
              height: 14
              radius: 8
            }
          }
        }
      }
    }

    // Volume widget
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 22
      height: 60
      radius: 2
      color: "#111A1F"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 3

        // Speaker icon
        Rectangle {
          Layout.alignment: Qt.AlignHCenter
          width: 10
          height: 10
          color: "transparent"

          Image {
            anchors.fill: parent
            source: `file:///home/${Qt.application.arguments[0]?.split('/').pop() || 'toji'}/.config/fabric/svg/speaker.svg`
            opacity: muted ? 0.6 : 1.0
          }
        }

        // Volume bar (vertical)
        Rectangle {
          Layout.alignment: Qt.AlignHCenter
          width: 6
          height: 34
          color: "#333B3F"
          radius: 1

          Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: muted ? 1 : parent.height * volume
            radius: 1
            gradient: Gradient {
              orientation: Gradient.Vertical
              GradientStop { position: 0; color: "#6791C9" }
              GradientStop { position: 1; color: "#BC83E3" }
            }
          }
        }
      }

      MouseArea {
        anchors.fill: parent

        onClicked: { sink.audio.muted = !muted; }

        onWheel: wheel => {
          if (sink && !muted) {
            let delta = wheel.angleDelta.y > 0 ? 0.1 : -0.1
            let newVolume = volume + delta
            newVolume = Math.max(0, Math.min(1, newVolume))
            sink.audio.volume = newVolume
          }
        }
      }
    }

    // Internet connection indicator
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 22
      height: 24
      radius: 2
      color: "#111A1F"

      Image {
        anchors.centerIn: parent
        width: 20
        height: 20
        source: `file:///home/${Qt.application.arguments[0]?.split('/').pop() || 'toji'}/.config/fabric/svg/${internetConnected ? 'connected' : 'disconnected'}.svg`
      }
    }

    // System Tray
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredHeight: childrenRect.height + 6
      width: 22
      radius: 2
      color: "#111A1F"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 3

        Repeater {
          model: SystemTray.items

          Rectangle {
            required property var modelData
            Layout.alignment: Qt.AlignHCenter
            height: 16
            width: 16
            color: "transparent"

            Image {
              anchors.centerIn: parent
              width: 15
              height: 15
              source: modelData.icon
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                if (modelData.hasMenu) QsMenuAnchor.open(modelData.menu)
              }
            }
          }
        }
      }
    }
  }
}
