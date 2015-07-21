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
	keyboard.stroke("shift", "p");
end

--@help Play next item
actions.next = function()
	keyboard.stroke("shift", "n");
end

--@help Enter fullscreen
actions.fullscreen = function()
	keyboard.stroke("F");
end

--@help Exit fullscreen
actions.exit_fullscreen = function()
	keyboard.stroke("esc");
end

--@help Toggle play/pause
actions.play_pause = function()
	keyboard.stroke("K");
end

