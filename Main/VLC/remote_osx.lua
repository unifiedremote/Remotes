local timer = libs.timer
local tid = -1;
local tid_seek = -1;
local title = "";

events.focus = function ()
	title = "";
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local temp = os.script("tell application \"VLC\" to set out to name of current item");
	if (temp == "") then
		temp = "[Not Playing]";
	end
	if (temp ~= title) then
		title = temp;
		layout.info.text = title;
	end
end

--@help Launch VLC application
actions.launch = function()
	os.script("tell application \"VLC\" to activate");
end

--@help Toggle play/pause
actions.play_pause = function()
	if (tid_seek ~= -1) then
		timer.cancel(tid_seek);
	else
		os.script("tell application \"VLC\" to play");
	end
end

--@help Resume playback
actions.resume = function ()
	os.script(
		"tell application \"VLC\"",
			"if (not playing) then",
				"play",
			"end if",
		"end tell");
end

--@help Pause playback
actions.pause = function ()
	os.script(
		"tell application \"VLC\"",
			"if (playing) then",
				"play",
			"end if",
		"end tell");
end

--@help Raise volume
actions.volume_up = function()
	os.script("tell application \"VLC\" to volumeUp");
end

--@help Lower volume
actions.volume_down = function()
	os.script("tell application \"VLC\" to volumeDown");
end

--@help Mute volume
actions.volume_mute = function()
	os.script("tell application \"VLC\" to mute");
end

--@help Seek backward
actions.rewind = function()
	if (tid_seek ~= -1) then
		timer.cancel(tid_seek);
	else
		timer.interval(actions.jump_back, 1000);
	end
end

--@help Toggle fullscreen
actions.fullscreen = function()
	os.script("tell application \"VLC\" to fullscreen");
end

--@help Seek forward
actions.fast_forward = function()
	if (tid_seek ~= -1) then
		timer.cancel(tid_seek);
	else
		timer.interval(actions.jump_forward, 1000);
	end
end

--@help Next playlist item
actions.next = function()
	os.script("tell application \"VLC\" to next");
end

--@help Previous playlist item
actions.previous = function()
	os.script("tell application \"VLC\" to previous");
end

--@help Stop playback
actions.stop = function()
	os.script("tell application \"VLC\" to stop");
end

--@help Jump back 10 seconds
actions.jump_back = function ()
	os.script("tell application \"VLC\" to step backward short");
end

--@help Jump forward 10 seconds
actions.jump_forward = function ()
	os.script("tell application \"VLC\" to step forward short");
end
