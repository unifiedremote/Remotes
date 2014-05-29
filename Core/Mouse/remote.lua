
local mouse = libs.mouse;

--@help Perform raw mouse movement
--@param x:number Move cursor X amount
--@param y:number Move cursor Y amount
actions.moveraw = function (x, y)
	mouse.moveraw(x,y);
end

--@help Perform relative mouse movement
--@param x:number Move cursor X pixels
--@param y:number Move cursor Y pixels
actions.moveby = function (x, y)
	mouse.moveby(x,y);
end

--@help Perform absolute mouse movement
--@param x:number Move to X coordinate
--@param y:number Move to Y coordinate
actions.moveto = function (x, y)
	mouse.moveto(x, y);
end

--@help Hold down button(s)
--@param buttons:buttons Buttons to hold down
actions.down = function (...)
	mouse.down(unpack({...}));
end

--@help Release mouse button(s)
--@param buttons:buttons Buttons to release
actions.up = function (...)
	mouse.up(unpack({...}));
end

--@help Click mouse button(s)
--@param buttons:buttons Buttons to click
actions.click = function (...)
	mouse.click(unpack({...}));
end

--@help Double click mouse button(s)
--@param buttons:buttons Buttons to double click
actions.double = function (...)
	mouse.double(unpack({...}));
end

--@help Signal beginning of drag motion
actions.dragbegin = function ()
	mouse.dragbegin();
end

--@help Signal end of drag motion
actions.dragend = function ()
	mouse.dragend();
end

--@help Perform vertical mouse scroll
--@param amount:number How much to scroll vertically
actions.vscroll = function (amount)
	mouse.vscroll(amount);
end

--@help Perform horizontal mouse scroll
--@param amount:number How much to scroll horizontally
actions.hscroll = function (amount)
	mouse.hscroll(amount);
end

--@help Perform zoom in
actions.zoom_in = function ()
	mouse.zoomin();
end

--@help Perform zoom out
actions.zoom_out = function ()
	mouse.zoomout();
end