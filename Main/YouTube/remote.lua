local keyboard = libs.keyboard;

--@help Launch YouTube
actions.launch = function()
	os.open("http://www.youtube.com");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("up");
end

--@help Rewind
actions.rewind = function()
	keyboard.stroke("left");
end

--@help Fast forward
actions.fast_forward = function()
	keyboard.stroke("right");
end

--@help Play previous item
actions.previous = function()
	keyboard.stroke("media_prev_track");
end

--@help Play next item
actions.next = function()
	keyboard.stroke("media_next_track");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("F");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

