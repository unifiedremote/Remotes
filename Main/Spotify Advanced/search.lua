local d = require("data");
local http = require("http");
local utf8 = require("utf8");
local server = require("server");
local timer = require("timer");

local query = "";
local mainitems = {};
local trackitems = {};

actions.search_changed = function (text)
	if (utf8.empty(text) and #settings.search_query > 2) then
		text = settings.search_query;
		layout.search_query.text = text;
		query = text;
		actions.go();
	end

	query = http.urlencode(utf8.trim(text));
	settings.search_query = text;
end

actions.search_done = function (text)
	actions.search_changed(text);
	actions.go();
end

actions.go = function ()
	local types = { "track", "album", "artist", "playlist" };

	local limit = 5;
	local url = spotify_api_v1_url("/search?q=" .. query .. "&type=" .. utf8.join(",", types) .. "&limit=" .. limit );
	print("GET " .. url);
	
	layout.mainlist.visibility="visible";
	layout.playlistlist.visibility="gone";
	layout.tracklist.visibility="gone";
	layout.artistinfolist.visibility="gone";
	
	mainitems = {};
	server.update({
		id = "mainlist",
		children = {{ type = "item", text = "Searching..."}}
	});

	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			print(err);
			server.update({
				id = "mainlist",
				children = {{ type = "item", text = "Not logged in..."}}
			});
		else
			local res = libs.data.fromjson(resp.content);

			if(res.tracks ~= nil) then
				table.insert(mainitems, {type = "item", text = "Tracks\nTop " .. limit .. " tracks",  checked = true, stype = 5});
				local titems = res.tracks.items;
				for i = 1, #titems do
					local fmt = format_track_2line(titems[i]);
					local checked = titems[i].uri == playing_uri;
					table.insert(mainitems, {type = "item", text = fmt, stype = 1, track = titems[i], checked = checked});
				end
				if (#titems == 0) then
					table.insert(mainitems, {type = "item", text = "(no results)", stype = 5});
				end
			end
			if(res.artists ~= nil) then
				table.insert(mainitems, {type = "item", text = "Artists\nTop " .. limit .. " artists",  checked = true, stype = 6});
				local aitems = res.artists.items;
				for i = 1, #aitems do
					local artist = aitems[i];
					local fmt = format_artist(artist);
					table.insert(mainitems, {type = "item", text = fmt, stype = 2, artist = artist});
				end
				if (#aitems == 0) then
					table.insert(mainitems, {type = "item", text = "(no results)", stype = 6});
				end
			end
			if(res.albums ~= nil) then
				table.insert(mainitems, {type = "item", text = "Albums\nTop " .. limit .. " albums",  checked = true, stype = 4});
				local aitems = res.albums.items;
				for i = 1, #aitems do
					local album = aitems[i];
					local fmt = format_album(album);
					table.insert(mainitems, {type = "item", text = fmt, stype = 0, album = album});
				end
				if (#aitems == 0) then
					table.insert(mainitems, {type = "item", text = "(no results)", stype = 4});
				end
			end
			if(res.playlists ~= nil) then
				table.insert(mainitems, {type = "item", text = "Playlists\nTop " .. limit .. " playlists",  checked = true, stype = 7});
				local pitems = res.playlists.items;
				for i = 1, #pitems do
					local playlist = pitems[i];
					local fmt = format_playlist(playlist);
					table.insert(mainitems, {type = "item", text = fmt, stype = 3, playlist = playlist});
				end
				if (#pitems == 0) then
					table.insert(mainitems, {type = "item", text = "(no results)", stype = 7});
				end
			end
			server.update({id = "mainlist", children = mainitems});
		end
	end);
end

local mainlist_selected = 0;
actions.mainlist = function ( id )
	if (not is_connected()) then
		open_connect_dialog();
		return;
	end

	mainlist_selected = id;
	id = id + 1;
	local it = mainitems[id];
	
	if (it == nil) then
		print("Mainlist was reset...");
		return;
	end

	-- If press on track in search
	if(it.stype == 1) then
		webhelper_play(it.track.uri, "");
		playing_uri = it.track.uri;
		actions.go();
		timer.timeout(function()
			playing_uri = it.track.uri;
			actions.go();
		end, 1000);
	end

	-- If press on artist, show popular tracks
	if (it.stype == 2) then
		layout.mainlist.visibility = "gone";
		layout.artistinfolist.visibility = "visible";
		layout.artistinfolist.children = {
			type = "item", text = "Loading..."
		};

		show_artist(it);
	end 

	-- If press on album, show all tracks
	if (it.stype == 0) then
		layout.mainlist.visibility = "gone";
		layout.tracklist.visibility = "visible";
		layout.tracklist.children = {
			type = "item", text = "Loading..."
		};

		show_album(it);
	end 

	-- If press on playlist, show all tracks
	if (it.stype == 3) then
		layout.mainlist.visibility = "gone";
		layout.playlistlist.visibility = "visible";
		layout.playlistlist.children = {
			type = "item", text = "Loading..."
		};

		show_playlist(it);
	end

end

actions.artistinfolist_tap = function ( id )
	id = id + 1;
	local it = trackitems[id];
	local uri = it.track.uri;
	print("artistinfolist_tap: " .. it.track.uri);
	webhelper_play(uri, "");
	
	playing_uri = uri;
	actions.mainlist(mainlist_selected);
end


actions.playlistlist_tap = function ( id )
	id = id + 1;
	local it = trackitems[id];
	local uri = it.track.uri;
	print("playlistlist_tap: " .. uri .. ", " .. it.playlist);
	
	webhelper_play(uri, it.playlist);
	playing_uri = uri;
	actions.mainlist(mainlist_selected);
end

actions.tracklist_tap = function ( id )
	id = id + 1;
	local it = trackitems[id];
	local uri = it.track.uri;
	print("tracklist_tap: " .. uri);
	
	webhelper_play(uri, "");
	playing_uri = uri;
	actions.mainlist(mainlist_selected);
end

function show_artist(it)
	local url = spotify_api_v1_url("/artists/" .. it.artist.id .. "/top-tracks?country=" .. meinfo.country);
	http.request({ method = "get", url = url, connect = "spotify" }, 
		function (err, resp)
			if (err) then
				print("Error artist: " .. it.artist.id);
			else 
				print("Success artist: " .. it.artist.id);
				local res = libs.data.fromjson(resp.content);
				if(res.tracks ~= nil) then
					local titems = res.tracks;
					trackitems = {};
					for i = 1, #titems do
						local toptrack = titems[i];
						local fmt = toptrack.name .. "\n" .. "Popularity: " .. toptrack.popularity .. " /  100";
						local checked = (toptrack.uri == playing_uri);
						table.insert(trackitems, {type = "item", text = fmt, track = toptrack, checked = checked});
					end
					server.update({id = "artistinfolist", children = trackitems});
				end
			end
		end
	);
end

function show_album(it)
	local url = spotify_api_v1_url("/albums/" .. it.album.id .. "/tracks?market=" .. meinfo.country);
	http.request({ method = "get", url = url, connect = "spotify" }, 
		function (err, resp)
			if (err) then
				print("Error album: " .. it.album.id);
			else 
				print("Success album: " .. it.album.id);
				local res = libs.data.fromjson(resp.content);
				if(res.items ~= nil) then
					local titems = res.items;
					trackitems = {};
					for i = 1, #titems do
						local track = titems[i];
						local fmt = format_track(track);
						local checked = (track.uri == playing_uri);
						table.insert(trackitems, {type = "item", text = fmt, track = track, checked = checked});
					end
					server.update({id = "tracklist", children = trackitems});
				end
			end
		end
	);
end 
-- spotify:album:02h9kO2oLKnLtycgbElKsw

function show_playlist(it)
	local pid = it.playlist.id;
	local url = spotify_api_v1_url("/users/" .. it.playlist.owner.id .. "/playlists/" .. pid .. "/tracks?market=" .. meinfo.country);
	http.request({ method = "get", url = url, connect = "spotify" }, 
		function (err, resp)
			if (err) then
				print("Error playlist: " .. pid);
			else 
				print("Success playlist: " .. pid);
				local res = libs.data.fromjson(resp.content);
				if(res.items ~= nil) then
					local titems = res.items;
					trackitems = {};
					for i = 1, #titems do
						local trackitem = titems[i];
						local fmt = format_track(trackitem.track);
						local checked = (trackitem.track.uri == playing_uri);
						table.insert(trackitems, {type = "item", text = fmt, track = trackitem.track, playlist = pid, checked = checked});
					end
					server.update({id = "playlistlist", children = trackitems});
				end
			end
		end
	);
end 
