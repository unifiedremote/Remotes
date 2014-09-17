local j = libs.joystick;

local offset = { x = 0, y = 0, z = 0 };
local curr = { x = 0, y = 0, z = 0 };
local comp = { x = 0, y = 0, z = 0 };

function norm (v,min1,max1,min2,max2)
	if (v < min1) then v = v + (max1-min1); end
	if (v > max1) then v = v - (max1-min1); end
	
	local factor1 = (v-min1)/(max1-min1);
	local factor2 = factor1*(max2-min2);
	local v2 = factor2 + min2;

	return v2
end

actions.throttle = function (value)
	value = norm(100 - value, 0, 100, -127, 127);
	j.throttle(value);
end

actions.offset = function ()
	offset.x = curr.x;
	offset.y = curr.y;
	offset.z = curr.z;
	layout.offset.text = offset.x .. " " .. offset.y .. " " .. offset.z;
end

actions.orientation = function (x, y, z)
	curr.x = x;
	curr.y = y;
	curr.z = z;
	
	comp.x = x - offset.x;
	comp.y = y - offset.y;
	comp.z = z - offset.z;
	
	layout.info.text = comp.x .. " " .. comp.y .. " " .. comp.z;
	
	x = -norm(comp.y, -90, 90, -127, 127);
	y = -norm(comp.z, -90, 90, -127, 127);
	z = -norm(comp.x, -90, 90, -127, 127);
	
	--x = norm(comp.x, -180, 180, -127, 127);
	--y = -norm(comp.y, -180, 180, -127, 127);
	
	--xAxis = 0; --norm(-comp.y, -180, 180);
	--yAxis = norm(comp.y, -180, 180) * 254 - 127;
	--zAxis = 0; --norm(comp.z, 0, 100);
	
	j.look(x, y, z);
	
	--j.rotate(zAxis, 0);
end
