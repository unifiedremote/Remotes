local keyboard = libs.keyboard;

--@help Launch Pandora site
actions.launch = function ()
	os.open("http://www.pandora.com");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("volume_down");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("volume_up");
end

--@help Like current track
actions.thumbs_up = function()
	if (OS_WINDOWS) then
		keyboard.stroke("shift", "oem_plus");
	else
		keyboard.stroke("shift","plus");
	end
end

--@help Dislike current track
actions.thumbs_down = function()
	if (OS_WINDOWS) then
		keyboard.stroke("oem_minus");
	else
		keyboard.stroke("minus");
	end
end

--@help Next track
actions.next = function()
	keyboard.stroke("right");	
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.stroke("space");
end

