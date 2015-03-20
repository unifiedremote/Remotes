local server = libs.server;
local timer = libs.timer;
local http = libs.http;
local data = libs.data;
local st = libs.utf8;
local dev = libs.device;

playing = false;
playing_uri = "";

-------------------------------------------------------------------------------------------
-- Remote Events
-------------------------------------------------------------------------------------------
events.focus = function ()
	dev.toast("Unstable until Spotify fixes their issues. We're working on it :)");

	playing = false;
	playing_uri = "";
	
	focus();
	timer.timeout(get_playlists, 1000);
end

events.blur = function ()
	blur();
end

-------------------------------------------------------------------------------------------
-- Remote Actions
-------------------------------------------------------------------------------------------

actions.playlists = function (i)
	if (playlists.set_state(i)) then
		get_playlists();
	end
end

actions.back = function ()
	playlists.back();
	get_playlists();
end

-------------------------------------------------------------------------------------------
-- Helper Functions
-------------------------------------------------------------------------------------------
function get_playlists ()
	playlists.get_state();
	update_playlists();
end

function update_playlists ()
	local items = playlists.state;
	for k,v in pairs(items) do
		if (v.track ~= nil and v.track.LongURI ~= nil) then
			local checked = (playing_uri == v.track.LongURI);
			items[k].checked = checked;
		end
	end
	server.update({ id = "playlists", children = items });
end

function update_status (str)
	local items = {};
	table.insert(items, { type = "item", text = str });
	server.update({ id = "playlists", children = items });
end

-------------------------------------------------------------------------------------------
-- Spotify Cover Art Grabber
-------------------------------------------------------------------------------------------
function get_cover_art_url (uri)
	local url = "https://embed.spotify.com/oembed/?url=" .. uri;
	local raw = http.get(url);
	local json = data.fromjson(raw);
	return st.replace(json.thumbnail_url, "cover", "320");
end

function get_cover_art (uri)
	local url = get_cover_art_url(uri);
	local raw = http.get(url);
	return raw;
end

