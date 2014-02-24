local utf8 = libs.utf8;
local http = libs.http;
local data = libs.data;
local fs = libs.fs;

Playlists = nil;
Items = {};

-------------------------------------------------------------------------------------------
-- Returns the current playlists state
-------------------------------------------------------------------------------------------
function get_state ()
	status("Loading...");
	
	local username = settings.username;
	local playlist = settings.playlist;
	
	Items = {};
	if (username == "") then
		local usernames = get_usernames();
		if (#usernames == 0) then
			table.insert(Items, { type = "item", text = "No usernames found" });
		else
			for k,v in pairs(usernames) do
				table.insert(Items, { type = "item", text = v, username = v });
			end
		end
	elseif (playlist == "") then
		local playlists = get_playlists(username);
		if (#playlists == 0) then
			table.insert(Items, { type = "item", text = "No playlists found" });
		else
			for k,v in pairs(playlists) do
				table.insert(Items, { type = "item", text = v.Name, playlist = v });
			end
		end
	else
		local tracks = get_tracks(playlist);
		if (#tracks == 0) then
			table.insert(Items, { type = "item", text = "No tracks found" });
		else
			for k,v in pairs(tracks) do
				table.insert(Items, { type = "item", text = v.Name .. "\n" .. v.Artist, track = v });
			end
		end
	end
	
	return Items;
end

function set_state (i)
	local username = settings.username;
	local playlist = settings.playlist;
	local track = "";

	if (username == "") then
		username = Items[i+1].username;
		print("current user set to: " .. username);
	elseif (playlist == "") then
		playlist = Items[i+1].playlist.URI;
		print("current playlist set to: " .. playlist);
	else
		track = Items[i+1].track.Name;
		print("current track set to: " .. track);
		play(Items[i+1].track.LongURI, playlist);
	end
	
	settings.username = username;
	settings.playlist = playlist;
end

function back_state ()
	status("Loading...");
	
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
function get_spotify_dir ()
	if (OS_WINDOWS) then
		return "%appdata%/Spotify/Users/";
	elseif (OS_OSX) then
		return "/Users/".. os.getenv("USER") .. "/Library/Application Support/Spotify/Users/";
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
function get_usernames ()
	local dir = get_spotify_dir();
	local arr = {};
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
function get_playlists_file (user)
	local dir = get_spotify_dir();
	return dir .. user .. "-user/guistate";
end

-------------------------------------------------------------------------------------------
-- Parse all playlists for the specified user.
--    Uses the guistate json file to find all playlist URIs.
--    Uses the cached playlist name if available.
--    Otherwise fetches the name from the web API.
-------------------------------------------------------------------------------------------
function get_playlists (user)
	if (Playlists ~= nil) then
		return Playlists;
	end
	
	local arr = {};
	
	table.insert(arr, {
		Name = "★ Starred",
		URI = "spotify:user:" .. user .. ":starred",
		ShortURI = ""
	});
	
	local file = get_playlists_file(user);
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
				status("Syncing " .. k .. " of " .. count .. "...");
				name = get_playlist_name(uri_user, short);
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
	
	Playlists = arr;
	return arr;
end

-------------------------------------------------------------------------------------------
-- Parse the name of the playlist specified by the URI.
--    Uses the "API" to get the name (inefficient)!
--    Try to find a faster way of getting this information.
--    Caches the name to the settings file.
-- Returns the name or nil if not available.
-------------------------------------------------------------------------------------------
function get_playlist_name(user, uri)
	local url = "https://open.spotify.com/user/" .. user .. "/playlist/" .. uri;
	local raw = http.get(url);
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

	
function get_tracks (uri)
	-- Note: Must pass "real" headers, otherwise the request wont return any data...
	local headers = {};
	headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
	headers["Accept-Language"] = "en-US,en;q=0.8,sv;q=0.6";
	headers["UserAgent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36";
	
	local req = {};
	req.method = "GET";
	req.url = "https://embed.spotify.com/?uri=" .. uri;
	req.headers = headers;
	
	local t1 = libs.timer.time();
	local resp = http.request(req);
	local t2 = libs.timer.time();
	print("request took: " .. t2 - t1 .. " ms");
	
	local raw = resp.content;
	
	t1 = libs.timer.time();
	local str = utf8.new(raw);
	t2 = libs.timer.time();
	print("load took: " .. t2 - t1 .. " ms");
	
	local starttok = "<div id=\"mainContainer\" class=\"main-container\">";
	local endtok = "</div><div id=\"engageView\"";
	
	local arr = {};
	
	t1 = libs.timer.time();
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

	t2 = libs.timer.time();
	print("parse took: " .. t2 - t1 .. " ms");
	
	return arr;
end

