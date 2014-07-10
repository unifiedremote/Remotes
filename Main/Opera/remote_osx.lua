local keyboard = libs.keyboard;
local device = libs.device;

--@help Focus Opera application
actions.switch = function()
	os.script("tell application \"Opera\" to reopen activate");
end

--@help Launch Opera application
actions.launch = function()
	os.start("opera");
end

--@help Naviagte back
actions.back = function()
	actions.switch();
	keyboard.stroke("cmd", "left");
end

--@help Close current tab
actions.close_tab = function()
	actions.switch();
	keyboard.stroke("cmd", "W");
end

--@help Navigate forward
actions.forward = function()
	actions.switch();
	keyboard.stroke("cmd", "right");
end

--@help Go to next tab
actions.next_tab = function()
	actions.switch();
	keyboard.stroke("option", "tab");
end

--@help Go to previous tab
actions.previous_tab = function()
	actions.switch();
	keyboard.stroke("option", "shift", "tab");
end

--@help Open new tab
actions.new_tab = function()
	actions.switch();
	keyboard.stroke("option", "T");
end

--@help Type address
actions.address = function()
	actions.switch();
	keyboard.stroke("cmd", "L");
	device.keyboard();
end

--@help Go to home page
actions.home = function()
	actions.switch();
	keyboard.stroke("option", "home");
end

--@help Find on current page
actions.find = function()
	actions.switch();
	keyboard.stroke("cmd", "F");
	device.keyboard();
end

--@help Zoom page in
actions.zoom_in = function()
	actions.switch();
	keyboard.stroke("cmd", "plus");
end

--@help Zoom page out
actions.zoom_out = function()
	actions.switch();
	keyboard.stroke("cmd", "kpminus");
end

--@help Use normal zoom
actions.zoom_normal = function()
	actions.switch();
	keyboard.stroke("cmd", "0");
end

--@help Scroll page down
actions.scroll_down = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Scroll page up
actions.scroll_up = function()
	actions.switch();
	keyboard.stroke("shft", "space");
end

--@help Refresh current page
actions.refresh = function()
	actions.switch();
	keyboard.stroke("cmd", "R");
end

