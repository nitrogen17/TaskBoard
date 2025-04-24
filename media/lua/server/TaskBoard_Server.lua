-- Server
MODDATA_KEY = "KB.KanbanBoard"

-- function generateUUID()
--     local db = ModData.getOrCreate(MODDATA_KEY)

--     local function padWithZeros(num)
--         return string.format("%010d", num) -- Ensures the number is 10 digits long with leading zeros
--     end

--     for i = 1, 5 do
--         local id = padWithZeros(ZombRand(0, 1000000000)) -- Generate a number and pad it
--         if not db[id] then return id end
--     end

--     return padWithZeros(ZombRand(0, 1000000000)) -- Fallback in case of collision
-- end

Events.OnClientCommand.Add(function(module, command, player, task)
    if module ~= MODDATA_KEY then return end

    local db = ModData.getOrCreate(MODDATA_KEY)
    -- local transmit = function() ModData.transmit(MODDATA_KEY) end

    if command == "CreateTask" then
        TaskBoard_Core.create(task)
        -- task.id = generateUUID()
        -- db[task.id] = task
        -- transmit()
    -- elseif command == "UpdateTask" and db[task.id] then
    elseif command == "UpdateTask" then
        TaskBoard_Core.update(task)
        -- db[task.id] = task
        -- transmit()
    elseif command == "DeleteTask" then
        TaskBoard_Core.delete(task)
        -- db[task.id] = nil
        -- transmit()
    elseif command == "FetchAllTasks" or command == "ReloadAllTables" then
        sendServerCommand(player, MODDATA_KEY, command, { tasks = db })
    end
end)