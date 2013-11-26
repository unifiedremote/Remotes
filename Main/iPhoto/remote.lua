
--@help Launch VLC application
actions.launch = function()
	os.script("tell application \"iPhoto\" to reopen activate");
end

--@help Start slide show
actions.start = function ()
	running = os.script("tell application \"iPhoto\" to set out to slideshow running");
	if (not running) then
		os.script("tell application \"iPhoto\" to start slideshow");
	else
		os.script("tell application \"iPhoto\" to resume slideshow");
	end
end

--@help Stop slide show
actions.stop = function ()
	os.script("tell application \"iPhoto\" to stop slideshow");
end

--@help Show next slide
actions.next = function ()
	os.script("tell application \"iPhoto\" to next slide");
end

--@help Show previous slide
actions.previous = function ()
	os.script("tell application \"iPhoto\" to previous slide");
end

--@help Pause slide show
actions.pause = function ()
	os.script("tell application \"iPhoto\" to pause slideshow");
end

--@help Toggle volume mute
actions.volume_mute = function ()
	libs.keyboard.press("volumemute");
end
