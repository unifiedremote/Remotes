
local keyboard = libs.keyboard;

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

