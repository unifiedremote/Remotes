local kb = libs.keyboard;

actions.undo = function ()
    kb.stroke("Ctrl","Z");
end

actions.redo = function ()
    kb.stroke("Ctrl","Y");
end

actions.maximize = function ()
    kb.stroke("Shift","Space");
end

actions.copy = function ()
    kb.stroke("Ctrl","C");
end

actions.cut = function ()
    kb.stroke("Ctrl","X");
end

actions.duplicate = function ()
    kb.stroke("Ctrl","D");
end

actions.paste = function ()
    kb.stroke("Ctrl", "V");
end

actions.frame = function ()
    kb.stroke("F");
end

actions.frameLock = function ()
    kb.stroke("Shift","F");
end

actions.alignView = function ()
    kb.stroke("Ctrl","Shift","F");
end

actions.moveView = function ()
    kb.stroke("Ctrl","Alt","F");
end

actions.play = function ()
    kb.stroke("Ctrl","P");
end

actions.pause = function ()
    kb.stroke("Ctrl","Shift","P");
end

actions.createParent = function ()
    kb.stroke("Ctrl", "Shift", "G");
end