-----------------------------------------------------
-- Define your variables here
-----------------------------------------------------

local log = require("log")
local timer = libs.timer
local server = libs.server
local keyboard = libs.keyboard;
local tid = -1
local tellTo = "tell application \"Porthole\" to "
local speakers = {}

-----------------------------------------------------
-- Methods:
-----------------------------------------------------

--@help Update interface
function update()

  speakers = {}

  local output = os.script(tellTo .. "id of every speaker as list")

  local sp = {}

  for k,v in pairs(output:split(", ")) do
    local name = get_speaker_property(v, "name", "Unknown")
    local streaming = get_speaker_property(v, "streaming", false)
    local connected = get_speaker_property(v, "connected", false)
    if streaming then
      name = name .. " ✓"
    end
    table.insert(sp, {
      id = v,
      type = "speaker",
      text = name,
      connected = connected,
      streaming = streaming
    })
  end

  speakers = sp

  server.update({ id = "speakers", children = speakers })

  local use_computer_speaker = get_property("use computer speaker")
  if use_computer_speaker then
    server.update({ id = "computer_speaker", text = "Computer Speaker ✓" })
  else
    server.update({ id = "computer_speaker", text = "Computer Speaker" })
  end

end

--@help Toggle AirPlay speaker
function toggle_speaker(speaker)
  local script
  local id = speaker["id"]
  if speaker["connected"] then
    script = tellTo .. "disconnect from first speaker whose id is \"" .. id .. "\""
  else
    script = tellTo .. "connect to first speaker whose id is \"" .. id .. "\""
  end
  os.script(script)
end

-----------------------------------------------------
-- Implement your actions here, if needed:
-----------------------------------------------------

--@help Invoked when a speaker is pressed
actions.speaker = function(i)
  i = i + 1
  toggle_speaker(speakers[i])
  update()
end

--@help Launch Porthole application
actions.launch = function()
  os.script(tellTo .. "activate")
end

--@help Update status information
actions.update = function ()
  update()
  tid = timer.timeout(actions.update, 500)
end

--@help Connect to every available speaker
actions.connect_to_all = function()
  os.script(tellTo .. "connect to every speaker")
end

--@help Disconnect from every available speaker
actions.disconnect_from_all = function()
  os.script(tellTo .. "disconnect from every speaker")
end

--@help Toggle use of the computer's speaker
actions.toggle_computer_speaker = function()
  local enabled = get_property("use computer speaker", false)
  if enabled then
    os.script(tellTo .. "set use computer speaker to false")
  else
    os.script(tellTo .. "set use computer speaker to true")
  end
end

--@help Lower system volume
actions.volume_down = function()
  keyboard.press("volumedown");
end

--@help Mute system volume
actions.volume_mute = function()
  keyboard.press("volumemute");
end

--@help Raise system volume
actions.volume_up = function()
  keyboard.press("volumeup");
end

-----------------------------------------------------
-- Implement event handlers here, if needed:
-----------------------------------------------------

events.detect = function ()
  return libs.fs.exists("/Applications/Porthole.app")
end

events.focus = function ()
  tid = timer.timeout(actions.update, 100)
end

events.blur = function ()
  timer.cancel(tid)
end

-----------------------------------------------------
-- Implement helpers here
-----------------------------------------------------

--@help Get property from Porthole
function get_property(name, missing_value_placeholder)
  local value = os.script(tellTo .. "set out to " .. name)
  if (value ~= "missing value") then
    return value
  else
    return missing_value_placeholder
  end
end

--@help Get speaker property from Porthole
function get_speaker_property(id, name, missing_value_placeholder)
  local value = os.script(tellTo .. "set out to " .. name .. " of first speaker whose id is \"" .. id .."\"")
  if (value ~= "missing value") then
    return value
  else
    return missing_value_placeholder
  end
end

--@help Add ability to split into table to strings
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end
