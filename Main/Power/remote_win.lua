
-- Native Windows Stuff
local ffi = require("ffi");
ffi.cdef[[
bool LockWorkStation();
int ExitWindowsEx(int uFlags, int dwReason);
bool SetSuspendState(bool hibernate, bool forceCritical, bool disableWakeEvent);
]]
local PowrProf = ffi.load("PowrProf");

--@help System restart
--@param sec:number Timeout in seconds (default 5)
actions.restart = function (sec)
	if not sec then sec = 5; end
	os.execute("shutdown /r /t " .. sec);
end

--@help System shutdown
--@param sec:number Timeout in seconds (default 5)
actions.shutdown = function (sec)
	if not sec then sec = 5; end
	-- Default Windows shutdown behavior is /hybdrid - This should hopefully make WOL work!
	os.execute("shutdown /s /hybrid /t " .. sec);
end

--@help Logoff current user
actions.logoff = function ()
	ffi.C.ExitWindowsEx(0,0);
end

--@help Lock current session
actions.lock = function ()
	ffi.C.LockWorkStation();
end

--@help Put system in sleep state
actions.sleep = function ()
	PowrProf.SetSuspendState(false, true, false);
end

--@help Put system in hibernate state
actions.hibernate = function ()
	PowrProf.SetSuspendState(true, true, false);
end

--@help Abort any pending restart or shutdown
actions.abort = function ()
	os.execute("shutdown /a");
end
