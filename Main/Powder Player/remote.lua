local kb = libs.keyboard;

actions.aspectRatio = function ()
	kb.stroke("a");
end


actions.cropScreen = function ()
	kb.stroke("c");
end


actions.zoomMode = function ()
	kb.stroke("z");
end


actions.toggleMute = function ()
	kb.stroke("m");
end


actions.showTime = function ()
	kb.stroke("t");
end


actions.jumpLeft = function ()
	kb.stroke("left");
end


actions.jumpRight = function ()
	kb.stroke("right");
end


actions.volumeUp = function ()
	kb.stroke("up");
end


actions.volumeDown = function ()
	kb.stroke("down");
end


actions.togglePause = function ()
	kb.stroke("space");
end


actions.toggleFullscreen = function ()
	kb.stroke("f");
end


actions.playlistNext = function ()
	kb.stroke("n");
end
