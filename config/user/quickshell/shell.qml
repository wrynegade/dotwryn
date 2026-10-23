//@ pragma UseQApplication

import QtQuick
import Quickshell

// hyprland shell; a port of the polybar / xfce4-notifyd / i3-nagbar setup (+ volume popup)
ShellRoot {
	Variants {
		model: Quickshell.screens

		Bar {
			required property var modelData
			screen: modelData
		}
	}

	Notifications {}

	VolumeOsd {}

	LogoutPrompt {}
}
