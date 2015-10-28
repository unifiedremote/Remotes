local kb = libs.keyboard;
local uia = libs.uia;
local win = libs.win;
local tmr = libs.timer;
local server = libs.server;
local popup = nil;
local tid = -1;

local last_title = nil;
local last_sne = nil;
local last_et = nil;
local last_pos = -1;
local changing_pos = false;

events.focus = function()
	last_title = nil;
	last_sne = nil;
	last_et = nil;
	last_pos = -1;
	changing_pos = false;
	tid = tmr.timeout(update, 1000);
end

events.blur = function()
	tmr.cancel(tid);
end

function get_root()
	local desktop = uia.desktop();
	local root = uia.find(desktop, "Netflix", "children");
	return root;
end

function begin_popup()
	local root = get_root();
	local appbar = uia.find(root, "BottomAppBar", "subtree");
	local off = uia.property(appbar, "isoffscreen");
	if (off) then
		local player = uia.find(root, "Video player page", "subtree");
		uia.dodefaultaction(player);
		appbar = uia.find(root, "TopAppBar", "subtree");
	end
	popup = uia.parent(appbar);
end

function get_time()
	local root = get_root();
	local vp = uia.find(root, "Video player page", "subtree");
	local v = uia.find(vp, "Video", "subtree");
	return uia.property(v, "rangevaluemaximum");
end

function get_pos()
	local root = get_root();
	local vp = uia.find(root, "Video player page", "subtree");
	local v = uia.find(vp, "Video", "subtree");
	return uia.property(v, "rangevaluevalue");
end

actions.play_pause = function ()	
	begin_popup();
	local pp = uia.find(popup, "PauseResume", "subtree");
	uia.toggle(pp);
end

actions.rewind = function ()
	begin_popup();
	local tp = uia.find(popup, "TrickPlay", "subtree");
	local curr = uia.property(tp, "rangevaluevalue");
	uia.rangesetvalue(tp, curr - 60);
end

actions.forward = function ()
	begin_popup();
	local tp = uia.find(popup, "TrickPlay", "subtree");
	local curr = uia.property(tp, "rangevaluevalue");
	uia.rangesetvalue(tp, curr + 60);
end

actions.volumeup = function()
	kb.press("volumeup");
end

actions.volumedown = function()
	kb.press("volumedown");
end

actions.volumemute = function()
	kb.press("volumemute");
end

actions.pos_stop = function(pos)
	local t = get_time();
	local newtime = (pos/100) * t;
	begin_popup();
	local tp = uia.find(popup, "TrickPlay", "subtree");
	local curr = uia.property(tp, "rangevaluevalue");
	uia.rangesetvalue(tp, newtime);
	changing_pos = false;
end

actions.pos_start = function(pos)
	changing_pos = true;
end

function update()
	local t = get_time();
	local pos = get_pos();
	
	-- extract current pos
	if (pos ~= last_pos and changing_pos == false) then
		local prog = math.round(pos/t * 100);
		server.update({ id = "pos", progress = prog }); 
		last_pos = pos;
	end
	
	-- extrat current info
	local root = get_root();
	local tp = uia.find(root, "TopAppBar", "subtree");
	local title = uia.name(uia.child(tp, 1));
	local sne = uia.name(uia.child(tp, 2));
	local et = uia.name(uia.child(tp, 3));
	if (title ~= last_title) then
		last_title = title;
		last_sne = sne;
		last_et = et;
		server.update(
			{ id = "title", text = title },
			{ id = "sne", text = sne },
			{ id = "et", text = et }
		);
	end
	
	tmr.timeout(update, 1000);
end