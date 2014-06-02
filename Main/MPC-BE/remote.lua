local win = libs.win;
local tid = -1;

events.focus = function ()
	tid = libs.timer.interval(update, 1000);
end

events.blur = function ()
	libs.timer.cancel(tid);
end

function update ()
	local hwnd = win.find("MPC-BE", nil);
	local title = win.title(hwnd);
	if title == "" then
		title = "[Not Running]";
	elseif title == "Media Player Classic Black Edition" then
		title = "[Not Playing]";
	end
	layout.info.text = title;
end

--@help Launch MPCBE application
actions.launch = function()
	os.start("mpc-be.exe");
	os.start("mpc-be64.exe");
end

--@help Run command
--@param code:number MPCBE command to run
actions.command = function (code)
	local hwnd = win.find("MPC-BE", nil);
	win.send(hwnd, 0x0111, code, 0);
end
--@help Fullscreen
actions.fullscreen = function ()
	actions.command(830);
end
--@help Move up
actions.up = function ()
	actions.command(931);
end

--@help Move down
actions.down = function ()
	actions.command(932);
end

--@help Move left
actions.left = function ()
	actions.command(929);
end

--@help Move right
actions.right = function ()
	actions.command(930);
end

--@help Move back
actions.back = function ()
	actions.command(934);
end

--@help Select
actions.select = function ()
	actions.command(933);
end

--@help Play Pause track
actions.play_pause = function ()
	actions.command(889);
end

--@help Pause track
actions.pause = function ()
	actions.command(888);
end

--@help Play track
actions.play = function ()
	actions.command(887);
end

--@help Stop track
actions.stop = function ()
	actions.command(890);
end

--@help Forward track
actions.forward = function ()
	actions.command(900);
end

--@help Rewind track
actions.rewind = function ()
	actions.command(899);
end

--@help Next track
actions.next = function ()
	actions.command(920);
end

--@help Prevous track
actions.previous = function ()
	actions.command(919);
end

--@help Go to Home
actions.home = function ()
	actions.command(924);
end

--@help Open title
actions.title = function ()
	actions.command(923);
end

--@help Open chapters
actions.chapters = function ()
	actions.command(928);
end

--@help Volume up
actions.volume_up = function ()
	actions.command(907);
end

--@help Volume down
actions.volume_down = function ()
	actions.command(908);
end

--@help Mute Volume
actions.volume_mute = function ()
	actions.command(909);
end

-- Command Codes:
-- 969 Quick Open File
-- 800 Open File
-- 801 Open DVD
-- 802 Open Device
-- 976 Reopen File
-- 805 Save As
-- 806 Save Image
-- 807 Save Image (auto)
-- 808 Save thumbnails
-- 809 Load Ext Subtitle...
-- 810 Save Subtitle
-- 804 Close
-- 814 Properties
-- 816 Exit
-- 889 Play/Pause
-- 887 Play
-- 888 Pause
-- 890 Stop
-- 1001 Menu Subtitle Language
-- 1000 Menu Audio Language
-- 1002 Menu Jump To...
-- 891 Framestep
-- 892 Framestep back
-- 893 Go To
-- 895 Increase Rate
-- 894 Decrease Rate
-- 896 Reset Rate
-- 905 Audio Delay +10ms
-- 906 Audio Delay -10ms
-- 900 Jump Forward (small)
-- 899 Jump Backward (small)
-- 902 Jump Forward (medium)
-- 901 Jump Backward (medium)
-- 904 Jump Forward (large)
-- 903 Jump Backward (large)
-- 898 Jump Forward (keyframe)
-- 897 Jump Backward (keyframe)
-- 922 Next
-- 921 Previous
-- 920 Next File
-- 919 Previous File
-- 974 Tuner scan
-- 975 Quick add favorite
-- 817 Toggle Caption&Menu
-- 818 Toggle Seeker
-- 819 Toggle Controls
-- 820 Toggle Information
-- 821 Toggle Statistics
-- 822 Toggle Status
-- 823 Toggle Subresync Bar
-- 824 Toggle Playlist Bar
-- 825 Toggle Capture Bar
-- 826 Toggle Shader Editor Bar
-- 827 View Minimal
-- 828 View Compact
-- 829 View Normal
-- 830 Fullscreen
-- 831 Fullscreen (w/o res.change)
-- 832 Zoom 50`%
-- 833 Zoom 100`%
-- 834 Zoom 200`%
-- 968 Zoom Auto Fit
-- 859 Next AR Preset
-- 835 VidFrm Half
-- 836 VidFrm Normal
-- 837 VidFrm Double
-- 838 VidFrm Stretch
-- 839 VidFrm Inside
-- 841 VidFrm Zoom 1
-- 842 VidFrm Zoom 2
-- 840 VidFrm Outside
-- 843 VidFrm Switch Zoom
-- 884 Always On Top
-- 861 PnS Reset
-- 862 PnS Inc Size
-- 864 PnS Inc Width
-- 866 PnS Inc Height
-- 863 PnS Dec Size
-- 865 PnS Dec Width
-- 867 PnS Dec Height
-- 876 PnS Center
-- 868 PnS Left
-- 869 PnS Right
-- 870 PnS Up
-- 871 PnS Down
-- 872 PnS Up/Left
-- 873 PnS Up/Right
-- 874 PnS Down/Left
-- 875 PnS Down/Right
-- 877 PnS Rotate X+
-- 878 PnS Rotate X-
-- 879 PnS Rotate Y+
-- 880 PnS Rotate Y-
-- 881 PnS Rotate Z+
-- 882 PnS Rotate Z-
-- 907 Volume Up
-- 908 Volume Down
-- 909 Volume Mute
-- 970 Volume boost increase
-- 971 Volume boost decrease
-- 972 Volume boost Min
-- 973 Volume boost Max
-- 993 Toggle custom channel mapping
-- 994 Toggle normalization
-- 995 Toggle regain volume
-- 984 Brightness increase
-- 985 Brightness decrease
-- 986 Contrast increase
-- 987 Contrast decrease
-- 990 Saturation increase
-- 991 Saturation decrease
-- 992 Reset color settings
-- 923 DVD Title Menu
-- 924 DVD Root Menu
-- 925 DVD Subtitle Menu
-- 926 DVD Audio Menu
-- 927 DVD Angle Menu
-- 928 DVD Chapter Menu
-- 929 DVD Menu Left
-- 930 DVD Menu Right
-- 931 DVD Menu Up
-- 932 DVD Menu Down
-- 933 DVD Menu Activate
-- 934 DVD Menu Back
-- 935 DVD Menu Leave
-- 944 Boss key
-- 949 Player Menu (short)
-- 950 Player Menu (long)
-- 951 Filters Menu
-- 815 Options
-- 952 Next Audio
-- 953 Prev Audio
-- 954 Next Subtitle
-- 955 Prev Subtitle
-- 956 On/Off Subtitle
-- 2303 Reload Subtitles
-- 996 Subtitle shift positions up
-- 997 Subtitle shift positions down
-- 998 Subtitle shift positions left
-- 999 Subtitle shift positions right
-- 812 Download subtitles
-- 957 Next Audio (OGM)
-- 958 Prev Audio (OGM)
-- 959 Next Subtitle (OGM)
-- 960 Prev Subtitle (OGM)
-- 961 Next Angle (DVD)
-- 962 Prev Angle (DVD)
-- 963 Next Audio (DVD)
-- 964 Prev Audio (DVD)
-- 965 Next Subtitle (DVD)
-- 966 Prev Subtitle (DVD)
-- 967 On/Off Subtitle (DVD)
-- 1041 Tearing Test
-- 1043 OSD: Remaining Time
-- 1036 OSD: Local Time
-- 1037 OSD: File Name
-- 1021 Toggle Pixel Shaders
-- 1022 Toggle Screen Space Pixel Shaders
-- 1023 Toggle Direct3D fullscreen
-- 1014 Goto Prev Subtitle
-- 1015 Goto Next Subtitle
-- 1012 Shift Subtitle Left
-- 1013 Shift Subtitle Right
-- 1042 Display Stats
-- 1040 EVR Sync reset stats
-- 1066 VSync
-- 1053 Enable Frame Time Correction
-- 1067 Accurate VSync
-- 1070 Decrease VSync Offset
-- 1071 Increase VSync Offset
-- 1010 Subtitle Delay -
-- 1011 Subtitle Delay +
-- 912 After Playback: Exit
-- 913 After Playback: Stand By
-- 914 After Playback: Hibernate
-- 915 After Playback: Shutdown
-- 916 After Playback: Log Off
-- 917 After Playback: Lock
-- 1077 After Playback: Always exit
-- 918 After Playback: Do Nothing
-- 1078 After Playback: Play next in the folder
-- 846 Toggle EDL window
-- 847 EDL set In
-- 848 EDL set Out
-- 849 EDL new clip
-- 860 EDL save
-- 1038 Move Window to PrimaryScreen