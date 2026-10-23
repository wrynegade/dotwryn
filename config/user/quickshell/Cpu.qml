import QtQuick

// polybar 'internal/cpu'; silent until cpu usage is high
BarLabel {
	id: cpu

	property int warnPercentage: 79

	property real lastIdle: 0
	property real lastTotal: 0

	color: Colors.alert
	text: ""

	PollingCommand {
		interval: 3000
		command: ["head", "-n1", "/proc/stat"]
		onOutput: output => {
			const fields = output.trim().split(/\s+/).slice(1).map(Number)
			const idle   = fields[3] + fields[4]  // idle + iowait
			const total  = fields.reduce((sum, value) => sum + value, 0)

			const deltaTotal = total - cpu.lastTotal
			const used = cpu.lastTotal > 0 && deltaTotal > 0
				? Math.round((1 - (idle - cpu.lastIdle) / deltaTotal) * 100)
				: 0

			cpu.lastIdle  = idle
			cpu.lastTotal = total

			cpu.text = used >= cpu.warnPercentage
				? `CPU${String(used).padStart(2)}%`
				: ""
		}
	}
}
