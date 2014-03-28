local timer = libs.timer
local tid = -1;
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
	os.script("tell application \"VLC\" to play");
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
	os.script(
		"set jump to 5",
		"tell application \"VLC\"",
				"set now to current time",
				"set tMax to duration of current item",
				"set jumpTo to now - jump",
				"if jumpTo > tMax",
					"set jumpTo to tMax",
				"else if jumpTo < 0",
						"set jumpTo to 0",
				"end if",
				"set current time to jumpTo",
		"end tell");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	os.script("tell application \"VLC\" to fullscreen");
end

--@help Seek forward
actions.fast_forward = function()
	os.script(
		"set jump to 5",
		"tell application \"VLC\"",
				"set now to current time",
				"set tMax to duration of current item",
				"set jumpTo to now + jump",
				"if jumpTo > tMax",
					"set jumpTo to tMax",
				"else if jumpTo < 0",
						"set jumpTo to 0",
				"end if",
				"set current time to jumpTo",
		"end tell");
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
