local server = require("server");
local http = require("http");
local utf8 = require("utf8");
local timer = require("timer");
local data = require("data");
local keyboard = require("keyboard");

local keys;
local selectedPlaylist;

include("common.lua");
include("spotify_api_v1.lua");
include("webhelper.lua");
include("playlist.lua");
include("search.lua");

events.detect = function ()
    return libs.fs.exists("/Applications/Spotify.app");
end

function send_script(cmd)
	os.script("tell application \"Spotify\" to " .. cmd);
end

--@help Next track
actions.next = function ()
    send_script("next track");
    update();
end

--@help Previous track
actions.previous = function ()
    send_script("previous track");
    update();
end

--@help Change Volume
--@param vol:number Set Volume
actions.volchange = function (vol)
	send_script("set sound volume to " .. vol);
	update_quiet();
end

--@help Change Position
--@param pos:number Set Position
actions.poschange = function (pos)
    send_script("set player position to " .. pos);
	update_quiet();
end

--@help Toggle Shuffle 
actions.shuffle = function (checked)
	set_shuffle(checked);
	update_quiet();
end

--@help Toggle Repeat 
actions.repeating = function ()
	set_repeat(not playing_repeat);
	update();
end

function set_shuffle (yes) 
	if yes then 
		send_script("set shuffling to true");
    else
        send_script("set shuffling to false");
    end
end

function set_repeat (yes) 
	if yes then 
        send_script("set repeating to true");
    else
        send_script("set repeating to false");
    end
end