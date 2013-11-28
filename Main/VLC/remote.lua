
local task = libs.task;

--@help Launch VLC application
actions.launch = function()
	os.script("tell application \"VLC\" to activate");
end

--@help Toggle playback state
actions.play_pause = function()
	os.script("tell application \"VLC\" to play");
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
