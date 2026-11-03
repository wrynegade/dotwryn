local dotwryn = ...  -- $DOTWRYN/config/desktop/hyprland/config.lua
---------------------------------------------------------------------

hl.on("hyprland.start", function()
	-- ./hypridle.conf : power the screen off after 10 minutes idle
	hl.exec_cmd("hypridle -c '" .. dotwryn.DOTWRYN .. "/config/local/pikachu/user/hypr/hypridle.conf'")
end)
