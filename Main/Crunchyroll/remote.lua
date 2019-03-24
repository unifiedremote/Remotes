local keyboard = libs.keyboard;

--@help Launch Crunchroll
actions.launch = function()
	os.open("http://www.crunchyroll.com");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("volumedown");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volumeup");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("M");
end

--@help Forward 10 seconds
actions.right = function()
	keyboard.stroke("right");
end

--@help Toggle play pause state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Rewind 10 seconds
actions.left = function()
	keyboard.stroke("left");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("F");
end

