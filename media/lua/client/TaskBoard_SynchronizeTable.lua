require('TaskBoard_Core')
require('TaskBoard_Utils')

local function onServerCommand(module, command, args)
    if module == "TaskBoard" then
        if command == "TaskBoardTaskUpdated" then
            local square = getCell():getGridSquare(args.x, args.y, args.z)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if object:getModData().isTaskBoard then
                        local modData = object:getModData()
                        modData.tasks = modData.tasks or {}

                        if args.action == "CreateTask" then
                            modData.tasks[args.task.id] = args.task
                        elseif args.action == "UpdateTask" and args.task.id then
                            modData.tasks[args.task.id] = args.task
                        elseif args.action == "DeleteTask" and args.task.id then
                            modData.tasks[args.task.id] = nil
                        end

                        if TaskBoard_mainWindowFurniture == object then
                            TaskBoard_Core.reloadAllTables(getPlayer(), object)
                        end
                        break
                    end
                end
            end
        elseif command == "TaskBoardDeleted" then
            local square = getCell():getGridSquare(args.x, args.y, args.z)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if TaskBoard_mainWindowFurniture == object then
                        TaskBoard_Utils.closeTaskBoardMainWindow()
                        break
                    end
                end
            end
        end
    end
end

Events.OnServerCommand.Add(onServerCommand)
