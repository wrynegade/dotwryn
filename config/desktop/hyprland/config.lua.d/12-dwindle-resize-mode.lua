local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- i3wm-style resize mode
--

local resize = function(x, y)
	return function()
		local monitor = hl.get_active_monitor()
		local scale   = (monitor ~= nil and monitor.scale ~= nil and monitor.scale > 0) and monitor.scale or 1
		local step_x  = monitor ~= nil and math.floor(monitor.width  / scale * 0.1) or 10
		local step_y  = monitor ~= nil and math.floor(monitor.height / scale * 0.1) or 10
		hl.dispatch(hl.dsp.window.resize({ x = x * step_x, y = y * step_y, relative = true }))
	end
end

hl.bind("SUPER + r", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	hl.bind("h", resize( 1,  0), { repeating = true })
	hl.bind("j", resize( 0, -1), { repeating = true })
	hl.bind("k", resize( 0,  1), { repeating = true })
	hl.bind("l", resize(-1,  0), { repeating = true })

	hl.bind("Return",    hl.dsp.submap("reset"))
	hl.bind("Escape",    hl.dsp.submap("reset"))
	hl.bind("SUPER + r", hl.dsp.submap("reset"))
end)
