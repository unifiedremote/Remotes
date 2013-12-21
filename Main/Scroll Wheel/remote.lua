
local mouse = libs.mouse;

local width = 0;
local height = 0;
local dist = 0;
local last = 0;
local free = true;

actions.done = function (id)
	free = true;
end

actions.abs = function (id, x, y)
	local angel = math.atan2(y-height, x-width) * 180 / math.pi;
	angel = angel + 180;
	
	if (free) then
		last = angel;
		dist = 0;
		free = false;
	else
		local delta = angel - last;
		dist = dist + delta;
		if (math.abs(dist) > 10) then
			if (dist < 0) then
				mouse.vscroll(-100);
			else
				mouse.vscroll(100);
			end
			dist = 0;
		end
		last = angel;
	end
end

actions.size = function (w, h)
	width = w / 2;
	height = h / 2;
end
