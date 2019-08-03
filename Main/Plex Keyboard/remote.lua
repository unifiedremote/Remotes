local kb = libs.keyboard;
local win = libs.win;

events.detect = function ()
	if OS_WINDOWS then
		return libs.fs.exists("C:\\Program Files (x86)\\Plex Home Theater") or libs.fs.exists("C:\\Program Files (x86)\\Plex")  or libs.fs.exists("C:\\Program Files\\Plex") or libs.fs.exists("C:\\Program Files\\Plex Home Theater");
	elseif OS_OSX then
		return libs.fs.exists("/Applications/Plex Home Theater.app") or libs.fs.exists("/Applications/Plex.app") or libs.fs.exists("/Applications/Pley Media Player.app");
	end
end

--@help Focus Plex application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("Plex Home Theater.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("Plex Home Theater.exe");
	end
end

--@help Launch Plex application
actions.launch = function()
	if OS_WINDOWS then
		pcall(function ()
			os.start("%programfiles(x86)%\\Plex Home Theater\\Plex Home Theater.exe");
		end);
		pcall(function ()
			os.start("%programfiles(x86)%\\Plex\\Plex Media Center\\Plex.exe"); 
		end);
		pcall(function ()
			os.start("%programfiles(x86)%\\Plex\\Plex Media Player\\PlexMediaPlayer.exe"); 
		end);
		pcall(function ()
			os.start("%programfiles(x86)%\\Plex\\Plex Media Player\\PlexMediaPlayer.exe"); 
		end);
		
	elseif OS_OSX then
		os.script("tell application \"Plex Home Theater\" to activate");
		os.script("tell application \"Plex\" to activate");
		os.script("tell application \"Plex Media Player\" to activate");
	end
end

--@help Navigate back
actions.back = function ()
	actions.switch();
	kb.press("esc");
end

--@help Play pause
actions.play_pause = function ()
	actions.switch();
	kb.press("space");
end

--@help Seek forward
actions.forward = function ()
	actions.switch();
	kb.press("right");
end

--@help Seek rewind
actions.rewind = function ()
	actions.switch();
	kb.press("left");
end

--@help Navigate home
actions.home = function ()
	actions.switch();
	kb.press("x");
	kb.press("enter");
	kb.press("g");
	kb.press("d");
end

--@help Stop playback
actions.stop = function ()
	actions.switch();
	kb.press("x");
end

--@help Show menu
actions.menu = function ()
	actions.switch();
	kb.press("m");
end

--@help Next item
actions.next = function ()
	actions.switch();
	kb.stroke("shift","right");
end

--@help Previous item
actions.previous = function ()
	actions.switch();
	kb.stroke("shift","left");
end

--@help Play current item
actions.play_current = function ()
	actions.switch();
	kb.press("space");
end

--@help Play select item
actions.select = function ()
	actions.switch();
	kb.press("enter");
end

--@help Play volumeup item
actions.volumeup = function ()
	actions.switch();
	kb.press("up");
end

--@help Play volumeup item
actions.volumedown = function ()
	actions.switch();
	kb.press("down");
end
