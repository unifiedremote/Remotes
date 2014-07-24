local keyboard = libs.keyboard;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\Team MediaPortal\\MediaPortal") or
		libs.fs.exists("C:\\Program Files\\Team MediaPortal\\MediaPortal");
end

--@help Launch MediaPortal application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%programfiles(x86)%\\Team MediaPortal\\MediaPortal\\MediaPortal.exe");
	end
end

--@help Stop playback
actions.stop = function()
	keyboard.stroke("B");
end

--@help Navigate up
actions.up = function()
	keyboard.stroke("up");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Navigate left
actions.left = function()
	keyboard.stroke("left");
end

--@help Select current
actions.select = function()
	keyboard.stroke("return");
end

--@help Navigate right
actions.right = function()
	keyboard.stroke("right");
end

--@help Previous track
actions.previous = function()
	keyboard.stroke("F7");
end

--@help Navigate down
actions.down = function()
	keyboard.stroke("down");
end

--@help Next track
actions.next = function()
	keyboard.stroke("F8");
end

--@help Seek backward
actions.rewind = function()
	keyboard.stroke("F5");
end

--@help Seek forward
actions.forward = function()
	keyboard.stroke("F6");
end

--@help Navigate back
actions.back = function()
	keyboard.stroke("escape");
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

--@help Navigate home
actions.home = function()
	keyboard.stroke("H");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("X");
end

--@help Show information
actions.info = function()
	keyboard.stroke("F9");
end

