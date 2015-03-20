local server = require("server");
local utf8 = require("utf8");
local timer = require("timer");
local kb = require("keyboard");
local http = require("http");
local data = require("data");
local log = require("log");

local PORT = 4370;
local oauth_token = "";
local csrf_token_token = "";

-- Based on https://github.com/cgbystrom/spotify-local-http-api

function fetch_tokens()
    oauth_token = get_oauth_token();
    log.info("Using oauth_token: " .. oauth_token);
    csrf_token = get_csrf_token();
    log.info("Using csrf_token: " .. csrf_token);
end

function get_json(url)
    local raw = http.get(url);
    local json = data.fromjson(raw);
    return json;
end

function get_json_adv(url)
    local hdrs = {};
    hdrs["Origin"] = "https://open.spotify.com";
    local req = { 
        url = url,
        method = "get",
        headers = hdrs 
    };
    log.info("GET " .. url);
    local resp = http.request(req);
    local json = data.fromjson(resp.content);
    return json;
end

function generate_local_hostname()
    return  'ur.spotilocal.com';
end

function get_url_plain( url )
    return "https://" .. generate_local_hostname() .. ":" .. PORT .. url ;
end

function get_url_adv(url, params)
    local all = 'oauth=' .. oauth_token .. "&" .. 'csrf=' .. csrf_token .. "&" .. params
    return get_url_plain(url) .. "?" .. all;
end

function get_csrf_token()
    local url = get_url_plain('/simplecsrf/token.json');
    return get_json_adv(url, "")['token'];
end 

function get_oauth_token()
    return get_json('http://open.spotify.com/token')['t'];
end