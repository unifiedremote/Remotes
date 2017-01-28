local keyboard = libs.keyboard;

--@help Lower system volume
actions.volume_down = function()
	keyboard.press("f8");
end

--@help Mute system volume
actions.volume_mute = function()
	keyboard.press("f7");
end

--@help Raise system volume
actions.volume_up = function()
	keyboard.press("f9");
end

--@help Previous track
actions.previous = function()
	keyboard.press("ctrl", "b"); 
end

--@help Next track
actions.next = function()
	keyboard.press("ctrl", "f");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.press("ctrl", "p");
end

--@help Toggle repeat
actions.toggle_repeat = function()
	keyboard.press("ctrl", "t");
end

--@help Toggle shuffle
actions.toggle_shuffle = function()
	keyboard.press("ctrl", "h");
end
