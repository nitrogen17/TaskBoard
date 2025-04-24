-- Persistency Manager
-- Hook under onGameStart then adapt TaskBoard Core
    MODDATA_KEY = "KB.KanbanBoard"

    TaskBoard_Core = {}

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
            db = task

        elseif action == "AssignTasks" then
            db = task
        end
        
        return db
    end
    
    function TaskBoard_Core.fetchAllTasks() 
        -- server
        if command == "FetchAllTasks" then
            kb_DataManager.tasks = args.tasks
        end
    
    end

    function TaskBoard_Core.reloadAll(tasks)
        if isClient() then
            sendClientCommand(MODDATA_KEY, "ReloadAllTables", task)
        elseif isServer() then
            handleTaskAction("AssignTasks", task)
            reloadAllTablesInClient(db)
        else
            handleTaskAction("AssignTasks", task)
            reloadAllTablesInClient(ModData.getOrCreate(MODDATA_KEY))
        end

        -- server
        if command == "ReloadAllTables" then
            kb_DataManager.tasks = args.tasks
            reloadAllTablesInClient(kb_DataManager.tasks)
        end
    end
    
    function TaskBoard_Core.create(task)
        print("[TaskBoard_Core.create] Creating task with data:")
    
        if isClient() then
            print("[TaskBoard_Core.create] Detected isClient() - sending ClientCommand")
            sendClientCommand(MODDATA_KEY, "CreateTask", task)
        elseif isServer() then
            print("[TaskBoard_Core.create] Detected isServer() - handling and transmitting ModData")
            handleTaskAction("CreateTask", task)
            ModData.transmit(MODDATA_KEY)
        else
            print("[TaskBoard_Core.create] Detected singleplayer - handling and reloading tables")
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