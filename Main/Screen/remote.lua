local screen = libs.screen;
local mouse = libs.mouse;

events.focus = function()
    libs.server.update({
        id = "monitors",
        index = screen.monitors()
    })
end

actions.update = function (x, y, w, h, update, monitor)
	local res = screen.capture(x, y, w, h, update, monitor);
	local x,y = mouse.position();

	libs.server.update({
		id = "back",
		x = res.x,
		y = res.y,
		w = res.w,
		h = res.h,
		image = res.image,
	},{
		id = "cursor",
		x = x,
		y = y
	});
end
