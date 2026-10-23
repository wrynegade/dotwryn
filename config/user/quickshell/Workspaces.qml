import QtQuick
import Quickshell
import Quickshell.Hyprland

// polybar 'internal/xworkspaces'
Row {
	id: workspaces

	required property HyprlandMonitor monitor

	// numbered workspaces first (🎮 is 100), then named in creation order; specials are hidden
	readonly property var visibleWorkspaces: Hyprland.workspaces.values
		.filter(workspace => !workspace.name.startsWith("special"))
		.sort((a, b) => {
			if ((a.id > 0) !== (b.id > 0)) return a.id > 0 ? -1 : 1
			return a.id > 0 ? a.id - b.id : b.id - a.id
		})

	Repeater {
		model: workspaces.visibleWorkspaces

		Rectangle {
			id: workspace

			required property HyprlandWorkspace modelData
			readonly property bool isActive: modelData.id === workspaces.monitor?.activeWorkspace?.id

			height: workspaces.height
			width: label.implicitWidth + label.font.pixelSize * 1.2
			color: modelData.urgent ? Colors.alert
				: isActive ? Colors.backgroundAlt
				: "transparent"

			BarLabel {
				id: label
				anchors.centerIn: parent
				text: workspace.modelData.name
				color: workspace.isActive ? Colors.foregroundAlt : Colors.foreground
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				// through hyprland.lua so the slide direction matches the keybinds
				onClicked: Quickshell.execDetached(["hyprctl", "eval", `dotwryn_focus_workspace("${
					workspace.modelData.id > 0 ? workspace.modelData.id : "name:" + workspace.modelData.name
				}")`])
			}
		}
	}
}
