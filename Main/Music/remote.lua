local timer = libs.timer;
local server = libs.server;
local str = libs.utf8;
local tid_update = -1;
local oldtitle = "";
local playliststate = {};
local currPlaylist = {};
local dialog_shuffle = {
	{ type="item", text = "Off", id = "off" }, 
	{ type="item", text="By Songs", id = "songs" },
	{ type="item", text="By Albums", id = "albums" },
	{ type="item", text="By Groupings", id = "groups" }
}

local dialog_repeat = {
	{ type="item", text = "Off", id = "off" }, 
	{ type="item", text="One", id = "one" },
	{ type="item", text="All", id = "all" }
}
--@help Launch Music application

actions.launch = function()
	os.open("/Applications/Music.app");
end
events.focus = function ()
	update();
	oldtitle = "";
	update_playlist();
	tid_update = timer.timeout(update, 100);
end

events.blur = function ()
	timer.cancel(tid_update);
end
function update_playlist()
	local playlists = displayPlaylists();
	server.update(
			{ id = "playlists", children = playlists }
		);
end
function update ()
	local title = "";
	local duration = 0;
	local position = 0;
	local volume = 0;
	local icon = "play";
	local tracks = {};
		
	title = get_title();
	if title ~= oldtitle then
		local cover = get_cover()
		oldtitle = title;
		server.update(
			{ id = "title", text = title },
			{ id = "cover", image = cover}
		);
	end
	volume = get_volume();
	position = get_position();
	if get_playing() ~= false then
		icon = "pause";
	end
	server.update(
		{ id = "pos", progress = position, progressmax = 100 },
		{ id = "vol", progress = volume },
		{ id = "play", icon = icon }
	);

	timer.timeout(update, 1000);
end
--@help Open Suffle dialog
actions.shuffle = function ()
	server.update({ type="dialog", ontap="suffle_dialog", children = dialog_shuffle });
end
--@help Open Repeat dialog
actions.rep = function ()
	server.update({ type="dialog", ontap="repeat_dialog", children = dialog_repeat });
end
--@help Set Shuffle state
--@param item:number
actions.suffle_dialog = function (item)
	if item ~= 0 then
		os.script("tell application \"System Events\" to tell process \"Music\"'s menu bar 1's menu bar item \"Controls\"'s menu 1's menu item \"Shuffle\"'s menu 1",
						"if (name of menu item 1) is not \"Turn Off Shuffle\" then",
							"perform action \"AXPress\" of menu item 1",
						"end if",
						"perform action \"AXPress\" of menu item \"".. dialog_shuffle[item+1].text .."\"",
					"end tell");
	else
		os.script("tell application \"System Events\" to tell process \"Music\"'s menu bar 1's menu bar item \"Controls\"'s menu 1's menu item \"Shuffle\"'s menu 1",
						"if (name of menu item 1) is \"Turn Off Shuffle\" then",
							"perform action \"AXPress\" of menu item 1",
						"end if",
						"end tell");
	end
end
--@help Set Repeate state
--@param item:number
actions.repeat_dialog = function (item)
	os.script("tell application \"System Events\" to tell process \"Music\"'s menu bar 1's menu bar item \"Controls\"'s menu 1's menu item \"Repeat\"'s menu 1",
					"perform action \"AXPress\" of menu item \"" .. dialog_repeat[item+1].text .. "\"",
				"end tell");
end

--@help Previous track
actions.previous = function () 
	os.script("tell application \"Music\" to previous track");
end
--@help Next track
actions.next = function ()
	os.script("tell application \"Music\" to next track");
end
--@help Rewind track
actions.rewind = function ()
	os.script("tell application \"Music\" to rewind");
end
--@help Fast Forward track
actions.forward = function ()
	os.script("tell application \"Music\" to fast forward");
end
--@help Volume Up
actions.volume_up = function ()
	os.script("tell application \"Music\" to set sound volume to (sound volume + 10)");
end
--@help Volume Down
actions.volume_down = function ()
	os.script("tell application \"Music\" to set sound volume to (sound volume - 10)");
end
--@help Volume Mute
actions.volume_mute = function ()
	os.script("tell application \"Music\" to set mute to (not mute)");
end
--@help Fullscreen
actions.fullscreen = function ()
	os.script("tell application \"System Events\" to tell process \"Music\"'s menu bar 1's menu bar item \"View\"'s menu 1",
				"if name of last menu item is \"Enter Full Screen\" then",
					"perform action \"AXPress\" of menu item \"Enter Full Screen\"",
				"else",
					"perform action \"AXPress\" of menu item \"Exit Full Screen\"",
				"end if",
			"end tell");
end
--@help Stop track
actions.stop = function ()
	os.script("tell application \"Music\" to stop");
end
--@help Play track
actions.play = function ()
	os.script("tell application \"Music\" to play");
end
--@help Pause track
actions.pause = function ()
	os.script("tell application \"Music\" to pause");
end
--@help Toggle Play/Pause
actions.play_pause = function ()
	os.script("tell application \"Music\" to playpause");
end
--@help Set Volume
--@param vol:number set volume
actions.volume = function (vol)
	os.script("tell application \"Music\"",
					"set sound volume to " .. vol , 
				"end tell");
end
--@help Go back to viweing playlists
actions.back = function ( )
	local playlists = displayPlaylists();
	server.update(
			{ id = "playlists", children = playlists }
		);
end
--@help Set Position
--@param pos:number Set position
actions.position = function (pos)
	local lenght = os.script("tell application \"Music\"",
								"set curr to current track",
								"set out to duration of curr",
							"end tell");
	local newpos = pos/100 * lenght;
	os.script("tell application \"Music\"",
					"set player position to " .. newpos , 
				"end tell"); 
end

actions.playlist = function( index )
	playliststate[index+1].func(playliststate[index+1]);
end

function displayPlaylists( )
	local playlists = {};
	local plnames = get_playlist_names();
	playliststate = {};
	for i = 1, #plnames do 
		playliststate[i] = {func = openPlaylist, name = plnames[i].name};
		table.insert(playlists, { type = "item", checked = plnames[i].play, text = plnames[i].name .. "\n" .. "Tracks:" .. plnames[i].count});
	end
	currPlaylist = playlist;
	return playlists;
end

function openPlaylist( item )
	local tracks = get_playlist_tracks(item.name);
	playliststate = {};
	local playtracks = {};
	for i = 1, #tracks do 
		playliststate[i] = {func = playTrack, index = tracks[i].index, name = tracks[i].name, playlist = tracks[i].playlist, id = tracks[i].id};
		table.insert(playtracks, { type = "item", checked = tracks[i].play, text = tracks[i].name .. "\n" .. tracks[i].artist .. " Duration:" .. tracks[i].time});
	end
	currPlaylist = playtracks;
	server.update({ id = "playlists", children = playtracks });
end
function updateCurrentPlaylist( item )
	local tracks = get_playlist_tracks(item.playlist);
	local playtracks = {};
	for i = 1, #tracks do 
		table.insert(playtracks, { type = "item", checked = tracks[i].play, text = tracks[i].name .. "\n" .. tracks[i].artist .. " Duration:" .. tracks[i].time});
	end
	currPlaylist = playtracks;
	server.update({ id = "playlists", children = playtracks });
end
function playTrack( item )
		 os.script("tell application \"Music\"",
						"play track " .. item.index .. " of playlist \"" .. item.playlist .. "\"",
					"end tell");	
		 updateCurrentPlaylist(item);
end

function get_title()
	return os.script("tell application \"Music\"",
			"if player state is playing or player state is paused then",
				"set out to name of current track",
			"else",
				"set out to \"[Not Available]\"",
			"end if",
		"end tell");
end

function get_volume() 
	return os.script("tell application \"Music\"",
						"set out to sound volume",
					"end tell");
end

function get_position()
	local currpos = os.script("tell application \"Music\"",
						"set out to player position",
					"end tell");
	local lenght = os.script("tell application \"Music\"",
								"set curr to current track",
								"set out to duration of curr",
							"end tell");
	if currpos ~= "missing value" then
		return math.floor((currpos/lenght) * 100);
	end
	return 0;
end

function get_playing()
	return os.script("tell application \"Music\"",
						"set out to player state is playing",
					"end tell");	
end

function get_cover()
	return os.script(
		"tell application \"Music\" to tell artwork 1 of current track",
			"set d to raw data",
			"if format is «class PNG » then",
				"set x to \"png\"",
			"else",
				"set x to \"jpg\"",
			"end if",
		"end tell",

		"((path to temporary items from user domain as text) & \"cover.\" & x)",
		"set b to open for access file result with write permission",
		"set eof b to 0",
		"write d to b",
		"close access b",
		"set this_file to ((path to temporary items from user domain as text) & \"cover.\" & x)",
			"tell application \"Image Events\"",
				"launch",
				"set this_image to open this_file",
				"scale this_image to size 400",
				"save this_image with icon",
				"close this_image",
			"end tell",
		"set out to POSIX path of ((path to temporary items from user domain as text) & \"cover.\" & x)");
end

function get_playlist_names( ) 
	local playlists = os.script("set myPlaylists to \"\" as text",
								"tell application \"Music\"",
									"try",
										"set v to (get view of front browser window)",
										"set mySource to (get container of v)",
									"end try",
									"repeat with p in every playlist of mySource",
										"if (count tracks of p) > 0 and (visible of p) then",
											"set myPlaylists to myPlaylists & name of p & tab & (count tracks of p) & tab & id of p & linefeed",
										"end if",
									"end repeat",
								"end tell");

	local curplayid = os.script("tell application \"Music\"",
									"set a to id of current playlist",
								"end tell");
	local n = str.split(playlists,"\n");
	local result = {};
	for i = 1, #n do
		local list = str.split(n[i], "\t");
		if #list == 3 then
			table.insert(result, {name = list[1], count = list[2], play = (curplayid == list[3])})
		end
	end
	return result;
end
function get_current_playing_id(  )
	return os.script("tell application \"Music\"",
									"set a to id of current track",
								"end tell");
end
function get_playlist_tracks( name )
	local tracks = os.script("set myTracks to \"\" as text",
							"tell application  \"Music\"",
								"set s to playlist \"" .. name .. "\" ",
								"repeat with p in every track in s",
									"set myTracks to myTracks & name of p & tab & artist of p & tab & index of p & tab & time of p & tab & id of p & linefeed ",
								"end repeat ",
							"end tell");
	local curplayid = os.script("tell application \"Music\"",
								"set a to id of current track",
							"end tell");
	local result = {};

	if tracks ~= "" then

		local stracks = str.split(tracks,"\n");
		for i = 1, #stracks do
			local track = str.split(stracks[i], "\t");
			if #track == 5 then				
				table.insert(result,{name = track[1], artist=track[2], index = track[3], time = track[4], playlist = name, play = (curplayid == track[5]), id = track[5]});
			end
		end
		return result;
	end
	return result;
end