local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8;
local server = libs.server;

-- Commands
local WM_COMMAND 			= 0x111;
local CMD_PLAY				= 20001;
local CMD_PAUSE				= 20000;
local CMD_STOP				= 20002;
local CMD_PREVIOUS			= 10123;
local CMD_NEXT				= 10124;
local CMD_PLAY_PAUSE		= 10014;

local CMD_VOLUME_UP			= 10035;
local CMD_VOLUME_DOWN 		= 10036;

local CMD_TOGGLE_MUTE		= 10037;
local CMD_TOGGLE_PLAYLIST   = 10011;
local CMD_TOGGLE_CONTROL	= 10383;
local CMD_OPEN_FILE			= 10158;
local CMD_TOGGLE_SUBS		= 10126;
local CMD_TOGGLE_OSD		= 10351;
local CMD_CAPTURE			= 10224;

local CMD_5SEC_BACK			= 10059;
local CMD_5SEC_FORWARD		= 10060;
local CMD_30SEC_BACK		= 10061;
local CMD_30SEC_FORWARD		= 10062;
local CMD_1MIN_BACK			= 10063;
local CMD_1MIN_FORWARD		= 10064;
local CMD_5MIN_BACK			= 10065;
local CMD_5MIN_FORWARD 		= 10066;

local CMD_SPEED_NORMAL		= 10246;
local CMD_SPEED_DOWN		= 10247;
local CMD_SPEED_UP			= 10248;

local CMD_FULLSCREEN		= 10013;

local tid = -1;
local title = "";

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\Daum\\PotPlayer") or
		libs.fs.exists("C:\\Program Files\\Daum\\PotPlayer");
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("PotPlayer", nil);
	if (hwnd == 0) then
		hwnd = win.find("PotPlayer64", nil);
	end
	local _title = win.title(hwnd);
	_title = utf8.replace(_title, " - Daum PotPlayer", "");
	if (_title == "") then
		_title = "[Not Playing]";
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
end

--@help Send raw command to PotPlayer
--@param cmd:number Raw PotPlayer command number
actions.command = function(cmd)
	local hwnd = win.find("PotPlayer", nil);
	if (hwnd == 0) then
		hwnd = win.find("PotPlayer64", nil);
	end
	win.post(hwnd, WM_COMMAND, cmd, 0);
	actions.update();
end

--@help Launcher PotPlayer application
actions.launch = function()
	pcall(function ()
		os.start("C:\\Program Files (x86)\\Daum\\PotPlayer\\PotPlayerMini.exe");
	end);
	pcall(function ()
		os.start("C:\\Program Files\\Daum\\PotPlayer\\PotPlayerMini64.exe");
	end);
end

--@help Lower volume
actions.volume_down = function()
	actions.command(CMD_VOLUME_DOWN);
end

--@help Mute volume
actions.volume_mute = function()
	actions.command(CMD_TOGGLE_MUTE);
end

--@help Raise volume
actions.volume_up = function()
	actions.command(CMD_VOLUME_UP);
end

--@help Previous track
actions.previous = function()
	actions.command(CMD_PREVIOUS);
end

--@help Next track
actions.next = function()
	actions.command(CMD_NEXT);
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
	actions.command(CMD_PLAY_PAUSE);
end

--@help Toggle fullscreen
actions.fullscreen = function ()
	actions.command(CMD_FULLSCREEN);
end

--@help Toggle playlist
actions.toggle_playlist = function ()
	actions.command(CMD_OPEN_FILE);
end

--@help Jump back 30 seconds
actions.big_back = function ()
	actions.command(CMD_30SEC_BACK);
end

--@help Jump back 5 seconds
actions.small_back = function ()
	actions.command(CMD_5SEC_BACK);
end

--@help Jump forward 5 seconds
actions.small_forward = function ()
	actions.command(CMD_5SEC_FORWARD);
end

--@help Jump forward 30 seconds
actions.big_forward = function ()
	actions.command(CMD_30SEC_FORWARD);
end