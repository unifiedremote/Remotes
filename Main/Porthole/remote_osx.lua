-----------------------------------------------------
-- Define your variables here
-----------------------------------------------------

local timer = libs.timer;
local log = libs.log;
local server = libs.server;
local tid = -1;
local tellTo = "tell application \"Porthole\" to ";

-----------------------------------------------------
-- Implement your actions here, if needed:
-----------------------------------------------------

--@help Launch Porthole application
actions.launch = function()
  os.script(tellTo .. "activate");
  server.update({ id = "info", text = "Bloep" })
end

--@help Update status information
actions.update = function ()
  local speakers = os.script(tellTo .. "every speaker as list");
end

--@help List speakers
actions.list_speakers = function()
  local speakers = os.script(tellTo .. "every speaker as list");
  server.update({ id = "info", text = speakers })
end

--@help Connect to every available speaker
actions.connect_to_all = function()
  os.script(tellTo .. "connect to every speaker");
end

--@help Disconnect from every available speaker
actions.disconnect_from_all = function()
  os.script(tellTo .. "disconnect from every speaker");
end

-----------------------------------------------------
-- Implement event handlers here, if needed:
-----------------------------------------------------

events.detect = function ()
  return libs.fs.exists("/Applications/Porthole.app");
end

events.focus = function ()
  tid = timer.timeout(actions.update, 100);
end

events.blur = function ()
  timer.cancel(tid);
end

-----------------------------------------------------
-- Implement helpers here
-----------------------------------------------------

function get_property(name, missing_value_placeholder)
  local value = os.script(tellTo .. "set out to " .. name);
  if (value ~= "missing value") then
    return value
  else
    return missing_value_placeholder
  end
end
