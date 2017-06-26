local kb = libs.keyboard;
local ms = libs.mouse;
local j = libs.joystick;
local MIN_AXIS = -32768;
local MAX_AXIS = 32767;
local width = 0;
local height = 0;
local nx = 0;
local ny = 0;

events.blur = function ()
	kb.up("s");
	kb.up("w");
	kb.up("a");
	kb.up("d");
	j.look(0, 0);
end

actions.orientation = function (x, y, z)
	local SPAN = 45;
	nx = j.normalize(-y, -SPAN, SPAN, MIN_AXIS, MAX_AXIS);
	
	if (math.abs(x) > 90) then
		--libs.device.vibrate();
	end
	
	j.look(nx, ny);
end

actions.look = function (id, x, y)
	ms.moveraw(x, y);
end

actions.look_tap = function ()
	kb.press("1");
end

actions.control = function (i, x, y)
	ny = j.normalize(y, 0, height, MIN_AXIS, MAX_AXIS);
	j.look(nx, ny);
end

actions.control_up = function ()
	ny = 0;
end

actions.control_size = function (w, h)
	width = w;
	height = h;
end

actions.indicate_left = function ()
	print("left");
	kb.down("oem_2");
	os.sleep(100);
	kb.up("oem_2");
end

actions.indicate_right = function ()
print("right");
	kb.down("oem_6");
	os.sleep(100);
	kb.up("oem_6");
end

actions.brake_down = function ()
	kb.down("s");
end

actions.brake_up = function ()
	kb.up("s");
end

actions.gas_down = function ()
	kb.down("w");
end

actions.gas_up = function ()
	kb.up("w");
end