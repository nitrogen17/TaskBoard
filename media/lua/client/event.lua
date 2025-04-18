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

MODDATA_KEY = "SimpleModData"

-- for Create, Edit and Delete event on the server
Events.OnReceiveGlobalModData.Add(function(key, data)
    print("[Client] Events.OnReceiveGlobalModData.Add(function(key, data)")
    if key ~= MODDATA_KEY then return end
    
    for taskID, task in pairs(data) do
        -- print("  TaskID:", taskID, "Title:", task.title)
        printTable(task)
    end

    -- You can now update UI or local cache here if needed
end)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= MODDATA_KEY then return end

    if command == "SendAllTasks" then
        print("[Client] Events.OnServerCommand.Add(function(module, command, args)")

        -- UUIDGenerator is dependent here
        kb_DataManager.tasks = args.tasks

        for taskID, task in pairs(args.tasks) do
            print("  TaskID:", taskID, "Title:", task.title)
        end
    end
end)

-- Utility to print table contents recursively
function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(prefix .. tostring(key) .. " = {")
            printTable(value, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(key) .. " = " .. tostring(value))
        end
    end
end