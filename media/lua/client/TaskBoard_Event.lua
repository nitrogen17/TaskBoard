-- Event Lua
-- https://pzwiki.net/wiki/Lua_event

-- Hook
require 'TaskBoard_Main'
require 'TaskBoard_Action'

-- Event
--Events.OnGameStart.Add(main)
Events.OnGameStart.Add(main)
-- Events.OnCustomUIKeyPressed.Add(onCustomUIKeyPressed)

MODDATA_KEY = "KB.KanbanBoard"

-- Global Property for holding the tasks
kb_DataManager = {}
kb_DataManager.tasks = {}

-- for Create, Edit and Delete event on the server
-- Events.OnReceiveGlobalModData.Add(function(key, data)
--     if key ~= MODDATA_KEY then return end

--     reloadAllTablesInClient(data)
-- end)

function reloadAllTablesInClient(furniture)
    if not furniture then return end

    local tasks = furniture:getModData().tasks or {}

    kb_leftListBox:clear()
    kb_middleListBox:clear()
    kb_rightListBox:clear()

    kb_leftListBox.tableTasks = {}
    kb_middleListBox.tableTasks = {}
    kb_rightListBox.tableTasks = {}

    local sectionMap = {
        [1] = {},
        [2] = {},
        [3] = {}
    }

    for _, task in pairs(tasks) do
        if sectionMap[task.sectionID] then
            table.insert(sectionMap[task.sectionID], task)
        end
    end

    local function sortByUpdatedAtDesc(a, b)
        return a.updatedAt > b.updatedAt
    end

    table.sort(sectionMap[1], sortByUpdatedAtDesc)
    table.sort(sectionMap[2], sortByUpdatedAtDesc)
    table.sort(sectionMap[3], sortByUpdatedAtDesc)

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

-- Events.OnServerCommand.Add(function(module, command, args)
--     if module ~= MODDATA_KEY then return end

--     if command == "ReloadAllTables" then
--         kb_DataManager.tasks = args.tasks
--         reloadAllTablesInClient(kb_DataManager.tasks)
--     end
-- end)
