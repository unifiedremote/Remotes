local server = libs.server;
local devices = {};
local sensors = {};


function send(url)
	local url = url;
	local res = libs.http.request({ method = "get", url = url, connect = "telldus" });
	return res.content;
end


function get_sensors ()
	local data = send("http://api.telldus.com/xml/sensors/list");
	local sensors = {};
	local xml = libs.data.fromxml(data);
	if (xml.name == "sensors") then
		for i,xsensor in ipairs(xml.children) do
			if (xsensor.attributes.ignored == "0" and xsensor.attributes.online == "1" and xsensor.attributes.name ~= "") then
				local sensor = {
					id = xsensor.attributes.id,
					name = xsensor.attributes.name,
					data = {}
				}
				
				data = send("http://api.telldus.com/xml/sensor/info?id=" .. xsensor.attributes.id);
				
				local info = libs.data.fromxml(data);
				if (info.name == "sensor") then
					for j,child in ipairs(info.children) do
						if (child.name == "data") then
							table.insert(sensor.data, {
								name = child.attributes.name,
								value = child.attributes.value,
								scale = child.attributes.scale
							});
						end
					end
				end
				
				--libs.fs.write("info.xml", resp.content);
				table.insert(sensors, sensor);
			end;
		end
	end
	
	--libs.fs.write("sensors.xml", resp.content);
	return sensors;
end


function get_devices ()
	local data = send("http://api.telldus.com/xml/devices/list?supportedMethods=255");
	local devices = {};
	local xml = libs.data.fromxml(data);
	if (xml.name == "devices") then
		for i,xdevice in ipairs(xml.children) do
			if (xdevice.attributes.online == "1" and xdevice.attributes.name ~= "") then
				local device = {
					id = xdevice.attributes.id,
					name = xdevice.attributes.name,
					methods = xdevice.attributes.methods
				}
				table.insert(devices, device);
			end
		end
	end
	
	--libs.fs.write("devices.xml", data);
	return devices;
end


events.preload = function ()
	sensors = get_sensors();
	devices = get_devices();
	
	local devices_rows = {};
	
	table.insert(devices_rows, { type = "row", weight = "wrap",
		{ type = "button", text = "All On", onTap = "all_on", color = "green" },
		{ type = "button", text = "All Off", onTap = "all_off", color = "red" }
	});
			
	for i,device in ipairs(devices) do
		if (device.methods == "19" or device.methods == "51") then
			table.insert(devices_rows, { type = "row", weight = "wrap",
				{ type = "slider", text = device.name, progressmax = 255, ondone = "dim," .. device.id }
			});
		elseif (device.methods == "3" or device.methods == "35") then
			table.insert(devices_rows, { type = "row", weight = "wrap",
				{ type = "label", text = device.name, weight = 20 },
				{ type = "button", text = "On", ontap = "turn_on," .. device.id, color = "green", weight = 10 },
				{ type = "button", text = "Off", ontap = "turn_off," .. device.id, color = "red", weight = 10 }
			});
		end
	end
	
	local sensors_rows = {};
	for i,sensor in ipairs(sensors) do
		table.insert(sensors_rows, { type = "row", weight = "wrap", 
			{ type = "label", text = sensor.name, color = "yellow" }
		});
		
		for j,data in ipairs(sensor.data) do
			table.insert(sensors_rows, { type = "row", weight = "wrap",
				{ type = "label", text = data.name },
				{ type = "label", text = data.value }
			});
		end
	end
	
	local layout = {};
	layout.default = { type = "tabs", children = {
		{ type = "tab", text = "Devices", scroll="vertical", children = devices_rows },
		{ type = "tab", text = "Sensors", scroll="vertical", children = sensors_rows }
	}};
	return layout;
end


--@help Turn all devices on
actions.all_on = function ()
	for i,device in ipairs(devices) do
		send("http://api.telldus.com/xml/device/turnOn?id=" .. device.id);
	end
end


--@help Turn all devices off
actions.all_off = function ()
	for i,device in ipairs(devices) do
		send("http://api.telldus.com/xml/device/turnOff?id=" .. device.id);
	end
end


--@help Turn device on
--@param id:number Device ID
actions.turn_on = function (id)
	send("http://api.telldus.com/xml/device/turnOn?id=" .. id);
end


--@help Turn device off
--@param id:number Device ID
actions.turn_off = function (id)
	send("http://api.telldus.com/xml/device/turnOff?id=" .. id);
end


--@help Dim device by ID
--@param id:number Device ID
--@param dim:number Dim level (0-100)
actions.dim = function (id, dim)
	if (dim == 0) then
		actions.turn_off(id);
	else
		send("http://api.telldus.com/xml/device/dim?id=" .. id .. "&level=" .. dim);
	end
end
