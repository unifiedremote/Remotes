local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

local last_switch = 0;

function FindPlayerWindow(browserClass)
	--   1. Find all windows for the specified browser window class (i.e. all tabs)
	--   2. For each "tab" check if the title contains " - YouTube" (i.e. a youtube tab)
	local hwnds = win.findall(0, browserClass, nil, false);
	for i,hwnd in ipairs(hwnds) do
		local title = win.title(hwnd);
		print(title);
		if utf8.contains(title, " - YouTube") then
			return hwnd;
		end
	end
	return 0;
end

function FindWindow()
	-- Check Chrome
	hwnd = FindPlayerWindow("Chrome_WidgetWin_1");
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	-- Check IE
	hwnd = FindPlayerWindow("IEFrame");
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	-- Check FF
	hwnd = FindPlayerWindow("MozillaWindowClass");
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	return 0;
end

function ClickAndReturn (x, y)
	curx,cury = libs.mouse.position();
	libs.mouse.moveto(x, y);
	libs.mouse.click();
	libs.mouse.moveto(curx, cury);
end

actions.switch = function ()
	local now = libs.timer.time();
	if (now - last_switch < 1000) then
		return;
	else
		last_switch = now;
	end
	
	local hwnd = FindWindow();
	if (hwnd ~= 0) then
		win.switchto(hwnd);
		os.sleep(100);
		win.switchto(hwnd);
		x,y = win.findimage("volume.bmp", hwnd);
		if (x ~= -1 and y ~= -1) then 
			ClickAndReturn(x+200, y);
			return true;
		end
	end
	return false;
end

actions.click = function (icon)
	local hwnd = FindWindow();
	if (hwnd ~= 0) then
		win.switchto(hwnd);
		os.sleep(100);
		win.switchto(hwnd);
		x,y = win.findimage(icon, hwnd);
		if (x ~= -1 and y ~= -1) then
			ClickAndReturn(x, y);
			return true;
		end
	end
	return false;
end

--@help Launch YouTube
actions.launch = function()
	os.open("http://www.youtube.com");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("up");
end

--@help Rewind
actions.rewind = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Fast forward
actions.fast_forward = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Play previous item
actions.previous = function()
	actions.switch();
	keyboard.stroke("shift", "p");
end

--@help Play next item
actions.next = function()
	actions.switch();
	keyboard.stroke("shift", "n");
end

--@help Enter fullscreen
actions.fullscreen = function()
	if (not actions.click("fullscreen.bmp")) then
		keyboard.stroke("F");
	end
end

--@help Exit fullscreen
actions.exit_fullscreen = function()
	actions.switch();
	keyboard.stroke("esc");
end

--@help Toggle play/pause
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

