import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
	id: root

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

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {

			anchors.bottom: true
			margins.bottom: screen.height / 10

			implicitWidth: 200
			implicitHeight: 36
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}

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
                let len = parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0);
                return (len > parent.width) ? parent.width : len;
              }
						}
					}
				}
			}
		}
	}
}
