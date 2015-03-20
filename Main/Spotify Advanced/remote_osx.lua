local server = require("server");
local utf8 = require("utf8");
local timer = require("timer");
local kb = require("keyboard");
local http = require("http");
local data = require("data");
local update_loop;
local tid = -1;

include("webhelper.lua")
include("common.lua")
include("playlists.lua")
include("search.lua")

events.detect = function ()
    return libs.fs.exists("/Applications/Spotify.app");
end

function focus()
    timer.timeout(update_loop, 100);
    timer.timeout(fetch_tokens, 500);
end

function blur()
    timer.cancel(tid);
end

update_loop = function ()
    local status, err = pcall(update);
    if (err) then
        print(err);
    end 
    tid = timer.timeout(update_loop, 1000);
end

function update()
    local volume = os.script("tell application \"Spotify\" to set out to sound volume") + 0;
    local pos = os.script("tell application \"Spotify\" to set out to player position") + 0;
    pos = math.ceil(pos);

    --local repeating = os.script("tell application \"Spotify\" to set out to repeating");
    --local shuffling = os.script("tell application \"Spotify\" to set out to shuffling");
    
    playing = os.script("tell application \"Spotify\" to set out to player state") == "playing";
    local id = os.script("tell application \"Spotify\" to set out to id of current track");

    local duration = os.script("tell application \"Spotify\" to set out to duration of current track") + 0;
    duration = math.ceil(duration);

    local name = os.script("tell application \"Spotify\" to set out to name of current track");

    if id ~= playing_uri then
        playing_uri = id;
        server.update({id = "currimg", image = get_cover_art(id) });
        update_playlists();
    end
    
    local icon = "play";
    if (playing) then
        icon = "pause";
    end
    
    server.update(
        { id = "currtitle", text = name },
        { id = "currvol", progress = volume },
        { id = "currpos", progress = pos, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) },
        { id = "currpos", progressMax = duration },
        { id = "play", icon = icon }
    );
end

function play(track, context)
    local play = ( 'uri=' .. track .. "&" .. 'context=' .. context);
    get_json_adv(get_url_adv('/remote/play.json', play));
end

--@help Launch Spotify application
actions.launch = function()
    os.start("spotify");
end

--@help Change position
--@param pos:number Set position
actions.poschange = function (pos)
    os.script("tell application \"Spotify\" to set player position to " .. pos);
    update();
end

--@help Change volume
--@param vol:number Set volume
actions.volchange = function (vol)
    os.script("tell application \"Spotify\" to set sound volume to " .. vol);
    update();
end

--@help Next track
actions.next = function ()
    os.script("tell application \"Spotify\" to next track");
    update();
end

--@help Previous track
actions.previous = function ()
    os.script("tell application \"Spotify\" to previous track");
    update();
end

--@help Set repeting
actions.setrepeat = function()
    os.script("tell application \"Spotify\" to set repeating to true");
end

--@help Set not repeting
actions.setnotrepeat = function()
    os.script("tell application \"Spotify\" to set repeating to false");
end

actions.repeating = function (checked)
    if checked then 
        os.script("tell application \"Spotify\" to set repeating to true");
    else
        os.script("tell application \"Spotify\" to set repeating to false");
    end
end

--@help Play track
actions.play = function ()
    os.script("tell application \"Spotify\" to play");
    update();
end

--@help Pause track
actions.pause = function ()
    os.script("tell application \"Spotify\" to pause");
    update();
end

--@help Play Pause track
actions.play_pause = function ()
    os.script("tell application \"Spotify\" to playpause");
    update();
end

--@help Set Suffle
actions.setshuffle = function()
    os.script("tell application \"Spotify\" to set shuffling to true");
end
--@help Set not Shuffle
actions.setnotshuffle = function()
    os.script("tell application \"Spotify\" to set shuffling to false");
end

actions.suffle = function (checked)
    if checked then 
        os.script("tell application \"Spotify\" to set shuffling to true");
    else
        os.script("tell application \"Spotify\" to set shuffling to false");
    end
end

