import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// polybar 'internal/tray'
Row {
	id: tray

	required property var window

	spacing: 8
	leftPadding: 8
	rightPadding: 8
	visible: SystemTray.items.values.length > 0

	Repeater {
		model: SystemTray.items

		IconImage {
			id: icon

			required property SystemTrayItem modelData

			anchors.verticalCenter: parent.verticalCenter
			implicitSize: 18
			source: modelData.icon

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
				cursorShape: Qt.PointingHandCursor

				onClicked: mouse => {
					const item = icon.modelData
					const showMenu = mouse.button === Qt.RightButton || item.onlyMenu
					if (showMenu && item.hasMenu) {
						const position = icon.mapToItem(null, 0, 0)
						item.display(tray.window, position.x, position.y - 4)
					} else if (mouse.button === Qt.MiddleButton) {
						item.secondaryActivate()
					} else {
						item.activate()
					}
				}

				onWheel: wheel => icon.modelData.scroll(wheel.angleDelta.y, false)
			}
		}
	}
}
