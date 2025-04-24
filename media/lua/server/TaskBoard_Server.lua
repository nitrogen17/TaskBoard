-- Server
MODDATA_KEY = "KB.KanbanBoard.SP"
TaskBoard_PersistencyManager = {}

function generateUUID()
    local db = ModData.getOrCreate(MODDATA_KEY)

    local function padWithZeros(num)
        return string.format("%010d", num) -- Ensures the number is 10 digits long with leading zeros
    end

    for i = 1, 5 do
        local id = padWithZeros(ZombRand(0, 1000000000)) -- Generate a number and pad it
        if not db[id] then return id end
    end

    return padWithZeros(ZombRand(0, 1000000000)) -- Fallback in case of collision
end

function TaskBoard_PersistencyManager.action(command, task)
    print("[Debug] created task with in TaskBoard_PersistencyManager 1")

    local db = ModData.getOrCreate(MODDATA_KEY)
    local transmit = function() reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY)) end

    if command == "CreateTask" then
        print("[Debug] created task with in TaskBoard_PersistencyManager")
        task.id = generateUUID()
        db[task.id] = task
        transmit()
    elseif command == "UpdateTask" and db[task.id] then
        db[task.id] = task
        transmit()
    elseif command == "DeleteTask" then
        db[task.id] = nil
        transmit()
    elseif command == "DeleteAllTasks" then
        table.wipe(db)
        transmit()
    elseif command == "FetchAllTasks" or command == "ReloadAllTables" then
        reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
    end
end