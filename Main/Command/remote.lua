local last = "";
local cmd = "";

actions.update = function (str)
	cmd = str;
end

actions.execute = function ()
	if (cmd == "") then
		cmd = last;
	end
	
	last = cmd;
	layout.command.hint = cmd;
	layout.command.text = "";
	layout.output.text = "Executing...";

	local pout = "";
	local presult = 0;
	local perr = "";
	
	local success, ex = pcall(function ()
		pout,presult,perr = io.pread(cmd);
	end);
	
	if (success) then
		layout.output.text = "Result: " .. presult .. "\n\n" .. pout .. "\n\n" .. perr;
	else
		layout.output.text = "Error: " .. ex;
	end
end