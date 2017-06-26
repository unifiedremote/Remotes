local j = libs.joystick;
local kb = libs.keyboard;
local throttle = 0;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;
local MIN_THROTTLE = 0;
local MAX_THROTTLE = 255;


----------------------------------------------------------------------------------------
-- Events
----------------------------------------------------------------------------------------


events.focus = function ()
	-- Load throttle
	throttle = settings.throttle;
	layout.throttle.progress = throttle;
end


events.blur = function ()
	-- Save throttle
	settings.throttle = throttle;
end


----------------------------------------------------------------------------------------
-- Orientation Stuff
----------------------------------------------------------------------------------------


actions.orientation = function (x, y, z)
	-- Map orientation values to joystick range
	local SPAN = 90;
	local nx = j.normalize(-y, -SPAN, SPAN, MIN_AXIS, MAX_AXIS);
	local ny = j.normalize(-z, -SPAN, SPAN, MIN_AXIS, MAX_AXIS);
	local nz = j.normalize(-x, -SPAN, SPAN, MIN_AXIS, MAX_AXIS);
	
	if (math.abs(z) > 90) then
		libs.device.vibrate();
	end
	
	j.look(nx, ny);
	--j.rotate(z, 0);
end


----------------------------------------------------------------------------------------
-- Controls
----------------------------------------------------------------------------------------


actions.throttle = function (value)
	throttle = value
	local norm = j.normalize(value, 0, 10, MIN_THROTTLE, MAX_THROTTLE);
	j.throttle(norm);
end

--@help Show GPS
actions.show_gps = function ()
	kb.stroke("shift", "3");
end

--@help Show ATS
actions.show_ats = function ()
	kb.stroke("oem_3");
end

--@help Increase trim
actions.trim_up = function ()
	kb.press("numlock");
	kb.stroke("num1");
	kb.press("numlock");
end

--@help Decrease trim
actions.trim_down = function ()
	kb.press("numlock");
	kb.stroke("num7");
	kb.press("numlock");
end

--@help Look up
actions.look_up = function ()
	kb.stroke("num8");
end

--@help Look down
actions.look_down = function ()
	kb.stroke("num2");
end

--@help Look left
actions.look_left = function ()
	kb.stroke("num4");
end

--@help Look right
actions.look_right = function ()
	kb.stroke("num6");
end

--@help Apply brakes
actions.brakes_apply = function ()
	print("applying brakes");
	kb.down("oem_period");
end

--@help Release brakes
actions.brakes_release = function ()
	print("released brakes");
	kb.up("oem_period");
end

--@help Extend flaps
actions.flaps_down = function ()
	kb.stroke("f7");
end

--@help Retract flaps
actions.flaps_up = function ()
	kb.stroke("f6");
end

--@help Gear
actions.gear = function ()
	kb.stroke("g");
end

--@help Pause
actions.pause = function ()
	kb.stroke("p");
end










