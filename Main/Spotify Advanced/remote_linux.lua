local server = require("server");
local http = require("http");
local utf8 = require("utf8");
local timer = require("timer");
local data = require("data");
local keyboard = require("keyboard");
local script = require("script");

local keys;
local selectedPlaylist;

include("common.lua");
include("spotify_api_v1.lua");
include("webhelper.lua");
include("playlist.lua");
include("search.lua");

events.detect = function ()
    return libs.fs.exists("/opt/spotify/spotify-client/spotify");
end

function dbus(command)
    script.default("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player." .. command);
end

--@help Next track
actions.next = function ()
    dbus("Next");
    update();
end

--@help Previous track
actions.previous = function ()
    dbus("Previous");
    update();
end

--@help Lower volume
actions.volume_down = function()
    keyboard.press("volumedown");
end

--@help Raise volume
actions.volume_up = function()
    keyboard.press("volumeup");
end

--@help Mute volume
actions.volume_mute = function()
    keyboard.press("volumemute");
end