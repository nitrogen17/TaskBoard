-- Event Lua
-- https://pzwiki.net/wiki/Lua_event

-- Hook
require 'main'
require 'action'
require 'test'

-- Event
--Events.OnGameStart.Add(main)
Events.OnGameStart.Add(main)
Events.OnCustomUIKeyPressed.Add(onCustomUIKeyPressed)