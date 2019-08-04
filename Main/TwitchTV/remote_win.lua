local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

--@help Launch Twitch site
actions.launch = function ()
	os.open("http://www.twitch.tv/");
end

--@help Lower volume
actions.volume_down = function()
	--actions.switch();
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	--actions.switch();
	keyboard.stroke("pageup");
	keyboard.stroke("up");
end

--@help Toggle playback state
actions.play_pause = function()
	--actions.switch();
	keyboard.stroke("space");
end

--@help Fullscreen view
actions.fullscreen = function()
	actions.stroke("control", "f");
end

--@help mute volume
actions.volume_mute = function()
	keyboard.stroke("pagedown");
end

--@help Windowed view
actions.window = function()
	keyboard.stroke("escape");
end

