local device = libs.device;
local server = libs.server;
local utf8 = libs.utf8;
local items = {};
local account;
local user;

function update ()
	items = {};
	
	local obj = luacom.CreateObject("Skype4COM.Skype");
	if (not obj.Client.IsRunning) then
		obj.Client:Start();
	end
	
	obj:Attach(7, false);
	local count = obj.Friends.Count;
	for i = 1, count do
		local friend = obj.Friends(i);
		local status = friend.OnlineStatus;
		if (status > 0) then
			local name = friend.FullName;
			local handle = friend.Handle;
			if (name == "") then
				name = handle;
			end
			table.insert(items, { type = "item", text = name, handle = handle });
		end
	end
	table.sort(items, function (a,b)
		return utf8.tolower(a.text) < utf8.tolower(b.text);
	end);
	server.update({ id = "list", children = items });
end

events.focus = function ()
	update();
end

events.blur = function ()
	obj = nil;
	collectgarbage();
end

actions.select = function (i)
	user = items[i+1].handle;
	server.update({
		type = "dialog",
		ontap = "pick",
		title = user,
		children = {
			{ type = "item", text = "Audio" },
			{ type = "item", text = "Video" },
			{ type = "item", text = "Chat" }
		}
	});
end

actions.pick = function (i)
	local uris = {
		"skype:" .. user .. "?call",
		"skype:" .. user .. "?call&video=true",
		"skype:" .. user .. "?chat",
	};
	device.toast(uris[i+1]);
	os.open(uris[i+1]);
end

--@help Open Skype
actions.launch = function ()
	device.toast("Opening...");
	os.start("%programfiles(x86)%/Skype/Phone/Skype.exe");
end

--@help Start audio call with a contact
--@param user Username of contact
actions.audio = function (user) 
	os.open("skype:" .. user .. "?call");
end

--@help Start video call with a contact
--@param user Username of contact
actions.video = function (user) 
	os.open("skype:" .. user .. "?call&video=true");
end

--@help Start chat with a contact
--@param user Username of contact
actions.chat = function (user) 
	os.open("skype:" .. user .. "?chat");
end




--------------------------------------------------------
-- OLD CODE BELOW HERE FOR XML READING INSTEAD OF COM --
--------------------------------------------------------

-- local fs = libs.fs;
-- local data = libs.data;

-- function getChildByName(node, name)
	-- for i,v in ipairs(node.children) do
		-- if (v.name == name) then
			-- return v;
		-- end
	-- end
	-- return nil;
-- end

-- function update()
	-- local xml, shared, node, config;
	
	-- -- parse shared config to find default account
	-- xml = fs.read("%appdata%/Skype/shared.xml");
	-- shared = data.fromxml(xml);
	-- node = shared.children[1]; -- config/Lib
	-- node = getChildByName(node, "Account");
	-- node = getChildByName(node, "Default");
	-- account = node.text;

	-- -- parse config for default account to get contacts
	-- xml = fs.read("%appdata%/Skype/" .. account .. "/config.xml");
	-- config = data.fromxml(xml);
	-- node = config.children[1]; -- config/Lib
	-- node = getChildByName(node, "CentralStorage"); -- config/Lib/CentralStorage
	-- node = getChildByName(node, "SyncSet"); -- config/Lib/CentralStorage/SyncSet
	-- node = getChildByName(node, "u"); -- config/Lib/CentralStorage/SyncSet/u
	
	-- -- update contacts list
	-- for i,v in ipairs(node.children) do
		-- 
	-- end
	-- server.update({ id = "list", children = items });
-- end
