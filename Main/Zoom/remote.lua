local keyboard = libs.keyboard;
local win = libs.win;
local device = libs.device;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\Mozilla Firefox") or
		libs.fs.exists("C:\\Program Files\\Mozilla Firefox");
end

--@help Focus Zoom application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("firefox.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("firefox.exe");
	end
end

--@help Launch Zoom application
actions.launch = function()
	if OS_WINDOWS then
		os.start("firefox.exe");
	end
end

--@help Toggle mute
actions.mute = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "a");
end

--@help Toggle video
actions.video = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "v");
end

--@help Share screen
actions.screen = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "s");
end

--@help Record
actions.record = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "r");
end

--@help End meeting
actions.stop = function()
	actions.switch();
	keyboard.stroke("cmd", "w")
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "f");
end

--@help Toggle chat
actions.chat = function()
	actions.switch();
	keyboard.stroke("shift", "cmd", "h");
end