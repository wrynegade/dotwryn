local dotwryn = ...  -- ../config.lua
---------------------------------------------------------------------

local hostnamectl = io.popen("hostnamectl --static")
local HOSTNAME = hostnamectl:read("l")
hostnamectl:close()

local dofile_if_exists = function(path)
	local file = io.open(path, "r")
	if file == nil then return end
	file:close()
	dofile(path)
end

------------------------------------------

dofile_if_exists(dotwryn.DOTWRYN .. "/config/local/" .. HOSTNAME .. "/user/hypr/host.lua")
dofile_if_exists((os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/local.lua")
