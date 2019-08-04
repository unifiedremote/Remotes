local keyboard = libs.keyboard;

--@help Launch Netflix site
actions.launch = function ()
	os.open("http://www.twitch.tv/");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("pageup");
	keyboard.stroke("up");
end

--@help mute volume
actions.volume_mute = function()
	keyboard.stroke("pagedown");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

