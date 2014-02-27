local utf8 = libs.utf8;
local http = libs.http;
local data = libs.data;
local fs = libs.fs;

playlists = {};
playlists.list = nil;
playlists.state = {};

-------------------------------------------------------------------------------------------
-- Returns the current playlists state.
-------------------------------------------------------------------------------------------
playlists.get_state = function ()
	update_status("Loading...");
	
	local username = settings.username;
	local playlist = settings.playlist;
	
	playlists.state = {};
	if (username == "") then
		local items = playlists.get_usernames();
		if (#items == 0) then
			table.insert(playlists.state, { type = "item", text = "No usernames found" });
		else
			for k,v in pairs(items) do
				table.insert(playlists.state, { type = "item", text = v, username = v });
			end
		end
	elseif (playlist == "") then
		local items = playlists.get_playlists(username);
		if (#items == 0) then
			table.insert(playlists.state, { type = "item", text = "No playlists found" });
		else
			for k,v in pairs(items) do
				table.insert(playlists.state, { type = "item", text = v.Name, playlist = v });
			end
		end
	else
		local items = playlists.get_tracks(playlist);
		if (#items == 0) then
			table.insert(playlists.state, { type = "item", text = "No tracks found" });
		else
			for k,v in pairs(items) do
				table.insert(playlists.state, { type = "item", checked = checked, text = v.Name .. "\n" .. v.Artist, track = v });
			end
		end
	end
	
	return playlists.state;
end

-------------------------------------------------------------------------------------------
-- Go the next state for the specified item index.
-------------------------------------------------------------------------------------------
playlists.set_state = function (i)
	local username = settings.username;
	local playlist = settings.playlist;
	local track = "";
	local uri = "";
	local update = false;
	
	if (username == "") then
		username = playlists.state[i+1].username;
		update = true;
	elseif (playlist == "") then
		playlist = playlists.state[i+1].playlist.URI;
		update = true;
	else
		track = playlists.state[i+1].track.Name;
		uri = playlists.state[i+1].track.LongURI;
		play(uri, playlist);
	end
	
	settings.username = username;
	settings.playlist = playlist;
	
	return update;
end

-------------------------------------------------------------------------------------------
-- Go back to the previous "state".
-------------------------------------------------------------------------------------------
playlists.back = function ()
	update_status("Loading...");
	
	local username = settings.username;
	local playlist = settings.playlist;
	
	if (playlist ~= "") then
		playlist = "";
	elseif (username ~= "") then
		username = "";
	end
	
	settings.username = username;
	settings.playlist = playlist;
end

-------------------------------------------------------------------------------------------
-- Build the path to the Spotify data directory.
--    Returns the correct path for different OS.
-------------------------------------------------------------------------------------------
playlists.get_spotify_dir = function ()
	if (OS_WINDOWS) then
		return "%appdata%/Spotify/Users/";
	elseif (OS_OSX) then
		return "~/Library/Application Support/Spotify/Users/";
	elseif (OS_LINUX) then
		return "";
	else
		return "";
	end
end

-------------------------------------------------------------------------------------------
-- Get a list of all available Spotify usernames.
--    Check for stored usernames in the data directory.
-------------------------------------------------------------------------------------------
playlists.get_usernames = function ()
	local arr = {};
	
	local dir = playlists.get_spotify_dir();
	if (not fs.exists(dir)) then
		return arr;
	end
	
	local dirs = fs.dirs(dir);
	for k,v in pairs(dirs) do
		local name = fs.name(v);
		name = utf8.sub(name, 0, utf8.len(name) - 5);
		table.insert(arr, name);
	end
	return arr;
end

-------------------------------------------------------------------------------------------
-- Build the filename of the playlists file for the specified user.
--    Uses the current logged in OSX username.
-------------------------------------------------------------------------------------------
playlists.get_playlists_file = function (user)
	local dir = playlists.get_spotify_dir();
	return dir .. user .. "-user/guistate";
end

-------------------------------------------------------------------------------------------
-- Parse all playlists for the specified user.
--    Uses the guistate json file to find all playlist URIs.
--    Uses the cached playlist name if available.
--    Otherwise fetches the name from the web API.
-------------------------------------------------------------------------------------------
playlists.get_playlists = function (user)
	if (playlists.list ~= nil) then
		return playlists.list;
	end
	
	local arr = {};
	
	table.insert(arr, {
		Name = "★ Starred",
		URI = "spotify:user:" .. user .. ":starred",
		ShortURI = ""
	});
	
	local file = playlists.get_playlists_file(user);
	local raw = io.fread(file);
	local json = data.fromjson(raw);
	local views = json.views;
	local count = #views;
	for k,v in pairs(views) do
		if v.sort_mode == 0 then
			local uri = v.uri;
			local split = utf8.split(uri, ":");
			local uri_user = split[3];
			local short = split[#split];
			local name = settings["playlists.names." .. short];
			if (name == "") then
				update_status("Syncing " .. k .. " of " .. count .. "...");
				name = playlists.get_playlist_name(uri_user, short);
			end
			if (name ~= nil) then
				local item = {}
				item.URI = v.uri;
				item.ShortURI = short;
				item.Name = name;
				table.insert(arr, item);
			end
		end
	end
	
	playlists.list = arr;
	return arr;
end

-------------------------------------------------------------------------------------------
-- Parse the name of the playlist specified by the URI.
--    Uses the "API" to get the name (inefficient)!
--    Try to find a faster way of getting this information.
--    Caches the name to the settings file.
-- Returns the name or nil if not available.
-------------------------------------------------------------------------------------------
playlists.get_playlist_name = function (user, uri)
	local url = "https://open.spotify.com/user/" .. user .. "/playlist/" .. uri;
	local raw = http.get(url);
	if (raw == nil) then
		return "Playlist";
	end
	local str = utf8.new(raw);
	local token = "<meta property=\"og:title\" content=\"";
	local start = str:indexof(token);
	if (start ~= -1) then
		start = start + string.len(token);
		local endpos = str:indexof("\">", start);
		if (endpos ~= -1) then
			local title = http.urldecode(str:sub(start, endpos - start));
			settings["playlists.names." .. uri] = title;
			return title;
		end
	end
	return nil;
end

-------------------------------------------------------------------------------------------
-- Get all the tracks for the given playlist URI
-------------------------------------------------------------------------------------------
playlists.get_tracks = function (uri)
	-- Note: Must pass "real" headers, otherwise the request wont return any data...
	local headers = {};
	headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
	headers["Accept-Language"] = "en-US,en;q=0.8,sv;q=0.6";
	headers["UserAgent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36";
	
	local arr = {};
	
	local req = {};
	req.method = "GET";
	req.url = "https://embed.spotify.com/?uri=" .. uri;
	req.headers = headers;
	
	local resp = http.request(req);
	local raw = resp.content;
	
	if (raw == nil) then
		return arr;
	end
	
	local str = utf8.new(raw);
	local starttok = "<div id=\"mainContainer\" class=\"main-container\">";
	local endtok = "</div><div id=\"engageView\"";
	local pos = str:indexof(starttok);
	if (pos ~= -1) then
		pos = pos + utf8.len(starttok);
		local endpos = str:indexof(endtok, pos);
		
		pos = str:indexof("<li class=\"track-", pos);
		while (pos > -1 and pos < endpos) do
		
			local track = {};
			
			-- Find the track URI
			pos = str:indexof("data-track=", pos);
			if pos > -1 then
				pos = str:indexof("\"", pos);
				track.URI = str:sub(pos+1, str:indexof("\"", pos+1)-pos-1);
				track.LongURI = "spotify:track:" .. track.URI;
			else 
				break;
			end
			
			-- Find the track Duration
			pos = str:indexof("data-duration=", pos);
			if pos > -1 then
				pos = str:indexof("\"", pos);
				track.Duration = str:sub(pos+1, str:indexof("\"", pos+1)-pos-1);
			else 
				break;
			end
			
			-- Find the track Cover Art
			pos = str:indexof("data-ca=", pos);
			if pos > -1 then
				pos = str:indexof( "\"", pos);
				track.Cover = str:sub(pos+1, str:indexof("\"", pos+1)-pos-1);
			else 
				break;
			end
			
			-- Find the track Title
			pos = str:indexof("<li class=\"track-title", pos);
			if pos > -1 then
				pos = str:indexof("rel=\"", pos);
				local pp = str:indexof("\">", pos);
				track.Name = str:sub(pos+5, pp-pos-5);
			else 
				break;
			end
			
			-- Find the track Artist
			pos = str:indexof("<li class=\"artist", pos);
			if pos > -1 then
				pos = pos + 5;
				pos = str:indexof(" ", pos)+1;
				track.ArtistURI = str:sub(pos, str:indexof(" ", pos)-pos);
				pos = str:indexof("rel=\"", pos)+5;
				track.Artist = str:sub(pos, str:indexof("\" style=\"", pos)-pos);
			else
				break;
			end
			
			table.insert(arr, track);
			pos = str:indexof("<li class=\"track-", pos);
		end
	end
	
	return arr;
end

