local ffi = require("ffi");

ffi.cdef[[
int mciSendString(const char* command, const char* buffer, int bufferSize, long hwndCallback);
]]

actions.eject = function ()
	ffi.C.mciSendString("set CDAudio door open", "", 127, 0);
end

actions.close = function ()
	ffi.C.mciSendString("set CDAudio door close", "", 127, 0);
end