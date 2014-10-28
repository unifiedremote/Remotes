local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

local html5 = false;

function FindPlayerWindow(browserClass, playerClass, silverlight)
	-- This is a bit of a beast:
	--   1. Find all windows for the specified browser window class (i.e. all tabs)
	--   2. For each "tab" check if the title starts with "Netflix - " (i.e. a netflix tab)
	--   3. For each child window in the tab, check if it is a silverlight plugin
	local hwnds = win.findall(0, browserClass, nil, false);
	for i,hwnd in ipairs(hwnds) do
		local title = win.title(hwnd);
		if utf8.startswith(title, "Netflix - ") then
			if (not silverlight) then
				if (browserClass == "IEFrame") then
					return 0;
				else
					return hwnd;
				end
			end
			local childHwnds = win.findall(hwnd, nil, nil, true);
			for j,child in ipairs(childHwnds) do
				local cls = win.class(child);
				if (cls == playerClass) then
					return child
				end
			end
		end
	end
	return 0;
end

function FindWindow(silverlight)
	-- Check if running in fullscreen
	-- If so, just return that window
	local hwnds = win.findall(0, "AGFullScreenWinClass", nil, false);
	if (#hwnds > 0) then
		return hwnds[1];
	end
	local hwnd = 0;
	-- Check Chrome
	hwnd = FindPlayerWindow("Chrome_WidgetWin_1", "NativeWindowClass", silverlight);
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	-- Check IE
	hwnd = FindPlayerWindow("IEFrame", "MicrosoftSilverlight", silverlight);
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	-- Check FF
	hwnd = FindPlayerWindow("MozillaWindowClass", "GeckoPluginWindow", silverlight);
	if (hwnd ~= 0) then 
		return hwnd; 
	end
	return 0;
end

actions.switch = function ()
	html5 = true;
	local hwnd = FindWindow(true);
	if (hwnd == 0) then
		hwnd = FindWindow(false);
	else
		html5 = false;
	end
	if (hwnd ~= 0) then
		win.switchto(hwnd);
		os.sleep(100);
		win.switchto(hwnd);
	end
end

--@help Launch Netflix site
actions.launch = function ()
	os.open("http://www.netflix.com/");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	if (html5) then
		keyboard.stroke("volumedown");
	else
		keyboard.stroke("down");
	end
end

--@help Mute volume
actions.volume_mute = function()
	actions.switch();
	if (html5) then
		keyboard.stroke("volumemute");
	else
		keyboard.stroke("M");
	end
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	if (html5) then
		keyboard.stroke("volumeup");
	else
		keyboard.stroke("up");
	end
end

--@help Pause playback
actions.pause = function()
	actions.switch();
	keyboard.stroke("next");
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Navigate left
actions.left = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Select current item
actions.select = function()
	actions.switch();
	keyboard.stroke("return");
end

--@help Navigate right
actions.right = function()
	actions.switch();
	keyboard.stroke("right");
end

--@help Seek forward
actions.forward = function()
	actions.switch();
	keyboard.stroke("control", "right");
end

--@help Seek backward
actions.rewind = function()
	actions.switch();
	keyboard.stroke("control", "left");
end

--@help Fullscreen view
actions.fullscreen = function()
	actions.switch();
	if (html5) then
		keyboard.stroke("F11");
	else
		keyboard.stroke("F");
	end
end

--@help Windowed view
actions.window = function()
	actions.switch();
	if (html5) then
		keyboard.stroke("F11");
	else
		keyboard.stroke("escape");
	end
end

