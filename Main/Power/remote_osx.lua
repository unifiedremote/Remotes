-- metadata
meta.id = "Unified.Power"
meta.name = "Power"
meta.author = "Unified Intents"
meta.description = "Remote system power control."
meta.platform = "osx"

--@help Force system restart
actions.restart = function (sec)
	os.script("tell application \"System Events\" to restart");
end

--@help Force system shutdown
actions.shutdown = function ()
	os.script("tell application \"System Events\" to shut down");
end

--@help Logoff current user
actions.logoff = function ()
	os.script("tell application \"System Events\" to log out");
end

--@help Lock current session
actions.lock = function ()
	
end

--@help Put system in sleep state
actions.sleep = function ()
	os.script("tell application \"System Events\" to sleep");
end