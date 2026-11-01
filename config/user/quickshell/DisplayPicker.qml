import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

// monitor layout picker for $DOTWRYN/config/desktop/hyprland/config.lua.d/02-monitor-layouts.lua;
// shown with 'qs ipc call -- displays show' (without '--', 'show' parses as 'qs ipc show')
Scope {
	id: picker

	property bool shown: false
	property var  screen: null

	property var layouts:     []
	property var resolutions: []

	property int selectedLayout:     0
	property int selectedResolution: -1  // -1 : the modes configured in the layout

	function show(): void {
		selectedLayout = 0
		selectedResolution = -1
		screen = Quickshell.screens.find(screen => screen.name === Hyprland.focusedMonitor?.name) ?? null
		Quickshell.execDetached(["hyprctl", "eval", "dotwryn_publish_monitor_layouts()"])
		shown = true
	}

	function moveLayout(offset: int): void {
		if (layouts.length > 0) selectedLayout = (selectedLayout + offset + layouts.length) % layouts.length
	}

	function moveResolution(offset: int): void {
		const count = resolutions.length + 1
		selectedResolution = ((selectedResolution + 1 + offset + count) % count) - 1
	}

	// hyprland 0.56.2 segfaults if a focused layer surface is destroyed by a
	// monitor change, so the picker must be gone before the layout is applied
	function applyLayout(): void {
		if (selectedLayout >= layouts.length) return

		const resolution = selectedResolution < 0 ? "nil" : JSON.stringify(resolutions[selectedResolution])
		evaluation.command = ["hyprctl", "eval", `dotwryn_set_monitor_layout(${JSON.stringify(layouts[selectedLayout])}, ${resolution})`]

		shown = false
		applyAfterHidden.restart()
	}

	Timer {
		id: applyAfterHidden
		interval: 250
		onTriggered: evaluation.running = true
	}

	Process {
		id: evaluation

		stdout: StdioCollector {
			onStreamFinished: {
				const result = text.trim()
				if (result !== "ok") Quickshell.execDetached(["notify-send", "displays", result.replace(/^.*:\d+: /, "")])
			}
		}
	}

	IpcHandler {
		target: "displays"

		function show(): void { picker.show() }
		function hide(): void { picker.shown = false }
	}

	Connections {
		target: Hyprland

		function onRawEvent(event) {
			const prefix = "dotwryn-monitor-layouts "
			if (event.name !== "custom" || !event.data.startsWith(prefix)) return

			const published = JSON.parse(event.data.slice(prefix.length))
			picker.layouts     = published.layouts
			picker.resolutions = published.resolutions
		}
	}

	component PickerText: Text {
		color: Colors.foreground
		font.family: Colors.font
		font.pointSize: Colors.fontSize
	}

	PanelWindow {
		visible: picker.shown
		screen: picker.screen

		WlrLayershell.layer: WlrLayer.Overlay
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
		exclusionMode: ExclusionMode.Ignore

		implicitWidth: content.implicitWidth + 24
		implicitHeight: content.implicitHeight + 24
		color: "transparent"

		Rectangle {
			anchors.fill: parent
			color: Colors.background
			border.width: 1
			border.color: Colors.primary

			focus: true
			Keys.onPressed: event => {
				switch (event.key) {
					case Qt.Key_J: case Qt.Key_Down:  picker.moveLayout(1);      break
					case Qt.Key_K: case Qt.Key_Up:    picker.moveLayout(-1);     break
					case Qt.Key_L: case Qt.Key_Right: picker.moveResolution(1);  break
					case Qt.Key_H: case Qt.Key_Left:  picker.moveResolution(-1); break

					case Qt.Key_Return: case Qt.Key_Enter: picker.applyLayout(); break

					case Qt.Key_Escape: case Qt.Key_Q: picker.shown = false; break
					default: return
				}
				event.accepted = true
			}

			Column {
				id: content
				anchors.centerIn: parent
				spacing: 4

				PickerText {
					text: "monitor layout"
					font.bold: true
					color: Colors.secondary
				}

				PickerText {
					visible: picker.layouts.length === 0
					text: "no monitor layouts for this host"
					color: Colors.disabled
				}

				Repeater {
					model: picker.layouts

					Rectangle {
						id: layoutRow

						required property int    index
						required property string modelData

						readonly property bool selected: picker.selectedLayout === index

						implicitWidth: Math.max(layoutLabel.implicitWidth + 24, 280)
						implicitHeight: layoutLabel.implicitHeight + 8
						color: selected ? Colors.primary : "transparent"

						PickerText {
							id: layoutLabel
							anchors.left: parent.left
							anchors.leftMargin: 12
							anchors.verticalCenter: parent.verticalCenter
							text: layoutRow.modelData
							font.bold: layoutRow.selected
						}

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							cursorShape: Qt.PointingHandCursor
							onEntered: picker.selectedLayout = layoutRow.index
							onClicked: picker.applyLayout()
						}
					}
				}

				Row {
					visible: picker.layouts.length > 0
					spacing: 8
					topPadding: 8

					PickerText {
						text: "resolution"
						color: Colors.secondary
					}

					Repeater {
						model: ["configured"].concat(picker.resolutions)

						PickerText {
							required property int    index
							required property string modelData

							readonly property bool selected: picker.selectedResolution === index - 1

							text: selected ? `[${modelData}]` : ` ${modelData} `
							color: selected ? Colors.foreground : Colors.disabled
							font.bold: selected

							MouseArea {
								anchors.fill: parent
								cursorShape: Qt.PointingHandCursor
								onClicked: picker.selectedResolution = parent.index - 1
							}
						}
					}
				}
			}
		}
	}
}
