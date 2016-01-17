------------------------------------------------------------------------------
-- Dvorak Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "TAB", "\"", "<", ">", "P", "Y", "F", "G", "C", "R", "L", "?", "+" }, 
	{ "CAPITAL", "A", "O", "E", "U", "I", "D", "H", "T", "N", "S", "-" },
	{ "SHIFT", ":", "Q", "J", "K", "X", "B", "M", "W", "V", "Z", "BACK" },
	{ "FN", "CONTROL", "LWIN", "MENU", "SPACE", "RMENU", "RETURN" } 
};

-- Key Icons
icons = {
	BACK = "backspace",
};

-- Key Texts
texts = {
	AT = "@",
	SPACE = " ",
	CAPITAL = "Caps",
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
	SPACE = 2
};