local obj = nil;
local tid_update = -1;
local tid_timer = -1;
local timer = libs.timer;
local server = libs.server;
local utf8 = libs.utf8;
local fs = libs.fs;
local timer_total = 0;
local timer_slide = 0;
local timer_state = 0;
local ready = false;

events.create = function ()
	file_curr = fs.temp();
	file_next = fs.temp();
	file_prev = fs.temp();
end

events.destroy = function ()
	fs.delete(file_curr);
	fs.delete(file_next);
	fs.delete(file_prev);
end

events.focus = function ()
	obj = luacom.CreateObject("PowerPoint.Application");
	update();
	tid_update = timer.interval(update, 1000);
	ready = false;
end

events.blur = function ()
	timer.cancel(tid_update);
	obj = nil;
	collectgarbage();
end

function getTitle(slide)
	local title = "";
	title = title .. slide.SlideNumber .. ". ";
	if (slide.Shapes.HasTitle == -1 and slide.Shapes.Title.HasTextFrame == -1) then
		title = title .. slide.Shapes.Title.TextFrame.TextRange.Text;
	end
	if (title == "") then
		title = "Untitled";
	end
	return title;
end

function getNotes(slide)
	local notes = "";
	local count = slide.NotesPage.Shapes.Count;
	for i = 1, count do
		local shape = slide.NotesPage.Shapes(i);
		if (shape.HasTextFrame == -1) then
			if (shape.TextFrame.HasText == -1) then
				if (utf8.contains(shape.Name, "Notes Placeholder")) then
					notes = notes .. utf8.replace(shape.TextFrame.TextRange.Text, "\r", "\n");
				end
			end
		end
	end
	return notes;
end

function getTime(prefix, seconds)
	local _min = math.floor(seconds / 60);
	if (_min < 10) then _min = "0" .. _min; end
	local _sec = seconds - (_min * 60);
	if (_sec < 10) then _sec = "0" .. _sec; end
	return prefix .. ": " .. _min .. ":" .. _sec;
end

function update_timer()
	local index = obj.ActivePresentation.SlideShowWindow.View.CurrentShowPosition;
	if (index ~= timer_state) then
		timer_state = index;
		timer_slide = 0;
	end
	timer_total = timer_total + 1;
	timer_slide = timer_slide + 1;
end

function valid()
	return (obj ~= nil and 
		obj.Presentations.Count > 0 and 
		obj.SlideShowWindows.Count > 0);
end

function update ()
	local title = "";
	local notes = "";
	local preview_curr = "";
	local preview_prev = "";
	local preview_next = "";
	local time_total = "";
	local time_slide = "";
	local items = {};
			
	time_total = getTime("Total", timer_total);
	time_slide = getTime("Slide", timer_slide);
	
	if (obj == nil) then
		title = "[No Application]";
		ready = false;
	elseif (obj.Presentations.Count == 0 or obj.SlideShowWindows.Count == 0) then
		title = "[No Presentation]";
		ready = false;
	else
		ready = true;
		
		local index = obj.ActivePresentation.SlideShowWindow.View.CurrentShowPosition;
		local slide = obj.ActivePresentation.Slides(index);
		
		-- Get title
		title = getTitle(slide);
		
		-- Get comments
		notes = getNotes(slide);
		
		-- Get slides list
		local count = obj.ActivePresentation.Slides.Count;
		for i = 1, count do
			local slide = obj.ActivePresentation.Slides(i);
			table.insert(items, { type = "item", text = getTitle(slide) });
		end
		
		-- Get previews
		slide:Export(file_curr, "jpg", 320, 240);
		slide = obj.ActivePresentation.Slides(math.max(1, index - 1));
		slide:Export(file_prev, "jpg", 320, 240);
		slide = obj.ActivePresentation.Slides(math.min(count, index + 1));
		slide:Export(file_next, "jpg", 320, 240);
		
		preview_curr = file_curr;
		preview_prev = file_prev;
		preview_next = file_next;
	end

	server.update(
		{ id = "title", text = title },
		{ id = "comments", text = notes },
		{ id = "slides", children = items },
		{ id = "preview_curr", image = preview_curr },
		{ id = "preview_prev", image = preview_prev },
		{ id = "preview_next", image = preview_next },
		{ id = "time_total", text = time_total },
		{ id = "time_slide", text = time_slide }
	);
end

--@help Start slide show presentation
actions.show_start = function ()
	keyboard.press("f5");
end

--@help End slide show presentation
actions.show_end = function ()
	keyboard.press("escape");
end

--@help Launch PowerPoint application
actions.launch = function ()
	os.start("powerpnt");
end

--@help Go to next slide
actions.next = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View:Next();
		update();
	end
end

--@help Go to previous slide
actions.previous = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View:Previous();
		update();
	end
end

--@help Go to first slide
actions.first = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View:First();
		update();
	end
end

--@help Go to last slide
actions.last = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View:Last();
		update();
	end
end

--@help Go to slide
--@param n:number Slide to go to
actions.goto = function (n)
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View:GotoSlide(n, 0);
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

--@help Set black screen
actions.black = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View.State = 3; -- 3=black
	end
end

--@help Set white screen
actions.white = function ()
	if (valid()) then
		obj.ActivePresentation.SlideShowWindow.View.State = 4; -- 4=white
	end
end
