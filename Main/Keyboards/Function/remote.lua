------------------------------------------------------------------------------
-- Function Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12" },
	{ "TAB", "!", "\"", "AT", "#", "£", "¤", "$", "%", "&", "/" },
	{ "CAPITAL", "(", ")", "[","]", "=", "?", "+", "\\", "´", "`", "^", "*"},
	{ "SHIFT", "¨", "~", "-", ":", ";", "<", ">", "|", "½", "§", "_", "'", "BACK" },
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