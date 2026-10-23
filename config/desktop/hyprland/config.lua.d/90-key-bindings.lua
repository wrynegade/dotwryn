local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------

local bind = function(bindings, ...)
	for keys, dispatcher in pairs(bindings) do
		hl.bind(keys, dispatcher, ...)
	end
end

local set_background = 

---------------------------------------------------------------------

bind({
	["XF86AudioRewind"]  = hl.dsp.exec_cmd("playerctl previous"),
	["XF86AudioPrev"]    = hl.dsp.exec_cmd("playerctl previous"),
	["XF86AudioForward"] = hl.dsp.exec_cmd("playerctl next"),
	["XF86AudioNext"]    = hl.dsp.exec_cmd("playerctl next"),
	["XF86AudioPlay"]    = hl.dsp.exec_cmd("playerctl play-pause"),

	["XF86AudioMute"]    = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	["XF86AudioMicMute"] = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
}, { locked = true })

------------------------------------------

bind({
	["XF86AudioRaiseVolume"] = hl.dsp.exec_cmd("qs ipc call volume up"),  -- ../../../user/quickshell/VolumeOsd.qml "going past 100%"
	["XF86AudioLowerVolume"] = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
}, { locked = true, repeating = true })

------------------------------------------

bind({
	["SUPER + SHIFT + m"]     = dotwryn.scwrypts.hyprland.launch_or_show("slack"),
	["SUPER + SHIFT + d"]     = dotwryn.scwrypts.hyprland.launch_or_show("fluxer", "-c", "Fluxer"),
	["SUPER + c"]             = dotwryn.scwrypts.hyprland.launch_or_show("google-voice-desktop"),
	["SUPER + m"]             = dotwryn.scwrypts.hyprland.launch_or_show("youtube-music-desktop-app", "-c", "YouTube Music Desktop App"),
	["SUPER + SHIFT + s"]     = dotwryn.scwrypts.hyprland.launch_or_show("signal"),
	["SUPER + a"]             = dotwryn.scwrypts.hyprland.launch_or_show("pavucontrol", "-s", "0.5", "-c", "pavucontrol"),
	["SUPER + SHIFT + o"]     = dotwryn.scwrypts.hyprland.launch_or_show("obs", "-c", "^obs", "-n", "-l"),
	["SUPER + Return"]        = hl.dsp.exec_cmd("$TERMINAL"),

	["SUPER + p"]             = dotwryn.scwrypts.hyprland.set_background("random"),
	["SUPER + SHIFT + p"]     = dotwryn.scwrypts.hyprland.set_background("theme"),

	["SUPER + SHIFT + minus"] = hl.dsp.exec_cmd("pidof hyprlock || hyprlock"),
	["SUPER + space"]         = hl.dsp.exec_cmd("rofi -theme $DOTWRYN/config/rofi.theme.rasi -modes drun,run -show run"),
	["SUPER + backslash"]     = dotwryn.scwrypts.hyprland.screenshot(),

	--
	-- global application shortcuts (wayland apps can't grab global keys)
	--

	["ALT + SHIFT + space"] = hl.dsp.exec_cmd("1password --quick-access"),
})
