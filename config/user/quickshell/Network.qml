import QtQuick

// polybar 'internal/network' (wlan / eth); shows the first physical interface of the given type
BarLabel {
	id: network

	required property string interfaceType  // "wireless" | "wired"

	text: ""

	PollingCommand {
		interval: 31000
		command: ["sh", "-c", `
			for path in /sys/class/net/*
			do
				[ -e "$path/device" ] || continue
				[ -d "$path/wireless" ] && type=wireless || type=wired
				[ "$type" = "${network.interfaceType}" ] || continue

				ifname="$(basename "$path")"
				ip="$(ip -4 -o addr show dev "$ifname" | awk '{print $4}' | cut -d/ -f1 | head -n1)"
				echo "$ifname $ip"
				break
			done
		`]
		onOutput: output => {
			const [ifname, ip] = output.trim().split(/\s+/)
			if (!ifname) {
				network.text = ""
			} else if (ip) {
				network.text  = `${ifname}/${ip}`
				network.color = Colors.secondary
			} else {
				network.text  = `(${ifname}:⊘)`
				network.color = Colors.disabled
			}
		}
	}
}
