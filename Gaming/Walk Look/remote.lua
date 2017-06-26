local kb = libs.keyboard;
local ms = libs.mouse;
local size = { w = 0, h = 0 };
local device = libs.device;
local state = { up = false, down = false, left = false, right = false };
local look = { x = 0, y = 0 };
local dir;
local timez = 0;

events.focus = function ()
	--libs.timer.interval(look, 500);
end

function getdir(x, y)
	if (y < size.h / 3) then
		return "up";
	end
	if (y > (size.h / 3 * 2)) then
		return "down";
	end
	if (x < size.w / 3) then
		return "left";
	end
	if (x > (size.w / 3 * 2)) then
		return "right"
	end
end

actions.walk = function (id, x, y)
	dir = getdir(x, y);
	
	if (dir == "up") then
		kb.down("w");
	else
		kb.up("w");
	end
	
	if (dir == "down") then
		kb.down("s");
	else
		kb.up("s");
	end
	
	if (dir == "left") then
		kb.down("a");
	else
		kb.up("a");
	end
	
	if (dir == "right") then
		kb.down("d");
	else
		kb.up("d");
	end
end 

last = 0;

actions.foo = function (id, x, y)
	
end

actions.look = function (id, x, y)
	ms.moveraw(x, y);
end

actions.walk_size = function (w, h)
	size.w = w;
	size.h = h;
end

actions.look_size = function (w, h)
	size.w = w;
	size.h = h;
end

actions.walk_up = function ()
	kb.up("w");
	kb.up("a");
	kb.up("s");
	kb.up("d");
end

actions.look_up = function ()
	look = nil;
	ms.up();
end

actions.look_down = function ()
	
end

actions.walk_tap = function ()
	kb.down("space");
	os.sleep(100);
	kb.up("space");
end

actions.look_tap = function ()
	ms.click();
end

actions.attack = function ()
	ms.click();
end

actions.jump = function ()
	kb.down("space");
	os.sleep(100);
	kb.up("space");
end