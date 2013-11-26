
actions.previous = function ()
	os.script("tell application \"iTunes\" to previous track");
end

actions.next = function ()
	os.script("tell application \"iTunes\" to next track");
end

actions.rewind = function ()
	os.script("tell application \"iTunes\" to rewind");
end

actions.forward = function ()
	os.script("tell application \"iTunes\" to fast forward");
end

actions.volume_up = function ()
	os.script("tell application \"iTunes\" to set sound volume to (sound volume + 10)");
end

actions.volume_down = function ()
	os.script("tell application \"iTunes\" to set sound volume to (sound volume - 10)");
end

actions.fullscreen = function ()
	os.script("tell application \iTunes\" to set full screen to (not full screen)");
end

actions.play = function ()
	os.script("tell application \"iTunes\" to play");
end

actions.play_pause = function ()
	os.script("tell application \"iTunes\" to playpause");
end
