-- Event Lua
-- https://pzwiki.net/wiki/Lua_event

-- Hook
require 'main'
require 'action'

-- Event
Events.OnGameStart.Add(main)
Events.OnCustomUIKeyPressed.Add(onCustomUIKeyPressed)