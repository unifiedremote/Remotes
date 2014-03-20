local keyboard = libs.keyboard;

--@help Launch XBMC application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%programfiles(x86)%\\XBMC\\XBMC.exe");
	end
end

--@help Start playback
actions.play = function()
	keyboard.stroke("P");
end

--@help Pause playback
actions.pause = function()
	keyboard.stroke("P");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("P");
end

--@help Raise volume
actions.volume_up = function()
	if(OS_WINDOWS)
		then
		keyboard.stroke("oem_plus");
	else
		keyboard.stroke("plus");
	end
end

--@help Lower volume
actions.volume_down = function()
	if(OS_WINDOWS)
	then
		keyboard.stroke("oem_minus");
	else
		keyboard.stroke("minus");
	end
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volume_mute");
end

--@help Navigate up
actions.up = function()
	keyboard.stroke("up");
end

--@help Navigate left
actions.left = function()
	keyboard.stroke("left");
end

--@help Navigate down
actions.down = function()
	keyboard.stroke("down");
end

--@help Navigate right
actions.right = function()
	keyboard.stroke("right");
end

--@help Select current
actions.select = function()
	keyboard.stroke("return");
end

--@help Stop playback
actions.stop = function()
	keyboard.stroke("X");
end

--@help Previous track
actions.previous = function()
	keyboard.stroke("oem_comma");
end

--@help Next track
actions.next = function()
	keyboard.stroke("oem_period");
end

--@help Seek backward
actions.rewind = function()
	keyboard.stroke("R");
end

--@help Seek forward
actions.fast_forward = function()
	keyboard.stroke("F");
end

--@help Navigate back
actions.back = function()
	keyboard.stroke("escape");
end

