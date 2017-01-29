local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;

--@help Focus Chrome application
actions.switch = function()
	local hwnds = win.findall(0, "ApplicationFrameWindow", nil, false);
	for i,hwnd in ipairs(hwnds) do
		local title = win.title(hwnd);
		if utf8.startswith(title, "Groove") then
			win.switchtowait(hwnd);
		end
	end
end

--@help Lower system volume
actions.volume_down = function()
	keyboard.stroke("f8");
end

--@help Mute system volume
actions.volume_mute = function()
	keyboard.stroke("f7");
end

--@help Raise system volume
actions.volume_up = function()
	keyboard.stroke("f9");
end

--@help Previous track
actions.previous = function()
	keyboard.stroke("ctrl", "b"); 
end

--@help Next track
actions.next = function()
	keyboard.stroke("ctrl", "f");
end

--@help Toggle playback state
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("ctrl", "p");
end

--@help Toggle repeat
actions.toggle_repeat = function()
	keyboard.stroke("ctrl", "t");
end

--@help Toggle shuffle
actions.toggle_shuffle = function()
	keyboard.stroke("ctrl", "h");
end
