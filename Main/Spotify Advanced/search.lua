local d = libs.data;
local http = libs.http;
local utf8 = libs.utf8;
local server = libs.server;
search = {};
search.search = function ( searchType, q )
    local res = http.get("http://ws.spotify.com/search/1/" .. searchType .. "?q=" .. q);
    local xml = d.fromxml(res);
	local items = {};
	local links = {};
	for i = 1, #xml.children do
		local c = xml.children[i];
		if(utf8.iequals(c.name,searchType)) then
			for j = 1, #c.children do
				if utf8.iequals(c.children[j].name,"name") then
					table.insert(items, { type = "item", text = c.children[j].text});
				end
			end
			table.insert(links, c.attributes["href"]);
		end
	end
	return {items = items, links = links};
end


search.lookup = function ( t, uri )
	local res =  http.get("http://ws.spotify.com/lookup/1/?uri=" .. uri .. "&extras=" .. t);
	print("http://ws.spotify.com/lookup/1/?uri=" .. uri .. "&extras=" .. t);
	local xml = d.fromxml(res);
	local items = {};
	local links = {};
	for i = 1, #xml.children do
		local c = xml.children[i];
		if(utf8.iequals(c.name, t .. "s")) then
			for j = 1, #c.children do
				local a = c.children[j];
				table.insert(links, a.attributes["href"]);
				if(utf8.iequals(a.name,t)) then
					for j = 1, #a.children do
						if utf8.iequals(a.children[j].name,"name") then
							table.insert(items, { type = "item", text = a.children[j].text});
						end
					end
					
				end
				
			end
		end
	end
	return {items = items, links = links};
end

local query = nil;
local tabnumber = 0;
local tracks = {};
local albums = {};
local artists = {};
actions.changeq = function (text)
   	query = text;
end
actions.go = function ( )
	if(query ~= nil) then
		if(tabnumber == 0) then
			artists = search.search("artist", query);
			server.update({ id = "lart", children = artists.items });
		elseif(tabnumber == 1) then
			albums = search.search("album", query);
			server.update({ id = "lalb", children = albums.items });
		elseif(tabnumber == 2) then
			tracks = search.search("track", query);
			server.update({ id = "ltrc", children = tracks.items });
		end
	end
end

actions.trcselect = function ( id )
	id = id+1;
	os.script("tell application \"Spotify\" to play track \"" .. tracks.links[id] .. "\"");
end

actions.artselect = function ( id )
	server.update({id="lists", index = 1});
	local res = search.lookup("album", artists.links[id+1]);
	albums = res;
	server.update({id = "lalb", children = res.items });
end

actions.albselect = function ( id )
	server.update({id="lists", index = 2});
	local res = search.lookup("track", albums.links[id+1]);
	tracks = res;
	server.update({id = "ltrc", children = res.items });
end

actions.changetab = function ( id )
	tabnumber = id;
end