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

-- Global Property for holding the tasks
kb_DataManager = {}
kb_DataManager.tasks = {}

-- for Create, Edit and Delete event on the server
Events.OnReceiveGlobalModData.Add(function(key, data)
    if key ~= MODDATA_KEY then return end

    -- for taskID, task in pairs(data) do
    --     -- print("  TaskID:", taskID, "Title:", task.title)
    --     printTable(task)
    -- end

    reloadAllTablesInClient(data)
end)

function reloadAllTablesInClient(tasks)
    -- Clear UI and internal data
    kb_leftListBox:clear()
    kb_middleListBox:clear()
    kb_rightListBox:clear()

    kb_leftListBox.tableTasks = {}
    kb_middleListBox.tableTasks = {}
    kb_rightListBox.tableTasks = {}

    -- Prepare section maps
    local sectionMap = {
        [1] = {},
        [2] = {},
        [3] = {}
    }

    -- Group tasks by section
    for _, task in pairs(tasks) do
        if sectionMap[task.sectionID] then
            table.insert(sectionMap[task.sectionID], task)
        end
    end

    -- Sort each section by updatedAt descending (newer last)
    local function sortByUpdatedAtDesc(a, b)
        return a.updatedAt > b.updatedAt
    end

    table.sort(sectionMap[1], sortByUpdatedAtDesc)
    table.sort(sectionMap[2], sortByUpdatedAtDesc)
    table.sort(sectionMap[3], sortByUpdatedAtDesc)

    -- Add sorted tasks to respective list boxes
    for _, task in ipairs(sectionMap[1]) do
        kb_leftListBox:addItem(task)
    end
    for _, task in ipairs(sectionMap[2]) do
        kb_middleListBox:addItem(task)
    end
    for _, task in ipairs(sectionMap[3]) do
        kb_rightListBox:addItem(task)
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