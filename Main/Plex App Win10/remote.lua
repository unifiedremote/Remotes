local kb = libs.keyboard;
local win = libs.win;

--@help Focus Plex application
actions.switch = function()
	
end

--@help Navigate left
actions.left = function ()
	actions.switch();
	kb.press("left");
end

--@help Navigate down
actions.down = function ()
	actions.switch();
	kb.press("down");
end

--@help Navigate right
actions.right = function ()
	actions.switch();
	kb.press("right");
end

--@help Navigate up
actions.up = function ()
	actions.switch();
	kb.press("up");
end

--@help Select
actions.select = function ()
	actions.switch();
	kb.press("return");
end

--@help Navigate back
actions.back = function ()
	actions.switch();
	kb.press("esc");
end

--@help Play pause  
actions.play_pause = function ()
	actions.switch();
	kb.stroke("ctrl", "p");
end

--@help Seek forward
actions.forward = function ()
	actions.switch();
	kb.stroke("ctrl", "f");
end

--@help Seek rewind
actions.rewind = function ()
	actions.switch();
	kb.stroke("ctrl", "b");
end

--@help Navigate home
actions.home = function ()
	actions.switch();
	kb.press("esc");
	kb.press("esc");
	kb.press("esc");
	kb.press("esc");
	kb.press("esc");
end

--@help Stop playback
actions.stop = function ()
	actions.switch();
	kb.stroke("ctrl", "s");
end
