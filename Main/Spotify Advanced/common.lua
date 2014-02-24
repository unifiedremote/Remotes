local server = libs.server;
local timer = libs.timer;
local tid = -1;

events.focus = function ()
	tid = timer.interval(actions.update, 1000);
	update_playlists();
end

events.blur = function ()
	timer.cancel(tid);
end

actions.update = function ()
	update();
end

actions.playlists = function (i)
	set_state(i);
	update_playlists();
end

actions.back = function ()
	back_state();
	update_playlists();
end

function update_playlists ()
	local items = get_state();
	server.update({ id = "playlists", children = items });
end

function status (str)
	local items = {};
	table.insert(items, { type = "item", text = str });
	server.update({ id = "playlists", children = items });
end
