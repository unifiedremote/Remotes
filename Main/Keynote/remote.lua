
--@help Start slide show
actions.show_start = function()
	os.script("tell application \"Keynote\"",
		"tell document 1",
		"start",
		"end tell",
		"end tell");
end

--@help Show slide switcher
actions.go_to = function()
	os.script("tell application \"Keynote\"",
		"tell document 1",
		"show slide switcher",
		"end tell",
		"end tell");
	layout.tabs.index = 1;
end

--@help Cancel slide switcher
actions.switcher_cancel = function()
	os.script("tell application \"Keynote\"",
		"cancel slide switcher",
		"end tell");
	layout.tabs.index = 0;
end

--@help Accept slide switcher
actions.switcher_accept = function()
	os.script("tell application \"Keynote\"",
		"accept slide switcher",
		"end tell");
	layout.tabs.index = 0;
end

--@help Slide switcher forward
actions.switcher_forward = function()
	os.script("tell application \"Keynote\"",
		"move slide switcher forward",
		"end tell");
end

--@help Slide switcher backward
actions.switcher_backward = function()
	os.script("tell application \"Keynote\"",
		"move slide switcher backward",
		"end tell");
end

--@help End slide show
actions.show_end = function()
	os.script("tell application \"Keynote\"",
		"tell document 1",
		"stop",
		"end tell",
		"end tell");
end

--@help Previous slide
actions.previous = function()
	os.script("tell application \"Keynote\"",
		"tell document 1",
		"show previous",
		"end tell",
		"end tell");
end

--@help Next slide
actions.next = function()
	os.script("tell application \"Keynote\"",
		"tell document 1",
		"show next",
		"end tell",
		"end tell");
end

actions.tab_changed = function(index)
	if (index == 1)
	then
		os.script("tell application \"Keynote\"",
		"tell document 1",
		"show slide switcher",
		"end tell",
		"end tell");
	else
		os.script("tell application \"Keynote\"",
		"tell document 1",
		"hide slide switcher",
		"end tell", 
		"end tell");
	end
end

actions.launch = function()
os.script("tell application \"Keynote\"",
	"activate",
	"end tell");
end