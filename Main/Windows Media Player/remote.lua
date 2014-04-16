local win = libs.win;

-- Commands
local WM_COMMAND = 0x111;
local CMD_FULLSCREEN = 0x0000495E;
local CMD_PLAY_PAUSE = 0x00004978;
local CMD_STOP = 0x00004979;
local CMD_VOLUME_DOWN = 0x00004980;
local CMD_VOLUME_UP = 0x0000497F;
local CMD_VOLUME_MUTE = 0x00004981;
local CMD_NEXT = 0x0000497B;
local CMD_PREVIOUS = 0x0000497A;

--@help Launch Windows Media Player
actions.launch = function()
	os.start("wmplayer.exe");
end

--@help Send command to program
--@param cmd:number
actions.command = function(cmd)
	local hwnd = win.find("WMPlayerApp", "Windows Media Player");
	win.send(hwnd, WM_COMMAND, cmd, 0);
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.command(CMD_FULLSCREEN);
end

--@help Mute volume
actions.volume_mute = function()
	actions.command(CMD_VOLUME_MUTE);
end

--@help Lower volume
actions.volume_down = function()
	actions.command(CMD_VOLUME_DOWN);
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

--@help Toggle play/pause
actions.play_pause = function()
	actions.command(CMD_PLAY_PAUSE);
end

