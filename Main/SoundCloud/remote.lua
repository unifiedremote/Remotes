local keyboard = libs.keyboard;

--@help Launch SoundCloud
actions.launch = function()
	os.open("http://www.soundcloud.com/");
end

--@help Lower system volume
actions.volume_down = function()
	keyboard.stroke("shift", "down");
end

--@help Mute system volume
actions.volume_mute = function()
	keyboard.stroke("M");
end

--@help Raise system volume
actions.volume_up = function()
	keyboard.stroke("shift", "up");
end

--@help Previous track
actions.previous = function()
	keyboard.stroke("shift", "left"); 
end

--@help Next track
actions.next = function()
	keyboard.stroke("shift", "right");
end

--@help Toggle play & pause
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Repeat playing song
actions.repeat_song = function ()
	keyboard.stroke("shift", "L");
end

--@help Seek Forward
actions.seek_forward = function ()
	keyboard.stroke("right");
end

--@help Seek Backward
actions.seek_backward = function ()
	keyboard.stroke("left");
end

--@help Like playing song
actions.like_song = function ()
	keyboard.stroke("L");
end

--@help Repost playing song
actions.repost_song = function ()
	keyboard.stroke("R");
end
