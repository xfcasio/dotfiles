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
  Layout.topMargin: 2
  width: 32
  height: 32
  radius: innerModulesRadius
  color: "#111A1F"
  clip: true

  Rectangle {
    anchors.centerIn: parent
    radius: 8
    width: 26
    height: 24
    clip: true
    color: "transparent"

    Image {
      anchors.fill: parent
      source: `file:///home/${username}/.face.jpg`
      fillMode: Image.PreserveAspectCrop
      scale: 1.2

      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Rectangle {
          width: 20
          height: 18
          radius: 10
        }
      }
    }
  }
}
