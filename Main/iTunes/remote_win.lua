local timer = libs.timer;
local server = libs.server;
local ITPlayerStateStopped = 0;
local ITPlayerStatePlaying = 1;
local ITPlayerStateFastForward = 2;
local ITPlayerStateRewind = 3;
local tid_update = -1;
local obj = nil;
local offset = 0;
local page = 100;
local last_playlist;
local playlists = {};
local tracks = {};

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
	update_state();
	update_lists();
	tid_update = timer.timeout(update, 1000);
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
	if (obj.CurrentPlaylist ~= nil) then
		if (last_playlist == nil or obj.CurrentPlaylist.playlistID ~= last_playlist.playlistID) then
			print("playlist changed");
			last_playlist = obj.CurrentPlaylist;
			offset = 0;
			offset_prev = false;
			offset_next = false;
			update_lists();
		end
	end
	update_state();
	tid_update = timer.timeout(update, 1000);
end

function update_lists ()
	print("updating lists ...");
	
	playlists = {};
	tracks = {};
	
	if (valid()) then
		-- Get playlists
		local count = obj.LibrarySource.Playlists.Count;
		for i = 1, count do
			local playlist = obj.LibrarySource.Playlists(i);
			if (playlist.Tracks.Count > 0) then
				table.insert(playlists, { type = "item", text = playlist.Name .. "\nTracks: " .. playlist.Tracks.Count });
			end
		end
		
		-- Get tracks
		if (obj.CurrentPlaylist ~= nil) then
			local total = obj.CurrentPlaylist.Tracks.Count;
			count = math.min(page, total);
			
			local from = math.min(1 + offset, total);
			local to = math.min(from + page, total);
			
			if (from > 1) then
				table.insert(tracks, { type = "item", text = "Load previous tracks" });
				offset_prev = true;
			end
			for i = from, to do
				local track = obj.CurrentPlaylist.Tracks:ItemByPlayOrder(i);
				table.insert(tracks, { type = "item", text = track.Name .. "\n" .. track.Artist, track = i });
			end
			if (to < total) then
				table.insert(tracks, { type = "item", text = "Load next tracks" });
				offset_next = true;
			end
		end
	end
	
	server.update(
		{ id = "playlists", children = playlists },
		{ id = "tracks", children = tracks }
	);
	
	print("updating lists: done");
end

function update_state ()
	local title = "";
	local duration = 0;
	local position = 0;
	local volume = 0;
	local icon = "play";
	
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
	else
		title = "[Not Running]";
	end
	
	server.update(
		{ id = "title", text = title },
		{ id = "pos", progress = position, progressmax = duration },
		{ id = "vol", progress = volume },
		{ id = "play", icon = icon }
	);
end

actions.playlist = function (i)
	print("playlist: " .. i);
	if (valid()) then
		obj:Stop();
		obj.LibrarySource.Playlists(i+1).Tracks(1):Play();
		update_state();
	end
end

actions.track = function (i)
	print("track: " .. i);
	if (valid()) then
		if (obj.CurrentPlaylist ~= nil) then
			if (tracks[i+1].text == "Load previous tracks") then
				offset = offset - page;
				update_lists();
			elseif (tracks[i+1].text == "Load next tracks") then
				offset = offset + page;
				update_lists();
			else
				local track = obj.CurrentPlaylist.Tracks:ItemByPlayOrder(tracks[i+1].track);
				track:Play();
				update_state();
			end
		end
	end
end

--@help Play Pause track
actions.play_pause = function ()
	if (valid()) then
		obj:PlayPause();
		update_state();
	end
end

--@help Play track
actions.play = function ()
	if (valid()) then
		obj:Play();
		update_state();
	end
end

--@help Pause track
actions.pause = function ()
	if (valid()) then
		obj:Pause();
		update_state();
	end
end

--@help Resume track
actions.resume = function ()
	if (valid()) then
		obj:Resume();
		update_state();
	end
end

--@help Stop track
actions.stop = function ()
	if (valid()) then
		obj:Stop();
		update_state();
	end
end

--@help Next track
actions.next = function ()
	if (valid()) then
		obj:NextTrack();
		update_state();
	end
end

--@help Previous track
actions.previous = function ()
	if (valid()) then
		obj:PreviousTrack();
		update_state();
	end
end

--@help Forward track
actions.forward = function ()
	if (valid()) then
		obj:FastForward();
		update_state();
	end
end

--@help Rewind track
actions.rewind = function ()
	if (valid()) then
		obj:Rewind();
		update_state();
	end
end

--@help Mute Volume
actions.volume_mute = function ()
	libs.keyboard.stroke("volumemute");
end

--@help Set Volume
--@param vol:number Set volume
actions.volume = function (vol)
	if (valid()) then
		obj.SoundVolume = vol;
		update_state();
	end
end

--@help Volume up
actions.volume_up = function ()
	if (valid()) then
		obj.SoundVolume = obj.SoundVolume + 10;
		update_state();
	end
end

--@help Volume Down
actions.volume_down = function ()
	if (valid()) then
		obj.SoundVolume = obj.SoundVolume - 10;
		update_state();
	end
end

--@help Set Position
--@param pos:number Set Position
actions.position = function (pos)
	if (valid()) then
		obj.PlayerPosition = pos;
		update_state();
	end
end
