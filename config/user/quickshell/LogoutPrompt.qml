import QtQuick
import Quickshell
import Quickshell.Io

// i3-nagbar replacement; shown with 'qs ipc call logout show'
Scope {
	id: prompt

	property bool shown: false

	IpcHandler {
		target: "logout"

		function show(): void { prompt.shown = true  }
		function hide(): void { prompt.shown = false }
	}

	PanelWindow {
		visible: prompt.shown

		anchors {
			top: true
			left: true
			right: true
		}

		implicitHeight: 32
		color: Colors.alert

		Text {
			anchors.left: parent.left
			anchors.leftMargin: 12
			anchors.verticalCenter: parent.verticalCenter
			text: "Do you really want to exit Hyprland?"
			color: Colors.foreground
			font.family: Colors.font
			font.pointSize: Colors.fontSize
			font.bold: true
		}

		Row {
			anchors.right: parent.right
			anchors.rightMargin: 8
			anchors.verticalCenter: parent.verticalCenter
			spacing: 8

			Repeater {
				model: [
					{ label: "Yes", action: () => Quickshell.execDetached(["sh", "-c", "notify-send 'system' 'exiting hyprland...' -i face-tired; hyprctl dispatch 'hl.dsp.exit()'"]) },
					{ label: "X",   action: () => prompt.shown = false },
				]

				Rectangle {
					required property var modelData

					implicitWidth: buttonLabel.implicitWidth + 20
					implicitHeight: 24
					color: Colors.background
					border.width: 1
					border.color: Colors.foreground

					Text {
						id: buttonLabel
						anchors.centerIn: parent
						text: parent.modelData.label
						color: Colors.foreground
						font.family: Colors.font
						font.pointSize: Colors.fontSize
						font.bold: true
					}

					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: parent.modelData.action()
					}
				}
			}
		}
	}
}
