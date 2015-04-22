local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8;
local server = libs.server;

-- Commands
local WM_COMMAND 			= 0x111;
local WA_PREVTRACK          = 40044; -- plays previous track
local WA_PLAY               = 40045; -- plays selected track
local WA_PAUSE              = 40046; -- pauses/unpauses currently playing track
local WA_STOP               = 40047; -- stops currently playing track
local WA_NEXTTRACK          = 40048; -- plays next track
local WA_VOLUMEUP           = 40058; -- turns volume up
local WA_VOLUMEDOWN         = 40059; -- turns volume down

local tid = -1;
local title = "";

events.detect = function ()
	return libs.fs.exists("C:\\The KMPlayer");
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("KMPlayer v3.x", nil);
	local _title = win.title(hwnd);
	
	if (_title == "") then
		_title = "[Not Playing]";
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
end

--@help Send raw command to Winamp
--@param cmd:number Raw winamp command number
actions.command = function(cmd)
	local hwnd = win.find("KMPlayer v3.x", nil);
	win.send(hwnd, WM_COMMAND, cmd, 0);
	actions.update();
end

--@help Launcher Winamp application
actions.launch = function()
	os.start("kmplayer.exe");
end

--@help Lower volume
actions.volume_down = function()
	actions.command(WA_VOLUMEDOWN);
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volume_mute");
end

--@help Raise volume
actions.volume_up = function()
	actions.command(WA_VOLUMEUP);
end

--@help Previous track
actions.previous = function()
	actions.command(WA_PREVTRACK);
end

--@help Next track
actions.next = function()
	actions.command(WA_NEXTTRACK);
end

--@help Stop playback
actions.stop = function()
	actions.command(WA_STOP);
end

--@help Start playback
actions.play = function()
	actions.command(WA_PLAY);
end

--@help Pause or unpause playback
actions.pause = function()
	actions.command(WA_PAUSE);
end

--@help Toggle play/pause state
actions.play_pause = function()
	actions.pause();
end
