------------------------------------------------------------------------
-- Variables
------------------------------------------------------------------------

local mouse = libs.mouse;
local kb = libs.keyboard;

drawing = false;
secondary = false;

panning = false;
double_clicked = false;

multiplier = 0.1;

------------------------------------------------------------------------
-- Touchpad to draw/secondary
------------------------------------------------------------------------

actions.down_draw = function ()
	mouse.down("left");
	mouse.dragbegin();
	drawing = true;
end

actions.up_draw = function ()
	layout.tg_color_picker.checked = false;

	mouse.dragend();

	if (drawing) then mouse.up("left"); end
	if (secondary) then mouse.up("right"); end
end

actions.hold_draw = function ()
	if (drawing) then
		mouse.dragend();
		mouse.up("left");
		drawing = false;
	end

	mouse.down("right");
	mouse.dragbegin();
	secondary = true;
end

actions.double_draw = function ()
	mouse.double("left");
end

actions.delta_draw = function  (id, x, y)
	mouse.moveraw(x, y);
end

------------------------------------------------------------------------
-- Touchpad to move cursor/pan/right click
------------------------------------------------------------------------

actions.up_fixed = function ()
	if (panning) then
		panning = false;
		mouse.dragend();
		mouse.up("middle");
	end
end

actions.tap_fixed = function ()
	layout.tg_color_picker.checked = false;
	if (double_clicked ~= true) then
		mouse.click("left");
	else
		double_clicked = false;
	end
end

actions.hold_fixed = function ()
	mouse.down("middle");
	mouse.dragbegin();
	panning = true;
end

actions.double_fixed = function ()
	double_clicked = true;
	mouse.click("right");
end

actions.delta_fixed = function  (id, x, y)
	mouse.moveraw(x, y);
end

------------------------------------------------------------------------
-- Touchpad to zoom
------------------------------------------------------------------------

actions.delta_toolsize = function  (id, x, y)
	mouse.vscroll(-(y * multiplier));
end

------------------------------------------------------------------------
-- Touchpad to tool size
------------------------------------------------------------------------

actions.down_toolsize = function ()
	kb.down("shift")
end

actions.up_toolsize = function ()
	kb.up("shift")
end

actions.delta_zoom = function  (id, x, y)
	mouse.vscroll(-(y * multiplier));
end

------------------------------------------------------------------------
-- Buttons
------------------------------------------------------------------------

actions.undo = function ()
	kb.stroke("ctrl", "z");
end

actions.redo = function ()
	kb.stroke("ctrl", "y");
end

actions.pen = function ()
	kb.stroke("p");
end

actions.eraser = function ()
	kb.stroke("e");
end

actions.selection = function ()
	kb.stroke("s");
end

actions.deselect = function ()
	kb.stroke("ctrl", "d");
end

actions.color_picker = function (checked)
	if (checked) then
		kb.down("Alt");
	else
		kb.up("Alt");
	end
end

actions.color_picker_window = function ()
	kb.stroke("c");
end

actions.swap_colors = function ()
	kb.stroke("x");
end

actions.bucket = function ()
	kb.stroke("f");
end

actions.color_replacer = function ()
	kb.stroke("k");
end

actions.magic_wand = function ()
	kb.stroke("w");
end

actions.tile_placer = function ()
	kb.stroke("a");
end

actions.offset = function ()
	kb.stroke("o");
end

