--
-- custom (temporary?) interface to scwrypts for hyprland lua
--

local scwrypts = function(args_meta, args_scwrypt, environment)
	local get_quoted = function(args)
		local quoted_args = {}
		for _, arg in ipairs(args) do
			table.insert(quoted_args, "'" .. arg:gsub("'", "'\\''") .. "'")
		end
		return table.concat(quoted_args, " ")
	end

	local environment_names = {}
	for name, _ in pairs(environment or {}) do table.insert(environment_names, name) end
	table.sort(environment_names)

	local environment_assignments = {}
	for _, name in ipairs(environment_names) do
		table.insert(environment_assignments, name .. "=" .. get_quoted({ environment[name] }))
	end

	return table.concat({
		table.concat(environment_assignments, " "),
		get_quoted({ os.getenv("DOTWRYN") .. "/zsh/plugins/scwrypts/scwrypts" }),
		get_quoted(args_meta or {}),
		"--",
		get_quoted(args_scwrypt or {}),
	}, " ")
end

------------------------------------------

local scwrypts_desktop = function(args_meta, args_scwrypt)
	return scwrypts(args_meta, args_scwrypt, {
		SCWRYPTS_LOG_LEVEL = "0",
		DESKTOP__SFX_PATH  = os.getenv("HOME") .. "/Media/sfx",
	})
end

---------------------------------------------------------------------

local hyprland = {
	launch_or_show = function(program, ...)
		return hl.dsp.exec_cmd(scwrypts_desktop({ 'hyprland', 'launch-or-show' }, { program, ... }))
	end,

	screenshot = function(...)
		return hl.dsp.exec_cmd(scwrypts_desktop({ 'hyprland', 'screenshot' }, { ... }))
	end,

	set_background = function(...)
		return hl.dsp.exec_cmd(scwrypts_desktop({ 'hyprland', 'set-background' }, { ... }))
	end,
}

local wayland = {
	sync_gtk_settings = function(...)
		return hl.dsp.exec_cmd(scwrypts({ 'sync-gtk-settings' }, { ... }))
	end,
}

local tmux = {
	omni = function()
		return hl.dsp.exec_cmd(scwrypts({ 'omni', 'tmux' }, { '--background' }))
	end,
}

---------------------------------------------------------------------

return {
	scwrypts         = scwrypts,
	scwrypts_desktop = scwrypts_desktop,

	hyprland = hyprland,
	wayland  = wayland,
	tmux     = tmux,
}
