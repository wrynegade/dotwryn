import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Scope {
	id: osd

	readonly property PwNode sink:   Pipewire.defaultAudioSink
	readonly property PwNode source: Pipewire.defaultAudioSource

	property string label: ""
	property real   level: 0
	property bool   muted: false
	property bool   shown: false
	property string warning: ""

	// going past 100% : at 100%, it takes 'unlockPresses' separate presses of
	// volume-up (the first shows a warning); above 100% there is no limit
	readonly property real step: 0.10
	readonly property int  unlockPresses: 3
	readonly property int  repeatGuardMs: 150  // key-repeat events don't count toward unlocking
	property int  pressesAtMax: 0
	property real lastUpPress: 0

	IpcHandler {
		target: "volume"
		function up(): void { osd.volumeUp() }
	}

	Timer {
		id: unlockReset
		interval: 3000
		onTriggered: osd.pressesAtMax = 0
	}

	function volumeUp(): void {
		const audio = sink?.audio
		if (!audio) return

		const now = Date.now()
		const isRepeat = now - lastUpPress < repeatGuardMs
		lastUpPress = now

		const percent = Math.round(audio.volume * 100)

		if (percent < 100) {  // normal range; stop exactly at 100%
			pressesAtMax = 0
			audio.volume = Math.min(1.0, audio.volume + step)
			return
		}

		if (percent > 100) {  // already past 100% : no limit
			audio.volume = audio.volume + step
			return
		}

		// exactly 100%
		if (!isRepeat) {
			pressesAtMax += 1
			unlockReset.restart()
		}

		if (pressesAtMax >= unlockPresses) {
			pressesAtMax = 0
			audio.volume = audio.volume + step
			return
		}

		if (isRepeat && shown) {  // holding the key at 100% : just keep the warning up
			hideTimer.restart()
			return
		}

		const remaining = unlockPresses - pressesAtMax
		show("volume", sink, "volume-max", `press ${remaining} more to go past 100%`)
	}

	// sound effects : names from $DOTWRYN/config/sfx.map, files in DESKTOP__SFX_PATH
	property string sfxPath: ""
	property var    sfxFiles: ({})

	// default devices must be tracked for their volume / mute to update
	PwObjectTracker { objects: [osd.sink, osd.source] }

	Process {  // DESKTOP__SFX_PATH lives in the scwrypts environment; read it once
		running: true
		command: ["scwrypts", "--group", "scwrypts", "--type", "zsh", "--name", "scwrypts/environment/getenv", "--", "DESKTOP__SFX_PATH"]
		environment: ({ SCWRYPTS_LOG_LEVEL: "0" })
		stdout: StdioCollector {
			onStreamFinished: osd.sfxPath = this.text.trim().replace(/^\$HOME|^~/, Quickshell.env("HOME"))
		}
	}

	FileView {
		path: Quickshell.env("DOTWRYN") + "/config/sfx.map"
		watchChanges: true
		onFileChanged: reload()
		onLoaded: {
			const files = {}
			for (const line of text().split("\n")) {
				const [name, file] = line.trim().split(/\s+/)
				if (name && file && !name.startsWith("#")) files[name] = file
			}
			osd.sfxFiles = files
		}
	}

	function playSfx(name: string): void {
		if (sfxPath === "" || !sfxFiles[name]) return
		Quickshell.execDetached(["canberra-gtk-play", "-f", `${sfxPath}/${sfxFiles[name]}`])
	}

	function show(label: string, node: PwNode, sfx: string, warning: string): void {
		if (!node?.audio) return
		osd.warning = warning ?? ""
		osd.label = label
		osd.level = node.audio.volume
		osd.muted = node.audio.muted
		osd.shown = true
		hideTimer.restart()
		playSfx(sfx)
	}

	// ignore the initial values reported while the devices bind at startup
	property bool armed: false
	Timer { running: true; interval: 1500; onTriggered: osd.armed = true }

	Connections {
		target: osd.sink?.audio ?? null
		ignoreUnknownSignals: true
		function onVolumeChanged() { if (osd.armed) osd.show("volume", osd.sink, "volume", "") }
		function onMutedChanged()  { if (osd.armed) osd.show("volume", osd.sink, "mute", "")   }
	}

	Connections {
		target: osd.source?.audio ?? null
		ignoreUnknownSignals: true
		function onVolumeChanged() { if (osd.armed) osd.show("mic", osd.source, "volume", "") }
		function onMutedChanged()  { if (osd.armed) osd.show("mic", osd.source, "mute", "")   }
	}

	Timer {
		id: hideTimer
		interval: 1500
		onTriggered: osd.shown = false
	}

	PanelWindow {
		visible: osd.shown

		anchors.bottom: true
		margins.bottom: 120
		exclusiveZone: 0

		readonly property bool boosted: osd.level > 1.005

		implicitWidth: 400
		implicitHeight: osd.warning !== "" ? 84 : 56
		color: "transparent"

		Rectangle {
			anchors.fill: parent
			color: Colors.background
			border.width: 2
			border.color: osd.muted || parent.boosted || osd.warning !== "" ? Colors.alert : Colors.secondary

			TextMetrics {
				id: percentSlot
				font.family: Colors.font
				font.pointSize: Colors.fontSize
				font.bold: true
				text: "1000%"
			}

			Text {  // past-100% warning; sits above the row so the row never moves
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: row.top
				anchors.bottomMargin: 8
				visible: osd.warning !== ""
				text: osd.warning
				color: Colors.alert
				font.family: Colors.font
				font.pointSize: Colors.fontSize - 1
				font.bold: true
			}

			Row {
				id: row

				// pinned to the bottom edge : the popup is anchored to the screen
				// bottom, so it grows upward for the warning and the bar stays put
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 18
				spacing: 14

				Text {
					anchors.verticalCenter: parent.verticalCenter
					width: 64
					text: osd.muted ? `${osd.label} \u2298` : osd.label
					color: osd.muted ? Colors.alert : Colors.foreground
					font.family: Colors.font
					font.pointSize: Colors.fontSize
					font.bold: true
				}

				Rectangle {  // level bar
					anchors.verticalCenter: parent.verticalCenter
					width: 200
					height: 10
					color: Colors.disabled

					Rectangle {
						width: parent.width * Math.min(osd.level, 1)
						height: parent.height
						color: osd.muted || osd.level > 1.005 ? Colors.alert : Colors.secondary
					}
				}

				Text {
					anchors.verticalCenter: parent.verticalCenter
					width: percentSlot.advanceWidth
					horizontalAlignment: Text.AlignRight
					text: `${Math.round(osd.level * 100)}%`
					color: osd.level > 1.005 ? Colors.alert : Colors.foreground
					font.family: Colors.font
					font.pointSize: Colors.fontSize
					font.bold: true
				}
			}
		}
	}
}
