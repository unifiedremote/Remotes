
local s = libs.server;

--@help Load remote with specified ID
actions.load = function (id)
	s.load(id);
end

--@help Run an action in a remote
actions.run = function (remote, name, ...)
	s.run(id, name, unpack({...}));
end

--@help Update a control in a remote
actions.update = function (remote, id, key, value)
	s.update(remote, id, key, value);
end

--@help Unload remote with specified ID
actions.unload = function (id)
	s.unload(remote);
end

--@help Modify a property
actions.set = function (key, value)
	s.set(key, value);
end
