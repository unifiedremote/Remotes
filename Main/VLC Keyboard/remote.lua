
local task = libs.task;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8
local server = libs.server;

local tid = -1;
local title = "";

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Focus VLC application
actions.switch = function ()
	local hwnd = task.window("vlc.exe");
	if (hwnd == 0) then
		actions.launch();
	end
	task.switchtowait(hwnd);
end

--@help Update status information
actions.update = function ()
	local hwnd = task.window("vlc.exe");
	local _title = task.title(hwnd);
	
	if (_title == "") then
		_title = "[Not Playing]";
	else
		local pos = utf8.lastindexof(_title, " - ");
		_title = utf8.sub(_title, 0, pos);
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
end

--@help Launch VLC application
actions.launch = function()
	task.start("%programfiles(x86)%\\VideoLAN\\VLC\\vlc.exe");
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("control", "up");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("control", "down");
end

--@help Mute volume
actions.volume_mute = function()
	actions.switch();
	keyboard.stroke("M");
end

--@help Seek backward
actions.rewind = function()
	actions.switch();
	keyboard.stroke("subtract");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("F");
end

--@help Seek forward
actions.fast_forward = function()
	actions.switch();
	keyboard.stroke("add");
end

--@help Next playlist item
actions.next = function()
	actions.switch();
	keyboard.stroke("N");
end

--@help Previous playlist item
actions.previous = function()
	actions.switch();
	keyboard.stroke("P");
end

--@help Stop playback
actions.stop = function()
	actions.switch();
	keyboard.stroke("S");
end

