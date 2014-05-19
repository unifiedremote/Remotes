
local kb = libs.keyboard;
--@help Zoom in
actions.zoom_in = function ()
	kb.stroke("lwin", "oem_plus");
end
--@help Zoom out
actions.zoom_out = function ()
	kb.stroke("lwin", "oem_minus");
end
--@help Pan Up
actions.pan_up = function ()
	kb.stroke("ctrl", "alt", "up");
end
--@help Pan left
actions.pan_left = function ()
	kb.stroke("ctrl", "alt", "left");
end
--@help Pan right
actions.pan_right = function ()
	kb.stroke("ctrl", "alt", "right");
end
--@help Pan down
actions.pan_down = function ()
	kb.stroke("ctrl", "alt", "down");
end
--@help Windows key
actions.windows = function ()
	kb.stroke("lwin");
end
--@help Exit
actions.exit = function ()
	kb.stroke("lwin", "esc");
end
--@help Invert
actions.invert = function ()
	kb.stroke("ctrl", "alt", "I");
end
--@help Full screen mode
actions.full_mode = function ()
	kb.stroke("ctrl", "alt", "F");
end
--@help Lense mode
actions.lens_mode = function ()
	kb.stroke("ctrl", "alt", "L");
end
--@help Docked mode
actions.docked_mode = function ()
	kb.stroke("ctrl", "alt", "D");
end