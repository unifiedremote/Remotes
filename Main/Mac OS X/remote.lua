
local keyboard = libs.keyboard;

--@help Open Explorer
actions.explorer = function ()
	os.script("tell application \"Finder\"",
	"make new Finder window",
	"activate",
	"end tell");
end

--@help Open Run Window
actions.run = function ()
	keyboard.stroke("cmd", "space");
end

--@help Minimize all Windows
actions.minimize_all = function ()
	keyboard.stroke("cmd", "alt", "m");
end

--@help Minimize Window
actions.minimize = function ()
	keyboard.stroke("cmd", "m");
end

--@help Maximize Window
actions.maximize = function ()
	keyboard.stroke("cmd", "ctrl", "f");
end

--@help Close Window
actions.close = function ()
	keyboard.stroke("cmd", "w");
end
