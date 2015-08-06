local server = require("server");
local http = require("http");
local utf8 = require("utf8");
local timer = require("timer");
local data = require("data");
local keyboard = require("keyboard");
local win = require("win");

local keys;
local selectedPlaylist;

include("common.lua");
include("spotify_api_v1.lua");
include("playlist.lua");
include("search.lua");
include("webhelper.lua");

-- Native Command Constants
local WM_LBUTTONDOWN = 0x0201;
local WM_LBUTTONUP = 0x0202;
local WM_APPCOMMAND = 0x0319;
local CMD_PLAY_PAUSE = 917504; 	-- E0000
local CMD_STOP = 851968; 		-- D0000
local CMD_PREVIOUS = 786432; 	-- C0000
local CMD_NEXT = 720896; 		-- B0000
local CMD_VOLUME_UP = 655360; 	-- A0000
local CMD_VOLUME_DOWN = 589824; -- 90000
local CMD_MUTE = 524288; 		-- 80000



-- Native Windows Stuff
local bit = require("bit");
local ffi = require("ffi");
ffi.cdef[[
typedef void* HWND;
typedef long LONG;
typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;
bool GetWindowRect(LONG hwnd, RECT* rect);
]]

--@help Next track
actions.next = function ()
	actions.command(CMD_NEXT);
end

--@help Previous track
actions.previous = function ()
	actions.command(CMD_PREVIOUS);
end

--@help Toggle Shuffle 
actions.shuffle = function ()
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	click(hwnd, rect.right - rect.left - 202, rect.bottom - rect.top - 37);
	click(hwnd, 0, 0);
end

--@help Toggle Repeat 
actions.repeating = function ()
	print("repeat");
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	click(hwnd, rect.right - rect.left - 170, rect.bottom - rect.top - 37);
	click(hwnd, 0, 0);
end

--@help Change Volume
--@param vol:number Set Volume
actions.volchange = function (vol)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	local y = rect.bottom - rect.top - 37;
	local x = (rect.right - rect.left - 107) + math.floor(vol / 100 * 79) + 1;
	click(hwnd, x, y);
	
	update_quiet();
end

--@help Change Position
--@param pos:number Set Position
actions.poschange = function (pos)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	pos = pos / playing_duration * 100;
	
	local y = rect.bottom - rect.top - 37;
	local x1 = 214;
	local x2 = rect.right - rect.left - 366;
	local w = x2 - x1;
	local x = x1 + math.floor(pos / 100 * w) + 1;
	click(hwnd, x, y);
	
	update_quiet();
end

--@help Launch Spotify application
actions.launch = function()
	os.start("%appdata%\\Spotify\\spotify.exe");
end

--@help Send raw command to Spotify
--@param cmd:number
actions.command = function (cmd)
	local hwnd = win.find("SpotifyMainWindow", nil);
	win.send(hwnd, WM_APPCOMMAND, 0, cmd);
end

function click(hwnd, x, y)
	local pos = bit.lshift(y, 16) + x;
	win.post(hwnd, WM_LBUTTONDOWN, 0x01, pos);
	os.sleep(100);
	win.post(hwnd, WM_LBUTTONUP, 0x00, pos);
end

function get_hwnd()
	local hwnd = win.find("SpotifyMainWindow", nil);
	hwnd = win.find(hwnd, 0, "CefBrowserWindow", nil);
	hwnd = win.find(hwnd, 0, "Chrome_WidgetWin_0", nil);
	hwnd = win.find(hwnd, 0, "Chrome_RenderWidgetHostHWND", nil);
	return hwnd;
end

