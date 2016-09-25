------------------------------------------------------------------------------
-- Arabic Keyboard
------------------------------------------------------------------------------
include("../keyboard.lua");

-- Layout
keys = {
	{ "ESCAPE", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩", "٠" },
	{ "،" , "\"" , "'" , ":" , "؛"      , "!" , "؟"  },
	{ "ـ" ,"ٖ" ,  "ٰ" ,  "ٓ" , "ِ" ,"ُ" ,"َ" },
	{   "ّ", "ٕ","ٔ" , "ْ","ٍ" , "ٌ" ,"ً"  },
	{ "TAB", "ض", "ص", "ث", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج" },
	{  "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك", "ط" },
	{ "SHIFT", "ذ", "ء", "ؤ", "ر", "ى", "ة", "و", "ز", "ظ", "د", "BACK" },
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
