local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer;
local server = libs.server;

local tid = -1;

events.focus = function()
	tid = timer.interval(actions.update, 500);
end

events.blur = function()
	timer.cancel(tid);
end

--@help Update state
actions.update = function()
	local hwnd = win.window("foobar2000.exe");
	local title = win.title(hwnd);
	if (title == "") then
		title = "[Not Playing]";
	end
	server.update({ id = "info", text = title });
end

--@help Focus foobar2000 application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("foobar2000.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait(hwnd);
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
	keyboard.stroke("media_prev_track");
end

--@help Next track
actions.next = function()
	actions.switch();
	keyboard.stroke("media_next_track");
end

--@help Stop playback
actions.stop = function()
	actions.switch();
	keyboard.stroke("media_stop");
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("media_play_pause");
end

