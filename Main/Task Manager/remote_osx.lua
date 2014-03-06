
local server = libs.server;
local utf8 = libs.utf8;
local list;
local items;
local tab;

function tab2list(str)
	local list = {};
	local lines = utf8.split(str, "\n");
	for i,v in ipairs(lines) do
		if (not utf8.empty(v)) then
		local parts = utf8.split(v, "\t");
		local id = parts[1];
		local name = parts[2];
		local title = parts[3];
		if (title == "missing value") then title = name; end
		local active = parts[4] ~= "false";
		table.insert(list, { id = id, name = name, title = title, active = active });
		end
	end
	return list;
end

actions.update = function (index)
	tab = index;
	local temp = "";
	local id = "";
	if (index == 0) then
		-- Tasks
		id = "ts";
		temp = os.script(
			"set myList to \"\" as text",
			"tell application \"System Events\"",
				"repeat with p in every process",
					"if background only of p is false then",
						"set myList to myList & id of p & tab & name of p & tab & short name of p & tab & frontmost of p & linefeed",
					"end if",
				"end repeat",
			"end tell",
			"return myList");
	else
		-- Processes
		id = "ps";
		temp = os.script(
			"set myList to \"\" as text",
			"tell application \"System Events\"",
				"repeat with p in every process",
					"set myList to myList & id of p & tab & name of p & tab & short name of p & tab & frontmost of p & linefeed",
				"end repeat",
			"end tell",
			"return myList");
	end

	list = tab2list(temp);
	items = {};
	for i,v in ipairs(list) do
		table.insert(items, { 
			type = "item", 
			checked = v.active, 
			text = v.title .. "\n" .. v.name
		});
	end
	server.update({ id = id, children = items });
end

actions.tap = function (index)
	local item = list[index+1];
	os.script(
		"tell application \"System Events\"",
			"repeat with p in every process whose id is " .. item.id,
				"set frontmost of p to true",
				"set visible of p to true",
			"end repeat",
		"end tell");
	actions.update(tab);
end

actions.hold = function (index)
	--local item = list[index+1];
	--local dialog = { type = "dialog", title = "Task", ontap="dialog", children = { 
	--	{ type = "item", text = "Close" },
	--	{ type = "item", text = "Quit" },
	--	{ type = "item", text = "Kill" }
	--}};
	--server.update(dialog);
end

actions.dialog = function (index)
	
end