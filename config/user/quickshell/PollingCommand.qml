import QtQuick
import Quickshell.Io

// runs a command every 'interval' ms and emits its stdout (polybar module 'interval')
Item {
	id: polling

	required property var command
	property int interval: 1000

	signal output(string text)

	Process {
		id: process
		command: polling.command
		stdout: StdioCollector {
			onStreamFinished: polling.output(this.text)
		}
	}

	Timer {
		interval: polling.interval
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: process.running = true
	}
}
