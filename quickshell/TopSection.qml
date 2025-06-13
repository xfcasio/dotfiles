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

Rectangle {
  Layout.fillWidth: true
  Layout.preferredHeight: columnLayout.implicitHeight + 12
  color: "transparent"

  property real innerModulesRadius: 3

  Behavior on Layout.preferredHeight {
    NumberAnimation {
      duration: 1000
      easing.type: Easing.InOutQuart
    }
  }

  // System info properties
  property real cpuUsage: 0.3
  property real ramUsage: 0.6

  property string username: ""


  Process {
    command: ["whoami"]
    running: true
    stdout: SplitParser { onRead: name => username = name }
  }

  // CPU monitoring
  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep '%Cpu(s):' | awk '{print $2}' | sed 's/%us,//'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        let usage = parseFloat(data.trim())
        if (!isNaN(usage)) cpuUsage = Math.round(usage)
      }
    }
  }

  // RAM monitoring  
  Process {
    id: ramProcess
    command: ["sh", "-c", "free | grep Mem: | awk '{printf \"%.0f\", ($2-$7)/$2*100}'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        let usage = parseInt(data.trim())
        if (!isNaN(usage)) ramUsage = usage
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      cpuProcess.running = true
      ramProcess.running = true
    }
  }

  ColumnLayout {
    id: columnLayout
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 2
    spacing: 6

    Components.BarProfilePicture {}
    Components.BarVolumeControl {}
    Components.Battery {}

    // CPU and RAM indicators
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 24
      height: 54
      radius: innerModulesRadius
      color: "#111A1F"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 3

        // CPU indicator
        Components.RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: cpuUsage
          indicatorColor: "#78B892"
          backgroundColor: "#333B3F"
          size: 20
        }

        // RAM indicator
        Components.RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: ramUsage
          indicatorColor: "#DF5B61"
          backgroundColor: "#333B3F"
          size: 20
        }
      }
    }
  }
}
