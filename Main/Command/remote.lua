local last = "";
local cmd = "";

actions.update = function (str)
	cmd = str;
end

--@help Execute a command
--@param command The command to execute
actions.execute = function (command)
	if (cmd == "") then
		cmd = last;
	end
	if (command ~= nil) then
		cmd = command;
	end
	
	last = cmd;
	layout.command.hint = cmd;
	layout.command.text = "";
	layout.output.text = "Executing...";

	local pout = "";
	local presult = 0;
	local perr = "";
	
	local success, ex = pcall(function ()
		pout,perr,presult = libs.script.shell(cmd);
	end);
	
	if (success) then
		layout.output.text = "Result: " .. presult .. "\n\n" .. pout .. "\n\n" .. perr;
	else
		layout.output.text = "Error: " .. ex;
	end
end