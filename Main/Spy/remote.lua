
local mouse = libs.mouse;
local server = libs.server;
local timer = libs.timer;

-- Native Windows Stuff
local ffi = require("ffi");
ffi.cdef[[
typedef void* HWND;
typedef unsigned long DWORD;
typedef long LONG;
typedef struct {
	LONG x;
	LONG y;
} POINT;
HWND GetDesktopWindow();
HWND WindowFromPoint(POINT Point);
int GetClassNameA(HWND hwnd, char* className, int maxCount);
int GetWindowTextA(HWND hwnd, char* text, int maxCount);
]]

--------------------------------------------------------

local tid = -1;

events.focus = function ()
	tid = timer.interval(function ()
		x1,y1 = mouse.position();
		
		local pos = ffi.new("POINT", x1, y1);
		local hwnd = ffi.C.WindowFromPoint(pos);
		
		local class = ffi.new("char[255]");
		ffi.C.GetClassNameA(hwnd, class, 255);
		class = ffi.string(class, 255);
		
		local text = ffi.new("char[255]");
		ffi.C.GetWindowTextA(hwnd, text, 255);
		text = ffi.string(text, 255);
		
		server.update({id = "position", text = "X: " .. x1 .. ", Y: " .. y1 });
		server.update({id = "window", text = "Window: " .. tostring(tonumber(ffi.cast("long", hwnd))) });
		server.update({id = "class", text = "Class: " .. tostring(class) });
		server.update({id = "text", text = "Text: " .. tostring(text) });
		
	end, 100);
end

events.blur = function ()
	timer.cancel(tid);
end
