local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------
--
-- as a long-time i3wm user, my dwindle configuration contains tries to
-- make the transition feel smooth
--
-- <https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/>
--

local colors = {
	active = {
		border = dotwryn.colorscheme.get_hex(".dwindle.colors.active.border", ".i3.focused.border", ".material.secondary.500",            ".ansi.green.bright"),
		text   = dotwryn.colorscheme.get_hex(".dwindle.colors.active.text",   ".i3.focused.text",   ".material.foreground.secondary.500", ".foreground"),
		locked = dotwryn.colorscheme.get_hex(".dwindle.colors.active.locked", ".i3.urgent.border",  ".material.error.500",                ".ansi.red.bright"),
	},

	inactive = {
		border = dotwryn.colorscheme.get_hex(".dwindle.colors.inactive.border", ".i3.unfocused.border", ".material.primary.700",            ".ansi.yellow.bright"),
		text   = dotwryn.colorscheme.get_hex(".dwindle.colors.inactive.text",   ".i3.unfocused.text",   ".material.foreground.primary.700", ".foreground"),
		locked = dotwryn.colorscheme.get_hex(".dwindle.colors.inactive.locked", ".i3.inactive.border",  ".material.primary.700",            ".ansi.yellow.bright"),
	},
}

hl.config({
	general = {
		layout = "dwindle",

		border_size = 4,
		gaps_in     = 0,
		gaps_out    = 0,

		resize_on_border = false,

		col = {
			active_border   = colors.active.border,
			inactive_border = colors.inactive.border,
		},
	},

	dwindle    = { preserve_split = true },
	input      = { follow_mouse = 1 },
	binds      = { movefocus_cycles_groupfirst = true },

	decoration = {
		rounding = 0,
		shadow   = { enabled = false },
		blur     = { enabled = false },
	},

	-- currently treating dwindle "groups" like an i3 "tabbed"
	group = {
		col = {
			border_active          = colors.active.border,
			border_inactive        = colors.inactive.border,
			border_locked_active   = colors.active.locked,
			border_locked_inactive = colors.inactive.locked,
		},

		groupbar = {
			font_family        = dotwryn.font.family,
			font_size          = dotwryn.font.size,
			height             = 22,
			gradients          = true,
			rounding           = 0,
			gradient_rounding  = 0,
			render_titles      = true,

			text_color          = colors.active.text,
			text_color_inactive = colors.inactive.text,

			col = {
				active          = colors.active.border,
				inactive        = colors.inactive.border,
				locked_active   = colors.active.locked,
				locked_inactive = colors.inactive.locked,
			},
		},
	},
})
