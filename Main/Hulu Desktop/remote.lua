local win = libs.win;
local keyboard = libs.keyboard;

events.detect = function ()
	return libs.fs.exists("%LOCALAPPDATA%\\HuluDesktop");
end

--@help Focus Hulu application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("HuluDesktop.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("HuluDesktop.exe");
	end
end

--@help Launch Hulu application
actions.launch = function()
	os.start("%LOCALAPPDATA%/HuluDesktop/HuluDesktop.exe")
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

--@help Select current
actions.select = function()
	actions.switch();
	keyboard.stroke("return");
end

--@help Navigate right
actions.right = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Navigate down
actions.down = function()
	actions.switch();
	keyboard.stroke("down");
end

--@help Navigate back
actions.back = function()
	actions.switch();
	keyboard.stroke("escape");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("volume_up");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("volume_down");
end

