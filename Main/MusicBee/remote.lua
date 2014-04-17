local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;
local timer = libs.timer;

local hwnd = 0;
local tid = -1;
local title = "";

function find ()
	-- Find all top level windows
	local hwnds = win.findall(0, nil, nil, false);
	for k,v in ipairs(hwnds) do
		local title = win.title(v);
		if (utf8.endswith(title, "MusicBee")) then
			return v;
		end
	end
	return 0;
end

function update ()
	if (hwnd ~= 0) then
		local _title = win.title(hwnd);
		if (_title ~= title) then
			title = _title;
			layout.info.text = title;
		end
	end
end

events.focus = function ()
	hwnd = find();
	tid = timer.interval(update, 1000);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Focus Chrome application
actions.switch = function()
	if (hwnd ~= 0) then
		win.switchtowait("MusicBee.exe");
	end
end

--@help Launch Chrome application
actions.launch = function()
	os.start("MusicBee");
end

--@help Toggle playback state
actions.play_pause = function ()
	actions.switch();
	keyboard.stroke("ctrl", "p");
end

--@help Stop playback
actions.stop = function ()
	actions.switch();
	keyboard.stroke("ctrl", "s");
end

--@help Next track
actions.next = function ()
	actions.switch();
	keyboard.stroke("ctrl", "n");
end

--@help Previous track
actions.previous = function ()
	actions.switch();
	keyboard.stroke("ctrl", "b");
end

--@help Lower volume
actions.volume_down = function ()
	actions.switch();
	keyboard.stroke("volumedown");
end

--@help Raise volume
actions.volume_up = function ()
	actions.switch();
	keyboard.stroke("volumeup");
end

--@help Toggle mute volume
actions.volume_mute = function ()
	actions.switch();
	keyboard.stroke("volumemute");
end



