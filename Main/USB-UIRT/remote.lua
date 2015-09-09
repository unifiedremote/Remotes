local server = require("server");
local device = require("device");
local utf8 = require("utf8");
local fs = require("fs");
local code = "";

events.detect = function ()
	local h = io.popen(fs.remotedir() .. "\\usbuirtc.exe --detect 2>&1");
	local s = h:read("*a");
	h:close();
	return s == "";
end

events.focus = function ()
	status(
		"For learning, make sure to hold your remote control approximately 5 cm from the USB-UIRT module.\n\n" ..
		"Press Learn button to begin learning. Hold the button your remote control until the code appears.\n\n" ..
		"Press Transmit to test that the code works. Copy/use the code in a custom remote or a widget.\n\n" ..
		"For more info, please visit:\nwww.unifiedremote.com/tutorials"
	);
end

events.blur = function ()
	
end

function status(s)
	code = s;
	server.update({ id = "status", text = s });
end

--@help Learn code
--@param fmt:enum uuirt,pronto
actions.learn = function (fmt)
	status("Waiting...");
	
	local h = io.popen(fs.remotedir() .. "\\usbuirtc.exe --learn " ..  fmt);
	local s = h:read("*a");
	s = utf8.replace(s, "\n", "");
	h:close();
	
	if (s == "") then
		status("Error");
	else
		status(s);
		server.set("code", s);
	end
end

--@help Transmit code
--@param fmt:enum uuirt,pronto
--@param code:string Text representation of IR code
actions.transmit = function (fmt,code)
	status("Sending...");
	
	local h = io.popen(fs.remotedir() .. "\\usbuirtc.exe --send " .. fmt .. " \"" .. code .. "\"");
	local s = h:read("*a");
	h:close();
	
	if (s == "") then
		status(code);
	else
		status(s);
	end
end

actions.irsend = function (code)
	actions.transmit("pronto", code);
end

actions.irlearn = function ()
	actions.learn("pronto");
	if (code ~= "Error") then
		device.irlearned(code);
	end
end

--@help Learn code (Pronto format)
actions.helper_learn_pronto = function ()
	actions.learn("pronto");
end

--@help Transmit saved code (Pronto format)
actions.helper_transmit_pronto = function ()
	actions.transmit("pronto", code);
end

--@help Transmit code to computer clipboard
actions.helper_clip = function ()
	local c = utf8.trim(code);
	os.script("echo \"" .. c .. "\" | clip");
	device.toast("Copied to computer clipboard!");
end

--@help Transmit Pronto code
--@param code:string Text representation of IR code
actions.pronto = function (code)
	actions.transmit("pronto", code);
end
