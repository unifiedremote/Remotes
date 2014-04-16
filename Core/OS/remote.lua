
--@help Sleep for given time
--@param time:number Number of milliseconds
actions.sleep = function (time)
	os.sleep(time);
end

--@help Start a task or process
--@param command The task or process name
actions.start = function (command)
	os.start(command);
end

--@help Open a task, process, file
--@param path The task/process/file path
actions.open = function (path)
	os.open(path);
end

--@help Open all files in path
--@param path The parent directory path
actions.open_all = function (path)
	os.openall(path);
end

--@help Execute script line(s)
actions.script = function (...)
	os.script(unpack({...}));
end

--@help Execute a system command
--@param command A valid system command
actions.execute = function (command)
	os.execute(command)
end