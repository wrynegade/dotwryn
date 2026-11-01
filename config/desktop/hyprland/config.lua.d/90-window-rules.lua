local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------

hl.window_rule({ name = "float-modal", match = { modal = true }, float = true })

hl.window_rule({
	name  = "float-dialog-titles",
	match = { title = "^(About|Organizer|Preferences|Task Dialog|Toolbox|Web Console).*$" },
	float = true,
})

hl.window_rule({
	name    = "screenshot-flameshot",  -- scwrypts hyprland screenshot
	match   = { class = "^flameshot$" },
	float   = true,
	move    = "0 0",
	pin     = true,
	no_anim = true,
})

hl.window_rule({
	name      = "games-workspace",
	match     = { class = "^steam_app_.*$" },
	workspace = "100",  -- 🎮
})

hl.window_rule({
	name         = "idle-inhibit-fullscreen",
	match        = { class = ".*" },
	idle_inhibit = "fullscreen",
})
