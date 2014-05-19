
local l = libs.log;

--@help Log trace message
--@param msg Message to write to trace log
actions.trace = function (msg)
	l.trace(msg);
end

--@help Log info message
--@param msg Message to write to info log
actions.info = function (msg)
	l.info(msg);
end

--@help Log warning message
--@param msg Message to write to warning log
actions.warning = function (msg)
	l.warning(msg);
end

--@help Log error message
--@param msg Message to write to error log
actions.error = function (msg)
	l.error(msg);
end
