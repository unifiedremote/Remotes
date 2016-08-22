local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer;
local server = libs.server;
local win = libs.win;
local utf8 = libs.utf8;
local tid = -1;


-- Commands
local WM_APPCOMMAND 					= 0x319;
local PlayPauseTrack 					= 0xE0000;
local MuteTrack 						= 0x80000;
local VolumeDown 						= 0x90000;
local VolumeUp 							= 0xA0000;
local StopTrack 						= 0xD0000;
local PreviousTrack 					= 0xC0000;
local NextTrack 						= 0xB0000;


events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\foobar2000") or
		libs.fs.exists("C:\\Program Files\\foobar2000");
end

events.focus = function()
	tid = timer.interval(actions.update, 1000);
end

events.blur = function()
	timer.cancel(tid);
end

--@help Update state
actions.update = function()
	local hwnd = win.window("foobar2000.exe");
	local title = win.title(hwnd);
	if (title == "" or utf8.startswith(title, "foobar2000")) then
		title = "[Not Playing]";
	else
		local pos = utf8.indexof(title, "[foobar2000");
		if (pos > -1) then
			title = utf8.sub(title, 0, pos);
		end
	end
	server.update({ id = "info", text = title });
end

--@help Focus foobar2000 application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("foobar2000.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("foobar2000.exe");
	end
end

--@help Launch program
actions.launch = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe");
	end
end

--@help Lower volume
actions.volume_down = function()
	actions.command(VolumeDown);
end

--@help Mute volume
actions.volume_mute = function()
	actions.command(MuteTrack);
end

--@help Raise volume
actions.volume_up = function()
	actions.command(VolumeUp);
end

--@help Previous track
actions.previous = function()
	actions.command(PreviousTrack);
end

--@help Next track
actions.next = function()
	actions.command(NextTrack);
end

--@help Stop playback
actions.stop = function()
	actions.command(StopTrack);
end

--@help Toggle playback state
actions.play_pause = function()
	actions.command(PlayPauseTrack);
end

--@help Send raw command
--@param cmd:number Raw command number
actions.command = function(cmd)
	local hwnd = win.window("foobar2000.exe");
	win.send(hwnd, WM_APPCOMMAND, 0, cmd);
	actions.update();
end

--@help Set play order to Default
actions.orderDefault = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Default"');
	end
end

--@help Set play order to Random
actions.orderRandom = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Random"');
	end
end

--@help Set play order to Repeat (playlist)
actions.orderRepeatPlaylist = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Repeat (playlist)"');
	end
end

--@help Set play order to Repeat (track)
actions.orderRepeatTrack = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Repeat (track)"');
	end
end

--@help Set play order to Shuffle (albums)
actions.orderShuffleAlbums = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Shuffle (albums)"');
	end
end

--@help Set play order to Shuffle (folders)
actions.orderShuffleFolders = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Shuffle (folders)"');
	end
end

--@help Set play order to Shuffle (tracks)
actions.orderShuffleTracks = function()
	if OS_WINDOWS then
		os.start("foobar2000.exe", '/command:"Shuffle (tracks)"');
	end
end
