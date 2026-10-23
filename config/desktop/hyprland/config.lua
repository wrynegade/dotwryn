--
-- dotwryn hyprland configuration library
--

local DOTWRYN = os.getenv("DOTWRYN")
local dotwryn = {
	DOTWRYN = DOTWRYN,

	colorscheme = dofile(DOTWRYN .. "/scwrypts/dotwryn/desktop/colorscheme/colorscheme.lua").load(),
	scwrypts    = dofile(DOTWRYN .. "/config/desktop/hyprland/scwrypts.lua"),

	font = {
		family = table.concat({
			"Pokémoji Color",
			"Monaspace Argon",
		}, ", "),

		size = 11,
	},
}

---------------------------------------------------------------------

local config_filepaths = {}

local config_dir        = (DOTWRYN .. "/config/desktop/hyprland/config.lua.d")
local config_dir_quoted = config_dir:gsub("'", "'\\''")

assert(io.open(config_dir, "r"), "error reading hyprland config.lua.d : " .. config_dir)

local find = io.popen("find '" .. config_dir_quoted .. "' -mindepth 1 -maxdepth 1 -type f -name '*.lua'")
for config_filepath in find:lines() do
	table.insert(config_filepaths, config_filepath)
end
find:close()

table.sort(config_filepaths)

for _, config_filepath in ipairs(config_filepaths) do
	assert(loadfile(config_filepath))(dotwryn)
end
