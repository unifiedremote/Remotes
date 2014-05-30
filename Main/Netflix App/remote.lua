local uia = libs.uia;
local win = libs.win;

actions.foo = function ()
	local desktop = uia.desktop();
	local wmp = uia.find(desktop, "Now Playing", "children");
	
	local status = uia.find(wmp, "Status and Command Bar View", "children");
	local status_group = uia.child(status, 0);
	local status_edit = uia.child(status_group, 1);
	print(uia.property(status_edit, "name"));
	
	local playback = uia.find(wmp, "Playback Controls View", "children");
	local seeker = uia.find(playback, "Seek", "subtree");
	print(uia.property(seeker, "valuevalue"));
	
	local volume = uia.find(playback, "Volume", "subtree");
	print(uia.property(volume, "valuevalue"));
end
