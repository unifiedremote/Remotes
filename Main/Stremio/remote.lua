local kb = libs.keyboard;
local tmr = require("timer");
local server = require("server");

actions.board = function ()
	kb.stroke("f1");
end


actions.discover = function ()
	kb.stroke("f2");
end


actions.library = function ()
	kb.stroke("f3");
end


actions.calendar = function ()
	kb.stroke("f4");
end


actions.back = function ()
	kb.stroke("esc");
end


actions.left = function ()
	kb.stroke("left");
end


actions.right = function ()
	kb.stroke("right");
end


actions.up = function ()
	kb.stroke("up");
end


actions.down = function ()
	kb.stroke("down");
end


actions.togglePause = function ()
	kb.stroke("space");
end


actions.toggleFullscreen = function ()
	kb.stroke("f");
end


actions.select = function ()
	kb.stroke("enter");
end


actions.search = function ()
	kb.stroke("f1");
	tid = tmr.timeout(function ()
		kb.stroke("s");
		kb.stroke("ctrl", "a");
		kb.stroke("delete");
		server.update({
			id = "inputdialog",
			type = "input",
			title = "Search query:",
			ontap = "inputdialog_done"
		});
	end, 2000);
end


actions.volume_up = function ()
	kb.stroke("volumeup");
end


actions.volume_down = function ()
	kb.stroke("volumedown");
end

actions.inputdialog_done = function(txt)
	kb.text(txt);
	kb.stroke("enter");
	kb.stroke("tab");
end
