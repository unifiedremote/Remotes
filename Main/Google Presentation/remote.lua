local keyboard = libs.keyboard;

--@help Start slide show
actions.start_show = function()
	if (OS_OSX) then
		keyboard.stroke("cmd", "shift", "return");
	else
		keyboard.stroke("ctrl", "shift", "F5");
	end
end

--@help Toggle fullscreen
actions.end_show = function()
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

