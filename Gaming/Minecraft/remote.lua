local kb = require("keyboard");
local ms = require("mouse");
local mine = false;
local walk = false;
local sprint = false;
local crouch = false;
local use = false;


local MineButton = "left";
local WalkKey = "w";
local SprintKey = "ctrl";
local CrouchKey = "shift";
local JumpKey = "space";
local UseButton = "right";


events.blur = function ()
	kb.up(WalkKey);
	ms.up(MineButton);
	kb.up(SprintKey);
	kb.up(CrouchKey);
	--ms.up(UseButton);
end


actions.toggle_mine = function ()
	mine = not mine;
	if (mine) then
		ms.down(MineButton);
	else
		ms.up(MineButton);
	end
end


actions.toggle_use = function ()
	use = not use;
	if (use) then
		ms.down(UseButton);
	else
		ms.up(UseButton);
	end
end


actions.toggle_walk = function ()
	walk = not walk;
	if (walk) then
		kb.down(WalkKey);
	else
		kb.up(WalkKey);
	end
end


actions.toggle_sprint = function ()
	sprint = not sprint;
	if (sprint) then
		kb.down(SprintKey);
	else
		kb.up(SprintKey);
	end
end


actions.toggle_crouch = function ()
	crouch = not crouch;
	if (crouch) then
		kb.down(CrouchKey);
	else
		kb.up(CrouchKey);
	end
end


actions.toggle_jump = function ()
	jump = not jump;
	if (jump) then
		kb.down(JumpKey);
	else
		kb.up(JumpKey);
	end
end

tid = -1;
actions.twerk_start = function ()
	tid = libs.timer.interval(function ()
		kb.down("lshift");
		os.sleep(80);
		kb.up("lshift");
	end, 150);
end

actions.twerk_stop = function ()
	libs.timer.cancel(tid);
end
