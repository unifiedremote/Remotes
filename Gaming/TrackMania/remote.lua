local kb = libs.keyboard;
local ms = libs.mouse;
local j = libs.joystick;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;

events.blur = function ()
	kb.up("up", "down");
end

actions.brake = function ()
	kb.down("down");
end

actions.brake_up = function ()
	kb.up("down");
end

actions.accel = function ()
	kb.down("up");
end

actions.accel_up = function ()
	kb.up("up");
end

actions.orientation = function (x, y, z)
	local SPAN = 90;
	
	local nx = j.normalize(-y, -SPAN, SPAN, MIN_AXIS, MAX_AXIS);
	
	if (math.abs(x) > 30) then
		--libs.device.vibrate();
	end
	
	
	j.look(nx, 0);
end

actions.restart = function ()
	kb.press("del");
end