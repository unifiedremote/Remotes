local d = libs.data;
local http = libs.http;
local utf8 = libs.utf8;
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