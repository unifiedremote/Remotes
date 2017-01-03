local keyboard = libs.keyboard;


--@help Launch Napster site
actions.launch = function()
	os.open("https://app.napster.com");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Previous track
actions.previous = function()
	keyboard.stroke("left");
end

--@help Next track
actions.next = function()
	keyboard.stroke("right");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("volumedown");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volumeup");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("volumemute");
end

