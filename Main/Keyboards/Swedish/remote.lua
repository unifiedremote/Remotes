------------------------------------------------------------------------------
-- Swedish Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "TAB", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "Å" }, 
	{ "CAPITAL", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Ö", "Ä" },
	{ "SHIFT", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "-", "BACK" },
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