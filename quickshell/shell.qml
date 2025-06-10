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

Scope {
  id: root

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      Hyprland.dispatch("workspace 1")
      Mpris.players.values.forEach((player, idx) => player.pause())
    }
  }

  PwObjectTracker {
    id: pwObjectTraacker

    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  Process {
    id: batteryProcess
    running: true
    command: [ "cat", "/sys/class/power_supply/BAT1/capacity" ]
    stdout: SplitParser {
      onRead: percent => batteryLevel = percent
    }
  }

  Process {
    id: internetProcess
    running: true
    command: [ "ping", "-c1", "1.0.0.1" ]

    property string fullOutput: ""

    stdout: SplitParser {
      onRead: out => {
        internetProcess.fullOutput += out + "\n"
        if (out.includes("0% packet loss")) internetConnected = true
      }
    }

    // Or check when process finishes
    onExited: {
      internetConnected = fullOutput.includes("0% packet loss")
      fullOutput = "" // reset for next run
    }
  }

  // CPU monitoring
  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep '%Cpu(s):' | awk '{print $2}' | sed 's/%us,//'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        let usage = parseFloat(data.trim())
        if (!isNaN(usage)) root.cpuUsage = Math.round(usage)
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
    id: updateTimer
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      internetProcess.running = true
      batteryProcess.running = true
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      cpuProcess.running = true
      ramProcess.running = true
      currentTime = Qt.formatDateTime(new Date(), "hh:mm")
      currentHours = Qt.formatDateTime(new Date(), "hh")
      currentMinutes = Qt.formatDateTime(new Date(), "mm")
    }
  }


  // Audio stuff
  readonly property PwNode sink: Pipewire.defaultAudioSink

  property bool muted: sink?.audio?.muted ?? false
  property real volume: sink?.audio?.volume ?? 0

  // Date/time formatting
  property string currentTime: Qt.formatDateTime(new Date(), "hh:mm")
  property string currentHours: Qt.formatDateTime(new Date(), "hh")
  property string currentMinutes: Qt.formatDateTime(new Date(), "mm")

  // System info properties
  property real batteryLevel: 0
  property real cpuUsage: 0.3
  property real ramUsage: 0.6
  property bool internetConnected: false
  property real currentVolume: 0.5

  function getBatteryColor(percent) {
    if (percent === 100) return "#78B8a2"
    if (percent >= 30) return "#78B892"
    if (percent >= 15) return "#ECD28B"
    return "#DF5B61"
  }

  WlrLayershell {
    id: bar
    margins { top: 3; bottom: 5; left: 3 }
    anchors { top: true; bottom: true; left: true }

    layer: WlrLayer.Top

    implicitWidth: 34
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
