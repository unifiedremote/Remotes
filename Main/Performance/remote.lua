
function b2gb (v)
	return math.round(v / (1024*1024*1024), 0.01) .. " GB";
end

local tid = -1;
local cpumin = 0;
local cpumax = 0;
local cpudata = {};

events.focus = function ()
	tid = libs.timer.interval(actions.update, 1000);
end

events.blur = function ()
	libs.timer.cancel(tid);
end

actions.update = function ()
	local stats = libs.ps.usage();

	cpumin = math.min(cpumin, stats.cpuload);
	cpumax = math.max(cpumax, stats.cpuload);
	
	table.insert(cpudata, stats.cpuload);
	while (#cpudata > 10) do
		table.remove(cpudata, 1);
	end
	
	cpuavg = 0;
	for k,v in ipairs(cpudata) do
		cpuavg = cpuavg + v;
	end
	cpuavg = math.round(cpuavg / #cpudata);
	
	libs.server.update(
		{ id = "mem_used", text = b2gb(stats.memphysused) .. "\nused" },
		{ id = "mem_total", text = b2gb(stats.memphystotal) .. "\ntotal" },
		{ id = "mem_load", text = stats.memload .. "%\nload" },
		{ id = "cpu_avg", text = cpuavg .. "%\navg" },
		{ id = "cpu_max", text = cpumax .. "%\nmax" },
		{ id = "cpu_load", text = stats.cpuload .. "%\nload" }
	);
end