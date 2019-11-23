local keyboard = libs.keyboard;

--@help Launch Netflix site
actions.launch = function ()
	os.open("http://www.netflix.com/");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("volumedown");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volumemute");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volumeup");
end

--@help Pause playback
actions.pause = function()
	keyboard.stroke("next");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Navigate left
actions.left = function()
	keyboard.stroke("left");
end

--@help Select current item
actions.select = function()
	keyboard.stroke("return");
end

--@help Navigate right
actions.right = function()
	keyboard.stroke("right");
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
	keyboard.stroke("F");
end

--@help Skip Intro
actions.skip_intro = function()
	keyboard.stroke("s");
end

--@help Windowed view
actions.window = function()
	keyboard.stroke("escape");
end
