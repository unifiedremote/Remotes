local fs = libs.fs;
local server = libs.server;

-------------------------------------------------------------------

local items = {};
local stack = {};

-------------------------------------------------------------------

-- NOTE: Start and end the string with a comma
local movie_extensions = ",asf,wmv,avi,flv,mkv,mk3d,mkv,mov,mp4,3gp,3g2,mj2,f4v,mpg,mpeg,vob,ts,m2t,m2ts,mts,mjpg,swf,ogg,ogv,"
local subtitle_extensions = ",sub,ass,ssa,txt,mpl2,srt,"
local home_path = "~"

-------------------------------------------------------------------

events.focus = function()
	stack = {};
	table.insert(stack, settings.last_path);
	update();
end

-------------------------------------------------------------------

function update ()
	local path = settings.last_path;
	items = {};
	if path == "" then
		path = home_path;
	end

	local dirs = fs.dirs(path);
	local files = fs.files(path);
	for t = 1, #dirs do
		if (not fs.ishidden(dirs[t])) then		
			table.insert(items, {
				type = "item",
				icon = "folder",
				text = fs.fullname(dirs[t]),
				path = dirs[t],
				isdir = true
			});
		end
	end
	for t = 1, #files do
		local icon = nil;
		if (ismovie(files[t])) then
			icon = "play"
		elseif (issubtitle(files[t])) then
			icon = "file"
		end		
		if (not fs.ishidden(files[t]) and icon ~= nil) then
			table.insert(items, {
				type = "item",
				icon = icon,
				text = fs.fullname(files[t]),
				path = files[t],
				isdir = false
			});
		end
	end
	server.update({ id = "list", children = items});
end

-------------------------------------------------------------------
-- Actions.
-------------------------------------------------------------------
actions.item = function (i)
	i = i + 1;
	if items[i].isdir then
		table.insert(stack, settings.last_path);
		settings.last_path = items[i].path;
		update();
	else
		actions.open(items[i].path);
	end
end

actions.back = function ()
	settings.last_path = table.remove(stack);
	update();
	if #stack == 0 then
		table.insert(stack, "");
	end
end

actions.up = function ()
	table.insert(stack, settings.last_path);
	settings.last_path = fs.parent(stack[#stack]);
	update();
end

actions.home = function ()
	table.insert(stack, home_path);
	settings.last_path = home_path;
	update();
end

actions.refresh = function ()
	update();
end

actions.goto = function ()
	server.update({id = "go", type="input", ontap="gotopath", title="Goto"});
end

actions.gotopath = function (p)
	if fs.isfile(p) then
		actions.open(p);
	else
		settings.last_path = p;
		update();
	end
end

--@help Open file or folder on computer.
--@param path:string The path to the file
actions.open = function (path)
	os.script("tell application \"Beamer\" to open (POSIX file \"" .. path .. "\")");
end

-------------------------------------------------------------------
-- Helpers.
-------------------------------------------------------------------
function ismovie(filepath)
	local extension = string.lower(fs.extension(filepath))
	return string.match(movie_extensions, "," .. extension .. ",") ~= nil
end

function issubtitle(filepath)
	local extension = string.lower(fs.extension(filepath))
	return string.match(subtitle_extensions, "," .. extension .. ",") ~= nil
end
