local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- i3wm & vim-style window navigation
--

-- moves a window through groups to recreate i3wm tab behavior
local move_window = function(direction)
	return function()
		local window = hl.get_active_window()
		local group  = window ~= nil and window.group or nil

		if group ~= nil and group.size > 1 and (direction == "left" or direction == "right") then
			local at_edge = (direction == "left"  and group.current_index <= 1)
			             or (direction == "right" and group.current_index >= group.size)
			if not at_edge then
				hl.dispatch(hl.dsp.group.move_window({ forward = direction == "right" }))
				return
			end
		end

		hl.dispatch(hl.dsp.window.move({ direction = direction, group_aware = true }))
	end
end

------------------------------------------

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	hl.bind("SUPER + "         .. key, hl.dsp.focus({ direction = direction }))
	hl.bind("SUPER + SHIFT + " .. key, move_window(direction))
end

hl.bind("SUPER + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind("SUPER + q", hl.dsp.window.close())

-- i3 'layout toggle split'
hl.bind("SUPER + e", hl.dsp.layout("togglesplit"))

-- i3 'layout tabbed' / 'layout stacking' : both toggle a group
hl.bind("SUPER + w", hl.dsp.group.toggle())
hl.bind("SUPER + s", hl.dsp.group.toggle())

-- (no equivalent) bindsym $mod+BackSpace open
