local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer;
local server = libs.server;

events.detect = function ()
	return libs.fs.exists("%APPDATA%\\Spotify");
end

-- Commands
local WM_APPCOMMAND = 0x0319;
local WM_KEYDOWN = 0x100;
local WM_KEYUP = 0x101;
local VK_UP = 0x26;
local VK_DOWN = 0x28;
local CMD_PLAY_PAUSE = 917504;
local CMD_VOLUME_DOWN = 589824;
local CMD_VOLUME_UP = 655360;
local CMD_STOP = 851968;
local CMD_PREVIOUS = 786432;
local CMD_NEXT = 720896;
local CMD_MUTE = 524288;

-- Key Simulation Helper
function KeyHelper(vk, param)
	local hwnd = win.find("SpotifyMainWindow", nil);
	hwnd = win.find(hwnd, 0, "CefBrowserWindow", nil);
	hwnd = win.find(hwnd, 0, "Chrome_WidgetWin_0", nil);
	hwnd = win.find(hwnd, 0, "Chrome_RenderWidgetHostHWND", nil);
	if (hwnd) then
		keyboard.down("control");
		win.post(hwnd, WM_KEYDOWN, vk, param);
		os.sleep(100);
		win.post(hwnd, WM_KEYUP, vk, param);
		keyboard.up("control");
	end
end

local tid = -1;
local playing = false;
local title = "";

events.focus = function ()
	playing = false;
	title = "";
	tid = timer.interval(actions.update, 500);
	layout.p.icon = "playpause";
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("SpotifyMainWindow", nil);
	local _title = win.title(hwnd):sub(10);
	local _playing = true;
	
	if (_title == "") then
		_title = "[Not Playing]";
		_playing = false;
	elseif (_title == "remium") then
		_title = "[Info not available right now]";
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
	
	if (_playing ~= playing) then
		playing = _playing;
		if (playing) then
			server.update({ id = "p", icon = "pause" });
		else
			server.update({ id = "p", icon = "play" });
		end
	end
end

--@help Send raw command to Spotify
--@param cmd:number
actions.command = function (cmd)
	local hwnd = win.find("SpotifyMainWindow", nil);
	win.send(hwnd, WM_APPCOMMAND, 0, cmd);
	actions.update();
end

--@help Launch Spotify application
actions.launch = function()
	os.start("%appdata%\\Spotify\\spotify.exe");
end

--@help Start playback
actions.play = function()
	if (not playing) then
		actions.play_pause();
	end
end

--@help Pause playback
actions.pause = function()
	if (playing) then
		actions.play_pause();
	end
end

--@help Toggle playback state
actions.play_pause = function()
	actions.command(CMD_PLAY_PAUSE);
end

--@help Lower volume
actions.volume_down = function()
	KeyHelper(VK_DOWN, 0xC1500001);
end

--@help Raise volume
actions.volume_up = function()
	KeyHelper(VK_UP, 0x01480001);
end

--@help Mute volume
actions.volume_mute = function()
	actions.command(CMD_MUTE);
end

--@help Next track
actions.next = function()
	actions.command(CMD_NEXT);
end

--@help Previous track
actions.previous = function()
	actions.command(CMD_PREVIOUS);
end

--@help Stop playback
actions.stop = function()
	actions.command(CMD_STOP);
end

