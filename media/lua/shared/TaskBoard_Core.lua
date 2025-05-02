TaskBoard_Core = {}

-- Generate a unique ID for tasks
local function generateUUID(furniture)
    local modData = furniture:getModData()
    modData.tasks = modData.tasks or {}

    local function padWithZeros(num)
        return string.format("%010d", num)
    end

    for i = 1, 1000 do
        local id = padWithZeros(ZombRand(0, 1000000000))
        if not modData.tasks[id] then return id end
    end

    error("Failed to generate a unique ID after 1000 attempts.")
end

-- Handle task actions for a specific furniture
local function handleTaskAction(furniture, action, task)
    local modData = furniture:getModData()
    modData.tasks = modData.tasks or {}

    if action == "CreateTask" then
        task.id = generateUUID(furniture)
        modData.tasks[task.id] = task

    elseif action == "UpdateTask" and task.id then
        modData.tasks[task.id] = task

    elseif action == "DeleteTask" and task.id then
        modData.tasks[task.id] = nil

    elseif action == "DeleteAllTasks" then
        modData.tasks = {}

    elseif action == "FetchAllTasks" then
        return modData.tasks
    end

    -- Sync modData in multiplayer
    furniture:transmitModData()
    return modData.tasks
end

-- Reload all tasks for a specific furniture
function TaskBoard_Core.reloadAllTables(player, furniture)
    if not furniture then return end

    -- local modData = furniture:getModData()
    -- modData.tasks = modData.tasks or {}

    -- if isClient() then
    --     sendClientCommand("TaskBoard", "ReloadAllTables", { tasks = modData.tasks })
    -- elseif isServer() then
    --     sendServerCommand(player, "TaskBoard", "ReloadAllTables", { tasks = modData.tasks })
    -- else
    --     reloadAllTablesInClient(modData.tasks)
    -- end

    mainWindowID = furniture
    reloadAllTablesInClient(furniture)
end

-- Create a new task for a specific furniture
function TaskBoard_Core.create(furniture, task)
    if not furniture then return end

    -- if isClient() then
    --     sendClientCommand("TaskBoard", "CreateTask", { furniture = furniture, task = task })
    -- elseif isServer() then
    --     handleTaskAction(furniture, "CreateTask", task)
    -- else
    --     handleTaskAction(furniture, "CreateTask", task)
    --     reloadAllTablesInClient(furniture:getModData().tasks)
    -- end

    handleTaskAction(furniture, "CreateTask", task)
    reloadAllTablesInClient(furniture)
end

-- Update an existing task for a specific furniture
function TaskBoard_Core.update(furniture, task)
    if not furniture or not task.id then return end

    -- if isClient() then
    --     sendClientCommand("TaskBoard", "UpdateTask", { furniture = furniture, task = task })
    -- elseif isServer() then
    --     handleTaskAction(furniture, "UpdateTask", task)
    -- else
    --     handleTaskAction(furniture, "UpdateTask", task)
    --     reloadAllTablesInClient(furniture:getModData().tasks)
    -- end

    handleTaskAction(furniture, "UpdateTask", task)
    reloadAllTablesInClient(furniture)
end

-- Delete a task for a specific furniture
function TaskBoard_Core.delete(furniture, task)
    if not furniture or not task.id then return end

    -- if isClient() then
    --     sendClientCommand("TaskBoard", "DeleteTask", { furniture = furniture, task = task })
    -- elseif isServer() then
    --     handleTaskAction(furniture, "DeleteTask", task)
    -- else
    --     handleTaskAction(furniture, "DeleteTask", task)
    --     reloadAllTablesInClient(furniture:getModData().tasks)
    -- end

    handleTaskAction(furniture, "DeleteTask", task)
    reloadAllTablesInClient(furniture)
end

-- MODDATA_KEY = "KB.KanbanBoard"

-- TaskBoard_Core = {}

-- local function generateUUID()
--     local db = ModData.getOrCreate(MODDATA_KEY)

--     local function padWithZeros(num)
--         return string.format("%010d", num)
--     end

--     for i = 1, 5 do
--         local id = padWithZeros(ZombRand(0, 1000000000))
--         if not db[id] then return id end
--     end

--     error("Failed to generate a unique ID after 5 attempts.")
-- end

-- local function handleTaskAction(action, task)
--     local db = ModData.getOrCreate(MODDATA_KEY)

--     if action == "CreateTask" then
--         task.id = generateUUID()
--         db[task.id] = task

--     elseif action == "UpdateTask" and task.id then
--         db[task.id] = task

--     elseif action == "DeleteTask" and task.id then
--         db[task.id] = nil

--     elseif action == "DeleteAllTasks" then
--         table.wipe(db)

--     elseif action == "FetchAllTasks" then
--         return db

--     elseif action == "AssignTasks" then
--         db = task
--     end

--     return db
-- end

-- function TaskBoard_Core.reloadAllTables(player)
--     if isClient() then
--         sendClientCommand(MODDATA_KEY, "ReloadAllTables", {})
--     elseif isServer() then
--         local db = handleTaskAction("FetchAllTasks")
--         sendServerCommand(player, MODDATA_KEY, "ReloadAllTables", { tasks = db })
--     else
--         reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
--     end
-- end

-- function TaskBoard_Core.create(task)
--     if isClient() then
--         sendClientCommand(MODDATA_KEY, "CreateTask", task)
--     elseif isServer() then
--         handleTaskAction("CreateTask", task)
--         ModData.transmit(MODDATA_KEY)
--     else
--         handleTaskAction("CreateTask", task)
--         reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
--     end
-- end

-- function TaskBoard_Core.update(task)
--     if not task.id then return end

--     if isClient() then
--         sendClientCommand(MODDATA_KEY, "UpdateTask", task)
--     elseif isServer() then
--         handleTaskAction("UpdateTask", task)
--         ModData.transmit(MODDATA_KEY)
--     else
--         handleTaskAction("UpdateTask", task)
--         reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
--     end
-- end

-- function TaskBoard_Core.delete(task)
--     if isClient() then
--         sendClientCommand(MODDATA_KEY, "DeleteTask", task)
--     elseif isServer() then
--         handleTaskAction("DeleteTask", task)
--         ModData.transmit(MODDATA_KEY)
--     else
--         handleTaskAction("DeleteTask", task)
--         reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
--     end
-- end
