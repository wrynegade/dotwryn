import QtQuick
import Quickshell

// polybar 'datetime' : Monday October 19, 2026 : 09:29:00-am {15:29-UTC}
BarLabel {
	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}

	readonly property date utc: new Date(clock.date.getTime() + clock.date.getTimezoneOffset() * 60000)

	text: `${Qt.formatDateTime(clock.date, "dddd MMMM dd, yyyy : hh:mm:ss-ap")} {${Qt.formatDateTime(utc, "HH:mm")}-UTC}`
}
