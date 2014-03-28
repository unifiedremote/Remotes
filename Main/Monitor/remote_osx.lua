keyboard = libs.keyboard;
osx = libs.osx;

--@help Wake up monitor
actions.turn_on = function ()
	osx.displayon();
end

--@help Put monitor to sleep
actions.turn_off = function ()
	osx.displayoff();
end

--@help Raise brightness
actions.brightness_up = function ()
	keyboard.press("brightnessup");
end

--@help Lower brightness
actions.brightness_down = function ()
	keyboard.press("brightnessdown");
end
