-- local function onSynchronizeFurniture(object)
--     if not object or TaskBoard_mainWindowFurniture ~= object or not TaskBoard_Utils.isFurnitureWhitelisted(object) then
--         return
--     end

--     local modData = object:getModData()
--     if modData.isTaskBoard then
--         TaskBoard_Core.reloadAllTables(getPlayer(), object)
--     end
-- end

-- Events.OnObjectModDataChanged.Add(onSynchronizeFurniture)

-- Improve this.
local function onServerCommand(module, command, args)
    if module == "TaskBoard" and command == "TaskBoardUpdated" then
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        if square then
            for i = 0, square:getObjects():size() - 1 do
                local object = square:getObjects():get(i)
                if object:getModData().isTaskBoard and TaskBoard_mainWindowFurniture == object then
                    TaskBoard_Core.reloadAllTables(getPlayer(), object)
                end
            end
        end
    end
end

Events.OnServerCommand.Add(onServerCommand)
