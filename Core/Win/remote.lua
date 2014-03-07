local t = libs.win;

--@help Kill a task or process
actions.kill = function (task)
	t.kill(task);
end

--@help Close a task or process
actions.close = function (task)
	t.close(task);
end

--@help Quit a task or process
actions.quit = function (task)
	t.quit(task);
end

--@help Switch focus to a task or process
actions.switchto = function (task)
	t.switchto(task);
end

--@help Switch and wait for focus to a task or process
actions.switchtowait = function (task)
	t.switchto(task);
end

--@help Post message to a window
actions.post = function (hwnd, msg, wparam, lparam)
	t.post(hwnd, msg, wparam, lparam);
end

--@help Send message to a window
actions.send = function (hwnd, msg, wparam, lparam)
	t.send(hwnd, msg, wparam, lparam);
end