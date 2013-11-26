
local task = libs.task;

--@help Open Calculator
actions.calculator = function ()
	task.start("calc");
end

--@help Open Notepad
actions.notepad = function ()
	task.start("notepad");
end

--@help Open VLC
actions.vlc = function ()
	task.start("%programfiles(x86)%\\VideoLAN\\VLC\\vlc.exe");
end

--@help Open Paint
actions.paint = function ()
	task.start("mspaint");
end

--@help Open Internet Explorer
actions.ie = function ()
	task.start("iexplore");
end

--@help Open Remote Desktop
actions.rdp = function ()
	task.start("mstsc");
end

--@help Open Windows Media Player
actions.wmp = function ()
	task.start("vmplayer");
end
