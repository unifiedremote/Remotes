local http = libs.http;
local timer = libs.timer;
local data = libs.data;
local utf8 = libs.utf8;
local server = require("server");

local tids, tidl;
local update_status;
local update_log;
local command;

local ur = function (path)
	return http.get('http://localhost:9510/' .. path);
end

actions.restart = function ()
	ur('system/restart');
end

actions.reload = function ()
	ur('system/reload');
end

actions.open = function ()
	os.open('http://localhost:9510/web');
end

events.focus = function ()
	timer.timeout(update_status, 100);
	tids = timer.interval(update_status, 2000);
	tidl = timer.interval(update_log, 700);
end

events.blur = function ()
	timer.cancel(tids);
	timer.cancel(tidl);
end

update_status = function() 
	local status = data.fromjson(ur('system/status'));
	local m = "";

	m = m .. status['machine'] .. " (" .. status['os'] .. ')\n';
	m = m .. "UR Verison: " .. status['version'] .. " (" .. status['version-code'] .. ')\n';
	m = m .. "Running since " .. status['started'] .. '\n';

	layout.misc.text = utf8.trim(m);

	local i = "Discovery: ";
	if status['interfaces']['ad']['status'] then
		i = i .. status['interfaces']['ad']['status'] .. '\n';
	else
		i = i .. status['interfaces']['ad']['error'] .. '\n';
	end
	
	i = i .. "Bluetooth: ";
	if status['interfaces']['bt']['status'] then
		i = i .. status['interfaces']['bt']['status'] .. '\n';
	else
		i = i .. status['interfaces']['bt']['error'] .. '\n';
	end

	i = i .. "Wireless: ";
	if status['interfaces']['wifi']['status'] then
		i = i .. status['interfaces']['wifi']['status'] .. '\n';
	else
		i = i .. status['interfaces']['wifi']['error'] .. '\n';
	end
	layout.intf.text = utf8.trim(i);


	local n = "LAN: ";
	if status['network']['lan']['available'] then
		n = n ..  status['network']['lan']['address'] .. '\n';
	else
		n = n .. "(unavailable)" .. '\n';
	end
	
	n = n .."WAN: ";
	if status['network']['wan']['available'] then
		n = n .. status['network']['wan']['address'] .. '\n';
	else
		n = n .. "(unavailable)" .. '\n';
	end

	layout.network.text = utf8.trim(n);

end

update_log = function ()
	local log = data.fromjson(ur('system/log/6/6'));
	local data = log['data'];
	local lines = {};

	for i = 1, #data do
  		local line = {" ------ "};
		local split = utf8.split(data[i], " ");

		for ii = 1, #split do
			if ii <= 3 and ii ~= 3 then
				table.insert(line, split[ii])
			end
			if ii == 3 then
				table.insert(line, split[ii] .. " ------\n")
			end
			if ii >= 4 then
				table.insert(line, split[ii]);
			end
		end
		table.insert(lines, utf8.join(" ", line));
	end

	layout.log.text = utf8.join("\n", lines);
end

actions.edit = function (c)
	command = c;
end

actions.execute = function ()
	local c = utf8.trim(command);
	if c then
		layout.command.text = "...sending...";
		ur("system/remote/run/" .. c);
		layout.command.text = "...sending...success!";
	else
		layout.comment.text = "...invalid...";
	end

	timer.timeout(function()
		layout.command.text = c;
	end, 1000);
end