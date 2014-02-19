
local kb = libs.keyboard;

actions.zoom_in = function ()
	kb.stroke("lwin", "oem_plus");
end

actions.zoom_out = function ()
	kb.stroke("lwin", "oem_minus");
end

actions.pan_up = function ()
	kb.stroke("ctrl", "alt", "up");
end

actions.pan_left = function ()
	kb.stroke("ctrl", "alt", "left");
end

actions.pan_right = function ()
	kb.stroke("ctrl", "alt", "right");
end

actions.pan_down = function ()
	kb.stroke("ctrl", "alt", "down");
end

actions.windows = function ()
	kb.stroke("lwin");
end

actions.exit = function ()
	kb.stroke("lwin", "esc");
end

actions.invert = function ()
	kb.stroke("ctrl", "alt", "I");
end

actions.full_mode = function ()
	kb.stroke("ctrl", "alt", "F");
end

actions.lens_mode = function ()
	kb.stroke("ctrl", "alt", "L");
end

actions.docked_mode = function ()
	kb.stroke("ctrl", "alt", "D");
end