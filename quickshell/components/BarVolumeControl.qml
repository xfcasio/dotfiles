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
  width: 24
  height: 74
  radius: innerModulesRadius
  color: "#111A1F"

  readonly property PwNode sink: Pipewire.defaultAudioSink

  property bool muted: sink?.audio?.muted ?? false
  property real volume: sink?.audio?.volume ?? 0
  property real currentVolume: 0.5
  property real lastVolume: 0

  
  PwObjectTracker {
    id: pwObjectTracker
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  SequentialAnimation {
    id: bounceAnimation
    PropertyAnimation {
      target: volumeBar
      property: "anchors.bottomMargin"
      to: -8
      duration: 120
      easing.type: Easing.OutBack
    }
    PropertyAnimation {
      target: volumeBar
      property: "anchors.bottomMargin"
      to: 10
      duration: 180
      easing.type: Easing.InOutBounce
    }
    PropertyAnimation {
      target: volumeBar
      property: "anchors.bottomMargin"
      to: -4
      duration: 140
      easing.type: Easing.OutBounce
    }
    PropertyAnimation {
      target: volumeBar
      property: "anchors.bottomMargin"
      to: 6
      duration: 100
      easing.type: Easing.InOutQuad
    }
    PropertyAnimation {
      target: volumeBar
      property: "anchors.bottomMargin"
      to: 0
      duration: 160
      easing.type: Easing.OutElastic
    }
  }

  onVolumeChanged: {
    if (Math.abs(volume - lastVolume) > 0.01) {
      bounceAnimation.start()
      lastVolume = volume
    }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 4

    // Speaker icon
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 12
      height: 12
      color: "transparent"

      Image {
        anchors.fill: parent
        source: `file:///home/${username}/.config/quickshell/svg/speaker.svg`
        opacity: muted ? 0.6 : 1.0
      }
    }

    // Volume bar (vertical)
    Rectangle {
      id: volumeBar
      Layout.alignment: Qt.AlignHCenter
      width: 6
      height: 42
      color: "#333B3F"
      radius: 1

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: {
          let len = muted ? 1 : parent.height * volume;
          return (len > 42) ? 42 : len;
        }
        radius: 1
        gradient: Gradient {
          orientation: Gradient.Vertical
          GradientStop { position: 0; color: "#6791C9" }
          GradientStop { position: 1; color: "#BC83E3" }
        }

        Behavior on height {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
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
