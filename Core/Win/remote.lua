local t = libs.win;

--@help Kill a task or process
--@param process The ID or name of a specific process to kill
actions.kill = function (task)
	t.kill(task);
end

--@help Close a task or process
--@param process The ID or name of a specific process to close
actions.close = function (task)
	t.close(task);
end

--@help Quit a task or process
--@param process The ID or name of a specific process to quit
actions.quit = function (task)
	t.quit(task);
end

--@help Switch focus to a task or process
--@param process The ID or name of a specific process to switch to
actions.switchto = function (task)
	t.switchto(task);
end

--@help Switch and wait for focus to a task or process
--@param process The ID or name of a specific process to switch to and wait
actions.switchtowait = function (task)
	t.switchto(task);
end

--@help Post message to a window
--@param hwnd:string Windows handle
--@param msg:number Message to process
--@param wparam:number The wparam
--@param lparam:number The lparam
actions.post = function (hwnd, msg, wparam, lparam)
	t.post(hwnd, msg, wparam, lparam);
end

--@help Send message to a window
--@param hwnd:string Windows handle
--@param msg:number Message to process
--@param wparam:number The wparam
--@param lparam:number The lparam
actions.send = function (hwnd, msg, wparam, lparam)
	t.send(hwnd, msg, wparam, lparam);
end