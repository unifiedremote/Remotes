local keyboard = libs.keyboard;
local script = libs.script;

--------------------------------
-- To enable dpms: xset +dpms --
--------------------------------

--@help Wake up monitor
actions.turn_on = function ()
	script.shell("xset dpms force on");
end

--@help Put monitor to sleep
actions.turn_off = function ()
	script.shell("xset dpms force off")
end
