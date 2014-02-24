local server = libs.server;

events.focus = function ()
	actions.update();
end

events.blur = function ()
	
end

actions.update = function ()
	local items = get_state();
	server.update({ id = "playlists", children = items });
end

actions.playlists = function (i)
	set_state(i);
	actions.update();
end

actions.back = function ()
	back_state();
	actions.update();
end

function status (str)
	local items = {};
	table.insert(items, { type = "item", text = str });
	server.update({ id = "playlists", children = items });
end