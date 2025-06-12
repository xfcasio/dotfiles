import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  property bool muted: sink?.audio?.muted ?? false
  property real volume: sink?.audio?.volume ?? 0
	property bool shouldShowOsd: false

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {

			anchors.bottom: true
			margins.bottom: screen.height / 12

			implicitWidth: 200
			implicitHeight: 36
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
      //mask: Region {}

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

			Rectangle {
				id: mainRect
				anchors.fill: parent
				radius: 4
				color: "#111A1F"
				
				property real yOffset: 100
				
				transform: [
					Scale {
						id: scaleTransform
						origin.x: mainRect.width / 2
						origin.y: mainRect.height / 2
						xScale: 0.4
						yScale: 0.4
					},
					Translate {
						id: translateTransform
						y: mainRect.yOffset
					}
				]
				
				// Slide up and grow animation
				ParallelAnimation {
					id: slideUpAndGrow
					running: root.shouldShowOsd
					
					// Slide up from bottom
					PropertyAnimation {
						target: mainRect
						property: "yOffset"
						from: 100
						to: 0
						duration: 400
						easing.type: Easing.OutBack
					}
					
					// Grow while sliding
					PropertyAnimation {
						target: scaleTransform
						properties: "xScale,yScale"
						from: 0.4
						to: 1.0
						duration: 400
						easing.type: Easing.OutBack
					}
				}
				
				SequentialAnimation {
					id: endWiggle
					running: slideUpAndGrow.running === false && root.shouldShowOsd
					
					PauseAnimation { duration: 50 }
					
					SequentialAnimation {
						loops: 2
						PropertyAnimation {
							target: scaleTransform
							properties: "xScale,yScale"
							to: 1.05
							duration: 100
							easing.type: Easing.InOutSine
						}
						PropertyAnimation {
							target: scaleTransform
							properties: "xScale,yScale"
							to: 1.0
							duration: 100
							easing.type: Easing.InOutSine
						}
					}
				}
				
				// Exit animation - slide back down and shrink
				ParallelAnimation {
					id: slideDownAndShrink
					running: !root.shouldShowOsd && mainRect.visible
					
					PropertyAnimation {
						target: mainRect
						property: "yOffset"
						to: 100
						duration: 300
						easing.type: Easing.InBack
					}
					
					PropertyAnimation {
						target: scaleTransform
						properties: "xScale,yScale"
						to: 0.4
						duration: 300
						easing.type: Easing.InBack
					}
				}

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					IconImage {
						implicitSize: 20
						source: "file:///home/toji/.config/quickshell/svg/speaker.svg"
            opacity: muted ? 0.6 : 1.0
					}

          Rectangle {
            color: "#333B3F"
						Layout.fillWidth: true

						implicitHeight: 10
            radius: 2

            Rectangle {
              radius: 2
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
              }

              gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: "#6791C9" }
                GradientStop { position: 1; color: "#BC83E3" }
              }

              implicitWidth: {
                let len = muted ? 1 : parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0);
                return (len > parent.width) ? parent.width : len;
              }
						}
					}
				}
			}
		}
	}
}
