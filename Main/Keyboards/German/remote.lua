------------------------------------------------------------------------------
-- German Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "TAB", "Q", "W", "E", "R", "T", "Z", "U", "I", "O", "P", "Ü" }, 
	{ "CAPITAL", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Ö", "Ä" },
	{ "SHIFT", "Y", "X", "C", "V", "B", "N", "M", "COMMA", ".", "-", "BACK" },
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
	FN = "Fn",
	COMMA = ","
};

-- Key Weights
weights = {
	SPACE = 2
};
