local keyboard = libs.keyboard;

function down(i)
	for i = 1, i do
		keyboard.press("volumedown");
	end
end

function up(i)
	for i = 1, i do
		keyboard.press("volumeup");
	end
end

function zero()
	if OS_WINDOWS then
		down(50);
	else
		down(16);
	end
end

function set(x)
	zero();
	if OS_WINDOWS then
		up(math.floor(x / 2));
	else
		up(math.floor(x / 16));
	end
end

--@help Set volume level
--@param vol:number Volume (0-100) percent.
actions.volume_set = function (vol)
	set(vol);
end

--@help Set volume to 0%
actions.volume_0 = function ()
	set(0);
end

--@help Set volume to 10%
actions.volume_10 = function ()
	set(10);
end

--@help Set volume to 20%
actions.volume_20 = function ()
	set(20);
end

--@help Set volume to 30%
actions.volume_30 = function ()
	set(30);
end

--@help Set volume to 40%
actions.volume_40 = function ()
	set(40);
end

--@help Set volume to 50%
actions.volume_50 = function ()
	set(50);
end

--@help Set volume to 60%
actions.volume_60 = function ()
	set(60);
end

--@help Set volume to 70%
actions.volume_70 = function ()
	set(70);
end

--@help Set volume to 80%
actions.volume_80 = function ()
	set(80);
end

--@help Set volume to 90%
actions.volume_90 = function ()
	set(90);
end

--@help Set volume to 100%
actions.volume_100 = function ()
	set(100);
end

--@help Raise volume
actions.volume_up = function ()
	up(1);
end

--@help Lower volume
actions.volume_down = function ()
	down(1);
end