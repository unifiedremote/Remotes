local keyboard = libs.keyboard;
local server = libs.server;

--@help Launch PowerPoint application
actions.launch = function()
	os.open("powerpnt");
end

--@help Navigate to slide
--@param n:number
actions.goto = function(n)
	keyboard.text(tostring(n));
	keyboard.press("return");
end

actions.prompt_goto = function()
	server.update({
		type = "input",
		title = "Enter slider number:",
		ontap = "goto"
	});
end

--@help Navigate to start
actions.show_start = function()
	keyboard.stroke("F5");
end

--@help Navigate to end
actions.show_end = function()
	keyboard.stroke("escape");
end

--@help Show black screen
actions.black = function()
	keyboard.stroke("B");
end

--@help Show white screen
actions.white = function()
	keyboard.stroke("W");
end

--@help Navigate previous slide
actions.previous = function()
	keyboard.stroke("left");
end

--@help Navigate next slide
actions.next = function()
	keyboard.stroke("right");
end

