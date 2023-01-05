local keyboard = libs.keyboard;

--@help Increase volume
actions.volume_down = function()
	keyboard.press("volume_down");
end

--@help Decrease volume
actions.volume_up = function()
	keyboard.press("volume_up");
end

--@help Rewind 10 seconds
actions.rewind = function()
	keyboard.press("left"); 
end

--@help Forward 10 seconds
actions.forward = function()
	keyboard.press("right");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.press("space");
end
