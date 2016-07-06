local mouse = libs.mouse;
local win = libs.win;

local WM_SYSCOMMAND = 0x0112;
local SC_MONITORPOWER = 0xF170;
local HWND_BROADCAST = 0xffff;

--@help Turn monitor on
actions.turn_on = function()
	mouse.moveby(0,0);
	--this doesn't seem to work in windows 8+
	--win.post(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, -1);
end

--@help Turn monitor off
actions.turn_off = function()
	win.post(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
end

--@help Put monitor in standby
actions.standby = function()
	win.post(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 1);
end

--@help Duplicate desktop on multiple displays
actions.clone = function()
	os.start("%windir%/system32/DisplaySwitch.exe", "/clone");
end

--@help Extend desktop on multiple displays
actions.extend = function()
	os.start("%windir%/system32/DisplaySwitch.exe", "/extend");
end

--@help Display projector only
actions.external = function()
	os.start("%windir%/system32/DisplaySwitch.exe", "/external");
end

--@help Display computer only
actions.internal = function()
	os.start("%windir%/system32/DisplaySwitch.exe", "/internal");
end

