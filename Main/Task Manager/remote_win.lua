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
	item = list[index+1];
	win.switchto(item.handle);
end

actions.hold = function (index)
	item = list[index+1];
	local dialog = { type = "dialog", title = "Task", ontap="dialog", children = { 
		{ type = "item", text = "Close" },
		{ type = "item", text = "Quit" },
		{ type = "item", text = "Kill" }
	}};
	server.update(dialog);
end

actions.dialog = function (index)
	if index == 0 then
		win.close(item.handle);
	elseif index == 1 then
		win.quit(item.handle);
	elseif index == 2 then
		win.kill(item.handle);
	end
	actions.update();
end