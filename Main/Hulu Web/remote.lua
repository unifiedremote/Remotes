
local task = libs.task;
local keyboard = libs.keyboard;

--@help Launch Hulu site
actions.launch = function()
	os.open("http://www.hulu.com/");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volume_up");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("volume_down");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volume_mute");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("escape");
end

