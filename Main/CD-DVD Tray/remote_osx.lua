local script = libs.script;

events.detect = function ()
	out = script.shell("drutil list | wc -l");
	return tonumber(out) > 2
end

actions.eject = function ()
	script.shell("drutil tray eject");
end

actions.close = function ()
	script.shell("drutil tray close");
end