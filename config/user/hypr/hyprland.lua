local DOTWRYN = os.getenv("DOTWRYN")
assert(DOTWRYN ~= nil and DOTWRYN ~= "", "DOTWRYN must be set for hyprland to start (have you loaded ~/.zshrc?)")

dofile(DOTWRYN .. "/config/desktop/hyprland/config.lua")
