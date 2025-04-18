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

    reloadAllTablesInClient(data)

    -- You can now update UI or local cache here if needed
end)

function reloadAllTablesInClient(tasks)
    kb_leftListBox.tableTasks = {}
    kb_middleListBox.tableTasks = {}
    kb_rightListBox.tableTasks = {}

    kb_leftListBox:clear()
    kb_middleListBox:clear()
    kb_rightListBox:clear()

    for _, task in pairs(tasks) do
        if task.sectionID == 1 then
            kb_leftListBox:addItem(task)
        elseif task.sectionID == 2 then
            kb_middleListBox:addItem(task)
        elseif task.sectionID == 3 then
            kb_rightListBox:addItem(task)
        end
    end
end


Events.OnServerCommand.Add(function(module, command, args)
    if module ~= MODDATA_KEY then return end

    if command == "SendAllTasks" then
        
    end
    
    -- For UUIDGenerator
    if command == "FetchAllTasks" then
        -- UUIDGenerator is dependent here
        kb_DataManager.tasks = args.tasks
    end

    if command == "ReloadAllTables" then
        kb_DataManager.tasks = args.tasks
        reloadAllTablesInClient(kb_DataManager.tasks)
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