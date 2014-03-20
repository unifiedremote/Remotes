keyboard = libs.keyboard;

actions.turn_on = function ()
	keyboard.press("brightnessup");
end

actions.turn_off = function ()
	keyboard.stroke("ctrl", "shift", "eject");
end

actions.brightness_up = function ()
	keyboard.press("brightnessup");
end

actions.brightness_down = function ()
	keyboard.press("brightnessdown");
end
