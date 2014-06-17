local script = libs.script;

actions.eject = function ()
	script.shell("drutil tray eject");
end

actions.close = function ()
	script.shell("drutil tray close");
end