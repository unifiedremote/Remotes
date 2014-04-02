local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

local ffi = require("ffi");
ffi.cdef[[
typedef unsigned long DWORD;
typedef long LONG;
typedef int BOOL;
typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;
BOOL GetWindowRect(LONG hwnd, RECT* rect);
]]

local last_switch = 0;

function FindPlayerWindow(browserClass)
	-- This is a bit of a beast:
	--   1. Find all windows for the specified browser window class (i.e. all tabs)
	--   2. For each "tab" check if the title starts with "Netflix - " (i.e. a netflix tab)
	--   3. For each child window in the tab, check if it is a silverlight plugin
	local hwnds = win.findall(0, browserClass, nil, false);
	for i,hwnd in ipairs(hwnds) do
		local title = win.title(hwnd);
		if utf8.contains(title, " - Twitch") then
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

actions.switch = function (clicks)
	local now = libs.timer.time();
	if (now - last_switch < 1000) then
		return;
	else
		last_switch = now;
	end

	local hwnd = FindWindow();
	if (hwnd ~= 0) then
		win.switchto(hwnd);
		
		local rect = ffi.new("RECT", 0, 0, 0, 0);
		ffi.C.GetWindowRect(hwnd, rect);
		local width = rect.right - rect.left;
		
		local x, y = libs.mouse.position();
		libs.mouse.moveto(rect.left + math.round(width/3), rect.top + 300);
		if (clicks == nil) then
			clicks = 1;
		end
		for i = 1,clicks do
			libs.mouse.click();
		end
		libs.mouse.moveto(x, y);
	end
end

--@help Launch Twitch site
actions.launch = function ()
	os.open("http://www.twitch.tv/");
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

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("space");
end

--@help Fullscreen view
actions.fullscreen = function()
	actions.switch(2);
end

--@help Windowed view
actions.window = function()
	keyboard.stroke("escape");
end

