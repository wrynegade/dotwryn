local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- provides per-workspace gaps settings
--

local get_gaps_config = function(workspace)
	local gaps = {}
	for key, value in pairs(dotwryn.workspace_defaults.gaps) do gaps[key] = value end
	for key, value in pairs(workspace.gaps or {}) do gaps[key] = value end
	return gaps
end

local to_pixels = function(value)
	local percent = type(value) == "string" and tonumber((value:gsub("%%$", ""))) or nil
	if percent == nil then return value end

	local monitor = hl.get_active_monitor()
	if monitor == nil then return 0 end  -- (recomputed once a monitor shows up)

	local scale = (monitor.scale ~= nil and monitor.scale > 0) and monitor.scale or 1
	return math.floor(math.min(monitor.width, monitor.height) / scale * percent / 100)
end

local labels = {} -- reattach labels from ./80-workspaces.lua
for _, workspace in ipairs(dotwryn.workspaces) do labels[workspace.name] = workspace.label end

local gaps_rules = {}
local set_gaps = function(workspace, inner, outer)
	if gaps_rules[workspace] ~= nil then gaps_rules[workspace].rule:set_enabled(false) end
	gaps_rules[workspace] = {
		inner = inner,
		outer = outer,
		rule  = hl.workspace_rule({ workspace = workspace, gaps_in = inner, gaps_out = outer, default_name = labels[workspace] }),
	}
end

local apply_gaps = function()
	for _, workspace in ipairs(dotwryn.workspaces) do
		local gaps = get_gaps_config(workspace)
		if gaps.enabled == false then
			set_gaps(workspace.name, 0, 0)
		else
			set_gaps(workspace.name, to_pixels(gaps.inner), to_pixels(gaps.outer))
		end
	end
end

apply_gaps()

for _, event in ipairs({ "monitor.added", "monitor.removed", "monitor.layout_changed" }) do
	hl.on(event, apply_gaps)
end

hl.window_rule({
	name        = "smart-no-borders",
	match       = { float = false, group = false, workspace = "s[false] w[tv1]" },
	border_size = 0,
})

local GAPS_STEP = "0.5%"

local adjust_gaps = function(direction)
	return function()
		local workspace = hl.get_active_workspace()
		if workspace == nil then return end

		local name = workspace.id > 0 and tostring(workspace.id) or ("name:" .. workspace.name)
		local current = gaps_rules[name] or { inner = 0, outer = 0 }
		local delta = direction * math.max(1, to_pixels(GAPS_STEP))
		set_gaps(name, math.max(0, current.inner + delta), math.max(0, current.outer + delta))
	end
end

hl.bind("SUPER + z",         adjust_gaps( 1), { repeating = true })
hl.bind("SUPER + SHIFT + z", adjust_gaps(-1), { repeating = true })
