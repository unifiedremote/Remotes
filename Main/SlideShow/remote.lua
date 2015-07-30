local utf8 = require("utf8");
local server = require("server");
local device = require("device");
local keyboard = require("keyboard");

--@help Start slide show
actions.show_start = function()
	keyboard.stroke("F5");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("F11");
end

--@help End slide show
actions.show_end = function()
	keyboard.stroke("escape");
end

--@help Previous slide
actions.previous = function()
	keyboard.stroke("left");
end

--@help Next slide
actions.next = function()
	keyboard.stroke("right");
end

--@help Open goto input
actions.open_goto = function()
	keyboard.stroke("right");
end

--@help Goto specific slide
actions.open_goto = function()
	server.update({
	    id = "gotodialog",
	    type = "input",
	    title = "Select a slide", 
	    ontap = "goto"
	});
end

actions.goto = function (txt) 
	txt = utf8.trim(txt);
	if (tonumber(txt) ~= nil) then
		for i = 1, #txt do
		    local c = utf8.char(txt, i - 1);
			keyboard.press(c);
		end
		keyboard.press("enter");
	else
		device.toast("Invalid slide number!");
	end
end
