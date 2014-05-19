local host;
local port;
local password;
local tid = -1;

------------------------------------------------------------------------
-- Events
------------------------------------------------------------------------

events.focus = function ()
	host = settings.host;
	port = settings.port;
	password = settings.password;
	
	test();
	
	tid = libs.timer.interval(update_status, 500);
	update_library();
end

events.blur = function ()
	libs.timer.cancel(tid);
end

function test()
	local resp = send();
	if (resp == nil or resp.status ~= 200) then
		libs.server.update({
			type = "dialog",
			title = "VLC Connection",
			text = "A connection to VLC could not be established." ..
				"We recommend using the latest version of VLC.\n\n" ..
				"1. Make sure VLC is running on your computer.\n\n" ..
				"2. Enable web interface in VLC settings > Show all settings > Interface > Main interfaces.\n\n" ..
				"3. VLC 2.1+ you MUST specify a password in Main interfaces > Lua > Lua HTTP > Password. Unified Remote is configured to use the password 'vlcremote'.\n\n" ..
				"4. You can also specify a different IP address, port, or password in the remote settings.\n\n" ..
				"You may have to restart VLC after enabling the web interface for the changes to take effect.",
			children = {{ type = "button", text = "OK" }}
		});
	end
end

------------------------------------------------------------------------
-- Web Request
------------------------------------------------------------------------

function request(url)
	local auth = libs.data.tobase64(":" .. password);
	local req = {
		method = "get",
		url = url,
		headers = { Authorization = "Basic " .. auth }
	}
	local ok, resp = pcall(libs.http.request,req);
	if (ok and resp.status == 200) then
		return resp;
	else
		libs.server.update({ id = "title", text = "[Not Connected]" });
		return nil;
	end
end

function send(cmd, val, id)
	local url = "http://" .. host .. ":" .. port .. "/requests/status.xml";
	if (cmd ~= nil) then
		url = url .. "?command=" .. cmd;
	end
	if (val ~= nil) then
		url = url .. "&val=" .. val;
	end
	if (id ~= nil) then
		url = url .. "&id=" .. id;
	end
	return request(url);
end

------------------------------------------------------------------------
-- Status
------------------------------------------------------------------------

local pos = 0;
local length = 0;
local seeking = false;
local seeking_pos = 0;

function update_status()
	local resp = send();
	if (resp == nil) then return end
	
	local root = libs.data.fromxml(resp.content);
	
	local title = "";
	local file = "";
	local info = "";
	
	for k,v in pairs(root.children) do
		if (v.name == "time") then pos = tonumber(v.text); end
		if (v.name == "length") then length = tonumber(v.text); end
		if (v.name == "volume") then vol = tonumber(v.text); end
		if (v.name == "information") then
			for k2,v2 in pairs(v.children) do
				if (v2.attributes.name == "meta") then
					for k3,v3 in pairs(v2.children) do
						local name = v3.attributes.name;
						if (name == "title") then title = v3.text; end
						if (name == "filename") then file = v3.text; end
						
						-- TV Meta Data
						if (name == "showName") then info = info .. v3.text .. "\n\n"; end
						if (name == "episodeNumber") then info = info .. "Episode: " .. v3.text .. "\n\n"; end
						if (name == "seasonNumber") then info = info .. "Season: " .. v3.text .. "\n\n"; end
					end
				end
			end
		end
	end
	
	if (title == "") then
		title = file;
	end
	if (info == "") then
		info = "No Meta Information";
	end
	
	if (seeking) then
		pos = seeking_pos;
	end
	
	libs.server.update(
		{ id = "title", text = title },
		{ id = "info", text = info },
		{ id = "pos", progress = pos, progressmax = length, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(length) },
		{ id = "vol", progress = vol, progressmax = 320}
	);
end

------------------------------------------------------------------------
-- Library
------------------------------------------------------------------------

local library_root = {};
local library = {};
local selection = {};

function update_items(items)
	local list = {};
	library = {};
	for k,v in pairs(items) do
		if (v.name == "item") then
			local id = v.attributes.id;
			local name = v.attributes.name;	
			local duration = v.attributes.duration;
			table.insert(list, { type = "item", text = name });
			table.insert(library, { id = id, name = name, duration = duration });
		end
	end
	libs.server.update({ id = "list", children = list });
end

function parse_items(items, level)
	if (#selection < level) then
		update_items(items);
	else
		for k,v in pairs(items) do
			local id = v.attributes.id;
			local name = v.attributes.name;
			if (selection[level] == id) then
				parse_items(v.children, level+1);
				return;
			end
		end
		update_items(items);
	end
end

actions.library_select = function (i)
	local item = library[i+1];
	if (item.duration == nil) then
		-- Folders don't have a duration
		table.insert(selection, library[i+1].id);
		parse_items(library_root.children, 1);
	else
		libs.device.toast("Playing " .. item.name .. "...");
		play_item(item.id);
	end
end

function play_item (id)
	send("pl_play", nil, libs.utf8.sub(id, 5));
end

actions.library_back = function ()
	if (#selection > 0) then
		table.remove(selection);
		parse_items(library_root.children, 1);
	else
		libs.device.toast("Cannot go back any more.");
	end
end

actions.library_refresh = function ()
	libs.device.toast("Refreshing...");
	update_library();
end

function update_library()
	-- Grab new playlist data from vlc
	libs.server.update({ id = "list", children = { { type = "item", text = "Loading..." } } });
	local url = "http://" .. host .. ":" .. port .. "/requests/playlist_jstree.xml";
	local resp = request(url);
	if (resp == nil) then return end
	
	-- Save it and refresh the view
	library_root = libs.data.fromxml(resp.content);
	parse_items(library_root.children, 1);
end

------------------------------------------------------------------------
-- Seeking
------------------------------------------------------------------------

function seek(pos)
	seeking = true;
	
	-- Calculate the seek percentage from the time position
	local v = 0;
	if (length > 0) then
		v = math.floor(math.min(100, pos / length * 100));
	end
	send("seek", v .. "%25");
	
	-- Add delay so that the slider doesn't "jump" due to an incoming status update
	libs.timer.timeout(function ()
		seeking = false;
	end, 1000);
end

actions.position_change = function (pos)
	-- Trigger seeking mode so that the slider text updates
	seeking = true;
	seeking_pos = pos;
end
--@help Change position
--@param pos:number Set Position
actions.position_stop = function (pos)
	seek(pos);
end

--@help Seek backwards
actions.jump_back = function ()
	-- Seeking precision is only 1% so:
	-- If 1% is greater than 10 sec, then jump 1%
	-- Otherwise just jump 10 sec
	local pc = math.floor(0.01 * length);
	if (pc > 10) then
		seeking_pos = pos - pc;
	else
		seeking_pos = pos - 10;
	end
	seek(seeking_pos);
end

--@help Seek forwards
actions.jump_forward = function ()
	-- Seeking precision is only 1% so:
	-- If 1% is greater than 10 sec, then jump 1%
	-- Otherwise just jump 10 sec
	local pc = math.floor(0.01 * length);
	if (pc > 10) then
		seeking_pos = pos + pc;
	else
		seeking_pos = pos + 10;
	end
	seek(seeking_pos);
end

------------------------------------------------------------------------
-- General
------------------------------------------------------------------------

--@help Toggle play/pause
actions.play_pause = function ()
	send("pl_pause");
end

--@help Start playback
actions.play = function ()
	send("pl_play");
end

--@help Resume playback
actions.resume = function ()
	send("pl_forceresume");
end

--@help Pause playback
actions.pause = function ()
	send("pl_pause");
end

--@help Stop playback
actions.stop = function ()
	send("pl_stop");
end

--@help Play next item
actions.next = function ()
	send("pl_next");
end

--@help Play previous item
actions.previous = function ()
	send("pl_previous");
end

--@help Toggle shuffle
actions.shuffle = function ()
	send("pl_random");
end

--@help Toggle loop
actions.loop = function ()
	send("pl_loop");
end

--@help Toggle repeat
actions.loop_repeat = function ()
	send("pl_repeat");
end

--@help Raise volume
actions.volume_up = function ()
	send("volume", "%2B20");
end

--@help Lower volume
actions.volume_down = function ()
	send("volume", "-20");
end

--@help Mute volume
actions.volume_mute = function ()
	send("volume", "-1000");
end

--@help Change volume
--@param vol:number Set Volume
actions.volume_change = function (vol)
	send("volume", vol);
end

--@help Toggle fullscreen
actions.fullscreen = function ()
	send("fullscreen");
end
