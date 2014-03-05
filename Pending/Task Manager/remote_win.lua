local win = libs.win;
local server = libs.server;
local list;
local items;

actions.update = function (index)
	if (index == 0) then
		-- Tasks
		list = win.list(false);
		items = {};
		for i,task in ipairs(list) do
			table.insert(items, { type = "item", text = task.title });
		end
		server.update({ id = "ts", children = items });
	else
		-- Processes
		list = win.list(true);
		items = {};
		for i,task in ipairs(list) do
			table.insert(items, { type = "item", text = task.name .. "\n" .. task.title });
		end
		server.update({ id = "ps", children = items });
	end
end

actions.tap = function (index)
	local item = list[index+1];
	win.switchto(item.handle);
end

actions.hold = function (index)
	local item = list[index];
	local dialog = { type = "dialog", title = "Task", ontap="dialog", children = { 
		{ type = "item", text = "Close" },
		{ type = "item", text = "Quit" },
		{ type = "item", text = "Kill" }
	}};
	server.update(dialog);
end
