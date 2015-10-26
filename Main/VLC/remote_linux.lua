local keyboard = libs.keyboard;

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Resume playback
actions.resume = function ()
	actions.play_pause();
end

--@help Pause playback
actions.pause = function ()
	actions.play_pause();
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("control", "up");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("control", "down");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("M");
end

--@help Seek backward
actions.rewind = function()
	keyboard.stroke("subtract");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("F");
end

--@help Seek forward
actions.fast_forward = function()
	keyboard.stroke("add");
end

--@help Next playlist item
actions.next = function()
	keyboard.stroke("N");
end

--@help Previous playlist item
actions.previous = function()
	keyboard.stroke("P");
end

--@help Stop playback
actions.stop = function()
	keyboard.stroke("S");
end

--@help Jump back 10 seconds
actions.jump_back = function ()
	keyboard.stroke("alt", "left");
end

--@help Jump forward 10 seconds
actions.jump_forward = function ()
	keyboard.stroke("alt", "right");
end
