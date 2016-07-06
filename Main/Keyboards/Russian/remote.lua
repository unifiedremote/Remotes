------------------------------------------------------------------------------
-- Russian Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "TAB", "Й","Ц","У","К","Е","Н","Г","Ш","Щ","З","Х","Ъ"}, 
	{ "CAPITAL", "Ф","Ы","В","А","П","Р","О","Л","Д","Ж","Э","Ё"},
	{ "SHIFT", "Я","Ч","С","М","И","Т","Ь","Б","Ю", "COMMA", ".", "/","BACK"},
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