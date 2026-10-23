local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- hyprland-base configuration
--

hl.config({
	ecosystem = {
		no_update_news   = true,
		no_donation_nag  = true,
	},

	input = {
		kb_layout    = "us",
	},

	misc = {
		font_family              = dotwryn.font.family,
		force_default_wallpaper  = 0,
		disable_hyprland_logo    = true,
		disable_splash_rendering = true,
	},
})

hl.monitor({
	output   = "",
	mode     = "preferred",
	position = "auto",
	scale    = "auto",
})

------------------------------------------

hl.bind("SUPER + SHIFT + e", hl.dsp.exec_cmd("qs ipc call logout show"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind("SUPER + SHIFT + r", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + SHIFT + c", hl.dsp.exec_cmd("hyprctl reload"))
