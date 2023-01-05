local de = "";

events.create = function ()
	-- Try to determine the current DE
	local desktop = os.getenv("XDG_CURRENT_DESKTOP");
	local session = os.getenv("GDMSESSION");
	if (desktop == "Unity") then
		de = "Unity";
	elseif (desktop == "KDE" or utf8.contains(session, "kde")) then
		de = "KDE";
	elseif (desktop == "GNOME") then
		de = "GNOME";
	elseif (desktop == "LXDE") then
		de = "LXDE";
	else
		de = "";
	end
end
	
--@help System restart
actions.restart = function ()
	-- Alternatives for other DEs should be added here...
	if (de == "KDE") then
		os.execute("qdbus org.kde.ksmserver /KSMServer logout 0 1 2");
	else
		os.execute('dbus-send --system --print-reply --dest="org.freedesktop.login1" /org/freedesktop/login1 org.freedesktop.login1.Manager.Reboot boolean:true');
	end
end

--@help System shutdown
actions.shutdown = function ()
	-- Alternatives for other DEs should be added here...
	if (de == "KDE") then
		os.execute("qdbus org.kde.ksmserver /KSMServer logout 0 2 2");
	else
		os.execute('dbus-send --system --print-reply --dest="org.freedesktop.login1" /org/freedesktop/login1 org.freedesktop.login1.Manager.PowerOff boolean:true');
	end
end

--@help Logoff current user
actions.logoff = function ()
	os.execute("logout");
end

--@help Put system in sleep state
actions.sleep = function ()
	os.execute("systemctl suspend -i")
	os.execute('dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend');
end

--@help Put system in hibernate state
actions.hibernate = function ()
	os.execute("systemctl hibernate -i")
	os.execute('dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate');
end

--@help Abort any pending restart or shutdown
actions.abort = function ()
	os.execute("pkill shutdown");
end
