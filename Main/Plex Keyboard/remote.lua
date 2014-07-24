local kb = libs.keyboard;

events.detect = function ()
	if OS_WINDOWS then
		libs.fs.exists("%programfiles(x86)%\\Plex Home Theater\\Plex Home Theater.exe") or libs.fs.exists("%programfiles(x86)%\\Plex\\Plex Media Center\\Plex.exe");
	elseif
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

actions.left = function ()
	kb.press("left");
end

actions.down = function ()
	kb.press("down");
end

actions.right = function ()
	kb.press("right");
end

actions.up = function ()
	kb.press("up");
end

actions.select = function ()
	kb.press("return");
end

actions.back = function ()
	kb.press("esc");
end

actions.play_pause = function ()
	kb.press("space");
end

actions.forward = function ()
	kb.press("f");
end

actions.rewind = function ()
	kb.press("r");
end

actions.home = function ()
	kb.press("tab");
end

actions.stop = function ()
	kb.press("x");
end

actions.menu = function ()
	kb.press("m");
end

actions.next = function ()
	kb.press("right");
end

actions.previous = function ()
	kb.press("left");
end

actions.play_current = function ()
	kb.press("space");
end

actions.osd = function ()
	kb.press("o");
end

actions.info = function ()
	kb.press("i");
end