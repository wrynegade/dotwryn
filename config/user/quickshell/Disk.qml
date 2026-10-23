import QtQuick

// polybar 'internal/fs'; silent until the disk is nearly full
BarLabel {
	id: disk

	property int warnPercentage: 83

	color: Colors.alert
	text: ""

	PollingCommand {
		interval: 17000
		command: ["df", "--human-readable", "--output=pcent,avail", "/"]
		onOutput: output => {
			const [percentage, free] = output.trim().split("\n").pop().trim().split(/\s+/)
			const used = parseInt(percentage)
			disk.text = used >= disk.warnPercentage
				? `${free} remaining on disk (${used}% full)`
				: ""
		}
	}
}
