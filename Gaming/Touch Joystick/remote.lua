local j = libs.joystick;
local x, y, rx, t = 0, 0, 0, 0;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;
local MIN_THROTTLE = 0;
local MAX_THROTTLE = 255;
local width = 0;
local height = 0;


-- Normalize converts the 'value' from one range to another
-- For example from 0-100 to 0-255
local norm = j.normalize;


actions.touch_abs = function (i, x, y)
	local jx = norm(x, 0, width, MIN_AXIS, MAX_AXIS);
	local jy = norm(y, 0, height, MIN_AXIS, MAX_AXIS);
	
	layout.touch.text = jx .. "," .. jy;
	
	j.look(jx, jy);
end


actions.touch_size = function (w, h)
	width = w;
	height = h;
	layout.info.text = w .. " " .. h;
end


--@help Change Throttle
--@param value:number Value between 0 and 100
actions.throttle = function (value)
	t = norm(value, 0, 100, MIN_THROTTLE, MAX_THROTTLE);
	j.throttle(t);
end


