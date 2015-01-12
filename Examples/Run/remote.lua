

-- Documentation
-- http://www.unifiedremote.com/api

-- OS Library
-- http://www.unifiedremote.com/api/libs/os


--@help Command 1
actions.command1 = function ()
	os.start("calc");
end


--@help Command 2
actions.command2 = function ()
	os.start("C:\\foobar.exe");
end


--@help Command 3
actions.command3 = function ()
	os.start("ipconfig", "/all");
end

