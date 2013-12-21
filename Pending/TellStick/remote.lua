--Device methods
local TELLSTICK_TURNON		= 1
local TELLSTICK_TURNOFF		= 2
local TELLSTICK_BELL		= 4
local TELLSTICK_TOGGLE		= 8
local TELLSTICK_DIM			= 16
local TELLSTICK_LEARN		= 32
local TELLSTICK_EXECUTE		= 64
local TELLSTICK_UP			= 128
local TELLSTICK_DOWN		= 256
local TELLSTICK_STOP		= 512

--Sensor value types
local TELLSTICK_TEMPERATURE		= 1
local TELLSTICK_HUMIDITY		= 2

--Error codes
local TELLSTICK_SUCCESS 					= 0
local TELLSTICK_ERROR_NOT_FOUND 			= -1
local TELLSTICK_ERROR_PERMISSION_DENIED 	= -2
local TELLSTICK_ERROR_DEVICE_NOT_FOUND 		= -3
local TELLSTICK_ERROR_METHOD_NOT_SUPPORTED 	= -4
local TELLSTICK_ERROR_COMMUNICATION 		= -5
local TELLSTICK_ERROR_CONNECTING_SERVICE 	= -6
local TELLSTICK_ERROR_UNKNOWN_RESPONSE 		= -7
local TELLSTICK_ERROR_SYNTAX 				= -8
local TELLSTICK_ERROR_BROKEN_PIPE 			= -9
local TELLSTICK_ERROR_COMMUNICATING_SERVICE = -10
local TELLSTICK_ERROR_UNKNOWN 				= -99

--Device typedef
local TELLSTICK_TYPE_DEVICE	= 1
local TELLSTICK_TYPE_GROUP	= 2
local TELLSTICK_TYPE_SCENE	= 3

--Device changes
local TELLSTICK_DEVICE_ADDED			= 1
local TELLSTICK_DEVICE_CHANGED			= 2
local TELLSTICK_DEVICE_REMOVED			= 3
local TELLSTICK_DEVICE_STATE_CHANGED	= 4

--Change types
local TELLSTICK_CHANGE_NAME				= 1
local TELLSTICK_CHANGE_PROTOCOL			= 2
local TELLSTICK_CHANGE_MODEL			= 3
local TELLSTICK_CHANGE_METHOD			= 4

-- TellStick Lib
local ffi = require("ffi");
ffi.cdef[[
void tdInit(void);

int tdUnregisterCallback( int callbackId );
void tdClose(void);
void tdReleaseString(char *string);
int tdTurnOn(int intDeviceId);
int tdTurnOff(int intDeviceId);
int tdBell(int intDeviceId);
int tdDim(int intDeviceId, unsigned char level);
int tdExecute(int intDeviceId);
int tdUp(int intDeviceId);
int tdDown(int intDeviceId);
int tdStop(int intDeviceId);
int tdLearn(int intDeviceId);
int tdMethods(int id, int methodsSupported);
int tdLastSentCommand( int intDeviceId, int methodsSupported );
char *tdLastSentValue( int intDeviceId );

int tdGetNumberOfDevices();
int tdGetDeviceId(int intDeviceIndex);
int tdGetDeviceType(int intDeviceId);

char * tdGetErrorString(int intErrorNo);

char * tdGetName(int intDeviceId);
bool tdSetName(int intDeviceId, const char* chNewName);
char * tdGetProtocol(int intDeviceId);
bool tdSetProtocol(int intDeviceId, const char* strProtocol);
char * tdGetModel(int intDeviceId);
bool tdSetModel(int intDeviceId, const char *intModel);

char * tdGetDeviceParameter(int intDeviceId, const char *strName, const char *defaultValue);
bool tdSetDeviceParameter(int intDeviceId, const char *strName, const char* strValue);

int tdAddDevice();
bool tdRemoveDevice(int intDeviceId);

int tdSendRawCommand(const char *command, int reserved);

void tdConnectTellStickController(int vid, int pid, const char *serial);
void tdDisconnectTellStickController(int vid, int pid, const char *serial);

int tdSensor(char *protocol, int protocolLen, char *model, int modelLen, int *id, int *dataTypes);
int tdSensorValue(const char *protocol, const char *model, int id, int dataType, char *value, int len, int *timestamp);
]]
local lib = ffi.load("TelldusCore");

--@help Toggle deivce by ID
--@param id:number
--@param state:boolean
actions.toggle = function (id, state)
	if state then
		lib.tdTurnOn(id);
	else
		lib.tdTurnOff(id);
	end
end

--@help Toggle device by name
--@param name
--@param state:boolean
actions.toggle_name = function (name, state)
	local id = actions.find(name);
	if (id ~= nil) then actions.toggle(id, state); end
end

--@help Toggle all devices
--@param state:boolean
actions.toggle_all = function(state)
	local n = lib.tdGetNumberOfDevices();
	for i=1,n do
		local id = lib.tdGetDeviceId(i-1);
		actions.toggle(id, state);
	end
end

--@help Turn on all devices
actions.all_on = function()
	actions.toggle_all(true);
end

--@help Turn off all devices
actions.all_off = function()
	actions.toggle_all(false);
end

--@help Turn on by ID
--@param id:number
actions.turn_on = function(id)
	actions.toggle(id, true);
end

--@help Turn on by name
--@param name
actions.turn_on_name = function(name)
	local id = actions.find(name);
	if (id ~= nil) then actions.turn_on(id); end
end

--@help Turn off device by ID
--@param id:number
actions.turn_off = function(id)
	actions.toggle(id, false);
end

--@help Turn off device by name
--@param name
actions.turn_off_name = function(name)
	local id = actions.find(name);
	if (id ~= nil) then actions.turn_off(id); end
end

--@help Dim device by ID
--@param id:number
--@param dim:number
actions.dim = function (id, dim)
	if (dim == 0) then
		lib.tdTurnOff(id);
	else
		lib.tdDim(id, dim);
	end
end

--@help Dim device by name
--@param name
--@param dim:number
actions.dim_name = function (name, dim)
	local id = actions.find(name);
	if (id ~= nil) then actions.dim(id, dim); end
end

--@help Dim all devices
actions.dim_all = function(dim)
	local n = lib.tdGetNumberOfDevices();
	for i=1,n do
		local id = lib.tdGetDeviceId(i-1);
		actions.dim(id, dim);
	end
end

--@help List all devices (id, name, model)
actions.devices = function()
	local devices = {};
	
	local n = lib.tdGetNumberOfDevices();
	for i=1,n do
		local id = lib.tdGetDeviceId(i-1);
		
		local device = {};
		device.id = id;
		device.name = ffi.string(lib.tdGetName(id));
		device.model = ffi.string(lib.tdGetModel(id));
		
		local methods = lib.tdMethods(id, bit.bor(TELLSTICK_TURNON, TELLSTICK_TURNOFF, TELLSTICK_DIM));
		device.canTurnOn = bit.band(methods, TELLSTICK_TURNON) ~= 0;
		device.canTurnOff = bit.band(methods, TELLSTICK_TURNOFF) ~= 0;
		device.canDim = bit.band(methods, TELLSTICK_DIM) ~= 0;
		
		table.insert(devices, device);
	end
	
	return devices;
end

--@help Find device ID by name
--@param name
actions.find = function(name)
	local n = lib.tdGetNumberOfDevices();
	for i=1,n do
		local id = lib.tdGetDeviceId(i-1);
		if (name == lib.tdGetName(id)) then
			return id;
		end
	end
	return nil;
end

events.preload = function()
	local rows = {};
	table.insert(rows, { type = "row", weight = "wrap",
		{ type = "button", text = "All On", onTap = "all_on", color = "green" },
		{ type = "button", text = "All Off", onTap = "all_off", color = "red" },
	});
	
	local devices = actions.devices();
	for index,device in ipairs(devices) do
		if device.canDim then
			local row = { type = "row", weight = "wrap",
				{ type = "button", text = device.name, weight = 3 },
				{ type = "slider", text = "Dim", onDone = "dim," .. device.id, color = "green", progressMax = "100" },
			};
			table.insert(rows, row);
			actions["dim_" .. device.name] = function(dim) actions.dim(device.id, dim); end;
		else
			local row = { type = "row", weight = "wrap",
				{ type = "button", text = device.name, weight = 3 },
				{ type = "button", text = "On", onTap = "turn_on," .. device.id, color = "green" },
				{ type = "button", text = "Off", onTap = "turn_off," .. device.id, color = "red" },
			};
			table.insert(rows, row);
		end
		actions["turn_on_" .. device.name] = function() actions.turn_on(device.id); end;
		actions["turn_off_" .. device.name] = function() actions.turn_off(device.id); end;
	end
	
	local layout = {};
	layout.default = { type = "grid", children = rows };
	return layout;
end