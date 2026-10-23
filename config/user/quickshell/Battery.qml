import QtQuick
import Quickshell.Services.UPower

// polybar 'internal/battery' (battery0 / battery1)
Row {
	id: battery

	required property UPowerDevice device

	readonly property int fullAt: 74
	readonly property int lowAt: 39

	readonly property real percentage: device.percentage <= 1 ? device.percentage * 100 : device.percentage
	readonly property bool discharging: device.state === UPowerDeviceState.Discharging

	readonly property var ramp: ["", "", "", "", ""]
	readonly property int rampIndex: Math.min(ramp.length - 1, Math.floor(percentage / (100 / ramp.length)))
	readonly property var rampColors: [
		Colors.alert,
		Colors.foreground,
		Colors.secondaryGradient[2],
		Colors.secondaryGradient[3],
		Colors.secondaryGradient[4],
	]

	spacing: 4
	visible: device.isPresent

	BarLabel {
		text: battery.ramp[battery.rampIndex]
		color: battery.rampColors[battery.rampIndex]
	}

	BarLabel {  // label-full
		text: battery.percentage >= battery.fullAt ? "c:" : ""
		color: Colors.secondaryGradient[4]
	}

	BarLabel {  // label-low
		text: battery.discharging && battery.percentage <= battery.lowAt ? "⚠" : ""
		color: Colors.alert
	}
}
