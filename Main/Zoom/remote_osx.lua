local keyboard = libs.keyboard;
local device = libs.device;

events.detect = function ()
	return libs.fs.exists("/Applications/zoom.us.app");
end

--@help Focus Zoom application
actions.switch = function()
	print("switch")
	os.script("tell application \"zoom.us\" to reopen activate");
end

--@help Launch Zoom application
actions.launch = function()
	print("launch")
	os.open("/Applications/Zoom.us.app");
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