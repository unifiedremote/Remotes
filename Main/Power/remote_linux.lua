
--@help Force system restart
actions.restart = function ()
	os.execute("reboot");
end

--@help Force system shutdown
actions.shutdown = function ()
	os.execute("shutdown");
end

--@help Logoff current user
actions.logoff = function ()
	os.execute("logout");
end

--@help Put system in sleep state
actions.sleep = function ()
	os.execute("apmsleep --standby");
end

--@help Put system in hibernate state
actions.hibernate = function ()
	os.execute("apmsleep --suspend");
end

--@help Abort any pending restart or shutdown
actions.abort = function ()
	os.execute("pkill shutdown");
end
