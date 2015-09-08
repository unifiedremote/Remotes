local uia = libs.uia;
local win = libs.win;
local tmr = libs.timer;
local server = libs.server;
local player = nil;
local popup = nil;
local tid = -1;
local title = nil;
local sne = nil;
local et = nil;
local movielength = -1;
local currpos = -1;
local onChangePos = false;

events.focus = function()
	title = nil;
	sne = nil;
	et = nil;
	movielength = -1;
	tid = tmr.interval(update, 1000);
end

events.blur = function()
	tmr.cancel(tid);
	end_popup();
end

function begin_popup()
	local desktop = uia.desktop();
	local root = uia.find(desktop, "Netflix", "children");
	local appbar = uia.find(root, "TopAppBar", "subtree");
	if(appbar == nil) then
		player = uia.find(root, "Video player page", "subtree");
		uia.dodefaultaction(player);
		appbar = uia.find(root, "TopAppBar", "subtree");
	end
	popup = uia.parent(appbar);
end

function end_popup()
	if (player ~= nil) then
		uia.dodefaultaction(player);
	end
	player = nil;
	popup = nil;
end

function get_time()
	local desktop = uia.desktop();
	local root = uia.find(desktop, "Netflix", "children");
	local vp = uia.find(root, "Video player page", "subtree");
	local v = uia.find(vp, "Video", "subtree");
	return uia.property(v, "rangevaluemaximum");
end

function get_pos()
	local desktop = uia.desktop();
	local root = uia.find(desktop, "Netflix", "children");
	local vp = uia.find(root, "Video player page", "subtree");
	local v = uia.find(vp, "Video", "subtree");
	return uia.property(v, "rangevaluevalue");
end

actions.play_pause = function ()
	begin_popup();	
		local pp = uia.find(popup, "PauseResume", "subtree");
		uia.toggle(pp);
	end_popup();
end

actions.rewind = function ()
	begin_popup();
		local tp = uia.find(popup, "TrickPlay", "subtree");
		local curr = uia.property(tp, "rangevaluevalue");
		uia.rangesetvalue(tp, curr - 60);
	end_popup();
end

actions.forward = function ()
	begin_popup();
		local tp = uia.find(popup, "TrickPlay", "subtree");
		local curr = uia.property(tp, "rangevaluevalue");
		uia.rangesetvalue(tp, curr + 60);
	end_popup();
end

actions.volumeup = function()
	begin_popup();
		local appbar = uia.find(popup, "BottomAppBar", "children");
		local v = uia.find(appbar, "Volume", "children");
		local vb = uia.findby(v, "AutomationId","string", "ShowHide");
		if(vb ~= nil) then
			uia.toggle(vb);
			local slider = uia.child(v, 1);
			local value = uia.property(slider, "rangevaluevalue");
			
			if(value <= 95) then
				uia.rangesetvalue(slider, value + 5);
			else
				uia.rangesetvalue(slider, 100);
			end
			uia.toggle(vb);
		end
	end_popup();
end

actions.volumedown = function()
	begin_popup();
		local appbar = uia.find(popup, "BottomAppBar", "children");
		local v = uia.find(appbar, "Volume", "children");
		local vb = uia.findby(v, "AutomationId","string", "ShowHide");
		if(vb ~= nil) then
			uia.toggle(vb);
			local slider = uia.child(v, 1);
			local value = uia.property(slider, "rangevaluevalue");
			
			if(value >= 5) then
				uia.rangesetvalue(slider, value - 5);
			else
				uia.rangesetvalue(slider, 0);
			end
			uia.toggle(vb);
		end
	end_popup();
end

actions.volumemute = function()
	begin_popup();
		local appbar = uia.find(popup, "BottomAppBar", "children");
		local v = uia.find(appbar, "Volume", "children");
		local vb = uia.findby(v, "AutomationId","string", "ShowHide");
		if(vb ~= nil) then
			uia.toggle(vb);
			local mute = uia.find(v, "Mute", "children");
			uia.dodefaultaction(mute);
			uia.toggle(vb);
		end
	end_popup();
end

actions.posFinish = function(pos)
	local t = get_time();
	local newtime = (pos/100) * t;
	begin_popup();
		local tp = uia.find(popup, "TrickPlay", "subtree");
		local curr = uia.property(tp, "rangevaluevalue");
		uia.rangesetvalue(tp, newtime);
	end_popup();
	onChangePos = false;
end

actions.posStart = function(pos)
	onChangePos = true;
end

function update()
	local t = get_time();
	local cpos = get_pos();
	
	if(cpos ~= currpos and onChangePos ~= true)then
		local proc = math.round(cpos/t * 100);
		server.update(
			{ id = "pos", progress = proc }
		); 
		currpos = cpos;
	end
	if (movielength ~= t) then
		movielength = t;
		begin_popup();
		local tp = uia.find(popup, "TopAppBar", "children");
		local t = uia.child(tp, 1);
		local t1 = uia.child(tp, 2);
		local t2 = uia.child(tp, 3);
		title = uia.name(t);
		sne = uia.name(t1);
		et = uia.name(t2);
		server.update(
			{ id = "title", text = title },
			{ id = "sne", text = sne },
			{ id = "et", text = et }
		); 
		end_popup(); 
	end
end