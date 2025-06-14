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
  implicitHeight: childrenRect.height + 24
  width: 24
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

          width: 4
          Layout.preferredHeight: modelData.active ? 40 : 10
          radius: 1

          color: (modelData.active || hovered) ? "#6791C9" : "#333B3F"

          Behavior on Layout.preferredHeight {
            NumberAnimation {
              duration: 160
              easing.type: Easing.InOutQuart
            }
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
