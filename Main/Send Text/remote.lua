local keyboard = require("keyboard");
local script = require("script");
local utf8 = require("utf8");

local _text = "";

--@help Set current text
--@param text
actions.change = function(text)
	_text = text;
end

--@help Send current text
actions.send = function()
	keyboard.text(_text);
end

--@help Enter
actions.enter = function()
	keyboard.press("return");
end

--@help Backspace
actions.back = function()
	keyboard.press("back");
end

--@help Copy to clipboard
actions.copy = function()
	local code = utf8.replace(_text, "\"", "\\\"");
	print("Copying " .. code .. " into clipboard");
	if OS_WINDOWS then
		script.shell("echo \"" .. code .. "\" | clip");
	elseif OS_OSX then
		script.apple("set the clipboard to \"" .. code .."\"");
	elseif OS_LINUX then
		-- Might not work on every distribution..
		script.shell("echo \"" .. code .. "\" | xclip -selection c")
	else 
		print("WTF!?");
	end
end

