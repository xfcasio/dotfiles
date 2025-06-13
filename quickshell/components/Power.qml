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
  Layout.topMargin: 4
  height: 24
  width: 24
  radius: innerModulesRadius
  color: "#111A1F"

  Image {
    anchors.centerIn: parent
    width: 14
    height: 14
    source: `file:///home/${username}/.config/quickshell/svg/power.svg`
  }
}
