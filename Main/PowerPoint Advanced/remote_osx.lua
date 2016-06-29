local fs = libs.fs;
local str = libs.utf8;
local tid_update = -1;
local tid_timer = -1;
local timer = libs.timer;
local server = libs.server;
local utf8 = libs.utf8;
local fs = libs.fs;
local timer_total = 0;
local timer_slide = 0;
local timer_state = 0;
local slidePaths = {};
local noPresentation = true;

events.detect = function ()
	return libs.fs.exists("/Applications/Microsoft Office 2011/Microsoft PowerPoint.app") or libs.fs.exists("/Applications/Microsoft PowerPoint.app");
end

events.create = function ()
end

events.destroy = function ()

end

events.focus = function ()
	noPresentation = true;
	update();
	tid_update = timer.interval(update, 1000);	
end

events.blur = function ()
	timer.cancel(tid_update);
end
function createSlides( )
	if(valid()) then
		local p = os.script("set target_folder to ((path to temporary items from user domain as text) & \"Powerpoint\")");
		if fs.exists(p) then
			fs.delete(p, true);
		end
		local path = os.script("set target_folder to ((path to temporary items from user domain as text) & \"Powerpoint\")",
								"tell application \"Microsoft PowerPoint\"",
									"save of active presentation in target_folder as save as JPG",
								"end tell",
								"set out to POSIX path of ((path to temporary items from user domain as text) & \"Powerpoint\")");
		return fs.list(path);
	end
	return "";
end
function shrinkSlide( path )
	if (path == nil) then 
		return nil;
	end
	if fs.exists(path .. ".r") then
		return path .. ".r";
	end
	os.script("set this_file to \""..path.."\"",
				"set the target_length to 320",
				"tell application \"Image Events\"",
					"launch",
					"set this_image to open this_file",
					"scale this_image to size target_length",
					"save this_image with icon",
					"close this_image",
				"end tell");
	fs.rename(path, path..".r");
end
function getTitleForAllSlide()
	if(valid()) then
		local titlesString = os.script("tell application \"Microsoft PowerPoint\"",
			"set n to count slides of active presentation",
			"set i to 1",
			"set o to \"\"",
			"repeat n times",
				"set o to o & content of text range of text frame of shape 1 of slide i in active presentation & \",\" ", 
				"set i to i + 1",
			"end repeat",
			"return o",
		"end tell");
		titlesString = str.sub(titlesString, 0, str.len(titlesString) -1);
		local titles = str.split(titlesString,",");
		for i = 1, #titles-1 do
			if (titles[i] == nil or titles[i] == "" or titles[i] == "missing value") then
				titles[i] = "(no name)";
			end
			titles[i] = i .. ": " .. titles[i];
		end
		return titles;
	end
	return {};
end

function valid( )
	local isValid = true;
	if (not is_powerpoint_running()) then
		isValid = false;
	end
	if isValid then
		if(not is_presentation_running()) then
			isValid = false;
		end
	end
	return isValid;
end

function getTitle()
	if(valid()) then
		local title = os.script("tell application \"Microsoft PowerPoint\"",
									"try",
										"set myindex to (current show position of slide show view of slide show window of active presentation)",
										"set the next_title to content of text range of text frame of shape 1 of slide myindex of active presentation",
										"set fullData to next_title",
									"end try",
								"end tell");
		
		if (title == nil or title == "" or title == "missing value") then
			title = "(no name)";
		end
		return title;
	end
	return "";
end

function getNotes()
	if(valid()) then
		return os.script("tell application \"Microsoft PowerPoint\"",
					"set a to slide show view of slide show window of active presentation",
					"set b to slide of a",
					"set tNote to \"\"",
					"repeat with t_shape in (get shapes of notes page of b)",
						"tell t_shape to if has text frame then tell its text frame to if has text then",
							"set tNote to content of its text range",
							"exit repeat",
						"end if",
					"end repeat",
					"set o to tNote",
					"end tell");
	end
	return "";
end

function getTime(prefix, seconds)
	local _min = math.floor(seconds / 60);
	if (_min < 10) then _min = "0" .. _min; end
	local _sec = seconds - (_min * 60);
	if (_sec < 10) then _sec = "0" .. _sec; end
	return prefix .. ": " .. _min .. ":" .. _sec;
end

function update_timer()
	local index = get_slideshow_position();
	if (index ~= timer_state) then
		timer_state = index;
		timer_slide = 0;
	end
	timer_total = timer_total + 1;
	timer_slide = timer_slide + 1;
end
function get_slideshow_position()
	if(valid()) then
		return os.script("tell application \"Microsoft PowerPoint\"",
							"set s to slide show view of slide show window of active presentation",
							"if s is not missing value then",
								"set o to current show position of s",
							"else",
								"set o to -1",
							"end if",
						"end tell");
	end
	return -1;
end
function is_powerpoint_running()
	return os.script("tell application \"System Events\" to (name of processes) contains \"Microsoft PowerPoint\"");
end
function is_presentation_running()
	return os.script("tell application \"Microsoft PowerPoint\"",
						"set o to slide show window of active presentation is not missing value",
					"end tell");
end
function get_number_of_slides( )
	if(valid()) then
		return os.script("tell application \"Microsoft PowerPoint\"",
							"set o to count slides of active presentation",
						"end tell");
	end
	return 0;
end

local notes = "";

function update ()
	local _notes = "";
	local title = "";
	local items = {};
	local preview_curr = "";
	local preview_prev = "";
	local preview_next = "";
	local time_total = "";
	local time_slide = "";
	local items = {};
	time_total = getTime("Total", timer_total);
	time_slide = getTime("Slide", timer_slide);
	-- Get title

	if is_powerpoint_running() then
		if is_presentation_running() then
			if noPresentation then		
				-- Get slides list
				local titles = getTitleForAllSlide();
				for i = 1, #titles do
					table.insert(items, { type = "item", text = titles[i]});
				end

				server.update(
					{ id = "slides", children = items }
				);
				
				slidePaths = createSlides();
				noPresentation=false;
			end
			title = getTitle();
			_notes = getNotes();
			if #slidePaths > 0 then
				local index = get_slideshow_position() - 1;
				local count = #slidePaths;
				
				preview_curr = shrinkSlide(slidePaths[index+1]);
				preview_next = shrinkSlide(slidePaths[math.min(count, index+2)]);
				preview_prev = shrinkSlide(slidePaths[math.max(1, index)]);
			end
			
			if (_notes ~= notes) then
				notes = _notes;
				server.update({ id = "comments", text = notes });
			end
			
			server.update(
				{ id = "title", text = title },
				{ id = "preview_curr", image = preview_curr },
				{ id = "preview_prev", image = preview_prev },
				{ id = "preview_next", image = preview_next },
				{ id = "time_total", text = time_total },
				{ id = "time_slide", text = time_slide }	
			);
		else
			title = "[No Presentation Running]"; 
			server.update({ id = "title", text = title });
			noPresentation = true;
		end
	else
		title = "[PowerPoint Not Running]";
		server.update({ id = "title", text = title });
		noPresentation = true;
	end


end

--@help Launch Power Point Advanced application
actions.launch = function ()
	os.script("tell application \"Microsoft PowerPoint\"",
				"activate",
			"end tell");
end

--@help Go to next slide
actions.next = function ()
	if (valid()) then
		os.script("tell application \"Microsoft PowerPoint\"",
						"go to next slide slide show view of slide show window of active presentation",
					"end tell");
		update();
	end
end

--@help Go to previous slide
actions.previous = function ()
	if (valid()) then
		os.script("tell application \"Microsoft PowerPoint\"",
				"go to previous slide slide show view of slide show window of active presentation",
			"end tell");
		update();
	end
end

--@help Go to first slide
actions.first = function ()
	if (valid()) then
		os.script("tell application \"Microsoft PowerPoint\"",
				"go to first slide slide show view of slide show window of active presentation",
			"end tell");
		update();
	end
end

--@help Go to last slide
actions.last = function ()
	if (valid()) then
				os.script("tell application \"Microsoft PowerPoint\"",
				"go to last slide slide show view of slide show window of active presentation",
			"end tell");
		update();
	end
end

--@help Go to slide
--@param n:number Slide to go to
actions.goto = function (n)
	if (valid()) then
		os.script("tell application \"Microsoft PowerPoint\"",
					"activate",
					"tell application \"System Events\"",
						"keystroke \"".. n .. "\"",
					"end tell",
					"tell application \"System Events\" to key code 36", 
				"end tell");

		update();
	end
end

actions.slides_tap = function (n)
	if (valid()) then
		actions.goto(n + 1); 
		update();
	end
end

--@help Start timer
actions.timer_start = function ()
	tid_timer = timer.interval(update_timer, 1000);
	update();
end

--@help Stop timer
actions.timer_stop = function ()
	timer.cancel(tid_timer);
	update();
end

--@help Reset timer
actions.timer_reset = function ()
	timer_total = 0;
	timer_slide = 0; 
	update();
end

--@help Set screen to black
actions.black = function ()
	if (valid()) then
			os.script("tell application \"Microsoft PowerPoint\"",
				"set s to slide state of slide show view of slide show window of active presentation",
				"if s is not slide show state black screen then",
					"set slide state of slide show view of slide show window of active presentation to slide show state black screen",
				"else",
					"activate",
					"tell application \"System Events\" to key code 36",
				"end if",
			"end tell");
	end
end

--@help Set screen to white
actions.white = function ()
	if (valid()) then
			os.script("tell application \"Microsoft PowerPoint\"",
				"set s to slide state of slide show view of slide show window of active presentation",
				"if s is not slide show state white screen then",
					"set slide state of slide show view of slide show window of active presentation to slide show state white screen",
				"else",
					"activate",
					"tell application \"System Events\" to key code 36",
				"end if",
			"end tell");
	end
end
