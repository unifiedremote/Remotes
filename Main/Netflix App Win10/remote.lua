local kb = libs.keyboard;
local win = libs.win;
local server = libs.server;

--@help Focus Netflix app
actions.switch = function()
	local hwnd = win.find(nil, "Netflix");
	if (hwnd == 0) then return; end
	win.switchtowait(hwnd);
end

--@help Toggle play pause
actions.play_pause = function ()	
	kb.press("space");
end

actions.rewind = function ()
	
end

actions.forward = function ()
	
end

actions.volumeup = function()
	kb.press("volumeup");
end

actions.volumedown = function()
	kb.press("volumedown");
end

actions.volumemute = function()
	kb.press("volumemute");
end

