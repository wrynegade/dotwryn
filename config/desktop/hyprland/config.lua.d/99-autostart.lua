local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------

hl.on("hyprland.start", function()
	hl.dispatch(dotwryn.scwrypts.hyprland.set_background("theme"))  -- (starts hyprpaper if it isn't running)
	hl.dispatch(dotwryn.scwrypts.wayland.sync_gtk_settings())  -- gtk theme from settings.ini
	hl.exec_cmd("quickshell")
	hl.exec_cmd("1password --silent")
	hl.dispatch(dotwryn.scwrypts.tmux.omni())
	hl.exec_cmd("/usr/lib/xfce-polkit/xfce-polkit")
	hl.exec_cmd("command -v apps && apps")  -- host-local background apps ($DOTWRYN/config/local/<hostname>/bin/apps)
end)

if dotwryn.monitor_layouts["default"] ~= nil then
	dotwryn.set_monitor_layout("default")
end

if dotwryn.emergency_monitor ~= nil then
	hl.bind(dotwryn.emergency_monitor.key, dotwryn_toggle_emergency_monitor)
end
