local server = libs.server;
local timer = libs.timer;
local tid = -1;

playing = false;
playing_uri = "";

-------------------------------------------------------------------------------------------
-- Remote Events
-------------------------------------------------------------------------------------------
events.focus = function ()
	playing = false;
	playing_uri = "";
	
	focus();
	tid = timer.interval(actions.update, 1000);
	timer.timeout(get_playlists, 1000);
end

events.blur = function ()
	timer.cancel(tid);
end

-------------------------------------------------------------------------------------------
-- Remote Actions
-------------------------------------------------------------------------------------------
actions.update = function ()
	update();
end

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
