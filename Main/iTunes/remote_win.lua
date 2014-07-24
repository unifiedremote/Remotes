local timer = libs.timer;
local server = libs.server;

local tid_update = -1;
local obj = nil;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\iTunes") or
		libs.fs.exists("C:\\Program Files\\iTunes");
end

--@help Launch iTunes application
actions.launch = function()
	os.start("itunes");
end

events.focus = function ()
	obj = luacom.CreateObject("iTunes.Application");
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

local ITPlayerStateStopped = 0;
local ITPlayerStatePlaying = 1;
local ITPlayerStateFastForward = 2;
local ITPlayerStateRewind = 3;

function update ()
	local title = "";
	local duration = 0;
	local position = 0;
	local volume = 0;
	local icon = "play";
	local playlists = {};
	local tracks = {};
	
	if (valid()) then
		-- Get title
		if (obj.CurrentTrack ~= nil) then
			title = obj.CurrentTrack.Name .. " - " .. obj.CurrentTrack.Artist;
			duration = obj.CurrentTrack.Duration;
			position = obj.PlayerPosition;
		else		
			title = "[Not Playing]";
		end
		
		-- Get volume
		volume = obj.SoundVolume;
		
		-- Get state
		if (obj.PlayerState == ITPlayerStatePlaying) then
			icon = "pause";
		end
		
		-- Get playlists
		local count = obj.LibrarySource.Playlists.Count;
		for i = 1, count do
			local playlist = obj.LibrarySource.Playlists(i);
			local curr = false;
			if (obj.CurrentPlaylist ~= nil) then
				curr = playlist.playlistID == obj.CurrentPlaylist.playlistID;
			end
			table.insert(playlists, { type = "item", checked = curr, text = playlist.Name .. "\nTracks: " .. playlist.Tracks.Count });
		end
		
		-- Get tracks
		if (obj.CurrentPlaylist ~= nil) then
			count = obj.CurrentPlaylist.Tracks.Count;
			for i = 1, count do
				local track = obj.CurrentPlaylist.Tracks:ItemByPlayOrder(i);
				table.insert(tracks, { type = "item", text = track.Name .. "\n" .. track.Artist });
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
		local playlist = obj.LibrarySource.Playlists(i + 1);
		playlist:PlayFirstTrack();
		update();
	end
end

actions.track = function (i)
	if (valid()) then
		if (obj.CurrentPlaylist ~= nil) then
			local track = obj.CurrentPlaylist.Tracks:ItemByPlayOrder(i + 1);
			track:Play();
			update();
		end
	end
end
--@help Play Pause track
actions.play_pause = function ()
	if (valid()) then
		obj:PlayPause();
		update();
	end
end
--@help Play track
actions.play = function ()
	if (valid()) then
		obj:Play();
		update();
	end
end
--@help Pause track
actions.pause = function ()
	if (valid()) then
		obj:Pause();
		update();
	end
end
--@help Resume track
actions.resume = function ()
	if (valid()) then
		obj:Resume();
		update();
	end
end
--@help Stop track
actions.stop = function ()
	if (valid()) then
		obj:Stop();
		update();
	end
end
--@help Next track
actions.next = function ()
	if (valid()) then
		obj:Next();
		update();
	end
end
--@help Previous track
actions.previous = function ()
	if (valid()) then
		obj:Previous();
		update();
	end
end
--@help Forward track
actions.forward = function ()
	if (valid()) then
		obj:FastForward();
		update();
	end
end
--@help Rewind track
actions.rewind = function ()
	if (valid()) then
		obj:Rewind();
		update();
	end
end
--@help Mute Volume
actions.volume_mute = function ()
	if (valid()) then
		obj.Mute = true;
		update();
	end
end
--@help Set Volume
--@param vol:number Set volume
actions.volume = function (vol)
	if (valid()) then
		obj.SoundVolume = vol;
		update();
	end
end
--@help Volume up
actions.volume_up = function ()
	if (valid()) then
		obj.SoundVolume = obj.SoundVolume + 10;
		update();
	end
end
--@help Volume Down
actions.volume_down = function ()
	if (valid()) then
		obj.SoundVolume = obj.SoundVolume - 10;
		update();
	end
end
--@help Set Position
--@param pos:number Set Position
actions.position = function (pos)
	if (valid()) then
		obj.PlayerPosition = pos;
		update();
	end
end
