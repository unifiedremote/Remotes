local keyboard = libs.keyboard;

--@help Increase volume
actions.volume_down = function()
	keyboard.press("down");
end

--@help Decrease volume
actions.volume_up = function()
	keyboard.press("up");
end

--@help Rewind 10 seconds
actions.rewind = function()
	keyboard.press("left"); 
end

--@help Forward 10 seconds
actions.forward = function()
	keyboard.press("right");
end

--@help Enter fullscreen
actions.fullscreen = function()
	keyboard.press("f");
end

--@help Exit fullscreen
actions.exit_fullscreen = function()
	keyboard.press("esc");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.press("space");
end
