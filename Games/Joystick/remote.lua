local j = libs.joystick;
local x, y, rx, t = 0, 0, 0, 0;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;
local MIN_THROTTLE = 0;
local MAX_THROTTLE = 255;


-- Normalize converts the 'value' from one range to another
-- For example from 0-100 to 0-255
local norm = j.normalize;


--@help Change X axis
--@param value:number Value between 0 and 100
actions.x = function (value)
	x = norm(value, 0, 100, MIN_AXIS, MAX_AXIS);
	j.look(x, y);
end


--@help Change Y axis
--@param value:number Value between 0 and 100
actions.y = function (value)
	y = norm(value, 0, 100, MIN_AXIS, MAX_AXIS);
	j.look(x, y);
end


--@help Change RX axis
--@param value:number Value between 0 and 100
actions.rx = function (value)
	rx = norm(value, 0, 100, MIN_AXIS, MAX_AXIS);
	j.rotate(rx, 0);
end


--@help Change Throttle
--@param value:number Value between 0 and 100
actions.throttle = function (value)
	t = norm(value, 0, 100, MIN_THROTTLE, MAX_THROTTLE);
	j.throttle(t);
end


