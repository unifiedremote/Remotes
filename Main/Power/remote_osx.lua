
--@help System restart
actions.restart = function ()
	os.script("tell application \"System Events\" to restart");
end

--@help System shutdown
actions.shutdown = function ()
	os.script("tell application \"System Events\" to shut down");
end

--@help Logoff current user
actions.logoff = function ()
	os.script("tell application \"System Events\" to log out");
end

--@help Lock current session
actions.lock = function ()
	os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend");
end

--@help Put system in sleep state
actions.sleep = function ()
	os.script("tell application \"System Events\" to sleep");
end