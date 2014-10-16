local keyboard = libs.keyboard;

--@help Zoom
actions.zoom = function()
	keyboard.stroke("ctrl", "cmd", "z");
end

--@help Close Window
actions.close_window = function()
	keyboard.stroke("cmd", "w");
end

--@help Lower volume
actions.volume_down = function()
	keyboard.stroke("cmd", "down");
end

--@help Mute volume
actions.volume_mute = function()
	keyboard.stroke("cmd", "k");
end

--@help Raise volume
actions.volume_up = function()
	keyboard.stroke("cmd", "up");
end

--@help Pause playback
actions.play_pause = function()
	keyboard.stroke("space");
end

--@help Navigate left
actions.left = function()
	keyboard.stroke("left");
end

--@help Navigate up
actions.up = function()
	keyboard.stroke("up");
end
--@help Select current item
actions.select = function()
	keyboard.stroke("return");
end

--@help Navigate right
actions.right = function()
	keyboard.stroke("right");
end

--@help Navigate down
actions.down = function()
	keyboard.stroke("down");
end

--@help Navigate back
actions.back = function()
	keyboard.stroke("esc");
end

--@help Next item
actions.next = function()
	keyboard.stroke("right");
end

--@help Channel up
actions.channel_up = function ()
	keyboard.stroke("plus");
end

--@help Channel down
actions.channel_down = function ()
	keyboard.stroke("minus");
end

--@help Jump forward
actions.jump_forward = function ()
	keyboard.stroke("right");
end

--@help Fast forward
actions.fast_forward = function ()
	keyboard.stroke("cmd", "right");
end

--@help Fast basck
actions.fast_back = function ()
	keyboard.stroke("cmd", "left");
end

--@help Info
actions.info = function ()
	keyboard.stroke("cmd", "i");
end

--@help Jump backward
actions.jump_back = function ()
	keyboard.stroke("left");
end

--@help Show Program Window
actions.show_program_window = function ()
	keyboard.stroke("space");
end

--@help Toggle fullscreen
actions.fullscreen = function ()
	keyboard.stroke("cmd", "0");
end

--@help Open menu
actions.menu = function ()
	keyboard.stroke("cmd", "esc");
end