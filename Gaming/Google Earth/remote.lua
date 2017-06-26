local j = libs.joystick;
local kb = libs.keyboard;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;


events.blur = function ()
	-- Release all keys!
	kb.up("oem_period");
	kb.up("oem_comma");
	kb.up("pgup");
	kb.up("pgdown");
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
end

----------------------------------------------------------------------------------------
-- Controls
----------------------------------------------------------------------------------------

--@help Apply brakes
actions.brakes_apply = function ()
	kb.down("oem_period");
	kb.down("oem_comma");
end

--@help Release brakes
actions.brakes_release = function ()
	kb.up("oem_period");
	kb.up("oem_comma");
end

--@help Extend flaps
actions.flaps_down = function ()
	kb.stroke("shift", "f");
end

--@help Retract flaps
actions.flaps_up = function ()
	kb.stroke("f");
end

--@help Extend/retract gear
actions.gear = function ()
	kb.stroke("g");
end

--@help Pause
actions.pause = function ()
	kb.stroke("space");
end

--@help Increase thrust
actions.throttle_up_apply = function ()
	kb.down("pgup");
end

--@help Reduce thrust
actions.throttle_down_apply = function ()
	kb.down("pgdown");
end

--@help Increase thrust
actions.throttle_up_release = function ()
	kb.up("pgup");
end

--@help Reduce thrust
actions.throttle_down_release = function ()
	kb.up("pgdown");
end

--@help Start/stop simulation
actions.start_stop = function ()
	kb.stroke("ctrl", "alt", "a");
end

--@help Toggle HUD
actions.hud = function ()
	kb.stroke("h");
end


