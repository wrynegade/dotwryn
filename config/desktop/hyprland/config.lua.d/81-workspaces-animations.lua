local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- workspace navigation with per-switch slide direction
--

local VERTICAL_WORKSPACES = {}  -- by target ("100", "name:🎧") and display name ("🎮", "🎧")
for _, workspace in ipairs(dotwryn.workspaces) do
	if workspace.vertical then
		VERTICAL_WORKSPACES[workspace.name] = true
		VERTICAL_WORKSPACES[workspace.label or (workspace.name:gsub("^name:", ""))] = true
	end
end

function animate_workspace_focus(name)
	local active = hl.get_active_workspace()
	local vertical = VERTICAL_WORKSPACES[name]
		or (active ~= nil and VERTICAL_WORKSPACES[active.name])

	hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutQuint", style = vertical and "slidevert" or "slide" })
	hl.dispatch(hl.dsp.focus({ workspace = name }))
end

for _, workspace in ipairs(dotwryn.workspaces) do
	if workspace.name ~= "2" then  -- (special case below)
		hl.bind("SUPER + " .. workspace.key, function() animate_workspace_focus(workspace.name) end)
	end
end

-- workspace 2 is home to the 'omni' tmux session; open a terminal if nothing is attached
hl.bind("SUPER + 2", function()
	animate_workspace_focus("2")
	hl.dispatch(hl.dsp.exec_cmd("[[ $(tmux -L omni.socket list-clients 2>/dev/null | wc -l) -eq 0 ]] && $TERMINAL"))
end)
