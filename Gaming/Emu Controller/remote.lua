local kb = libs.keyboard;
local size = { w = 0, h = 0 };
local device = libs.device;
local state = { up = false, down = false, left = false, right = false };

actions.up = function (button)
	print("up: " .. button);
	kb.up(button);
end

actions.down = function (button)
	print("down: " .. button);
	kb.down(button);
end

actions.touch = function (id, x, y)
	if (y < size.h / 3) then
		if (not state.up) then
			kb.down("up");
			device.vibrate();
			state.up = true;
		end
	else
		kb.up("up");
		state.up = false;
	end
	
	if (y > (size.h / 3 * 2)) then
		if (not state.down) then
			kb.down("down");
			device.vibrate();
			state.down = true;
		end
	else
		kb.up("down");
		state.down = false;
	end
	
	if (x < size.w / 3) then
		if (not state.left) then
			kb.down("left");
			device.vibrate();
			state.left = true;
		end
	else
		kb.up("left");
		state.left = false;
	end
	
	if (x > (size.w / 3 * 2)) then
		if (not state.right) then
			kb.down("right");
			device.vibrate();
			state.right = true;
		end
	else
		kb.up("right");
		state.right = false;
	end
end 

actions.size = function (w, h)
	size.w = w;
	size.h = h;
end

actions.touchup = function ()
	kb.up("up");
	kb.up("down");
	kb.up("left");
	kb.up("right");
	state.up = false;
	state.down = false;
	state.right = false;
	state.left = false;
end