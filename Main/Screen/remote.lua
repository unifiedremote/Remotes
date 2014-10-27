local win = libs.win;

actions.update = function (x, y, w, h, update)
	local res = win.capture(x, y, w, h, update);
	libs.server.update({
		id = "back",
		x = res.x,
		y = res.y,
		w = res.w,
		h = res.h,
		image = res.image,
	});
end