local win = libs.win;
local keyboard = libs.keyboard;

--@help Focus Boxee application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("BOXEE.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait(hwnd);
	end
end

--@help Launch Boxee application
actions.launch = function()
	if OS_WINDOWS then
		os.start("%programfiles(x86)%/Boxee/BOXEE.exe");
	end
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("oem_minus");
end

--@help Mute volume
actions.volume_mute = function()
	actions.switch();
	keyboard.stroke("volume_mute");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("oem_plus");
end

--@help Rewind
actions.rewind = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Fast forward
actions.forward = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Stop playback
actions.stop = function()
	actions.switch();
	keyboard.stroke("x");
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Navigate up
actions.up = function()
	actions.switch();
	keyboard.stroke("up");
end

--@help Navigate down
actions.down = function()
	actions.switch();
	keyboard.stroke("down");
end

--@help Navigate left
actions.left = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Navigate back
actions.back = function()
	actions.switch();
	keyboard.stroke("back");
end

--@help Navigate right
actions.right = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("control", "f");
end

--@help Navigate home
actions.home = function()
	actions.switch();
	keyboard.stroke("h");
end

--@help Select current item
actions.select = function()
	actions.switch();
	keyboard.stroke("return");
end

