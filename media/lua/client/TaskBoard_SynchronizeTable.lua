require('TaskBoard_Core')

local function processTaskBoardObjects(args, callback)
    local square = getCell():getGridSquare(args.x, args.y, args.z)
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object:getModData().isTaskBoard and TaskBoard_mainWindowFurniture == object then
            callback(object)
        end
    end
end

local function onServerCommand(module, command, args)
    if module == "TaskBoard" then
        if command == "TaskBoardUpdated" then
            processTaskBoardObjects(args, function(object)
                TaskBoard_Core.reloadAllTables(getPlayer(), object)
            end)
        elseif command == "TaskBoardDeleted" then
            processTaskBoardObjects(args, function(object)
                TaskBoard_mainWindow:setVisible(false)
                TaskBoard_mainWindowFurniture = nil
            end)
        end
    end
end

Events.OnServerCommand.Add(onServerCommand)
