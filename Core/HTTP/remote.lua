
local http = libs.http;

--@help Send GET request
--@param url:string Get URL
actions.get = function (url)
	http.get(url);
end

--@help Send POST request
--@param url:string Post to URL
actions.post = function (url)
	http.post(url);
end
