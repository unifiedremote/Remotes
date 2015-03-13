local server = libs.server;
local http = libs.http;
local utf8 = libs.utf8;
local timer = libs.timer;
local data = libs.data;
local win = libs.win;
local stop = false;

events.detect = function ()
	return libs.fs.exists("%APPDATA%\\Spotify");
end

include("common.lua")
include("playlists.lua")
include("search.lua")

local OAuthKey = nil;
local CFID = nil;
local HelperPort = 4381;

local WM_LBUTTONDOWN = 0x0201;
local WM_LBUTTONUP = 0x0202;
local WM_APPCOMMAND = 0x0319;
local CMD_PLAY_PAUSE = 917504;
local CMD_VOLUME_DOWN = 589824;
local CMD_VOLUME_UP = 655360;
local CMD_STOP = 851968;
local CMD_PREVIOUS = 786432;
local CMD_NEXT = 720896;
local CMD_MUTE = 524288;

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

function focus()
	get_oauth_key(function (key)
		print("oauthkey: " .. key);
		OAuthKey = key;
		get_cfid(function (cfid)
			print("cfid: " .. cfid);
			CFID = cfid;
			stop = false;
			update();
		end);
	end);
end

function blur()
	stop = true;
end

function update()
	status(function (status)
		if (stop) then
			return;
		end
		
		playing = status.playing ~= 0;
		local volume = math.ceil(status.volume * 100);
		
		local track = "";
		local artist = "";
		local album = "";
		local pos = 0;
		local duration = 0;
		local uri = "";
		
		if (status.track ~= nil) then
			uri = status.track.track_resource.uri;
			pos = math.ceil(status.playing_position);
			duration = math.ceil(status.track.length);
		
			if (status.track.artist_resource ~= nil) then
				artist = status.track.artist_resource.name;
			else
				artist = "Unknown";
			end
			if (status.track.track_resource ~= nil) then
				track = status.track.track_resource.name;
			else
				track = "Unknown";
			end
			if (status.track.album_resource ~= nil) then
				album = status.track.album_resource.name;
			else
				album = "";
			end
		end

		if (uri ~= playing_uri) then
			playing_uri = uri;
			server.update({ id = "currimg", image = get_cover_art(uri) });
			update_playlists();
		end
		
		--local repeating = status["repeat"] ~= 0;
		--local shuffling = status["shuffle"] ~= 0;
		
		local name = track .. " - " .. artist;
		if (track == "" and artist == "") then
			name = "[Not Playing]";
		end
		
		local icon = "play";
		if (playing) then
			icon = "pause";
		end
		
		Playing = playing;
		
		server.update(
			{ id = "currtitle", text = name },
			{ id = "currvol", progress = volume },
			{ id = "currpos", progress = math.floor(pos / duration * 100), progressMax = 100, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) },
			{ id = "play", icon = icon }
		);
		
		update();
	end);
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

--@help Start playback
actions.play = function()
	if (not Playing) then
		actions.play_pause();
	end
end

--@help Pause playback
actions.pause = function()
	if (Playing) then
		actions.play_pause();
	end
end

--@help Toggle playback state
actions.play_pause = function()
	actions.command(CMD_PLAY_PAUSE);
end

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
	click(hwnd, rect.right - rect.left - 202, rect.bottom - rect.top - 30);
	click(hwnd, 0, 0);
end

--@help Toggle Repeat 
actions.repeating = function ()
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	click(hwnd, rect.right - rect.left - 170, rect.bottom - rect.top - 30);
	click(hwnd, 0, 0);
end

--@help Change Volume
--@param vol:number Set Volume
actions.volchange = function (vol)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	local y = rect.bottom - rect.top - 30;
	local x = (rect.right - rect.left - 107) + math.floor(vol / 100 * 79) + 1;
	click(hwnd, x, y);
end

--@help Change Position
--@param pos:number Set Position
actions.poschange = function (pos)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	local y = rect.bottom - rect.top - 30;
	local x1 = 214;
	local x2 = rect.right - rect.left - 366;
	local w = x2 - x1;
	local x = x1 + math.floor(pos / 100 * w) + 1;
	click(hwnd, x, y);
end

-------------------------------------------------------------------------------------------
-- Spotify Local API
-------------------------------------------------------------------------------------------
function get_cfid (done)
	recv("simplecsrf/token.json?", nil, nil, function (resp)
		local json = data.fromjson(resp);
		done(json.token);
	end);
end

function play (uri, context)
	recv("remote/play.json?uri=" .. uri .. "&context=" .. context, OAuthKey, CFID);
end

function resume ()
	recv("remote/pause.json?pause=false", OAuthKey, CFID);
end

function pause ()
	recv("remote/pause.json?pause=true", OAuthKey, CFID);
end

function status (done)
	recv("remote/status.json?", OAuthKey, CFID, function (resp)
		done(data.fromjson(resp));
	end);
end


function recv (path, oauth, cfid, done)
	local params = "&ref=&cors=&_=" .. timer.time();
	if (oauth ~= nil) then
		params = params .. "&oauth=" .. oauth;
	end
	if (cfid ~= nil) then
		params = params .. "&csrf=" .. cfid;
	end
	params = params .. "&returnafter=1";
	params = params .. "&returnon=login%2Clogout%2Cplay%2Cpause%2Cerror%2Cap";
	
	local url = "http://127.0.0.1:" .. HelperPort .. "/" .. path .. params;
	
	local headers = {};
	headers["Origin"] = "https://embed.spotify.com";
	headers["Referer"] = "https://embed.spotify.com/?uri=spotify:track:5Zp4SWOpbuOdnsxLqwgutt";
	
	local req = {};
	req.method = "GET";
	req.url = url;
	req.headers = headers;
	
	http.request(req, function (err, resp)
		if (err) then
			if (HelperPort == 4381) then
				print("testing fallback port");
				HelperPort = 4380;
				recv(path, oauth, cfid, done);
			end
		elseif (done) then
			done(resp.content);
		end
	end);
end

function get_oauth_key (done)
	-- Note: Must pass "real" headers, otherwise the request wont return any data...
	local headers = {};
	headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
	headers["Accept-Language"] = "en-US,en;q=0.8,sv;q=0.6";
	headers["UserAgent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36";
	
	local req = {};
	req.method = "GET";
	req.url = "https://embed.spotify.com/?uri=spotify:track:5Zp4SWOpbuOdnsxLqwgutt";
	req.headers = headers;
	
	http.request(req, function (err, resp)
		local raw = resp.content;
		local str = utf8.new(raw);
		
		local pos = str:indexof("tokenData");
		if (pos > -1) then
			pos = str:indexof("'", pos);
			if (pos > -1) then
				pos = pos + 1;
				local pos2 = str:indexof("'", pos);
				local key = str:sub(pos, pos2 - pos);
				done(key);
				return;
			end
		end
	end);
end





