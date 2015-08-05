local keyboard = libs.keyboard;

function toast ()
	if (settings.toast == "") then
		libs.server.update({
			type = "dialog",
			text = "Volume control requires that the player has focus. Click in the player window using the mouse remote once to focus the player.",
			title = "Volume",
			children = { { type = "button", text = "OK" } }
		});
		settings.toast = "true";
	end
end

--@help Launch YouTube
actions.launch = function()
	os.open("http://www.youtube.com");
end

--@help Lower volume
actions.volume_down = function()
	toast();
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	toast();
	keyboard.stroke("up");
end

--@help Rewind
actions.rewind = function()
	keyboard.stroke("J");
end

--@help Fast forward
actions.fast_forward = function()
	keyboard.stroke("L");
end

--@help Play previous item
actions.previous = function()
	keyboard.stroke("shift", "p");
end

--@help Play next item
actions.next = function()
	keyboard.stroke("shift", "n");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	keyboard.stroke("F");
end

--@help Exit fullscreen
actions.exit_fullscreen = function()
	keyboard.stroke("esc");
end

--@help Toggle play/pause
actions.play_pause = function()
	keyboard.stroke("K");
end

