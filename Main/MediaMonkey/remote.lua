local timer = libs.timer;
local server = libs.server;

local tid_update = -1;
local obj = nil;
local prevVol = 0;
local tempplaylist = {};
local state = 0;
local playlists = {};
--@help Launch iTunes application
actions.launch = function()
	os.start("m");
end

events.focus = function ()
	obj = luacom.CreateObject("SongsDB.SDBApplication");
	update();
	tid_update = timer.interval(update, 1000);
end

events.blur = function ()
	timer.cancel(tid_update);
	obj = nil;
	collectgarbage();
end

function valid()
	return (obj ~= nil);
end


function update ()
	local title = "";
	local duration = 0;
	local position = 0;
	local volume = 0;
	local icon = "play";

	local tracks = {};
	
	if (valid()) then
		-- Get title
		if (obj.Player.CurrentSong ~= nil) then
			title = obj.Player.CurrentSong.Title .. " - " .. obj.Player.CurrentSong.ArtistName;
			duration = obj.Player.CurrentSongLength;
			position = obj.Player.PlaybackTime;
		else		
			title = "[Not Playing]";
		end
		
		-- Get volume
		volume = obj.Player.Volume *100;
		
		-- Get state
		if (obj.Player.isPlaying and not obj.Player.isPaused) then
			icon = "pause";
		end
		
	
		-- Get tracks
		if (obj.Player.CurrentPlaylist ~= nil) then
		count = obj.Player.CurrentPlaylist.Count;
			for i = 0, count -1 do
				local track = obj.Player.CurrentPlaylist:Item(i);
				local isCurrent = track.SongID == obj.Player.CurrentSong.SongID;
				table.insert(tracks, { type = "item", checked = isCurrent, text = track.Title .. "\n" .. track.ArtistName });
			end
		end
	else
		title = "[Not Running]";
	end
	
	server.update(
		{ id = "title", text = title },
		{ id = "pos", progress = position, progressmax = duration },
		{ id = "vol", progress = volume },
		{ id = "play", icon = icon },
		{ id = "playlists", children = playlists },
		{ id = "tracks", children = tracks }
	);
end
actions.playlist = function (i)
	if (valid()) then
		tempplaylist[i+1].func(tempplaylist[i+1]);
		update();
	end
end

actions.track = function (i)

	if (valid()) then

		if (obj.Player.CurrentPlaylist ~= nil) then
			obj.Player.CurrentSongIndex = i; 
			update();
		end
	end
end
--@help Play Pause track
actions.play_pause = function ()
	if (valid()) then
		if obj.Player.isPlaying then
			obj.Player:Pause();
		else
			obj.Player:Play();
		end
	end
end
--@help Play track
actions.play = function ()
	if (valid()) then
		obj.Player:Play();
		update();
	end
end
--@help Pause track
actions.pause = function ()
	if (valid()) then
		obj.Player:Pause();
		update();
	end
end
--@help Stop track
actions.stop = function ()
	if (valid()) then
		obj.Player:Stop();
		update();
	end
end
--@help Next track
actions.next = function ()
	if (valid()) then
		obj.Player:Next();
		update();
	end
end
--@help Previous Track
actions.previous = function ()
	if (valid()) then
		obj.Player:Previous();
		update();
	end
end
--@help Mute Volume
actions.volume_mute = function ()
	if (valid()) then
		if obj.Player.Volume == 0 then
			obj.Player.Volume = prevVol;
		else
			prevVol = obj.Player.Volume;
			obj.Player.Volume = 0;
		end
		update();
	end
end
--@help Set Volume
--@param vol:number Set Volume
actions.volume = function (vol)
	if (valid()) then
		obj.Player.Volume = vol/100;
		update();
	end
end
--@help Volume up
actions.volume_up = function ()
	if (valid()) then
		obj.Player.Volume = obj.Player.Volume + 0.1;
		update();
	end
end
--@help Volume down
actions.volume_down = function ()
	if (valid()) then
		obj.Player.Volume = obj.Player.Volume - 0.1;
		update();
	end
end
--@help Set Position
--@param pos:number Set position
actions.position = function (pos)
	if (valid()) then
		obj.Player.PlaybackTime = pos;
		update();
	end
end
--@help Rate Up
actions.rate_up = function ()
	if (valid()) then
		obj.Player.CurrentSong.Rating = math.min(100, obj.Player.CurrentSong.Rating + 20); 
		obj.Player.CurrentSong.UpdateDB();
		update();
	end
end
--@help Rate Down
actions.rate_down = function ()
	if (valid()) then
		obj.Player.CurrentSong.Rating = math.min(100, obj.Player.CurrentSong.Rating - 20); 
		obj.Player.CurrentSong.UpdateDB();
		update();
	end
end