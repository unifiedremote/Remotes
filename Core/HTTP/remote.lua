
local http = libs.http;

--@help Send GET request
actions.get = function (url)
	http.get(url);
end

--@help Send POST request
actions.post = function (url)
	http.post(url);
end
