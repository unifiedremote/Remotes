local mouse = libs.mouse;
local win = libs.win;

local WM_SYSCOMMAND = 0x0112;
local SC_MONITORPOWER = 0xF170;
local HWND_BROADCAST = 0xffff;

local display_switch_path = "%windir%/System32/DisplaySwitch.exe";
 
-- Invoke the native version of DisplaySwitch is we're on x64 Windows...
if os.getenv("PROCESSOR_ARCHITEW6432") == "AMD64" then
    display_switch_path = "%windir%/Sysnative/DisplaySwitch.exe";
end

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
	os.start(display_switch_path, "/clone");
end

--@help Extend desktop on multiple displays
actions.extend = function()
	os.start(display_switch_path, "/extend");
end

--@help Display projector only
actions.external = function()
	os.start(display_switch_path, "/external");
end

--@help Display computer only
actions.internal = function()
	os.start(display_switch_path, "/internal");
end

