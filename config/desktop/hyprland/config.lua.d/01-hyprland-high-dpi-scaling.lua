local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- high-dpi scaling : XWayland apps render at 1x and scale themselves
--

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- force_zero_scaling leaves steam at 1x; match the active monitor's scale instead
local set_steam_scaling = function()
	local monitor = hl.get_active_monitor()
	if monitor == nil or monitor.scale == nil or monitor.scale <= 0 then return end

	hl.env("STEAM_FORCE_DESKTOPUI_SCALING", tostring(monitor.scale))
end

set_steam_scaling()

for _, event in ipairs({ "monitor.added", "monitor.removed", "monitor.layout_changed" }) do
	hl.on(event, set_steam_scaling)
end
