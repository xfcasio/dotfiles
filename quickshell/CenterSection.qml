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
  Layout.fillHeight: true
  Layout.fillWidth: true
  color: "transparent"

  Rectangle {
    anchors.centerIn: parent
    height: {
      let totalHeight = 0
      let spacing = 3
      let workspaceCount = Hyprland.workspaces.values.length

      // Base height: inactive workspaces (10px each) + one active (40px) + spacing
      totalHeight = (workspaceCount - 1) * 10 + 40 + (workspaceCount - 1) * spacing
      return totalHeight + 12 // +12 for padding
    }
    width: 18
    radius: 2
    color: "#111A1F"

    ColumnLayout {
      anchors.centerIn: parent
      spacing: 3

      ColumnLayout {
        spacing: 3

        Repeater {
          model: Hyprland.workspaces

          Rectangle {
            required property var modelData
            property bool hovered: false

            width: 6
            Layout.preferredHeight: modelData.active ? 40 : 10
            radius: 1

            color: (modelData.active || hovered) ? "#6791C9" : "#333B3F"

            Behavior on Layout.preferredHeight {
              NumberAnimation { duration: 80; easing.type: Easing.OutCubic }
            }

            MouseArea {
              anchors.fill: parent
              onClicked: Hyprland.dispatch(`workspace ${modelData.id.toString()}`)

              hoverEnabled: true
              onEntered: { parent.hovered = true }
              onExited: { parent.hovered = false }
            }
          }
        }
      }
    }
  }
}
