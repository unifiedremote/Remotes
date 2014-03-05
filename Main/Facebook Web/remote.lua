
local win = libs.win;
local keyboard = libs.keyboard;
local tab_index = 0;

--@help Focus Facebook application
actions.switch = function()
	--if (OS_WINDOWS) then
		if (tab_index == 0) then
			local hwnd = win.window("firefox.exe");
			if (hwnd == 0) then
				actions.launch();
			end
			win.switchtowait(hwnd);
		elseif (tab_index == 1) then
			local hwnd = win.window("chrome.exe");
			if (hwnd == 0) then
				actions.launch();				
			end
			win.switchtowait(hwnd);
		elseif (tab_index == 2) then
			local hwnd = win.window("opera.exe");
			if (hwnd == 0) then
				actions.launch();
			end
			win.switchtowait(hwnd);
		elseif (tab_index == 3) then
			local hwnd = win.window("safari.exe");
			if (hwnd == 0) then
				actions.launch();
			end
			win.switchtowait(hwnd);
		end		
	--end
end

actions.tab_index = function(i)	
	tab_index = i;	
end

--@help Launch Browser application
actions.launch = function()
	os.open("http://www.facebook.com/");
end

--@help Next post
actions.Next_Post = function()
	actions.switch();
	keyboard.stroke("j");	
end

--@help Previous post
actions.Prev_Post = function()
	actions.switch();
	keyboard.stroke("k");
end

--@help Like post
actions.Like_Post = function()
	actions.switch();
	keyboard.stroke("l");
end

--@help New_Message
actions.New_Message = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","m");
	else
		keyboard.stroke("menu","m");
	end	
end

actions.Home_Page = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","1");
	else
		keyboard.stroke("menu","1");
	end
end

actions.Profile_Page = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","2");
	else
		keyboard.stroke("menu","shift","2");
	end
end

actions.Friend_Request = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","3");
	else
		keyboard.stroke("menu","3");
	end
end

actions.Messages = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","4");
	else
		keyboard.stroke("menu","4");
	end
end

actions.Note_Center = function()
	actions.switch();
	if (tab_index == 0) then
		keyboard.stroke("menu","shift","5");
	else
		keyboard.stroke("menu","5");
	end
end

actions.nav_escape = function ()
	keyboard.press("escape");
end

actions.nav_up = function ()
	keyboard.press("up");
end

actions.nav_back = function ()
	keyboard.press("back");
end

actions.nav_left = function ()
	keyboard.press("left");
end

actions.nav_enter = function ()
	keyboard.press("enter");
end

actions.nav_right = function ()
	keyboard.press("right");
end

actions.nav_tab = function ()
	keyboard.press("tab");
end

actions.nav_down = function ()
	keyboard.press("down");
end

actions.nav_menu = function ()
	keyboard.press("menu");
end
