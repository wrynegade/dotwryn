local dotwryn = ...  -- $DOTWRYN/config/desktop/hyprland/config.lua
---------------------------------------------------------------------

dotwryn.monitors.desk = {
	output = "DP-2",
	modes  = {
		"3840x2160@239.99", "3840x2160@180.00", "3840x2160@120.00", "3840x2160@119.88", "3840x2160@60.00", "3840x2160@59.94",
		"2560x1440@239.85", "2560x1440@120.00", "2560x1440@59.95",
		"1920x1080@239.88", "1920x1080@119.88", "1920x1080@60.00", "1920x1080@59.94",
	},
	excluded_modes       = { "1920x1080@239.88" },
	mirrored_max_refresh = 120,
}

dotwryn.monitors.zapdos = {
	output = "DP-1",
	modes  = {
		"3840x2160@60.00", "3840x2160@59.94",
		"2560x1440@143.97", "2560x1440@120.00",
		"1920x1080@143.98", "1920x1080@119.88", "1920x1080@100.00", "1920x1080@60.00", "1920x1080@59.94",
	},
	excluded_modes = { "2560x1440@143.97", "1920x1080@119.88" },
}

dotwryn.monitors.splitter = {
	output = "HDMI-A-1",
	modes  = {
		"3840x2160@119.88", "3840x2160@100.00", "3840x2160@60.00", "3840x2160@59.94",
		"2560x1440@144.01",
		"1920x1080@119.98", "1920x1080@60.00", "1920x1080@59.94",
	},
	max_refresh = 60,
}

dotwryn.monitors.server_rack = {
	output = "DP-3",
	modes  = {
		"1920x1080@144.00", "1920x1080@120.00", "1920x1080@119.88", "1920x1080@100.00", "1920x1080@60.00", "1920x1080@59.94",
	},
	max_refresh = 60,
}

dotwryn.emergency_monitor = { monitor = "server_rack", key = "XF86Calculator" }

dotwryn.monitor_layouts["default"] = {
	primary  = "desk",
	monitors = {
		desk     = { resolution = "4k", position = "0x0", scale = 1.5 },
		zapdos   = { resolution = "4k", mirror = "desk" },
		splitter = { resolution = "4k", mirror = "desk" },
	},
	wallpaper = "theme",
	sfx       = "login",
}

dotwryn.monitor_layouts["broadcast"] = {
	primary  = "desk",
	monitors = {
		desk     = { resolution = "4k", position = "2560x0", scale = 1.5 },
		zapdos   = { resolution = "4k", position = "0x0",    scale = 1.5 },
		splitter = { resolution = "4k", mirror = "zapdos" },
	},
	wallpaper = "theme",
	sfx       = "login",
}

dotwryn.monitor_layouts["beeg-game"] = {
	primary  = "zapdos",
	monitors = {
		zapdos = { resolution = "max", position = "0x0", scale = 1.5 },
	},
	wallpaper = "theme",
	sfx       = "gamedock",
}

dotwryn.monitor_layouts["smol-game"] = {
	primary  = "desk",
	monitors = {
		desk = { resolution = "max", position = "0x0", scale = 1.5 },
	},
	wallpaper = "theme",
	sfx       = "gamedock",
}

--------------------------------------------------------------------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("hypridle")  -- ./hypridle.conf : power the desk monitor off after an hour idle

	-- office mouse
	hl.exec_cmd("razer-cli --device 632531H25800834 --brightness 80 --effect breath_dual --color 006942 420069 --dpi 6400 --poll 1000")

	-- zapdos keyboard
	hl.exec_cmd("razer-cli --device IO2524F99900428 --brightness 5 --effect multicolor")
end)
