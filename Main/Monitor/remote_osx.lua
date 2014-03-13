keyboard = libs.keyboard;
osx = libs.osx;

actions.turn_on = function ()
	osx.displayon();
end

actions.turn_off = function ()
	osx.displayoff();
end

actions.brightness_up = function ()
	keyboard.press("brightnessup");
end

actions.brightness_down = function ()
	keyboard.press("brightnessdown");
end
