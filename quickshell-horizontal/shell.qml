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
    
    readonly property PwNode sink: Pipewire.defaultAudioSink

    property bool muted: sink?.audio?.muted ?? false
    property real volume: sink?.audio?.volume ?? 0

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
          if (out.includes("0% packet loss")) {
            internetConnected = true
          }
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
        }
    }

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

    // Date/time formatting
    property string currentTime: Qt.formatDateTime(new Date(), "hh:mm")

    WlrLayershell {
        id: bar
        margins {
          top: 3
          right: 8
          left: 5
        }
        anchors {
            top: true
            left: true
            right: true
        }
        
        layer: WlrLayer.Top
        
        implicitHeight: 32
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
          radius: 4
          color: "#000A0E"

          RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 8
            anchors.leftMargin: 4
            spacing: 2

            // Left section - Profile, Volume, Battery
            Rectangle {
              Layout.fillHeight: true
              Layout.preferredWidth: childrenRect.width
              color: "transparent"

              RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                // Profile picture
                Rectangle {
                  width: 28
                  height: 24
                  radius: 3
                  color: "#111A1F"
                  clip: true

                  Rectangle {
                    anchors.centerIn: parent
                    radius: 10
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
                          width: 20
                          height: 18
                          radius: 10
                        }
                      }
                    }
                  }
                }

                // Volume widget
                Rectangle {
                  width: 65
                  height: 18
                  radius: 3
                  color: "#111A1F"

                  RowLayout {
                    anchors.centerIn: parent
                    spacing: 3

                    // Speaker icon
                    Rectangle {
                      width: 10
                      height: 10
                      color: "transparent"

                      Image {
                        anchors.fill: parent
                        source: `file:///home/${Qt.application.arguments[0]?.split('/').pop() || 'toji'}/.config/fabric/svg/speaker.svg`
                        opacity: muted ? 0.6 : 1.0
                      }
                    }

                    // Volume bar
                    Rectangle {
                      width: 38
                      height: 6
                      color: "#333B3F"
                      radius: 1

                      Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: muted ? 2 : parent.width * volume
                        height: parent.height
                        radius: 1
                        gradient: Gradient {
                          orientation: Gradient.Horizontal
                          GradientStop { position: 0; color: "#BC83E3" }
                          GradientStop { position: 1; color: "#6791C9" }
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


                // Battery widget
                Rectangle {
                  width: 40
                  height: 20
                  radius: 3
                  color: "#111A1F"

                  Rectangle {
                    anchors.centerIn: parent
                    width: 30
                    height: 16
                    color: "transparent"

                    RowLayout {
                      anchors.centerIn: parent
                      spacing: 0

                      Rectangle {
                        width: 25
                        height: 12
                        radius: 2
                        color: "#041011"
                        border.color: getBatteryColor(batteryLevel)
                        border.width: 1.6

                        Rectangle {
                          anchors.left: parent.left
                          anchors.verticalCenter: parent.verticalCenter
                          anchors.leftMargin: 3  // 3px padding from left edge
                          anchors.topMargin: 3   // 3px padding from top
                          anchors.bottomMargin: 3 // 3px padding from bottom
                          width: Math.max(0, (parent.width - 6) * (batteryLevel / 100)) // -6 for left+right padding
                          height: parent.height - 6 // -6 for top+bottom padding
                          radius: 0.4
                          color: getBatteryColor(batteryLevel)
                        }
                      }

                      Rectangle {
                        width: 2
                        height: 6
                        radius: 1
                        color: getBatteryColor(batteryLevel)
                      }
                    }
                  }
                }
              }
            }

            // Center section - Workspaces
            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true
              color: "transparent"

              Rectangle {
                anchors.centerIn: parent
                width: {
                  let totalWidth = 0
                  let spacing = 2
                  let workspaceCount = Hyprland.workspaces.values.length

                  // Base width: inactive workspaces (10px each) + one active (40px) + spacing
                  totalWidth = (workspaceCount - 1) * 10 + 40 + (workspaceCount - 1) * spacing
                  return totalWidth + 22 // +22 for padding
                }
                height: 16
                radius: 3
                color: "#111A1F"

                RowLayout {
                  anchors.centerIn: parent
                  spacing: 2

                  RowLayout {
                    spacing: 3

                    Repeater {
                      model: Hyprland.workspaces

                      Rectangle {
                        required property var modelData
                        property bool hovered: false  // track hover state

                        Layout.preferredWidth: modelData.active ? 40 : 10
                        height: 4
                        radius: 1

                        // Color based on both active state and hover
                        color: (modelData.active || hovered) ? "#6791C9" : "#333B3F"

                        Behavior on Layout.preferredWidth {
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

            // Right section - System tray, network, indicators, time
            Rectangle {
              Layout.fillHeight: true
              Layout.preferredWidth: childrenRect.width
              color: "transparent"

              RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                // System Tray
                RowLayout {
                  spacing: 20

                  Rectangle {
                    Layout.preferredWidth: childrenRect.width + 14
                    height: 22
                    radius: 4
                    color: "#111A1F"

                    RowLayout {
                      anchors.centerIn: parent
                      spacing: 8

                      Repeater {
                        model: SystemTray.items

                        Rectangle {
                          required property var modelData
                          height: 15
                          width: 15
                          color: "transparent"

                          Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
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

                // Internet connection indicator
                Rectangle {
                  width: 22
                  height: 20
                  radius: 4
                  color: "#111A1F"

                  Image {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    source: `file:///home/${Qt.application.arguments[0]?.split('/').pop() || 'toji'}/.config/fabric/svg/${internetConnected ? 'connected' : 'disconnected'}.svg`
                  }
                }

                // CPU and RAM indicators
                Rectangle {
                  width: 50
                  height: 22
                  radius: 3
                  color: "#111A1F"

                  RowLayout {
                    anchors.centerIn: parent
                    height: 60
                    spacing: 2

                    // CPU indicator
                    RadialIndicator {
                      percent: cpuUsage
                      indicatorColor: "#78B892"
                      backgroundColor: "#333B3F"
                      size: 20
                    }

                    // RAM indicator
                    RadialIndicator {
                      percent: ramUsage
                      indicatorColor: "#DF5B61"
                      backgroundColor: "#333B3F"
                      size: 20
                    }
                  }
                }

                // Time display
                Rectangle {
                  width: timeText.width + 14
                  height: 22
                  radius: 4
                  color: "#111A1F"

                  Text {
                    id: timeText
                    anchors.centerIn: parent
                    text: currentTime
                    color: "#78B892"
                    font.family: "Cartograph CF Heavy Italic"
                    font.pixelSize: 14
                  }
                }
              }
            }
          }
        }
      }
    }

