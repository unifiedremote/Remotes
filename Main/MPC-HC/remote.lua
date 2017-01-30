-- Commands Codes can be found here:
-- MPC-HC > Options > Player > Keys

local win = libs.win;
local tid = -1;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\MPC-HC") or
		libs.fs.exists("C:\\Program Files\\MPC-HC");
end

events.focus = function ()
	tid = libs.timer.interval(update, 1000);
end

events.blur = function ()
	libs.timer.cancel(tid);
end

function update ()
	local hwnd = win.find("MediaPlayerClassicW", nil);
	local title = win.title(hwnd);
	if title == "" then
		title = "[Not Running]";
	elseif title == "Media Player Classic Home Cinema" then
		title = "[Not Playing]";
	end
	layout.info.text = title;
end

--@help Launch MPCHC application
actions.launch = function()
	pcall(function ()
		os.start("C:\\Program Files (x86)\\MPC-HC\\mpc-hc.exe");
	end);
	pcall(function ()
		os.start("C:\\Program Files\\MPC-HC\\mpc-hc.exe");
	end);
	pcall(function ()
		os.start("C:\\Program Files\\MPC-HC\\mpc-hc64.exe");
	end);
end

--@help Run command
--@param code:number MPCHC command to run
actions.command = function (code)
	local hwnd = win.find("MediaPlayerClassicW", nil);
	win.send(hwnd, 0x0111, code, 0);
end

--@help Fullscreen
actions.fullscreen = function ()
	actions.command(830);
end

--@help Move up
actions.up = function ()
	actions.command(931);
end

--@help Move down
actions.down = function ()
	actions.command(932);
end

--@help Move left
actions.left = function ()
	actions.command(929);
end

--@help Move right
actions.right = function ()
	actions.command(930);
end

--@help Move back
actions.back = function ()
	actions.command(934);
end

--@help Select
actions.select = function ()
	actions.command(933);
end

--@help Play Pause track
actions.play_pause = function ()
	actions.command(889);
end

--@help Pause track
actions.pause = function ()
	actions.command(888);
end

--@help Play track
actions.play = function ()
	actions.command(887);
end

--@help Stop track
actions.stop = function ()
	actions.command(890);
end

--@help Forward track
actions.forward = function ()
	actions.command(895);
end

--@help Rewind track
actions.rewind = function ()
	actions.command(894);
end

--@help Next track
actions.next = function ()
	actions.command(922);
end

--@help Prevous track
actions.previous = function ()
	actions.command(921);
end

--@help Go to Home
actions.home = function ()
	actions.command(923);
end

--@help Open title
actions.title = function ()
	actions.command(923);
end

--@help Open chapters
actions.chapters = function ()
	actions.command(928);
end

--@help Volume up
actions.volume_up = function ()
	actions.command(907);
end

--@help Volume down
actions.volume_down = function ()
	actions.command(908);
end

--@help Mute Volume
actions.volume_mute = function ()
	actions.command(909);
end

--@help Jump Back 5s
actions.jump_back = function ()
	actions.command(901);
end

--@help Jump Forward 5s
actions.jump_forward = function ()
	actions.command(902);
end
