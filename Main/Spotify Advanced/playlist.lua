local http = require("http");
local utf8 = require("utf8");
local server = require("server");
local data = require("data");

local state = 0;
local tracks;
local savedTracks = {};
local trackitems = {};
local playlistsinfo;
local offset = 0;

local PLAYLIST_STATE_INIT = 0;
local PLAYLIST_STATE_LISTS = 1;
local PLAYLIST_STATE_TRACKS = 2;

local playlist_current;
local playlist_tracks;
local playlist_lists = {};
local playlist_state = 0;

-- Globals
meinfo = {};
playlist = {};

function playlist_log (str)
	print("playlist.lua: " .. str);
end

-------------------------------------------------------------------------------------------
-- Playlist initialization
-------------------------------------------------------------------------------------------

function playlist_init ()
	playlist_state = 0;

	local url = spotify_api_v1_url("/me");
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			playlist_log(err);
			meinfo = nil;
			server.update({
				id = "playlists",
				children = { 
					{ type = "item", text = "Not logged in..." } 
				}
			});
		else
			meinfo = data.fromjson(resp.content);
			playlist_state = 0;
			playlist_select();
		end
	end);
end


-------------------------------------------------------------------------------------------
-- Playlist logic
-------------------------------------------------------------------------------------------

function playlist_back ()
	playlist_state = playlist_state - 2;
	if (playlist_state < 0) then
		playlist_state = 0;
	end
	playlist_update();
end

function playlist_update ()
	-- Update playlists
	if (playlist_state == 0) then
		local items = {};
		
		for i = 1, #playlist_lists.items do
			local playlist = playlist_lists.items[i];
			local fmt = format_playlist(playlist);
			if (playlist.id == -1) then
				table.insert(items, { type = "item", text = playlist.name});
			else 
				table.insert(items, { type = "item", text = fmt});
			end
		end

		server.update({
			id = "playlists",
			children = items
		});

		-- Hide back button
		layout.back.text = " ";

		playlist_state = 1;
	
	-- Update playlist contents
	elseif (playlist_state == 1) then
		playlist_get_tracks(0);
		playlist_state = 2;
		
	-- Update with more track to playlist contents
	elseif (playlist_state == 2) then
		if (#savedTracks > index) then
			webhelper_play(savedTracks[index + 1].track.uri, playlist_current.uri);
		else
			offset = offset + 100;
			playlist_get_tracks(offset);
		end
		
	end
end

function playlist_select (index)
	if (not is_connected()) then
		open_connect_dialog();
		return;
	end
	
	-- Get and show playlists
	if (playlist_state == 0) then
		playlist_get_lists();
		
	-- Get playlist contents
	elseif (playlist_state == 1) then
		-- Show back button again
		layout.back.icon = "back";
		
		playlist_current = playlist_lists.items[index+1];
		trackitems = {};
		savedTracks = {};
		playlist_get_tracks(0);

	-- Get more playlist tracks
	elseif (playlist_state == 2) then
		if (#savedTracks > index) then
			webhelper_play(savedTracks[index + 1].track.uri, playlist_current.uri);
		else
			offset = offset + 100;
			playlist_get_tracks(offset);
		end
		
	end
end

function playlist_update_playing () 
	if (playlist_state == 1) then
		-- Sorry but we are not able to tell what playlist is running
	end
	if (playlist_state == 2) then
		for i = 1, #trackitems do
			trackitems[i].checked = (utf8.equals(trackitems[i].uri, playing_uri));
		end
		server.update({
			id = "playlists",
			children = trackitems
		});
	end
end


-------------------------------------------------------------------------------------------
-- Fetch information
-------------------------------------------------------------------------------------------

function playlist_get_lists ()
	local url = spotify_api_v1_url("/users/" .. meinfo.id .. "/playlists"); 
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			playlist_log("HTTP.error: " .. err);
			playlist_lists = nil;
		else
			playlist_lists = data.fromjson(resp.content);
			table.insert(playlist_lists.items, 1, {
				name = "★ Starred\nYour starred tracks",
				tracks = { total = "-1" },
				id = -1,
				owner = { name = meinfo.id }
			});
			playlist_update();
		end
	end);
end

function playlist_get_tracks(offset)
	local filter = "items.track(uri,name,artists.name),total,next";
	
	if (playlist_current == nil) then 
		table.insert(savedTracks, { type = "item", text = "No current playlist"}); 
		return;
	end

	if (offset == 0) then
		trackitems = {};
	end

	if (playlist_current.id == -1) then 
		user_get_starred(offset);
		return;
	end

	get_playlist(playlist_current.owner.id, playlist_current.id, filter, offset, function (err, pllist)
		if (err) then 
			playlist_log("HTTP.error: " .. err);
			return;
		end

		playlist_tracks = pllist.items;
		if (playlist_tracks ~= nil) then
			
			if (#trackitems > 0 and utf8.equals(trackitems[#trackitems].text, "Load more tracks...")) then
				table.remove(trackitems, #trackitems);
			end
			
			for i = 1, #playlist_tracks do
				local track = playlist_tracks[i].track;
				local title = format_track_2line(track);
				local uri = track.uri;
				local checked = (uri == playing_uri);
				table.insert(trackitems, { type = "item", text = title, uri = uri, checked = checked});
				table.insert(savedTracks, playlist_tracks[i]); 
			end

			if (pllist.next ~= nil) then 
				table.insert(trackitems, { type = "item", text = "Load more tracks..."});
			end
			
			server.update({
				id = "playlists",
				children = trackitems
			});
			
			playlist_log("Number of tracks:" .. #playlist_tracks);

		end
		playlist_state = 2;

	end);
end

function user_get_starred(offset)
	local user = meinfo.id;
	get_starred(user, offset, function(err, starred)  
		if (err) then
			playlist_log(err);
			return;
		end

		playlist_tracks = starred.tracks.items;
		if (playlist_tracks ~= nil) then
			
			if (#trackitems > 0 and utf8.equals(trackitems[#trackitems].text, "Load more tracks...")) then
				table.remove(trackitems, #trackitems);
			end

			for i = 1, #playlist_tracks do
				local track = playlist_tracks[i].track;
				local title = format_track_2line(track);
				local uri = track.uri;
				local checked = (uri == playing_uri);
				table.insert(trackitems, { type = "item", text = title, uri = uri, checked = checked});
				table.insert(savedTracks, playlist_tracks[i]); 
			end
			if (starred.next ~= nil) then 
				table.insert(trackitems, { type = "item", text = "Load more tracks..."});
			end
			
			server.update({
				id = "playlists",
				children = trackitems
			});
		end
		playlist_current = {uri = starred.uri, owner = meinfo};
		playlist_state = 2;
	end);
end

function get_playlist(user, id, filter, offset, callback)
	local user_safe = http.urlcomponentencode(user);
	local params = "market=" .. meinfo.country .. "&fields=" .. filter .. "&limit=100&offset=" .. offset;
	local url = spotify_api_v1_url("/users/" .. user_safe .. "/playlists/" .. id .. "/tracks?" .. params);
	
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			playlist_log("HTTP.error: " .. err .. "\n" .. url);
			callback(err, nil)
		else
			local pllist = data.fromjson(resp.content);
			callback(nil, pllist);
		end
	end);
end

function get_starred(user, offset, callback)
	local user_safe = http.urlcomponentencode(user);
	local params = "market=" .. meinfo.country .. "&limit=100&offset=" .. offset;
	local url = spotify_api_v1_url("/users/" .. user_safe .. "/starred?" .. params); 
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			playlist_log("HTTP.error: " .. err .. "\n" .. url);
			callback(err, nil)
		else
			local starred = data.fromjson(resp.content);
			callback(nil, starred);
		end
	end);
end

function playlist.contains(list, item) 
	for i = 1, #list do
		if (utf8.equals(list[i], item)) then
			return true;
		end
	end
	return false;
end