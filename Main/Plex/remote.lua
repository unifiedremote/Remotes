-- TODO:
-- * Add support for send text
-- * Add support for library browsing (http://.../library)

-- REFERENCE:
-- * I couldn't find any official documentation...
-- * https://forums.plex.tv/index.php/topic/15850-plex-9-remote-api/

--@help Launch XBMC application
actions.launch = function()
if OS_WINDOWS then
	pcall(function ()
		os.start("C:\\Program Files (x86)\\Plex Home Theater\\Plex Home Theater.exe");
		end);
	pcall(function ()
		os.start("C:\\Program Files\\Plex Home Theater\\Plex Home Theater.exe");
		end);
	pcall(function ()
		os.start("C:\\Program Files (x86)\\Plex\\Plex Media Center\\Plex.exe"); 
		end);
	pcall(function ()
		os.start("C:\\Program Files\\Plex\\Plex Media Center\\Plex.exe"); 
		end);
	elseif OS_OSX then
		os.script("tell application \"Plex Home Theater\" to activate");
		os.script("tell application \"Plex\" to activate");
	end
end

events.create = function ()

end

events.focus = function ()
	update_server();
	update_players();
end

local server = "";
local player = "";
local players = {};

function update_server()
	server = settings.server;

	if (server == "") then
		-- Try to find a server...
		libs.device.toast("Looking for Plex servers...");
		
		local res = libs.http.discover({ port = 32400 });
		if (#res == 0) then
			server = "localhost";
			libs.device.toast("No servers found...");
			libs.device.toast("Using localhost for now...");
		else
			server = res[1];
			settings.server = server;
			libs.device.toast("Found server: " .. server);
		end
	else
		libs.device.toast("Saved server: " .. server);
	end
	print("Plex Server: " .. server);
end

function update_players()
	local xml = libs.http.get("http://" .. server .. ":32400/clients");
	local MediaContainer = libs.data.fromxml(xml);
	
	player = "localhost";
	players = {};
	
	local playersList = {};
	local savedPlayer = settings.player;
	local i = 0;
	
	for k,v in pairs(MediaContainer.children) do
		if (v.name == "Server") then
			local name = v.attributes.name;
			local host = v.attributes.host;
			if (savedPlayer == "" and i == 0) then
				player = host;
			elseif (savedPlayer == host) then
				player = host;
			end
			players[i] = { name = name, host = host };
			local checked = (host == player);
			local text = name .. "\n" .. host;
			table.insert(playersList, { type = "item", checked = checked, text = text });
			i = i + 1;
		end
	end
	send("navigation", "test");
	libs.server.update({ id = "players", children = playersList });
	print("Plex Player: " .. player);
end

function url(controller, action)
	local url = "http://" .. server .. ":32400";
	url = url .. "/system/players/" .. player;
	url = url .. "/" .. controller;
	url = url .. "/" .. action;
	return url;
end

function send(controller, action)
	local _url = url(controller, action);
	print(_url);
	local resp = libs.http.get(_url);
	if(libs.utf8.contains(resp, "Errno 10061")) then
		libs.server.update({
			type = "dialog",
			title = "Plex Connection",
			text = "A connection to Plex could not be established." ..
			"We recommend using the latest version of Plex.\n\n" ..
			"1. Make sure Plex is running on your computer.\n\n" ..
			"2. Enable remote controlling in Preferences > System > Services > Allow control of Plex/HT via HTTP.\n\n" ..
			"You may have to restart Plex after enabling the remote controlling for the changes to take effect.",
			children = {{ type = "button", text = "OK" }}
			});
	end
end

-------------------------------------------
-- Misc
-------------------------------------------

text = "";

actions.text_changed = function (s)
	text = s;
	print(text);
end

actions.send_text = function ()
	-- The API call does not seem to work...
	local _url = url("application", "sendString");
	_url = _url .. "?text=" .. text;
	libs.http.get(_url);
end

actions.select_player = function (i)
	print("Selected Player: " .. players[i].host);
	settings.player = players[i].host;
	update_players();
end

-------------------------------------------
-- Navigation
-------------------------------------------

--@help Navigate up
actions.up = function ()
	send("navigation", "moveUp");
end

--@help Navigate down
actions.down = function ()
	send("navigation", "moveDown");
end

--@help Navigate left
actions.left = function ()
	send("navigation", "moveLeft");
end

--@help Navigate right
actions.right = function ()
	send("navigation", "moveRight");
end

--@help Navigate page up
actions.page_up = function ()
	send("navigation", "pageUp");
end

--@help Navigate page down
actions.page_down = function ()
	send("navigation", "pageDown");
end

--@help Navigate 
actions.next_letter = function ()
	send("navigation", "nextLetter");
end

actions.previous_letter = function ()
	send("navigation", "previousLetter");
end

--@help Select
actions.select = function ()
	send("navigation", "select");
end

--@help Navigate back
actions.back = function ()
	send("navigation", "back");
end

--@help Open menu
actions.menu = function ()
	send("navigation", "contextMenu");
end

--@help Open On screen display
actions.osd = function ()
	send("navigation", "toggleOSD");
end

-------------------------------------------
-- Playback
-------------------------------------------

--@help Play track
actions.play = function ()
send("playback", "play");
end

--@help Pause track
actions.pause = function ()
	send("playback", "pause");
end

--@help Play Pause track
actions.play_pause = function ()
	send("playback", "play");
end

--@help Stop track
actions.stop = function ()
	send("playback", "stop");
end

--@help Rewind track
actions.rewind = function ()
	send("playback", "rewind");
end

--@help Forwad track
actions.forward = function ()
	send("playback", "fastForward");
end

--@help Step forward in track
actions.step_forward = function ()
	send("playback", "stepForward");
end

--@help Big Step forward in track
actions.big_step_forward = function ()
	send("playback", "bigStepForward");
end

--@help Step back in track
actions.step_back = function ()
	send("playback", "stepBack");
end

--@help Big step back in track
actions.bigStepBack = function ()
	send("playback", "bigStepBack");
end

--@help Next track
actions.next = function ()
	send("playback", "skipNext");
end

--@help Previous track
actions.previous = function ()
	send("playback", "skipPrevious");
end

--@help Play pause from navigation
actions.nav_play = function () 
	actions.select();
	actions.select();
end