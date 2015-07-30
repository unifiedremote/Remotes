
-- Config
local UUIRTDRV_CFG_LEDRX		= 0x0001
local UUIRTDRV_CFG_LEDTX		= 0x0002
local UUIRTDRV_CFG_LEGACYRX		= 0x0004

-- Format
local UUIRTDRV_IRFMT_UUIRT		= 0x0000
local UUIRTDRV_IRFMT_PRONTO		= 0x0010

-- Friendly Format
local FORMAT_UUIRT 		= "uuirt";
local FORMAT_PRONTO 	= "pronto";

-- Learn
local UUIRTDRV_IRFMT_LEARN_FORCERAW		= 0x0100
local UUIRTDRV_IRFMT_LEARN_FORCESTRUC	= 0x0200
local UUIRTDRV_IRFMT_LEARN_FORCEFREQ	= 0x0400
local UUIRTDRV_IRFMT_LEARN_FREQDETECT	= 0x0800

-- Error
local UUIRTDRV_ERR_NO_DEVICE = 0x20000001
local UUIRTDRV_ERR_NO_RESP   = 0x20000002
local UUIRTDRV_ERR_NO_DLL    = 0x20000003
local UUIRTDRV_ERR_VERSION   = 0x20000004

-- UsbUirt Lib
local ffi = require("ffi");
ffi.cdef[[
	//typedef void (WINAPI *PUUCALLBACKPROC) (char *IREventStr, void *userData);
	//typedef void (WINAPI *PLEARNCALLBACKPROC) (unsigned int progress, unsigned int sigQuality, unsigned long carrierFreq, void *userData);
	typedef void* HUUHANDLE;
	typedef void *HANDLE;
	typedef struct {
		unsigned int fwVersion;
		unsigned int protVersion;
		unsigned char fwDateDay;
		unsigned char fwDateMonth;
		unsigned char fwDateYear;
	} UUINFO, *PUUINFO;
	HUUHANDLE UUIRTOpen(void);
	bool 	UUIRTClose(HUUHANDLE hHandle);
	bool 	UUIRTGetDrvInfo(unsigned int *puDrvVersion);
	bool 	UUIRTGetUUIRTInfo(HUUHANDLE hHandle, PUUINFO puuInfo);
	bool	UUIRTGetUUIRTConfig(HUUHANDLE hHandle, unsigned int* puConfig);
	bool 	UUIRTSetUUIRTConfig(HUUHANDLE hHandle, unsigned int uConfig);
	bool 	UUIRTTransmitIR(HUUHANDLE hHandle, char *IRCode, int codeFormat, int repeatCount, int inactivityWaitTime, HANDLE hEvent, void *reserved0, void *reserved1);
	bool	UUIRTLearnIR(HUUHANDLE hHandle, int codeFormat, char *IRCode, void *progressProc, void *userData, bool *pAbort, unsigned int param1, void *reserved0, void *reserved1);
	//bool	UUIRTSetReceiveCallback(HUUHANDLE hHandle, PUUCALLBACKPROC receiveProc, void *userData);
]]
local lib = ffi.load("uuirtdrv");

-- Normal imports
local server = require("server");
local device = require("device");
local utf8 = require("utf8");

local code = "";
state = {}

events.focus = function ()
	local handle = lib.UUIRTOpen();
	state.handle = handle;
	
	local code = ffi.new("char[2048]", 0);
	state.code = code;
	
	local abort = ffi.new("bool[1]", 0);	
	state.abort = abort;
	
	status(
		"For learning, make sure to hold your remote control approximately 5 cm from the USB-UIRT module.\n\n" ..
		"Press Learn button to begin learning. Hold the button your remote control until the code appears.\n\n" ..
		"Press Transmit to test that the code works. Copy/use the code in a custom remote or a widget.\n\n" ..
		"For more info, please visit:\nwww.unifiedremote.com/guides"
	);
end

events.blur = function ()
	local close = lib.UUIRTClose(state.handle);
end

function status(s)
	code = s;
	server.update({ id = "status", text = s });
end

--@help Learn code
--@param fmt:enum uuirt,pronto
actions.learn = function (fmt)
	status("Learning...");
	
	local f = UUIRTDRV_IRFMT_PRONTO;
	if (fmt == FORMAT_UUIRT) then
		f = UUIRTDRV_IRFMT_UUIRT;
	end
	
	local learn = lib.UUIRTLearnIR(state.handle,
		bit.bor(f, UUIRTDRV_IRFMT_LEARN_FORCERAW), -- codeFormat
		state.code,		--IRCode
		nil,			--progressProc callback
		nil,			--userData
		state.abort,	--pAbort
		0,				--forced frequency
		nil,nil			--reserved
	);
	
	if (learn) then
		local code = ffi.string(state.code);
		status(code);
		server.set("code", code);
	else
		status("Error");
	end
end

--@help Transmit code
--@param fmt:enum uuirt,pronto
--@param code:string Text representation of IR code
actions.transmit = function (fmt,code)
	status("Transmitting...");
	
	local f = UUIRTDRV_IRFMT_PRONTO;
	if (fmt == FORMAT_UUIRT) then
		f = UUIRTDRV_IRFMT_UUIRT;
	end
	
	if (code ~= nil) then
		state.code = ffi.new("char[2048]", code);
	end
	
	local tx = lib.UUIRTTransmitIR(state.handle,
		state.code, --IRCode
		bit.bor(f, UUIRTDRV_IRFMT_LEARN_FORCERAW), -- codeFormat
		1,	--repeatCount,
		100,	--inactivityWaitTime
		nil,	--hEvent
		nil,nil	--reserved
	);
	
	if (tx) then
		status(ffi.string(state.code));
	else
		status("Error");
	end
end

--@help Learn code (Pronto format)
actions.helper_learn_pronto = function ()
	actions.learn("pronto");
end

--@help Learn code (UUIRT format)
actions.helper_learn_uuirt = function ()
	actions.learn("uuirt");
end

--@help Transmit saved code (Pronto format)
actions.helper_transmit_pronto = function ()
	actions.transmit("pronto");
end

--@help Transmit saved code (UUIRT format)
actions.helper_transmit_uuirt = function ()
	actions.transmit("uuirt");
end

--@help Transmit code to computer clipboard
actions.helper_clip = function ()
	local c = utf8.trim(code);
	os.script("echo \"" .. c .. "\" | clip");
	device.toast("Copied to computer clipboard!");
end

--@help Transmit UUIRT code
--@param code:string Text representation of IR code
actions.uuirt = function (code)
	actions.transmit("uuirt", code);
end

--@help Transmit Pronto code
--@param code:string Text representation of IR code
actions.pronto = function (code)
	actions.transmit("pronto", code);
end
