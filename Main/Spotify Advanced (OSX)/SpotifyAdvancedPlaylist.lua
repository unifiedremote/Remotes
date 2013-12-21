local utf8 = libs.utf8;
local net = libs.net;
local server = libs.server;
local task = libs.task;
local data = libs.data;
local timer = libs.timer;
local fs = libs.fs;
local views = {};
local playlists = {};
local curruser;
function updatePlayList( globtracks )
	local us = os.getenv("USER");
	if #globtracks == 0 then 
		globtracks = getUsers("/Users/" .. us .. "/Library/Application Support/Spotify/Users/");
		state = 0;
	end

	local children = {};
	for t = 1, #globtracks do
		local child = {};
		child.type = "item";
		child.text = globtracks[t].Name;
		print(globtracks[t].LongURI);
		table.insert(children, child);
	end
	server.update({ id = "playlist", children = children});
	return globtracks;
end



function loadPlaylists( index , user, globtracks)
	globtracks = getPlaylists(user);
	local children = {};
	for t = 1, #globtracks do
		local child = {};
		child.type = "item";
		child.text = globtracks[t].Name;
		table.insert(children, child);
	end
	server.update({ id = "playlist", children = children});
	return globtracks;
end

function loadTracks( index , playlist , globtracks)
	local http = net.http();
		local resp = http:request({
		method = "get", 
			url = "https://embed.spotify.com/?uri=" .. playlist,
		});
		local str = utf8.new(resp.content);
		globtracks = readPlaylistFile(str);
		local children = {};
		for t = 1, #globtracks do
			local child = {};
			child.type = "item";
			child.text = globtracks[t].Name;
			table.insert(children, child);
		end
		server.update({ id = "playlist", children = children});
		return globtracks;
end

function getUsers( dir )
	local users = {};
	local dirs = fs.dirs(dir);
	for d = 1, #dirs do 
		local user = {};
		user.Name = fs.name(dirs[d]);
		user.Path = dirs[d];
		table.insert(users, user);
	end
	return users;
end

function getPlaylists( user)
	local us = os.getenv("USER");
	print(#views);
	print(user);
	print (curruser);
	if #views == 0 or utf8.equals(user,curruser) == false then 
		curruser = user;
		print("first");
		views = readGuistate("/Users/".. us .. "/Library/Application Support/Spotify/Users/" .. user .. "/guistate");
		for v = 1 , #views do 
			print(views[v].uri);
			if views[v].sort_mode == 0 then
				local playlist = {}
				playlist.Uri = views[v].uri;
				playlist.Name = getPlaylistName(views[v].uri);
				table.insert(playlists, playlist);
			end
		end
	end
	return playlists;
end

function getPlaylistName( uri )
	local http = net.http();
	local resp = http:request({
		method = "get", 
			url = "https://embed.spotify.com/?uri=" .. uri,
	});
	local str = utf8.new(resp.content);
	local start = str:indexof("<title>") + 7;
	local endPos = str:indexof("</title>");
	return str:sub(start, endPos-start);
end

function readGuistate( file )
	local f = fs.read(file)
    local d = data.fromjson(f);
    return d.views;
end

function readPlaylistFile( content )

	local tracks = {};
	local begin = "<div id=\"mainContainer\" class=\"main-container\">";
	local endstring = "</div><div id=\"engageView\"";
	local beginpos = content:indexof(begin);
	if beginpos ~= -1 then
		beginpos = beginpos + utf8.len(begin);
		local endPos = content:indexof(endstring, beginpos);
		if endPos ~= -1 then
			local len = endPos - beginpos;
			local p = beginpos;
			p = content:indexof("<li class=\"track-", p);
			while p > -1 do
				local track = {};
				p = content:indexof("data-track=", p);
				if p ~= nil and p > -1 then
					p = content:indexof("\"", p);
					track.URI = content:sub(p+1, content:indexof("\"", p+1)-p-1);
					track.LongURI = "spotify:track:" .. track.URI;
				else 
					break;
				end
				p = content:indexof("data-duration=", p);
				if p > -1 then
					p = content:indexof("\"", p);
					track.Duration = content:sub(p+1, content:indexof("\"", p+1)-p-1);
				else 
					break;
				end
				p = content:indexof("data-ca=", p);
				if p > -1 then
					p = content:indexof( "\"", p);
					track.Cover = content:sub(p+1, content:indexof("\"", p+1)-p-1);
				else 
					break;
				end
				p = content:indexof("<li class=\"track-title", p);
				if p > -1 then
					p = content:indexof("rel=\"", p);
					local pp = content:indexof("\">", p);
					track.Name = content:sub(p+5, pp-p-5);
				else 
					break;
				end
				p = content:indexof("<li class=\"artist", p);
				if p > -1 then
					p = p + 5;
					p = content:indexof(" ", p)+1;
					track.ArtistURI = content:sub(p, content:indexof(" ", p)-p);
					p = content:indexof("rel=\"", p)+5;
					track.Artist = content:sub(p, content:indexof("\" style=\"", p)-p);
				else
					break;
				end
				table.insert(tracks,track);
			end
		end
	end
	return tracks;
end