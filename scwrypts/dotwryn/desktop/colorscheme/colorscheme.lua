-- lua implementation of the dotwryn colorscheme library (scwrypts/dotwryn/desktop/colorscheme)
--
-- usage:
--   local colorscheme = dofile(os.getenv("DOTWRYN") .. "/scwrypts/dotwryn/desktop/colorscheme/colorscheme.lua")
--   local theme = colorscheme.load()          -- the active theme
--   local theme = colorscheme.load("winter")  -- a named theme
--
--   theme.name    -- e.g. "halloween"
--   theme.values  -- the merged (default.yaml + theme) source, references unresolved
--   theme.get_hex(".i3.focused.border", ".material.secondary.500", ".ansi.green.bright")  --> "#ffc106"
--
-- theme.get_hex follows 'desktop/colorscheme/get-hex' : an ordered list of lookup terms where
-- the first which resolves wins; values which are themselves lookups (".material...") are
-- followed recursively; a term is a yq-style path, an ANSI color number (0-15), or one of
-- the compatibility terms below; unlike get-hex, colors are returned as "#rrggbb"
--
-- reads the yaml through 'yq' (dependency of the colorscheme library)

local DOTWRYN = os.getenv("DOTWRYN")
assert(DOTWRYN ~= nil and DOTWRYN ~= "", "DOTWRYN must be set to use the colorscheme library (have you loaded ~/.zshrc?)")

local COLORSCHEME_DIR             = DOTWRYN .. "/config/colorschemes"
local ACTIVE_THEME_PATH           = COLORSCHEME_DIR .. "/active"
local ACTIVE_THEME_SOURCE         = ACTIVE_THEME_PATH .. "/source.yaml"
local DEFAULT_MATERIAL_REFERENCES = ACTIVE_THEME_PATH .. "/default.yaml"

local MAX_LOOKUP_RECURSION = 10

local ANSI_COLOR_LOOKUPS = {
	[0]  = ".ansi.gray.black",
	[1]  = ".ansi.red.regular",
	[2]  = ".ansi.green.regular",
	[3]  = ".ansi.yellow.regular",
	[4]  = ".ansi.blue.regular",
	[5]  = ".ansi.magenta.regular",
	[6]  = ".ansi.cyan.regular",
	[7]  = ".ansi.gray.white",
	[8]  = ".ansi.gray.regular",
	[9]  = ".ansi.red.bright",
	[10] = ".ansi.green.bright",
	[11] = ".ansi.yellow.bright",
	[12] = ".ansi.blue.bright",
	[13] = ".ansi.magenta.bright",
	[14] = ".ansi.cyan.bright",
	[15] = ".ansi.gray.bright",
}

local COMPATIBILITY_LOOKUPS = {
	foreground           = { ".foreground",           ".ansi.gray.black" },
	background           = { ".background",           ".ansi.gray.white" },
	cursor               = { ".cursor",               ".ansi.gray.white" },
	selection_foreground = { ".selection.foreground", ".background"      },
	selection_background = { ".selection.background", ".foreground"      },
}

--------------------------------------------------------------------------------

local shell_quote = function(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

-- (the exit status from pipe:close() is unreliable inside hyprland, which reaps its own
-- children; a failed command is detected by its missing output instead)
local read_command = function(command)
	local pipe = io.popen(command)
	local output = pipe:read("a")
	pipe:close()
	if output == nil or output == "" then error("colorscheme : no output from command : " .. command) end
	return output
end

local read_yaml = function(...)
	local files = {}
	for _, file in ipairs({ ... }) do table.insert(files, shell_quote(file)) end

	local chunk = read_command("yq eval-all '. as $item ireduce ({}; . * $item)' -o lua " .. table.concat(files, " "))
	return assert(load(chunk, "colorscheme", "t", {}))()
end

-- ".material.primary.500" --> values.material.primary[500] (or ["500"])
local get_path = function(values, lookup)
	local value = values
	for key in lookup:gmatch("[^.]+") do
		if type(value) ~= "table" then return nil end
		value = value[tonumber(key)] or value[key]
	end
	return value
end

local expand_term = function(term, lookups)
	local ansi_color = term:match("^%d+$") and ANSI_COLOR_LOOKUPS[tonumber(term)]
	if ansi_color ~= nil then
		table.insert(lookups, ansi_color)
	elseif COMPATIBILITY_LOOKUPS[term] ~= nil then
		for _, lookup in ipairs(COMPATIBILITY_LOOKUPS[term]) do table.insert(lookups, lookup) end
	else
		table.insert(lookups, term)
	end
end

--------------------------------------------------------------------------------

local colorscheme = {}

colorscheme.load = function(theme_name)
	local theme_source = ACTIVE_THEME_SOURCE
	if theme_name ~= nil then
		theme_source = COLORSCHEME_DIR .. "/" .. theme_name .. ".yaml"
		if io.open(theme_source, "r") == nil then error("colorscheme : no such theme '" .. theme_name .. "'") end
	else
		-- (name.txt is only written after every theme file is generated)
		theme_name = read_command("readlink -- " .. shell_quote(ACTIVE_THEME_SOURCE)):match("([^/]+)%.yaml%s*$")
	end

	local theme = {
		name   = theme_name,
		values = read_yaml(DEFAULT_MATERIAL_REFERENCES, theme_source),
	}

	theme.get_hex = function(...)
		local lookups = {}
		for _, term in ipairs({ ... }) do expand_term(tostring(term), lookups) end
		if #lookups == 0 then error("colorscheme : must provide at least one color lookup") end

		for _, lookup in ipairs(lookups) do
			local value = lookup
			for _ = 1, MAX_LOOKUP_RECURSION do
				value = get_path(theme.values, value)
				if type(value) ~= "string" or value:sub(1, 1) ~= "." then break end
			end

			if type(value) == "string" and value ~= "" and value:sub(1, 1) ~= "." then
				return "#" .. value:gsub("^#", "")
			end
		end

		error("colorscheme : color lookup error for '" .. table.concat({ ... }, " ") .. "' in theme '" .. tostring(theme.name) .. "'")
	end

	return theme
end

return colorscheme
