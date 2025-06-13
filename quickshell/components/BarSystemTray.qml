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
  Layout.preferredHeight: childrenRect.height + 8
  visible: SystemTray.items.values.length
  width: 24
  radius: innerModulesRadius
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
