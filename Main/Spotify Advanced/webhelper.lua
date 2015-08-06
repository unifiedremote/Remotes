local http = require("http");
local data = require("data");
local utf8 = require("utf8");
local timer = require("timer");

local webhelper_port = 0;
local webhelper_key = "";
local webhelper_cfid = "";

-- Based on https://github.com/cgbystrom/spotify-local-http-api

-------------------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------------------

function webhelper_log (str)
	-- print(str);
end

function webhelper_init (done)
	webhelper_key = "";
	webhelper_cfid = "";
	webhelper_port = 4379;
	
	webhelper_get_oauth(function (err, key)
		if (err) then
			return done(err);
		end
		webhelper_key = key;
		webhelper_get_cfid(function (err, cfid)
			if (err) then
				return done(err);
			end
			webhelper_cfid = cfid;
			done();
		end); 
	end);
end

function webhelper_get_oauth (done)
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
				webhelper_log("OAuth key: " .. key);
				done(nil, key);
				return;
			end
		end
		done("Could not find OAuth token");
	end);
end

function webhelper_get_cfid (done)
	webhelper_req("simplecsrf/token.json?", function (resp)
		local json = data.fromjson(resp);
		if (json.token == nil) then
			return done("Could not find CSRF token");
		end
		webhelper_log("cfid: " .. json.token);
		done(nil, json.token);
	end);
end

-------------------------------------------------------------------------------------------
-- Request Logic
-------------------------------------------------------------------------------------------

function webhelper_req_retry (path, done)
	if (webhelper_port < 4385) then
		webhelper_port = webhelper_port + 1;
	else
		webhelper_port = 4379;
	end
	
	webhelper_log("Retrying with port: " .. webhelper_port);
	webhelper_req(path, done);
end

function webhelper_req (path, done)
	local params = "&ref=&cors=&_=" .. timer.time();
	params = params .. "&oauth=" .. webhelper_key;

	if (webhelper_cfid ~= "") then
		params = params .. "&csrf=" .. webhelper_cfid;
	end
	
	params = params .. "&returnafter=1";
	params = params .. "&returnon=login%2Clogout%2Cplay%2Cpause%2Cerror%2Cap";
	
	local url = "http://ur.spotilocal.com:" .. webhelper_port .. "/" .. path .. params;
	webhelper_log("webhelper_req: " .. url);
	
	local headers = {};
	headers["Origin"] = "https://embed.spotify.com";
	headers["Referer"] = "https://embed.spotify.com/?uri=spotify:track:5Zp4SWOpbuOdnsxLqwgutt";
	
	local req = {};
	req.method = "GET";
	req.url = url;
	req.headers = headers;
	
	http.request(req, function (err, resp)
		if (err) then
			webhelper_req_retry(path, done);
			return;
		end

		if (done) then
			done(resp.content);
		end
	end);
end

-------------------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------------------

function webhelper_play (uri, context)
	webhelper_req("remote/play.json?uri=" .. uri .. "&context=" .. context);
end

function webhelper_resume ()
	webhelper_req("remote/pause.json?pause=false");
end

function webhelper_pause ()
	webhelper_req("remote/pause.json?pause=true");
end

function webhelper_get_status (done)
	webhelper_req("remote/status.json?", function (resp)
		local json = data.fromjson(resp);
		done(json);
	end);
end
