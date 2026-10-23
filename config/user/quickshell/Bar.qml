import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower

// port of the polybar 'i3' bar ($DOTWRYN/config/user/polybar/config.ini)
PanelWindow {
	id: bar

	readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
	readonly property int activeWorkspaceId: monitor?.activeWorkspace?.id ?? 1
	readonly property bool activeWorkspaceFullscreen: monitor?.activeWorkspace?.hasFullscreen ?? false

	// the bar shows on every workspace except these
	readonly property var hiddenWorkspaceIds: [2]

	// fullscreen is checked here too: re-mapping the bar (on workspace switch) would
	// otherwise draw it over a window that was already fullscreen
	visible: !hiddenWorkspaceIds.includes(activeWorkspaceId)
		&& !activeWorkspaceFullscreen

	anchors {
		bottom: true
		left: true
		right: true
	}

	implicitHeight: 32
	color: Colors.background

	TextMetrics {
		id: padding
		font.family: Colors.font
		font.pointSize: Colors.fontSize
		text: " "
	}

	readonly property real separatorWidth: padding.advanceWidth * 2

	Row {  // modules-left
		anchors.left: parent.left
		anchors.leftMargin: padding.advanceWidth
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height
		spacing: bar.separatorWidth

		Workspaces { height: parent.height; monitor: bar.monitor }
	}

	Row {  // modules-center
		anchors.centerIn: parent
		height: parent.height
		spacing: bar.separatorWidth

		Tray { height: parent.height; window: bar }
		Repeater {
			model: UPower.devices.values.filter(device => device.isLaptopBattery)
			Battery { required property var modelData; device: modelData; anchors.verticalCenter: parent.verticalCenter }
		}
	}

	Row {  // modules-right
		anchors.right: parent.right
		anchors.rightMargin: padding.advanceWidth
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height
		spacing: bar.separatorWidth

		Disk    { anchors.verticalCenter: parent.verticalCenter }
		Memory  { anchors.verticalCenter: parent.verticalCenter }
		Cpu     { anchors.verticalCenter: parent.verticalCenter }
		Network { anchors.verticalCenter: parent.verticalCenter; interfaceType: "wireless" }
		Network { anchors.verticalCenter: parent.verticalCenter; interfaceType: "wired" }
		Clock   { anchors.verticalCenter: parent.verticalCenter }
	}
}
