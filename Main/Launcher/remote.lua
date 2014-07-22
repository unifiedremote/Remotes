local fs = require("fs");
local server = require("server");
local list;
local items;

events.focus = function ()
	list = fs.dirs("/Applications/");
	items = {};
	for i = 1, #list do
		print(list[i]);
		table.insert(items, { type = "item", text = fs.name(list[i]) });
	end
	server.update({ id = "list", children = items });
end

actions.tap = function (index)
	local item = list[index+1];
	os.open(item);
end