local server = libs.server;
local http = libs.http;
local utf8 = libs.utf8;
local timer = libs.timer;
local data = libs.data;

include("common.lua")
include("playlists.lua")

OAuthKey = nil;
CFID = nil;
Playing = false;

function focus()
	OAuthKey = get_oauth_key();
	CFID = get_cfid();
end

function update()
	local status = api_status();
	local playing = status.playing ~= 0;
	local volume = math.ceil(status.volume * 100);
	
	local track = "";
	local artist = "";
	local album = "";
	local pos = 0;
	local duration = 0;
	
	if (status.track ~= nil) then
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
	
	local repeating = status["repeat"] ~= 0;
	local shuffling = status["shuffle"] ~= 0;
	
	local name = track .. " - " .. artist;
	local icon = "play";
	if (playing) then
		icon = "pause";
	end
	
	Playing = playing;
	
	server.update(
		{ id = "currtitle", text = name },
		{ id = "currvol", progress = volume },
		{ id = "currpos", progress = pos, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) },
		{ id = "currpos", progressMax = duration },
		{ id = "repeat", checked = repeating },
		{ id = "suffle", checked = shuffling },
		{ id = "play", icon = icon }
	);
end

actions.play = function ()
	if (Playing) then
		api_pause();
	else
		api_resume();
	end
end

function get_cfid ()
	local resp = recv("simplecsrf/token.json?", nil, nil);
	local json = data.fromjson(resp);
	return json.token;
end

function api_play (uri, context)
	local resp = recv("remote/play.json?uri=" .. uri .. "&context=" + context, OAuthKey, CFID);
end

function api_resume ()
	local resp = recv("remote/pause.json?pause=false", OAuthKey, CFID);
end

function api_pause ()
	local resp = recv("remote/pause.json?pause=true", OAuthKey, CFID);
end

function api_status ()
	local resp = recv("remote/status.json?", OAuthKey, CFID);
	local json = data.fromjson(resp);
	return json;
end

function recv (req, oauth, cfid)
	local params = "&ref=&cors=&_=" .. timer.time();
	if (oauth ~= nil) then
		params = params .. "&oauth=" .. oauth;
	end
	if (cfid ~= nil) then
		params = params .. "&csrf=" .. cfid;
	end
	params = params .. "&returnafter=-1";
	params = params .. "&returnon=login%2Clogout%2Cplay%2Cpause%2Cerror%2Cap";
	
	local url = "http://127.0.0.1:4380/" .. req .. params;
	
	local headers = {};
	headers["Origin"] = "https://embed.spotify.com";
	headers["Referer"] = "https://embed.spotify.com/?uri=spotify:track:5Zp4SWOpbuOdnsxLqwgutt";
	
	local req = {};
	req.method = "GET";
	req.url = url;
	req.headers = headers;
	
	local resp = http.request(req);
	local raw = resp.content;
	return raw;
end

function get_oauth_key ()
	-- Note: Must pass "real" headers, otherwise the request wont return any data...
	local headers = {};
	headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
	headers["Accept-Language"] = "en-US,en;q=0.8,sv;q=0.6";
	headers["UserAgent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36";
	
	local req = {};
	req.method = "GET";
	req.url = "https://embed.spotify.com/?uri=spotify:track:5Zp4SWOpbuOdnsxLqwgutt";
	req.headers = headers;
	
	local resp = http.request(req);
	local raw = resp.content;
	local str = utf8.new(raw);
	
	local pos = str:indexof("tokenData");
	if (pos > -1) then
		pos = str:indexof("'", pos);
		if (pos > -1) then
			pos = pos + 1;
			local pos2 = str:indexof("'", pos);
			local key = str:sub(pos, pos2 - pos);
			print(key);
			return key;
		end
	end
	
	return nil;
end