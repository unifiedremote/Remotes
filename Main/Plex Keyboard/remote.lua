local kb = libs.keyboard;

events.detect = function ()
	if OS_WINDOWS then
		return libs.fs.exists("C:\\Program Files (x86)\\Plex Home Theater") or libs.fs.exists("C:\\Program Files (x86)\\Plex\\Plex Media Center")  or libs.fs.exists("C:\\Program Files\\Plex\\Plex Media Center") or libs.fs.exists("C:\\Program Files\\Plex Home Theater");
	elseif OS_OSX then
		return libs.fs.exists("/Applications/Plex Home Theater.app") or libs.fs.exists("/Applications/Plex.app");
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
	elseif OS_OSX then
		os.script("tell application \"Plex Home Theater\" to activate");
		os.script("tell application \"Plex\" to activate");
	end
end

--@help Navigate left
actions.left = function ()
	kb.press("left");
end

--@help Navigate down
actions.down = function ()
	kb.press("down");
end

--@help Navigate right
actions.right = function ()
	kb.press("right");
end

--@help Navigate up
actions.up = function ()
	kb.press("up");
end

--@help Select
actions.select = function ()
	kb.press("return");
end

--@help Navigate back
actions.back = function ()
	kb.press("esc");
end

--@help Play pause
actions.play_pause = function ()
	kb.press("space");
end

--@help Seek forward
actions.forward = function ()
	kb.press("f");
end

--@help Seek rewind
actions.rewind = function ()
	kb.press("r");
end

--@help Navigate home
actions.home = function ()
	kb.press("tab");
end

--@help Stop playback
actions.stop = function ()
	kb.press("x");
end

--@help Show menu
actions.menu = function ()
	kb.press("m");
end

--@help Next item
actions.next = function ()
	kb.press("right");
end

--@help Previous item
actions.previous = function ()
	kb.press("left");
end

--@help Play current item
actions.play_current = function ()
	kb.press("space");
end

--@help Show OSD
actions.osd = function ()
	kb.press("o");
end

--@help Show info
actions.info = function ()
	kb.press("i");
end
