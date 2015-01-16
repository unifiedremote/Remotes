local offset = { x = 0, y = 0, z = 0 };
local curr = { x = 0, y = 0, z = 0 };
local comp = { x = 0, y = 0, z = 0 };


events.focus = function ()
	-- Load offsets from saved settings
	offset.x = settings.x;
	offset.y = settings.y;
	offset.z = settings.z;
end


events.blur = function ()
	-- Save offsets to settings
	settings.x = offset.x;
	settings.y = offset.y;
	settings.z = offset.z;
end


actions.zero = function ()
	-- Set zero position as current position
	offset.x = curr.x;
	offset.y = curr.y;
	offset.z = curr.z;
end


actions.orientation = function (x, y, z)
	-- Update current position
	curr.x = x;
	curr.y = y;
	curr.z = z;
	
	-- Calculate compensated position
	comp.x = x - offset.x;
	comp.y = y - offset.y;
	comp.z = z - offset.z;
	
	-- Update layout values
	layout.x = comp.x;
	layout.y = comp.y;
	layout.z = comp.z;
end
