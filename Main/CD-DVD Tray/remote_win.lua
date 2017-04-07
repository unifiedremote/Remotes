local win = require("win");

actions.eject = function ()
	win.mci("set CDAudio door open");
end

actions.close = function ()
	win.mci("set CDAudio door closed");
end
