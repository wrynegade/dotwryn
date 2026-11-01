local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- named monitor layouts (hyprland port of the per-host xrandr layout scripts)
--
-- ---------------------------------------------------------------------
-- hosts define their monitors and layouts using the following spec:
--
-- (inside config/local/<host>/user/hypr/host.lua)
--
--   dotwryn.monitors.<name> = {
--     output               = "<connector>",           -- e.g. "DP-1"; a "desc:" rule can't re-enable a disabled monitor
--     modes                = { "<w>x<h>@<hz>", ... },  -- the modes the monitor advertises
--     excluded_modes       = { "<w>x<h>@<hz>", ... },  -- (optional) advertised, but tested and not working
--     max_refresh          = <hz>,                     -- (optional) never pick a faster mode
--     mirrored_max_refresh = <hz>,                     -- (optional) cap while another monitor mirrors this one
--   }
--
--   dotwryn.monitor_layouts["<layout>"] = {
--     primary   = "<name>",  -- the monitor an emergency monitor mirrors
--     monitors  = {          -- omit monitor = monitor disabled
--       <name> = { resolution = "4k", position = "0x0", scale = 1.5 },
--       <name> = { resolution = "4k", mirror = "<name>" },
--     },
--     wallpaper = "theme",     -- (optional) set-background selection
--     sfx       = "gamedock",  -- (optional) play-sfx selection
--   }
--
--   dotwryn.emergency_monitor = { monitor = "<name>", key = "<keysym>" }  -- (optional) the key toggles <name> as a mirror of the active layout's primary
--
-- a monitor runs the fastest of its modes at the requested resolution which isn't excluded
-- or over its refresh caps; 'max' takes the highest resolution, and a resolution the monitor
-- doesn't have falls back to 'max'. a resolution chosen in the picker replaces the resolution
-- of every monitor in the layout; the scale is kept unless it doesn't divide the mode evenly (then 1)
--
-- 'default' is applied on startup and reload (see ./99-autostart.lua)
--

dotwryn.monitors        = {}
dotwryn.monitor_layouts = {}

local RESOLUTIONS = {
	["1080"] = "1920x1080",
	["1440"] = "2560x1440",
	["4k"]   = "3840x2160",
	["max"]  = "max",
}

local MAX_RESOLUTION_ORDER = { "4k", "1440", "1080" }

------------------------------------------

local get_sorted_keys = function(table_)
	local keys = {}
	for key, _ in pairs(table_) do table.insert(keys, key) end
	table.sort(keys)
	return keys
end

local get_layout = function(layout_name, resolution)
	local layout = dotwryn.monitor_layouts[layout_name]

	assert(layout ~= nil, "unknown monitor layout '" .. tostring(layout_name) .. "' (available : " .. table.concat(get_sorted_keys(dotwryn.monitor_layouts), ", ") .. ")")
	assert(resolution == nil or RESOLUTIONS[resolution] ~= nil, "unknown resolution '" .. tostring(resolution) .. "' (available : " .. table.concat(get_sorted_keys(RESOLUTIONS), ", ") .. ")")
	assert(layout.primary ~= nil and (layout.monitors or {})[layout.primary] ~= nil, "monitor layout '" .. layout_name .. "' needs a primary from its monitors")

	for monitor_name, monitor in pairs(layout.monitors) do
		assert(dotwryn.monitors[monitor_name] ~= nil, "monitor layout '" .. layout_name .. "' uses unknown monitor '" .. monitor_name .. "'")
		assert(RESOLUTIONS[monitor.resolution or "max"] ~= nil, "monitor layout '" .. layout_name .. "' uses unknown resolution '" .. tostring(monitor.resolution) .. "' for '" .. monitor_name .. "'")
		assert(monitor.mirror == nil or layout.monitors[monitor.mirror] ~= nil, "monitor layout '" .. layout_name .. "' mirrors '" .. tostring(monitor.mirror) .. "', which isn't in the layout")
	end

	return layout
end

local get_monitor_mode = function(monitor_name, resolution, is_mirrored)
	local monitor = dotwryn.monitors[monitor_name]

	local max_refresh = monitor.max_refresh or math.huge
	if is_mirrored and monitor.mirrored_max_refresh ~= nil then max_refresh = math.min(max_refresh, monitor.mirrored_max_refresh) end

	local excluded_modes = {}
	for _, mode in ipairs(monitor.excluded_modes or {}) do excluded_modes[mode] = true end

	local get_fastest_mode = function(size)
		local fastest_mode, fastest_refresh
		for _, mode in ipairs(monitor.modes or {}) do
			local mode_size, refresh = mode:match("^(%d+x%d+)@([%d.]+)$")
			refresh = tonumber(refresh)

			if mode_size == size and refresh <= max_refresh and not excluded_modes[mode] and (fastest_refresh == nil or refresh > fastest_refresh) then
				fastest_mode, fastest_refresh = mode, refresh
			end
		end
		return fastest_mode
	end

	local mode = resolution ~= "max" and get_fastest_mode(RESOLUTIONS[resolution]) or nil
	for _, max_resolution in ipairs(MAX_RESOLUTION_ORDER) do
		if mode ~= nil then break end
		mode = get_fastest_mode(RESOLUTIONS[max_resolution])
	end

	assert(mode ~= nil, "monitor '" .. monitor_name .. "' has no usable 1080/1440/4k mode")
	return mode
end

local get_resolution_scale = function(mode, scale)
	local width, height = mode:match("^(%d+)x(%d+)")
	if width == nil or type(scale) ~= "number" then return scale end

	if (width / scale) % 1 == 0 and (height / scale) % 1 == 0 then return scale end
	return 1
end

local get_monitor_has_workspaces = function(output)
	for _, workspace in ipairs(hl.get_workspaces()) do
		if workspace.monitor ~= nil and workspace.monitor.name == output then return true end
	end
	return false
end

local emergency_monitor_enabled = false

dotwryn.set_monitor_layout = function(layout_name, resolution, options)
	local layout = get_layout(layout_name, resolution)

	local layout_monitors = {}
	for monitor_name, monitor in pairs(layout.monitors) do layout_monitors[monitor_name] = monitor end

	local emergency_monitor = dotwryn.emergency_monitor
	if emergency_monitor ~= nil and emergency_monitor_enabled and layout_monitors[emergency_monitor.monitor] == nil then
		layout_monitors[emergency_monitor.monitor] = { resolution = "max", mirror = layout.primary }
	end

	local mirrored_monitor_names = {}
	for _, monitor in pairs(layout_monitors) do
		if monitor.mirror ~= nil then mirrored_monitor_names[monitor.mirror] = true end
	end

	local get_monitor_spec = function(monitor_name)
		local monitor = layout_monitors[monitor_name]
		local output  = dotwryn.monitors[monitor_name].output
		local mode    = get_monitor_mode(monitor_name, resolution or monitor.resolution or "max", mirrored_monitor_names[monitor_name])

		local monitor_spec = {  -- every field set; hl.monitor merges into the output's previous rule
			output   = output,
			disabled = false,
			mode     = mode,
			position = monitor.position or "auto",
			scale    = get_resolution_scale(mode, monitor.scale or 1),
			mirror   = "",
		}

		if monitor.mirror ~= nil then
			monitor_spec.mirror = dotwryn.monitors[monitor.mirror].output

			-- after a dpms cycle hyprland can lose a mirror it still reports (the "mirror"
			-- owns workspaces); re-setting the same mirror is a no-op, so clear it first
			if get_monitor_has_workspaces(output) then hl.monitor({ output = output, mirror = "" }) end
		end

		return monitor_spec
	end

	-- monitors the others mirror come up first and disabled monitors go down last,
	-- so there's never a mirror of a disabled monitor or a moment with no monitors
	for monitor_name, monitor in pairs(layout_monitors) do
		if monitor.mirror == nil then hl.monitor(get_monitor_spec(monitor_name)) end
	end
	for monitor_name, monitor in pairs(layout_monitors) do
		if monitor.mirror ~= nil then hl.monitor(get_monitor_spec(monitor_name)) end
	end
	for monitor_name, monitor in pairs(dotwryn.monitors) do
		if layout_monitors[monitor_name] == nil then hl.monitor({ output = monitor.output, disabled = true }) end
	end

	dotwryn.active_monitor_layout = { name = layout_name, resolution = resolution }

	if not (options or {}).switch then return end

	if layout.wallpaper ~= nil then hl.dispatch(dotwryn.scwrypts.hyprland.set_background(layout.wallpaper)) end
	if layout.sfx       ~= nil then hl.dispatch(dotwryn.scwrypts.media.play_sfx(layout.sfx))               end
end

------------------------------------------

hl.bind("SUPER + d", hl.dsp.exec_cmd("qs ipc call -- displays show"))

dotwryn_set_monitor_layout = function(layout_name, resolution)
	dotwryn.set_monitor_layout(layout_name, resolution, { switch = true })
end

dotwryn_toggle_emergency_monitor = function()
	assert(dotwryn.emergency_monitor ~= nil, "no emergency monitor configured for this host")

	emergency_monitor_enabled = not emergency_monitor_enabled

	local layout = dotwryn.active_monitor_layout
	dotwryn.set_monitor_layout(layout.name, layout.resolution)
end

-- eval can't return values; the picker (config/user/quickshell/DisplayPicker.qml) reads this IPC event instead
dotwryn_publish_monitor_layouts = function()
	local get_json_string = function(value)
		return '"' .. value:gsub('[%c"\\]', function(character) return string.format("\\u%04x", character:byte()) end) .. '"'
	end

	local get_json_strings = function(values)
		local json_strings = {}
		for _, value in ipairs(values) do table.insert(json_strings, get_json_string(value)) end
		return "[" .. table.concat(json_strings, ",") .. "]"
	end

	local layout_names = get_sorted_keys(dotwryn.monitor_layouts)
	for index, layout_name in ipairs(layout_names) do
		if layout_name == "default" then table.insert(layout_names, 1, table.remove(layout_names, index)) break end
	end

	hl.dispatch(hl.dsp.event("dotwryn-monitor-layouts " .. table.concat({
		'{"layouts":',     get_json_strings(layout_names),
		',"resolutions":', get_json_strings(get_sorted_keys(RESOLUTIONS)), "}",
	})))
end
