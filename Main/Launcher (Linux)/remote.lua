local fs = require("fs");
local server = require("server");
local list;
local items;

events.focus = function ()
	items = {};
    list = {};

    -- User applications
    local listUser = fs.files("~/.local/share/applications/");
	for i = 1, #listUser do
        if fs.extension(listUser[i]) == "desktop" then
            table.insert(list, listUser[i]);

		    table.insert(items, { 
			    type = "item", 
			    text = readablename(listUser[i]),
			    icon = "folder"
		    });
        end
	end

    -- System applications
	local listSystem = fs.files("/usr/share/applications/");
	for i = 1, #listSystem do
        if fs.extension(listSystem[i]) == "desktop" then
            table.insert(list, listSystem[i]);

		    table.insert(items, { 
			    type = "item", 
			    text = readablename(listSystem[i]),
			    icon = "folder"
		    });
        end
	end
	server.update({ id = "list", children = items });
end

actions.tap = function (index)
	local item = list[index+1];

    local file = io.input(item);
    for line in io.lines() do
        if string.sub(line,1,5) == "Exec=" then --find the executable
            j = string.find(line,"%%"); --find any command line input
            if j ~= nil then
                os.execute(string.sub(line,6,j-1));
            else
                os.execute(string.sub(line,6));
            end
            break
        end
    end
    io.close(file);
end

-- Provides a human readable name for the list under Launcher
function readablename(name)
    local file = io.input(name);
    
    for line in io.lines() do
        if string.sub(line,1,5) == "Name=" then
            outname = string.sub(line,6);
            break
        end
    end
    io.close(file);

    return outname
end
