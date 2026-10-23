import QtQuick

// polybar-style text; hidden whenever it has nothing to say (like an empty polybar label)
Text {
	color: Colors.foreground
	font.family: Colors.font
	font.pointSize: Colors.fontSize
	font.bold: true
	visible: text !== ""
}
