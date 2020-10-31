local keyboard = libs.keyboard;
local win = libs.win;
local device = libs.device;

events.detect = function ()
	return libs.fs.exists("%appdata%/Zoom/bin/Zoom.exe");
end

--@help Focus Zoom application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.find("ZPContentViewWndClass", nil);
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait(hwnd);
	end
end

--@help Launch Zoom application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%appdata%/Zoom/bin/Zoom.exe");
	end
end

--@help Toggle mute
actions.mute = function()
	actions.switch();
	keyboard.stroke("alt", "a");
end

--@help Toggle video
actions.video = function()
	actions.switch();
	keyboard.stroke("alt", "v");
end

--@help Share screen
actions.screen = function()
	actions.switch();
	keyboard.stroke("alt", "s");
end

--@help Record
actions.record = function()
	actions.switch();
	keyboard.stroke("alt", "r");
end

--@help End meeting
actions.stop = function()
	actions.switch();
	keyboard.stroke("alt", "q")
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("alt", "f");
end

--@help Toggle chat
actions.chat = function()
	actions.switch();
	keyboard.stroke("alt", "h");
end