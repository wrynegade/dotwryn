local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- desktop workspace settings
--

dotwryn.workspace_defaults = {
	gaps = { inner = "0.5%", outer = "1%" },
}

dotwryn.workspaces = {
	{ key = "1", name = "1" },
	{ key = "2", name = "2", gaps = { enabled = false } },
	{ key = "3", name = "3" },
	{ key = "4", name = "4" },
	{ key = "5", name = "5" },
	{ key = "6", name = "6" },
	{ key = "7", name = "7" },
	{ key = "8", name = "8" },
	{ key = "9", name = "9" },

	{ key = "g", name = "100", label = "🎮", vertical = true, },
	{ key = "0", name = "name:🎧",           vertical = true, },
}

for _, workspace in ipairs(dotwryn.workspaces) do
	if workspace.label ~= nil then
		hl.workspace_rule({ workspace = workspace.name, default_name = workspace.label })
	end

	hl.bind("SUPER + SHIFT + " .. workspace.key, hl.dsp.window.move({ workspace = workspace.name, follow = false }))
end
