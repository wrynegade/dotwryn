local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- i3wm-style floating windows and scratchpad
--

hl.bind("SUPER + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

local SCRATCHPAD = "special:scratchpad"

local SCRATCHPAD_FILTERS = {
	terminal = { "^Alacritty$", "^kitty$" },
	games    = { "^steam$", "^dolphin%-emu$", "^Visualboyadvance%-m$", "^steam_app_" },
}

local matches_filter = function(class, filter)
	if filter == nil then
		for name, _ in pairs(SCRATCHPAD_FILTERS) do
			if matches_filter(class, name) then return false end
		end
		return true
	end
	for _, pattern in ipairs(SCRATCHPAD_FILTERS[filter]) do
		if class ~= nil and class:match(pattern) then return true end
	end
	return false
end

local workspace_selector = function(workspace)
	return workspace.id > 0 and tostring(workspace.id) or ("name:" .. workspace.name)
end

local scratchpad_shown = {}
local scratchpad_queue = {}

local scratchpad_enqueue = function(address)
	for index, queued in ipairs(scratchpad_queue) do
		if queued == address then table.remove(scratchpad_queue, index) break end
	end
	table.insert(scratchpad_queue, address)
end

local scratchpad_windows = function()
	local stashed = {}
	for _, window in ipairs(hl.get_workspace_windows(SCRATCHPAD)) do stashed[window.address] = window end

	local ordered = {}
	for _, address in ipairs(scratchpad_queue) do
		if stashed[address] ~= nil then
			table.insert(ordered, stashed[address])
			stashed[address] = nil
		end
	end
	for address, window in pairs(stashed) do
		table.insert(ordered, window)
		scratchpad_enqueue(address)
	end
	return ordered
end

local scratchpad_fit = function(selector)
	local monitor = hl.get_active_monitor()
	if monitor ~= nil then
		local scale = (monitor.scale ~= nil and monitor.scale > 0) and monitor.scale or 1
		hl.dispatch(hl.dsp.window.resize({
			window = selector,
			x = math.floor(monitor.width  / scale * 0.75),
			y = math.floor(monitor.height / scale * 0.75),
		}))
	end
	hl.dispatch(hl.dsp.window.center({ window = selector }))
end

hl.bind("SUPER + SHIFT + Tab", function()
	local window = hl.get_active_window()
	if window == nil then return end

	local selector = "address:" .. window.address
	hl.dispatch(hl.dsp.window.float({ window = selector, action = "enable" }))
	scratchpad_fit(selector)
	hl.dispatch(hl.dsp.window.move({ window = selector, workspace = SCRATCHPAD, follow = false }))
	scratchpad_shown[window.address] = nil
	scratchpad_enqueue(window.address)
end)

local scratchpad_show = function(filter)
	return function()
		local workspace = hl.get_active_workspace()
		if workspace == nil then return end

		local active = hl.get_active_window()
		local candidates = {}
		if filter == nil and active ~= nil and scratchpad_shown[active.address] then
			table.insert(candidates, active.address)
		end
		for address, _ in pairs(scratchpad_shown) do table.insert(candidates, address) end

		for _, address in ipairs(candidates) do
			local window = hl.get_window("address:" .. address)
			if window == nil or window.workspace == nil or window.workspace.name == SCRATCHPAD then
				scratchpad_shown[address] = nil
			elseif window.workspace.id == workspace.id and (filter == nil or matches_filter(window.class, filter)) then
				hl.dispatch(hl.dsp.window.move({ window = "address:" .. address, workspace = SCRATCHPAD, follow = false }))
				scratchpad_shown[address] = nil
				scratchpad_enqueue(address)
				return
			end
		end

		for _, window in ipairs(scratchpad_windows()) do
			if matches_filter(window.class, filter) then
				local selector = "address:" .. window.address
				hl.dispatch(hl.dsp.window.move({ window = selector, workspace = workspace_selector(workspace), follow = false }))
				scratchpad_fit(selector)
				hl.dispatch(hl.dsp.focus({ window = selector }))
				scratchpad_shown[window.address] = true
				return
			end
		end
	end
end

hl.bind("SUPER + Tab",       scratchpad_show(nil))
hl.bind("SUPER + x",         scratchpad_show("terminal"))
hl.bind("SUPER + SHIFT + x", scratchpad_show("games"))
