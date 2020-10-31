local keyboard = libs.keyboard;
local win = libs.win;
local device = libs.device;

events.detect = function ()
	return libs.fs.exists("%localappdata%/Microsoft/Teams/current/Teams.exe");
end

--@help Focus Zoom application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("Teams.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait(hwnd);
	end
end

--@help Launch Zoom application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%localappdata%/Microsoft/Teams/current/Teams.exe");
	end
end

--@help Toggle mute
actions.mute = function()
	actions.switch();
	keyboard.stroke("ctrl","shift", "m");
end

--@help Toggle video
actions.video = function()
	actions.switch();
	keyboard.stroke("ctrl","shift", "o");
end

--@help End meeting
actions.stop = function()
	actions.switch();
	keyboard.stroke("ctrl","shift", "b")
end

--@help Answer Call
actions.answer = function()
	actions.switch();
	keyboard.stroke("ctrl","shift", "s");
end