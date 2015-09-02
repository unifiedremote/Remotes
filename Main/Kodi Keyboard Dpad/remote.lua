local keyboard = libs.keyboard;
local win = libs.win;

--@help Launch Kodi application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%programfiles(x86)%\\Kodi\\Kodi.exe"); 
	elseif OS_OSX then
		os.script("tell application \"Kodi\" to activate");
	end
end

--@help Focus Kodi application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("Kodi.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("Kodi.exe");
	end
end

--@help Start playback
actions.play = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Pause playback
actions.pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Toggle play/pause
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	if (OS_WINDOWS) then
		keyboard.stroke("F10");
	else
		keyboard.stroke("plus");
	end
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	if (OS_WINDOWS) then
		keyboard.stroke("F9");
	else
		keyboard.stroke("minus");
	end
end

--@help Toggle mute volume
actions.volume_mute = function()
	actions.switch();
	if (OS_WINDOWS) then
		keyboard.stroke("F8");
	else
		keyboard.stroke("volume_mute");
	end
end

--@help Navigate up
actions.up = function()
	actions.switch();
	keyboard.stroke("up");
end

--@help Navigate left
actions.left = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Navigate down
actions.down = function()
	actions.switch();
	keyboard.stroke("down");
end

--@help Navigate right
actions.right = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Select current item
actions.select = function()
	actions.switch();
	keyboard.stroke("return");
end

--@help Stop playback
actions.stop = function()
	actions.switch();
	keyboard.stroke("X");
end

--@help Play previous item
actions.previous = function()
	actions.switch();
	keyboard.stroke("oem_comma");
end

--@help Play next item
actions.next = function()
	actions.switch();
	keyboard.stroke("oem_period");
end

--@help Rewind
actions.rewind = function()
	actions.switch();
	keyboard.stroke("R");
end

--@help Fast forward
actions.fast_forward = function()
	actions.switch();
	keyboard.stroke("F");
end

--@help Navigate back
actions.back = function()
	actions.switch();
	keyboard.stroke("esc");
end

