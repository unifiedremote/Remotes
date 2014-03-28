local fs = libs.fs;

--@help Copy file or folder
--@param a Path to source
--@param b Path to destination
actions.copy = function (a,b)
	fs.copy(a,b);
end

--@help Rename file or folder
--@param a Path to source
--@param b New name
actions.rename = function (a,b)
	fs.rename(a,b);
end

--@help Move file or folder
--@param a Path to source
--@param b Path to destination
actions.move = function (a,b)
	fs.move(a,b);
end

--@help Delete file or folder
--@param path Path to source
--@param recursive:boolean Delete sub files and folders
actions.delete = function (path, recursive)
	fs.delete(path, recursive)
end

--@help Write to file
--@param path Path to destination
--@param contents File contents
actions.write = function (path, contents)
	fs.write(path, contents);
end

--@help Create folder
--@param path Path to destination
actions.createdir = function (path)
	fs.createdir(path);
end

--@help Create all folders
--@param path Path to destination
actions.createdirs = function (path)
	fs.createdirs(path);
end

--@help Create file
--@param path Path to destination
actions.createfile = function (path)
	fs.createfile(path);
end
