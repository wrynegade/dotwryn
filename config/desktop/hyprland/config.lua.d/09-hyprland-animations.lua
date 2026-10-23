local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------

hl.config({ animations = { enabled = true } })

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

hl.animation({ leaf = "global",     enabled = false })
hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3, bezier = "easeOutQuint", style = "popin" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "border",     enabled = true, speed = 3, bezier = "easeOutQuint" })
