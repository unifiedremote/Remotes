------------------------------------------------------------------------------
-- Navigation Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "UP", "BACK" },
	{ "LEFT", "RETURN", "RIGHT" }, 
	{ "TAB", "DOWN", "MENU" },
	{ "CONTROL", "SPACE", "LWIN" }
};

-- Key Icons
icons = {
	BACK = "backspace",
	UP = "up",
	LEFT = "left",
	RIGHT = "right",
	DOWN = "down"
};

-- Key Texts
texts = {
	SPACE = " ",
	CONTROL = "Ctrl",
	SHIFT = "Shift",
	LWIN = "Win",
	MENU = "Alt",
	RMENU = "AltGr",
	RETURN = "Enter",
	DELETE = "Del",
	ESCAPE = "Esc",
	TAB = "Tab",
	FN = "Fn"
};

-- Key Weights
weights = {
	SPACE = 1
};