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
import 'components' as Components

Scope {
  id: root

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      Hyprland.dispatch("workspace 1")
      Mpris.players.values.forEach((player, idx) => player.pause())
    }
  }

  Components.PopoutVolume {}

  WlrLayershell {
    id: bar
    margins { top: 3; bottom: 5; left: 3 }
    anchors { top: true; bottom: true; left: true }
    
    layer: WlrLayer.Top

    implicitWidth: 36
    color: "transparent"

    MouseArea {
      anchors.fill: parent
      onWheel: wheel => {
        Hyprland.dispatch("workspace 1")
        Mpris.players.values.forEach((player, idx) => player.pause())
      }
    }

    // The actual bar - Extra rect to achieve bar-rounding
    Rectangle {
      anchors.fill: parent
      color: "#000A0E"
      radius: 4

      Behavior on height {
        NumberAnimation {
          duration: 1000
          easing.type: Easing.InOutQuart
        }
      }

      ColumnLayout {
        anchors { fill: parent; topMargin: 3; bottomMargin: 6; leftMargin: 3; rightMargin: 3 }
        spacing: 4

        TopSection {}
        CenterSection {}
        BottomSection {}
      }
    }
  }
}
