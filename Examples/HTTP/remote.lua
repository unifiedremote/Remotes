-- https://github.com/unifiedremote/Docs/blob/master/libs/http.md
local http = libs.http;

--@help Command 1
actions.something = function ()
	http.get("http://foobar.com/command", function (err, resp) 
		print(err);
		print(resp);
	end);
end