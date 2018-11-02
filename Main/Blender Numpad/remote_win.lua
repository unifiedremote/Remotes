local kb = libs.keyboard;

actions.viewSelected = function ()
    kb.stroke("numdecimal");
end

actions.globalLocal = function ()
    kb.stroke("numdivide");
end

actions.alignViewToActiveTop = function ()
    kb.stroke("Shift", "num7");
end

actions.alignViewToActiveBottom = function ()
    kb.stroke("Shift", "Ctrl", "num7");
end

actions.alignViewToActiveFront = function ()
    kb.stroke("Shift", "num1");
end

actions.alignViewToActiveBack = function ()
    kb.stroke("Shift", "Ctrl", "num1");
end

actions.alignViewToActiveLeft = function ()
    kb.stroke("Shift", "num3");
end

actions.alignViewToActiveRight = function ()
    kb.stroke("Shift", "Ctrl", "num3");
end

actions.alignActiveCameraToView = function ()
    kb.stroke("Ctrl", "Alt", "num0");
end

actions.viewLockToActive = function ()
    kb.stroke("Shift", "numdecimal");
end

actions.viewLockClear = function ()
    kb.stroke("Alt", "numdecimal");
end

actions.orbitLeft = function ()
    kb.stroke("num4");
end

actions.orbitRight = function ()
    kb.stroke("num6");
end

actions.orbitUp = function ()
    kb.stroke("num8");
end

actions.orbitDown = function ()
    kb.stroke("num2");
end

actions.orbitOpposite = function ()
    kb.stroke("num9");
end

actions.rollLeft = function ()
    kb.stroke("Shift", "num4");
end

actions.rollRight = function ()
    kb.stroke("Shift", "num6");
end

actions.panLeft = function ()
    kb.stroke("Ctrl", "num4");
end
actions.panRight = function ()
    kb.stroke("Ctrl", "num6");
end
actions.panUp = function ()
    kb.stroke("Ctrl", "num8");
end
actions.panDown = function ()
    kb.stroke("Ctrl", "num2");
end

actions.zoomIn = function ()
    kb.stroke("numadd");
end

actions.zoomOut = function ()
    kb.stroke("numsubtract");
end

actions.slowZoomIn = function ()
    kb.stroke("Shift", "numsubtract");
end

actions.slowZoomOut = function ()
    kb.stroke("Shift", "numadd");
end

actions.zoomCameraOneToOne = function ()
    kb.stroke("Shift", "return");
end

actions.viewPerspectiveOrthodox = function ()
    kb.stroke("num5");
end

actions.setActiveObjectAsCamera = function ()
    kb.stroke("Ctrl", "num0");
end

actions.camera = function ()
    kb.stroke("num0");
end

actions.left = function ()
    kb.stroke("Ctrl", "num3");
end

actions.right = function ()
    kb.stroke("num3");
end

actions.front = function ()
    kb.stroke("num1");
end

actions.back = function ()
    kb.stroke("Ctrl", "num1");
end

actions.top = function ()
    kb.stroke("num7");
end

actions.bottom = function ()
    kb.stroke("Ctrl", "num7");
end

actions.selectMore = function ()
    kb.stroke("Ctrl", "numadd");
end

actions.selectLess = function ()
    kb.stroke("Ctrl", "numsubtract");
end