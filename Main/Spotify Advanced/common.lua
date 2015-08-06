local server = require("server");
local timer = require("timer");
local http = require("http");
local data = require("data");
local utf8 = require("utf8");
local fs  = require("fs");

playing = false;
playing_uri = "";
playing_duration = 0;
playing_shuffle = false;
playing_repeat = false;

-------------------------------------------------------------------------------------------
-- Spotify Cover Art Grabber
-------------------------------------------------------------------------------------------
function get_cover_art_url (uri, callback)
	local url = "https://embed.spotify.com/oembed/?url=" .. uri;
	http.get(url, function(err, resp) 
		if (err) then
			callback(err, nil);
		else
			local json = data.fromjson(resp);
			local result = utf8.replace(json.thumbnail_url, "cover", "320");
			callback(nil, result);
		end
	end);
end

function get_cover_art (uri, callback)
	if (uri ~= nil and settings.last_cover_uri == uri) then 
		-- Return cached data
		local data = fs.read("latest_coverart.png");
		callback(nil, data);
		return;
	end

	get_cover_art_url(uri, function(err, url) 
		http.get(url, function(err, raw)
			callback(err, raw);
			-- Save for later
			fs.write("latest_coverart.png", raw);
			settings.last_cover_uri = uri;
		end);
	end);
end


-------------------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------------------

local quiet = false;

function update_quiet ()
	quiet = true;
end


function update ()
	if (quiet) then
		quiet = false;
		timer.timeout(update, 1000);
		return;
	end
	
	webhelper_get_status(function (status)
		if (stop) then
			print("Stopping update");
			return;
		end

		playing = (status.playing ~= 0);
		
		local volume = 0;
		local track = "";
		local artist = "";
		local album = "";
		local pos = 0;
		local duration = 0;
		local uri = "";

		if (status.volume ~= nil) then
			volume = math.ceil(status.volume * 100);
		end

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
			playlist_update_playing();
			timer.timeout(function ()
				get_cover_art(uri, function(err, img)
					if (err) then
						print("Failed to load image for track " + uri);
					else 
						server.update({ id = "currimg", image = img });
					end
				end);
			end, 100);
		end
		
		local name = track .. " - " .. artist;
		if (track == "" and artist == "") then
			name = "[Not Playing]";
		end
		
		Playing = playing;
		
		playing_shuffle = status["shuffle"] > 0;
		playing_repeat = status["repeat"] > 0;
		playing_duration = duration;
		local duraction_text = data.sec2span(pos) .. " / " .. data.sec2span(duration);
		server.update(
			{ id = "currtitle", text = name },
			{ id = "currvol", progress = volume },
			{ id = "currpos", progress = math.floor(pos), progressMax = duration, text = duraction_text }
		);

		server_update_play_state();

		timer.timeout(update, 1000);
	end);
end

function server_update_play_state()
	local icon = "";
	if (not Playing) then
		icon = "play";
	else 
		icon = "pause";
	end
	server.update(
		{ id = "play", icon = icon },
		{ id = "shuffle", checked = playing_shuffle }
	);
end

-------------------------------------------------------------------------------------------
-- Format string utils
-------------------------------------------------------------------------------------------


function format_artists(artists)
	local builder = {};
	if (#artists == 1) then 
		return artists[1].name
	end
	for i = 1, #artists do
		table.insert(builder, artists[i].name);
	end
	return utf8.join(", ", builder);
end

function format_track(item)
	return format_artists(item.artists) .. " - " .. item.name;
end

function format_track_2line(item)
	return item.name .. "\n" .. format_artists(item.artists);
end

function format_playlist(playlist)
	return playlist.name .. "\n" .. playlist.tracks.total .. " tracks";
end

function format_album(album)
	return album.name .. "\n(" .. album.album_type .. ")";
end

function format_artist(artist)
	return artist.name .. "\n" .. "Popularity: " .. artist.popularity .. " /  100";
end

-------------------------------------------------------------------------------------------
-- State
-------------------------------------------------------------------------------------------

events.focus = function()
	ensure_connect();
	
	webhelper_init(function (err)
		if (err) then
			print(err);
			layout.currtitle.text = "[Not Running]";
			return;
		end
		stop = false;
		playing_uri = "";
		playlist_init();
		update();
	end)
end

events.blur = function ()
	stop = true;
end


-------------------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------------------

actions.connect_dialog = function(i)
	os.open("http://localhost:9510/web/#/status/connect");
end

actions.selected = function(index)
	playlist_select(index);
end

--@help Navigate back
actions.back = function()
	playlist_back();
end

--@help Start playback
actions.play = function()
	if (not Playing) then
		webhelper_resume();
		Playing = true;
		server_update_play_state();
	end
end

--@help Pause playback
actions.pause = function()
	if (Playing) then
		webhelper_pause();
		Playing = false;
		server_update_play_state();
	end
end

--@help Toggle playback state
actions.play_pause = function()
	if (Playing) then 
		actions.pause();
	else
		actions.play();
	end
end
