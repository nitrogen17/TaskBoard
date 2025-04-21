-- Server
MODDATA_KEY = "SimpleModData"

function generateUUIDWithRetries()
    local retryCount = 0
    local maxRetries = 5

    local value = tostring(ZombRand(1000000000, 9999999999))

    while retryCount < maxRetries do
        if not ModData.getOrCreate(MODDATA_KEY)[value] then
            return value
        else
            retryCount = retryCount + 1
            value = tostring(ZombRand(1000000000, 9999999999))
        end
    end

    return tostring(ZombRand(1000000000, 9999999999))
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= MODDATA_KEY then return end

    local db = ModData.getOrCreate(MODDATA_KEY)

    if command == "CreateTask" then
        args.id = generateUUIDWithRetries()
        db[args.id] = args
        ModData.transmit(MODDATA_KEY)
    elseif command == "UpdateTask" then
        if db[args.id] then
            db[args.id] = args
            ModData.transmit(MODDATA_KEY)
        end
    elseif command == "DeleteTask" then
        db[args.id] = nil
        ModData.transmit(MODDATA_KEY)
    elseif command == "DeleteAllTasks" then
        for k in pairs(db) do
            db[k] = nil
        end
        ModData.transmit(MODDATA_KEY)  
    elseif command == "FetchAllTasks" then
        sendServerCommand(player, MODDATA_KEY, "FetchAllTasks", { tasks = db })
    elseif command == "ReloadAllTables" then
        sendServerCommand(player, MODDATA_KEY, "ReloadAllTables", { tasks = db })
    end
end)

Events.OnInitGlobalModData.Add(function()
    ModData.getOrCreate(MODDATA_KEY)
end)