require('TaskBoard_Utils')

MODDATA_KEY = "KB.KanbanBoard"

TaskBoard_Migrator = {}

local function onMigrateTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    TaskBoard_Migrator.requestMigration(furniture)
end

local function onClientCommand(module, command, player, args)
    if module == "TaskBoard" and command == "MigrateTaskBoard" then
        TaskBoard_Migrator.migrateData(args)
    end
end

local function onGameStart()
    if isClient() then
        ModData.request(MODDATA_KEY)
    end
end

local function onReceiveGlobalModData(key, data)
    if key == MODDATA_KEY then
        print("Received global mod data for " .. key)
        local globalModData = ModData.getOrCreate(MODDATA_KEY)

        for k, v in pairs(data) do
            print("Key: " .. tostring(k) .. ", Value: " .. tostring(v))
            globalModData[k] = v
        end
    end
end

function TaskBoard_Migrator.requestMigration(furniture)
    if isServer() or not furniture then return end

    local args = {
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
        name = TaskBoard_Utils.getFurnitureName(furniture),
    }

    if isClient() then
        sendClientCommand("TaskBoard", "MigrateTaskBoard", args)
    else
        TaskBoard_Migrator.migrateData(args)
    end
end

function TaskBoard_Migrator.migrateData(args)
    local globalModData = ModData.get(MODDATA_KEY)
    if not globalModData then return end

    local square = getCell():getGridSquare(args.x, args.y, args.z)
    if not square then return end

    local objects = square:getObjects()
    local processedObjects = {}

    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object and not processedObjects[object] and TaskBoard_Utils.isFurnitureWhitelisted(object) then
            processedObjects[object] = true
            local modData = object:getModData()
            modData.tasks = modData.tasks or {}
            for key, value in pairs(globalModData) do
                modData.tasks[key] = value
            end
            modData.isTaskBoard = true
            object:transmitModData()
            -- ModData.remove(MODDATA_KEY)
            break
        end
    end
end

function TaskBoard_Migrator.onFillWorldObjectContextMenu(context, worldobjects, object, modData, currentName, square)
    local globalModData = ModData.get(MODDATA_KEY)
    if TaskBoard_Utils.isFurnitureWhitelisted(object) and not modData.isTaskBoard and globalModData then
        context:addOption("Migrate Task Board (" .. currentName .. ")", worldobjects, onMigrateTaskBoard, square, object)
    end
end

Events.OnClientCommand.Add(onClientCommand)
Events.OnGameStart.Add(onGameStart)
Events.OnReceiveGlobalModData.Add(onReceiveGlobalModData)

return TaskBoard_Migrator
