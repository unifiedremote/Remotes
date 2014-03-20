local timer = libs.timer;
local data = libs.data;
local server = libs.server;
local tid = -1;

local playing = false;
local duration = 0;
local time = 0;
local icon = "";

events.focus = function ()
	tid = timer.interval(update, 1000);
end

events.blur = function ()
	timer.cancel(tid);
end

function update ()
	name = os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set out to name",
		"end if",
	"end tell");

	playing = os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set out to playing",
		"end if",
	"end tell");

	time = os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set out to time",
		"end if",
	"end tell");
	time = math.floor(time);

	duration = os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set out to duration",
		"end if",
	"end tell");
	duration = math.floor(duration);

	local pos = math.floor(time / duration * 100);
	local icon = "play";
	if (playing) then
		icon = "pause";
	end

	server.update(
		{ id = "pos", progress = pos, progressmax = 100, text = data.sec2span(time) .. " / " .. data.sec2span(duration) },
		{ id = "p", icon = icon },
		{ id = "info", text = name }
	);
end

--@help Launch Spotify application
actions.launch = function()
	os.open("/Application/QuickTimer Player.app");
end

actions.play_pause = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"if playing then",
				"pause",
			"else",
				"play",
			"end if",
		"end if",
	"end tell");
	update();
end

actions.play = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"play",
		"end if",
	"end tell");
end

actions.pause = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"pause",
		"end if",
	"end tell");
end

actions.stop = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"stop",
		"end if",
	"end tell");
end

actions.rewind = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set time to time - 10",
		"end if",
	"end tell");
end

actions.forward = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set time to time + 10",
		"end if",
	"end tell");
end

actions.volume_up = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set audio volume to audio volume + 0.1",
		"end if",
	"end tell");
end

actions.volume_down = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set audio volume to audio volume - 0.1",
		"end if",
	"end tell");
end

actions.volume_mute = function ()
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set muted to (not muted)",
		"end if",
	"end tell")
end

actions.seek = function (pos)
	local time = pos / 100 * duration;
	os.script("tell application \"QuickTime Player\"",
		"tell document 1 to if exists then",
			"set time to " .. time,
		"end if",
	"end tell");
end