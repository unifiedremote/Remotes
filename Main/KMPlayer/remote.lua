local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8;
local server = libs.server;

local tid = -1;
local title = "";

events.detect = function ()
	return libs.fs.exists("C:\\Program Files\\KMPlayer 64X");
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("KMPlayer 64X", nil);
	local _title = win.title(hwnd);
	
	if (_title == "") then
		_title = "[Not Playing]";
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
end

--@help Switch to KMPlayer
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("KMPlayer64.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("KMPlayer64.exe");
	end
end

--@help Launcher KMPlayer application
actions.launch = function()    
	os.start("KMPlayer64.exe");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("volume_down");
end

--@help Mute volume
actions.volume_mute = function()
	actions.switch();
	keyboard.stroke("volume_mute");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("volume_up");
end

--@help Previous track
actions.previous = function()
	actions.switch();
	keyboard.stroke("PageUp");
end

--@help Next track
actions.next = function()
	actions.switch();
	keyboard.stroke("PageDown");
end

--@help Stop playback
actions.stop = function()
	actions.switch();
	keyboard.stroke("ctrl", "z");
end

--@help Toggle play/pause state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end
