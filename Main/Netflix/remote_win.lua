local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

function FindPlayerWindow(browserClass)
	-- 1. Find all windows for the specified browser window class (i.e. all tabs)
	-- 2. For each "tab" check if the title starts with "Netflix" (i.e. a netflix tab)
	local hwnds = win.findall(0, browserClass, nil, false);
	for i,hwnd in ipairs(hwnds) do
		local title = win.title(hwnd);
		print(title);
		if utf8.startswith(title, "Netflix") then
			return hwnd;
		end
	end
	return 0;
end

function FindWindow()
	local hwnd = 0;
	-- Check Chrome
	hwnd = FindPlayerWindow("Chrome_WidgetWin_1");
	if (hwnd ~= 0) then 
		print("chrome");
		return hwnd; 
	end
	-- Check FF
	hwnd = FindPlayerWindow("MozillaWindowClass");
	if (hwnd ~= 0) then 
		print("ff");   
		return hwnd; 
	end
	-- Check Edge
	hwnd = FindPlayerWindow("ApplicationFrameWindow");
	if (hwnd ~= 0) then
		print("edge");
		return hwnd;
	end
	return 0;
end

actions.switch = function ()
	local hwnd = FindWindow();
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
	keyboard.stroke("volumedown");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volumemute");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volumeup");
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
	keyboard.stroke("right");  
end

--@help Seek backward
actions.rewind = function()
	actions.switch();
	keyboard.stroke("left");
end

--@help Fullscreen view
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("F11");
	keyboard.stroke("F");
end

--@help Windowed view
actions.window = function()
	actions.switch();
	keyboard.stroke("escape");
	keyboard.stroke("F11");
end

actions.skip_intro = function()
	keyboard.stroke("s");
end
