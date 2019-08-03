local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer;
local server = libs.server;

events.detect = function ()
	return libs.fs.exists("%APPDATA%\\Spotify");
end

--@help Focus Spotify application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("Spotify.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("Spotify.exe");
	end 
end

--@help Launch Spotify application
actions.launch = function()
	os.start("%appdata%\\Spotify\\spotify.exe");
end

--@help Start playback
actions.play = function()
		actions.play_pause();
end

--@help Pause playback
actions.pause = function()
		actions.play_pause();
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.press("space");
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("control", "down")
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("control", "up")
end

--@help Mute volume
actions.volume_mute = function()
	actions.switch();
	keyboard.stroke("control", "shift", "down");
end

--@help Shuffle tracks
actions.shuffle = function()
	actions.switch();
	keyboard.stroke("control", "s")
end

--@help Repeat tracks
actions["repeat"] = function()
	actions.switch();
	keyboard.stroke("control", "r")
end

--@help Next track
actions.next = function()
	actions.switch();
	keyboard.stroke("control", "right")
end

--@help Previous track
actions.previous = function()
	actions.switch();
	keyboard.stroke("control", "left")
end

