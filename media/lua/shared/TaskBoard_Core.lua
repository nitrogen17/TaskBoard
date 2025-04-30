MODDATA_KEY = "KB.KanbanBoard"

TaskBoard_Core = {}

local function generateUUID()
    local db = ModData.getOrCreate(MODDATA_KEY)

    local function padWithZeros(num)
        return string.format("%010d", num)
    end

    for i = 1, 5 do
        local id = padWithZeros(ZombRand(0, 1000000000))
        if not db[id] then return id end
    end

    return padWithZeros(ZombRand(0, 1000000000))
end

local function handleTaskAction(action, task)
    local db = ModData.getOrCreate(MODDATA_KEY)

    if action == "CreateTask" then
        task.id = generateUUID()
        db[task.id] = task

    elseif action == "UpdateTask" and task.id then
        db[task.id] = task

    elseif action == "DeleteTask" and task.id then
        db[task.id] = nil

    elseif action == "DeleteAllTasks" then
        table.wipe(db)

    elseif action == "FetchAllTasks" then
        return db

    elseif action == "AssignTasks" then
        db = task
    end

    return db
end

function TaskBoard_Core.reloadAllTables(player)
    if isClient() then
        sendClientCommand(MODDATA_KEY, "ReloadAllTables", {})
    elseif isServer() then
        local db = handleTaskAction("FetchAllTasks")
        sendServerCommand(player, MODDATA_KEY, "ReloadAllTables", { tasks = db })
    else
        reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
    end
end

function TaskBoard_Core.create(task)
    if isClient() then
        sendClientCommand(MODDATA_KEY, "CreateTask", task)
    elseif isServer() then
        handleTaskAction("CreateTask", task)
        ModData.transmit(MODDATA_KEY)
    else
        handleTaskAction("CreateTask", task)
        reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
    end
end

function TaskBoard_Core.update(task)
    if not task.id then return end

    if isClient() then
        sendClientCommand(MODDATA_KEY, "UpdateTask", task)
    elseif isServer() then
        handleTaskAction("UpdateTask", task)
        ModData.transmit(MODDATA_KEY)
    else
        handleTaskAction("UpdateTask", task)
        reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
    end
end

function TaskBoard_Core.delete(task)
    if isClient() then
        sendClientCommand(MODDATA_KEY, "DeleteTask", task)
    elseif isServer() then
        handleTaskAction("DeleteTask", task)
        ModData.transmit(MODDATA_KEY)
    else
        handleTaskAction("DeleteTask", task)
        reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
    end
end
