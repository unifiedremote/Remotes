local script = require("script");

--@help Execute a Windows Batch script.
--@param cmd Command to execute
actions.batch = function (cmd)
	script.batch(cmd);
end

--@help Execute a Windows PowerShell script.
--@param cmd Command to execute
actions.powershell = function (cmd)
	script.powershell(cmd);
end

--@help Execute a Mac OS X AppleScript.
--@param cmd Command to execute
actions.apple = function (cmd)
	script.apple(cmd);
end

--@help Execute a shell script (e.g. sh/batch).
--@param cmd Command to execute
actions.shell = function (cmd)
	script.shell(cmd);
end

--@help Execute the default script depending on OS.
--@param cmd Command to execute
actions.default = function (cmd)
	script.default(cmd);
end