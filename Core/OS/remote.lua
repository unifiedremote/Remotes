
--@help Sleep for given time (ms)
actions.sleep = function (time)
	os.sleep(time);
end

--@help Start a task or process
actions.start = function (command)
	os.start(command);
end

--@help Open a task, process, file
actions.open = function (path)
	os.open(path);
end

actions.open_all = function (path)
	os.openall(path);
end

--@help Execute script line(s)
actions.script = function (...)
	os.script(unpack({...}));
end