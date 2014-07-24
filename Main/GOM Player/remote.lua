local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8;
local server = libs.server;

-- Commands
local WM_COMMAND 			= 0x111;
local CMD_PLAYPAUSE = 0x800C;
local CMD_STOP = 0x8006;
local CMD_NEXTTRACK = 0x809A;
local CMD_PREVTRACK = 0x8099;
local CMD_VOLUMEUP = 0x8014;
local CMD_VOLUMEDOWN = 0x8013;
local CMD_VOLUMEMUTE = 0x8016;

local tid = -1;
local title = "";

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\GRETECH\\GomPlayer") or
		libs.fs.exists("C:\\Program Files\\GRETECH\\GomPlayer");
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("GOMPlayer1.x", nil);
	local _title = win.title(hwnd);
	print(_title);

	if (_title == "") then
		_title = "[Not Playing]";
	end
	
	if (_title ~= title) then
		title = _title;
		title = utf8.replace(title, " - GOM Player", "");
		server.update({ id = "info", text = title });
	end
end

--@help Send raw command to Winamp
--@param cmd:number Raw winamp command number
actions.command = function(cmd)
	local hwnd = win.find("GomPlayer1.x", nil);
	win.send(hwnd, WM_COMMAND, cmd, 0);
	actions.update();
end

--@help Launcher Winamp application
actions.launch = function()
	os.start("gom.exe");
end

--@help Lower volume
actions.volume_down = function()
	actions.command(CMD_VOLUMEDOWN);
end

--@help Mute volume
actions.volume_mute = function()
	actions.command(CMD_VOLUMEMUTE);
end

--@help Raise volume
actions.volume_up = function()
	actions.command(CMD_VOLUMEUP);
end

--@help Previous track
actions.previous = function()
	actions.command(CMD_PREVTRACK);
end

--@help Next track
actions.next = function()
	actions.command(CMD_NEXTTRACK);
end

--@help Stop playback
actions.stop = function()
	actions.command(CMD_STOP);
end

--@help Start playback
actions.play = function()
	actions.command(CMD_PLAY);
end

--@help Pause or unpause playback
actions.pause = function()
	actions.command(CMD_PAUSE);
end

--@help Toggle play/pause state
actions.play_pause = function()
	actions.command(CMD_PLAYPAUSE);
end
