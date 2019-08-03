events.detect = function ()
	return libs.fs.exists("/Applications/photos.app");
end

--@help Launch photos application
actions.launch = function()
	os.script("tell application \"photos\" to reopen activate");
end

actions.activate = function()
	os.script("tell application \"photos\" to activate");
end

--@help Start slide show
actions.start = function ()
	actions.activate();
	libs.keyboard.stroke("cmd", "a");
	os.script("tell application \"photos\"",
			"set theseItems to (get the selection)",
			"start slideshow using theseItems",
		"end tell");
end

--@help Stop slide show
actions.stop = function ()
actions.activate();
	os.script("tell application \"photos\" to stop slideshow");
end

--@help Show next slide
actions.next = function ()
actions.activate();
	os.script("tell application \"photos\" to next slide");
end

--@help Show previous slide
actions.previous = function ()
actions.activate();
	os.script("tell application \"photos\" to previous slide");
end

--@help Pause slide show
actions.pause = function ()
actions.activate();
	os.script("tell application \"photos\" to pause slideshow");
end

--@help Toggle volume mute
actions.volume_mute = function ()
	libs.keyboard.press("volumemute");
end
