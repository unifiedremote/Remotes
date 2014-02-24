local server = libs.server;

include("common.lua")
include("playlists.lua")

PlayingID = "";

function update()
	local volume = os.script("tell application \"Spotify\" to set out to sound volume") + 0;
	local pos = os.script("tell application \"Spotify\" to set out to player position") + 0;
	local repeating = os.script("tell application \"Spotify\" to set out to repeating");
	local shuffling = os.script("tell application \"Spotify\" to set out to shuffling");
	local playing = os.script("tell application \"Spotify\" to set out to player state");
	local id = os.script("tell application \"Spotify\" to set out to id of current track");
	
	if id ~= playingid then
		playingid = id;
		local name = os.script("tell application \"Spotify\"", "set out to name of current track");
		local duration = os.script("tell application \"Spotify\"", "set out to duration of current track");
		local imagepath = os.script(
			"tell application \"Spotify\"", 
				"set a to artwork in current track",
			"end tell",
			"tell current application",
				"set temp to (path to temporary items from user domain as text) & \"img.png\"",
				"set fileRef to (open for access temp with write permission)",
					"write a to fileRef",
				"close access fileRef",
				"tell application \"Image Events\"",
					"set theImage to open temp",
					"save theImage as PNG with replacing",
				"end tell",
				"set out to POSIX path of temp",
			"end tell");
			
		server.update({ id = "currtitle", text = name });
		server.update({ id = "currpos", progressMax = duration });
		server.update({id = "currimg", image = imagepath });
	end
	
	local icon = "play";
	if utf8.iequals(playing, "playing") then
		icon = "pause";
	end
	
	server.update({id = "currvol", progress = volume });
	server.update({id = "currpos", progress = pos });
	server.update({id = "repeat", checked = repeating });
	server.update({id = "suffle", checked = repeating });
	server.update({id = "play", icon = "pause"});
end

actions.poschange = function (pos)
	os.script("tell application \"Spotify\" to set player position to " .. pos);
end

actions.volchange = function (vol)
	os.script("tell application \"Spotify\" to set sound volume to " .. vol);
end

actions.next = function ()
	os.script("tell application \"Spotify\" to next track");
end

actions.previous = function ()
	os.script("tell application \"Spotify\" to previous track");
end

actions.repeating = function (checked)
	if checked then 
		os.script("tell application \"Spotify\" to set repeating to true");
	else
		os.script("tell application \"Spotify\" to set repeating to false");
	end
end

actions.play = function ()
	os.script("tell application \"Spotify\" to playpause");
end

actions.suffle = function (checked)
	if checked then 
		os.script("tell application \"Spotify\" to set shuffling to true");
	else
		os.script("tell application \"Spotify\" to set shuffling to false");
	end
end
