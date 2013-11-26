
local tid = -1;
local tracks = {};
local playlists = {};

function js (s, callback)
	if (not callback) then
		callback = function (result) end
	end
	if (OS_OSX) then
		local result = os.script("tell application id \"com.google.chrome\" to (execute javascript \"" .. esc(s) .. "\") in active tab of window 1");
		callback(result);
	else
		libs.extension.queue("browser", "execute", s, callback);
	end
end

function esc (s)
	temp = s;
	temp = libs.utf8.replace(temp, "\"", "\\\"");
	return temp;
end

function update_result(result)
	local data = libs.data.fromjson(result);
	update_playlists(data.playlists);
	update_tracks(data.tracks);
	layout.info.text = data.title .. "\n" .. data.artist .. " - " .. data.album;
end

function update_playlists(data)
	local items = {};
	local count = 0;
	playlsits = {};
	for i,v in pairs(data) do
		playlists[count] = v;
		count = count + 1;
		table.insert(items, { type = "item", text = v.title });
	end
	libs.server.update({ id = "playlists", children = items });
end

function update_tracks(data)
	local items = {};
	local count = 0;
	tracks = {};
	for i,v in pairs(data) do
		tracks[count] = v;
		count = count + 1;
		table.insert(items, { type = "item", text = v.title .. "\n" .. v.artist });
	end
	libs.server.update({ id = "tracks", children = items });
end

function update (s)
	js(io.fread("update.js"), update_result);
end

events.focus = function ()
	update();
	tid = libs.timer.interval(update, 3000);
end

events.blur = function ()
	libs.timer.cancel(tid);
end

actions.track = function (i)
	local id = tracks[i].id;
	js("document.evaluate(\"//tr[@data-id='"..id.."']//img\", document, null, 9, null).singleNodeValue.click()");
	js("document.evaluate(\"//tr[@data-id='"..id.."']//div[@data-id='play']\", document, null, 9, null).singleNodeValue.click()");
end

actions.playlist = function (i)
	local id = playlists[i].id;
	js("document.getElementById('"..id.."').click()");
end

--@help Launch Google Music site
actions.launch = function()
	os.open("http://play.google.com/music/");
end

--@help Close
actions.close = function()
    
end

--@help Toggle playback state
actions.play_pause = function()
	js("document.evaluate(\"//button[@data-id='play-pause']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Previous track
actions.previous = function()
	js("document.evaluate(\"//button[@data-id='rewind']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Next track
actions.next = function()
	js("document.evaluate(\"//button[@data-id='forward']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Seek forward
actions.seek_forward = function()
        
end

--@help Seek backward
actions.seek_backward = function()
        
end

--@help Search
actions.search = function()
        
end

--@help Navigate up
actions.up = function()
        
end

--@help Navigate down
actions.down = function()
        
end

--@help Instant
actions.instant = function()
        
end

--@help Toggle shuffle
actions.play_shuffle = function()
	js("document.evaluate(\"//button[@data-id='shuffle']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Toggle repeat
actions.play_repeat = function()
	js("document.evaluate(\"//button[@data-id='repeat']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Select current item
actions.select = function()
        
end

--@help Navigate home
actions.home = function()
        
end

--@help Lower volume
actions.volume_down = function()
        
end

--@help Raise volume
actions.volume_up = function()
        
end

--@help Increase rating
actions.thumbs_up = function ()
	js("document.evaluate(\"//li[@title='Thumbs up']\", document, null, 9, null).singleNodeValue.click()");
end

--@help Decrease rating
actions.thumbs_down = function ()
	js("document.evaluate(\"//li[@title='Thumbs down']\", document, null, 9, null).singleNodeValue.click()");
end
