local timer = libs.timer;
local server = libs.server;
local log = libs.log;
local dev = libs.device;

local tid = -1;
local update_position = true;

local unsupported_version = true;

local enabled_color = "blue"
local disabled_color = "grey"

local tellBeamerTo = "tell application \"Beamer\" to ";

events.detect = function ()
	return libs.fs.exists("/Applications/Beamer.app");
end

events.focus = function ()
	local beamer_version = get_beamer_property("version", "1");
	unsupported_version = string.match(beamer_version, "^1") ~= nil or string.match(beamer_version, "^2.0") ~= nil

	if (unsupported_version) then
		server.update({ id = "info", text = "This version of Beamer is not supported. Please upgrade to 2.1 or later." })
	else
		tid = timer.timeout(actions.update, 100);
	end
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local player_state = get_beamer_property("player state", "stopped");
	local player_position = get_beamer_property("player position", 0);
	local title = get_beamer_property("current movie title", "");
	local duration = get_beamer_property("current movie duration", 0);

	local toggle_play_color = enabled_color;
	local stop_color = enabled_color;
	local toggle_play_icon = "play"
	
	if (player_state == "stopped") then
		stop_color = disabled_color;
		if (title == "") then
			toggle_play_color = disabled_color
		end
	end

	if (player_state == "playing") then
		toggle_play_icon = "pause"
	end

	if (title == "") then
		title = "[Not Playing]";
	end
	
	server.update(
		{ id = "info", text = title },
		{ id = "toggle_play", icon = toggle_play_icon, color = toggle_play_color },
		{ id = "stop", color = stop_color }
	);

	if (update_position) then
		server.update({ id = "position", 
				text = libs.data.sec2span(player_position) .. " / " .. libs.data.sec2span(duration),
				progress = math.floor(1000 * player_position / duration), 
				progressmax = 1000 });
	end

	tid = timer.timeout(actions.update, 500)
end

--@help Launch Beamer application
actions.launch = function()
	os.script(tellBeamerTo .. "activate");
end

--@help Previous movie
actions.previous = function()
	os.script(tellBeamerTo .. "select previous movie");
end

--@help Next movie
actions.next = function()
	os.script(tellBeamerTo .. "select next movie");
end

--@help Stop playback
actions.stop = function()
	os.script(tellBeamerTo .. "stop");
end

--@help Toggle play/pause state
actions.toggle_play = function()
	os.script(tellBeamerTo .. "toggle play");
end

--@help Set position
actions.position = function(relative_position)
	local position = (relative_position / 1000) * get_beamer_property("current movie duration", 0);
	os.script(tellBeamerTo .. "set player position to " .. position);
end

--@help Open file manager
actions.open_file = function()
	dev.switch("Beamer.BeamerFilePicker");
end

-- Helpers
actions.position_down = function(position)
	update_position = false;
end

actions.position_up = function(position)
	update_position = true;
end

function get_beamer_property(name, missing_value_placeholder)
	local value = os.script(tellBeamerTo .. "set out to " .. name);
	if (value ~= "missing value") then
		return value
	else
		return missing_value_placeholder
	end
end

