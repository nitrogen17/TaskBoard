require('TaskBoard_Utils')

OLD_MOD_DATA_KEY = "KB.KanbanBoard"

local function migrateData(args)
    local globalModData = ModData.get(OLD_MOD_DATA_KEY)
    if not globalModData then return end

    local square = getCell():getGridSquare(args.x, args.y, args.z)
    if not square then return end

    local objects = square:getObjects()

    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object and TaskBoard_Utils.isFurnitureWhitelisted(object) then
            local modData = TaskBoard_Core.fetchModData(object)
            modData.tasks = modData.tasks or {}
            for key, value in pairs(globalModData) do
                modData.tasks[key] = value
            end
            modData.isTaskBoard = true
            object:transmitModData()
            break
        end
    end
end

local function requestMigration(furniture)
    if isServer() or not furniture then return end

    local square = furniture:getSquare()
    if not square then return end

    local args = {
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
        name = TaskBoard_Utils.getFurnitureName(furniture),
    }

    if isClient() then
        sendClientCommand("TaskBoard", "MigrateTaskBoard", args)
    else
        migrateData(args)
    end
end

local function onClientCommand(module, command, player, args)
    if module == "TaskBoard" and command == "MigrateTaskBoard" then
        migrateData(args)
    end
end

local function onGameStart()
    if isClient() then
        ModData.request(OLD_MOD_DATA_KEY)
    end
end

local function onReceiveGlobalModData(key, data)
    if key ~= OLD_MOD_DATA_KEY or not data or type(data) ~= "table" then return end

    local globalModData = ModData.getOrCreate(OLD_MOD_DATA_KEY)

    for k, v in pairs(data) do
        globalModData[k] = v
    end
end

local function onFillWorldObjectContextMenu(playerNum, context, worldobjects, test)
    local hideMigration = SandboxVars.TaskBoard.HideMigrateTaskBoardContextItem
    if hideMigration then return end

    local globalModData = ModData.get(OLD_MOD_DATA_KEY)
    if not globalModData then return end

    local clickedSquare = nil
    if worldobjects and #worldobjects > 0 then
        clickedSquare = worldobjects[1]:getSquare()
    end

    if not clickedSquare then return end

    local player = getPlayer(playerNum)
    if TaskBoard_Utils.isWithinRange(player, clickedSquare, 1) then
        local objects = clickedSquare:getObjects()
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            if object and TaskBoard_Utils.isFurnitureWhitelisted(object) then
                local modData = TaskBoard_Core.fetchModData(object)
                if not modData.isTaskBoard then
                    local currentName = TaskBoard_Utils.getFurnitureName(object)
                    context:addOption("Migrate Task Board (" .. currentName .. ")", object, requestMigration, object)
                end
            end
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)
Events.OnGameStart.Add(onGameStart)
Events.OnReceiveGlobalModData.Add(onReceiveGlobalModData)
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
