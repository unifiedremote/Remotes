local keyboard = libs.keyboard;

--@help Launch Amazon Prime Video site
actions.launch = function ()
	os.open("https://www.primevideo.com");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("down");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("m");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("up");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Seek forward
actions.forward = function()
	keyboard.stroke("right");
end

--@help Seek backward
actions.rewind = function()
	keyboard.stroke("left");
end

--@help Fullscreen view
actions.fullscreen = function()
	keyboard.stroke("f");
end
