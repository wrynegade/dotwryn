import QtQuick

// polybar 'internal/memory'; silent until memory usage is high
BarLabel {
	id: memory

	property int warnPercentage: 73

	color: Colors.alert
	text: ""

	PollingCommand {
		interval: 2000
		command: ["cat", "/proc/meminfo"]
		onOutput: output => {
			const total     = parseInt(output.match(/^MemTotal:\s+(\d+)/m)[1])
			const available = parseInt(output.match(/^MemAvailable:\s+(\d+)/m)[1])
			const used = Math.round((total - available) * 100 / total)
			memory.text = used >= memory.warnPercentage
				? `RAM${String(used).padStart(2)}%`
				: ""
		}
	}
}
