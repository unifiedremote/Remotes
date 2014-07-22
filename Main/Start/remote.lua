local fs = require("fs");
local server = require("server");
local utf8 = require("utf8");
local items;

function get_roots ()
	common_startmenu = fs.special("common_startmenu");
	startmenu = fs.special("startmenu");
	appdata = fs.special("appdata");
	return 
	{
		common_startmenu,
		startmenu,
		utf8.replace(startmenu, os.getenv("USERNAME"), "Default"),
		fs.combine(appdata, "Microsoft\\Internet Explorer\\Quick Launch\\User Pinned\\StartMenu")
	};
end

function update ()
	local path = settings.path;
	local roots = get_roots();
	local added_dirs = {};
	local added_files = {};
	local count = 0;
	
	-- loop through all roots
	for i,root in ipairs(roots) do
	
		-- create the nested path
		local nested = fs.combine(root, path);
		
		-- check if the path exists for the current root
		if (fs.exists(nested)) then
		
			-- get all subdirs in this path
			local dirs = fs.dirs(nested);
			
			-- loop through all subdirs
			for i,dir in ipairs(dirs) do
				-- add it if not already added
				local name = fs.fullname(dir);
				if (added_dirs[name] == nil) then
					added_dirs[name] = dir;
					count = count + 1;
				end
			end
			
			-- get all files in this path
			local files = fs.files(nested);
			
			-- loop through all files
			for i,file in ipairs(files) do
				-- add it if not already added
				local name = fs.fullname(file);
				if (added_files[name] == nil) then
					added_files[name] = file;
					count = count + 1;
				end
			end
		end
	end
	
	-- maybe show loading
	-- if (count > 30) then
		-- items = {};
		-- table.insert(items, {
			-- type = "item",
			-- text = "Loading..."
		-- });	
		-- server.update({ id = "list", children = items });
	-- end
	
	-- create list
	items = {};
	
	-- add dirs to list
	for name,dir in pairs(added_dirs) do
		table.insert(items, {
			type = "item",
			icon = "folder",
			text = name,
			path = dir,
			isdir = true;
		});
	end
	
	-- add files to list
	for name,file in pairs(added_files) do
		table.insert(items, {
			type = "item",
			icon = "file",
			text = name,
			path = file,
			isdir = false;
		});
	end
	
	-- sort list
	table.sort(items, function (a, b)
		if ((a.isdir and b.isdir) or not (a.isdir or b.isdir)) then
			return utf8.tolower(a.text) < utf8.tolower(b.text);
		else
			return a.isdir;
		end
	end);
	
	table.insert(items, 1, {
		type = "item",
		icon = "back",
		text = "Back"
	});
	
	server.update({ id = "list", children = items });
end

events.focus = function ()
	update();
end

actions.open = function (path)
	server.update({ type = "message", text = "Opening..." });
	os.open(path);
end

actions.tap = function (i)
	if i == 0 then
		actions.back();
	else
		local item = items[i+1];
		if item.isdir then
			settings.path = settings.path .. "\\" .. item.text;
			print(settings.path);
			update();
		else
			actions.open(item.path);
		end
	end
end

actions.back = function ()
	if (settings.path ~= "") then
		local split = utf8.lastindexof(settings.path, "\\");
		if (split > -1) then
			settings.path = utf8.sub(settings.path, 0, split);
		else
			settings.path = "";
		end
		update();
	end
end