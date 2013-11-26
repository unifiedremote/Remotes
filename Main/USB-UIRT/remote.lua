
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
local server = libs.server;

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
	server.update({ id = "status", text = s });
end

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
		status(ffi.string(state.code));
		server.set("code", ffi.string(state.code));
	else
		status("Error");
	end
end

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

actions.helper_learn_pronto = function ()
	actions.learn("pronto");
end

actions.helper_learn_uuirt = function ()
	actions.learn("uuirt");
end

actions.helper_transmit_pronto = function ()
	actions.transmit("pronto");
end

actions.helper_transmit_uuirt = function ()
	actions.transmit("uuirt");
end
