
local task = libs.task;

-- Commands
local WM_USER = 0x0400;
local WM_BSP_CMD = WM_USER + 2;

-- Codes
local BSP_ExitFScreen = 0;
local BSP_VolUp = 1;
local BSP_VolDown = 2;
local BSP_DeDynUp = 3;
local BSP_DeDynPreUp = 4;
local BSP_DeDynDown = 5;
local BSP_DeDynPreDown = 6;
local BSP_Preferences = 7;
local BSP_FrmCapture = 8;
local BSP_Frm2 = 9;
local BSP_FS_Switch = 10;
local BSP_SubsEnDi = 11;
local BSP_Skins = 12;
local BSP_AStrmVolCyc = 13;
local BSP_Rew = 14;
local BSP_Forw = 15;
local BSP_SubCorInc = 16;
local BSP_SubCorDec = 17;
local BSP_SubCorIncS = 18;
local BSP_SubCorDecS = 19;
local BSP_Play = 20;
local BSP_Pause = 21;
local BSP_Stop = 22;
local BSP_ViewChp = 23;
local BSP_VBlankSwitch = 24;
local BSP_Prev = 25;
local BSP_PrevCh = 26;
local BSP_PrevCD = 27;
local BSP_Next = 28;
local BSP_NextCh = 29;
local BSP_NextCD = 30;
local BSP_ATop = 31;
local BSP_OvrTop = 32;
local BSP_AspCyc = 33;
local BSP_PlayList = 34;
local BSP_Mute = 35;
local BSP_JumpToTime = 36;
local BSP_Zoom50 = 37;
local BSP_Zoom100 = 38;
local BSP_Zoom200 = 39;
local BSP_AspOrg = 40;
local BSP_Asp169 = 41;
local BSP_Asp43 = 42;
local BSP_FSSW640 = 43;
local BSP_FSSW800 = 44;
local BSP_VInf = 45;
local BSP_PanIn = 46;
local BSP_PanOut = 47;
local BSP_ZoomIn = 48;
local BSP_ZoomOut = 49;
local BSP_MoveLeft = 50;
local BSP_MoveRight = 51;
local BSP_MoveUp = 52;
local BSP_MoveDown = 53;
local BSP_FRSizeLeft = 54;
local BSP_FRSizeRight = 55;
local BSP_FRSizeUp = 56;
local BSP_FRSizeDown = 57;
local BSP_ResetMov = 58;
local BSP_HideCtrl = 59;
local BSP_EQ = 60;
local BSP_OpenAud = 61;
local BSP_OpenSub = 62;
local BSP_OpenMov = 63;
local BSP_PanScan = 64;
local BSP_CusPanScan = 65;
local BSP_DeskMode = 66;
local BSP_AddBk = 67;
local BSP_EditBK = 68;
local BSP_SkinRefr = 69;
local BSP_About = 70;
local BSP_CycleAS = 71;
local BSP_CycleSub = 72;
local BSP_IncPBRate = 73;
local BSP_DecPBRate = 74;
local BSP_IncPP = 75;
local BSP_DecPP = 76;
local BSP_Exit = 77;
local BSP_CloseM = 78;
local BSP_JumpF = 79;
local BSP_JumpB = 80;
local BSP_ChBordEx = 81;
local BSP_CycleVid = 82;
local BSP_IncFnt = 83;
local BSP_DecFnt = 84;
local BSP_IncBri = 85;
local BSP_DecBri = 86;
local BSP_MovSubUp = 87;
local BSP_MovSubDown = 88;
local BSP_SHTime = 89;
local BSP_IncBriHW = 90;
local BSP_DecBriHW = 91;
local BSP_IncConHW = 92;
local BSP_DecConHW = 93;
local BSP_IncHueHW = 94;
local BSP_DecHueHW = 95;
local BSP_IncSatHW = 96;
local BSP_DecSatHW = 97;
local BSP_ShowHWClr = 98;
local BSP_IncMovWin = 99;
local BSP_DecMovWin = 100;
local BSP_IncPBRate1 = 101;
local BSP_DecPBRate1 = 102;
local BSP_SWRepeat = 103;
local BSP_SWDispFmt = 104;
local BSP_FastForw = 105;
local BSP_FastRew = 106;
local BSP_BossBtn = 107;
local BSP_MediaLib = 108;
local BSP_OpenURL = 109;
local BSP_Minimize = 110;
local BSP_ShowMenu = 111;
local BSP_LoadSwSub = 112;
local BSP_CycleSubR = 113;
local BSP_SubNextFnt = 114;
local BSP_SubPrevFnt = 115;
local BSP_AspCycR = 116;
local BSP_DVDTitle = 117;
local BSP_DVDChapter = 118;
local BSP_DVDSub = 119;
local BSP_DVDLang = 120;
local BSP_Res8 = 121;
local BSP_Res9 = 122;

--@help Launch BSPlayer application
actions.launch = function()
	task.start("%programfiles(x86)%/Webteh/BSPlayer/bsplayer.exe");
end

--@help Send raw command to BSPlayer
--@param cmd:number
actions.command = function(cmd)
	local hwnd = task.find("BSPlayer", "BSPlayer");
	task.send(hwnd, WM_BSP_CMD, cmd, 0);
end

--@help Zoom in
actions.zoom_in = function()
	actions.command(BSP_ZoomIn);
end

--@help Zoom out
actions.zoom_out = function()
	actions.command(BSP_ZoomOut);
end

--@help Normal zoom
actions.zoom_normal = function()
	actions.command(BSP_Zoom100);
end

--@help Toggle playback state
actions.play_pause = function()
	actions.command(BSP_Pause);
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.command(BSP_FS_Switch);
end

--@help Raise volume
actions.volume_up = function()
	actions.command(BSP_VolUp);
end

--@help Lower volume
actions.volume_down = function()
	actions.command(BSP_VolDown);
end

--@help Navigate left
actions.left = function()
	actions.command(BSP_MoveLeft);
end

--@help Navigate right
actions.right = function()
	actions.command(BSP_MoveRight);
end

--@help Navigate up
actions.up = function()
	actions.command(BSP_MoveUp);
end

--@help Navigate down
actions.down = function()
	actions.command(BSP_MoveDown);
end

--@help Previous track
actions.previous = function()
	actions.command(BSP_Prev);
end

--@help Next track
actions.next = function()
	actions.command(BSP_Next);
end

--@help Stop playback
actions.stop = function()
	actions.command(BSP_Stop);
end

--@help Fast rewind
actions.fast_rewind = function()
	actions.command(BSP_FastRew);
end

--@help Rewind
actions.rewind = function()
	actions.command(BSP_Rew);
end

--@help Forward
actions.forward = function()
	actions.command(BSP_Forw);
end

--@help Fast forward
actions.fast_forward = function()
	actions.command(BSP_FastForw);
end

--@help Show DVD subtitles
actions.dvd_sub = function()
	actions.command(BSP_DVDSub);
end

--@help Show DVD title
actions.dvd_title = function()
	actions.command(BSP_DVDTitle);
end

--@help Show DVD languages
actions.dvd_lang = function()
	actions.command(BSP_DVDLang);
end

--@help Previous DVD chapter
actions.dvd_previous_chapter = function()
	actions.command(BSP_PrevCh);
end

--@help Show DVD chapters
actions.dvd_chapter = function()
	actions.command(BSP_DVDChapter);
end

--@help Next DVD chapter
actions.dvd_next_chapter = function()
	actions.command(BSP_NextCh);
end
