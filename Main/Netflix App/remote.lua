local uia = libs.uia;
local win = libs.win;

local player = nil;
local popup = nil;

function begin_popup()
	local desktop = uia.desktop();
	local root = uia.find(desktop, "Netflix", "children");
	
	popup = uia.find(root, "Popup", "children");
	if (popup == nil) then
		player = uia.find(root, "Video player page", "children");
		uia.dodefaultaction(player);
		popup = uia.find(root, "Popup", "children");
	end
end

function end_popup()
	if (player ~= nil) then
		uia.dodefaultaction(player);
	end
	player = nil;
	popup = nil;
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
