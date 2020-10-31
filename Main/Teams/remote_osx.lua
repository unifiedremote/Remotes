local keyboard = libs.keyboard;
local device = libs.device;

events.detect = function ()
	return libs.fs.exists("/Applications/Microsoft Teams.app");
end

--@help Focus Zoom application
actions.switch = function()
	print("switch")
	os.script("tell application \"Microsoft Teams\" to reopen activate");
end

--@help Launch Zoom application
actions.launch = function()
	print("launch")
	os.open("/Applications/Microsoft Teams.app");
end

--@help Toggle mute
actions.mute = function()
	actions.switch();
	keyboard.stroke("cmd","shift", "m");
end

--@help Toggle video
actions.video = function()
	actions.switch();
	keyboard.stroke("cmd","shift", "o");
end

--@help End meeting
actions.stop = function()
	actions.switch();
	keyboard.stroke("cmd","shift", "b")
end

--@help Answer Call
actions.answer = function()
	actions.switch();
	keyboard.stroke("cmd","shift", "s");
end