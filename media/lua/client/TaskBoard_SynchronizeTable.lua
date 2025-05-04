require('TaskBoard_Core')
require('TaskBoard_Utils')

local commandHandlers = {
    TaskBoardTaskUpdated = function(args, taskBoard)
        local modData = taskBoard:getModData()
        modData.tasks = modData.tasks or {}

        if args.action == "CreateTask" then
            modData.tasks[args.task.id] = args.task
        elseif args.action == "UpdateTask" and args.task.id then
            modData.tasks[args.task.id] = args.task
        elseif args.action == "DeleteTask" and args.task.id then
            modData.tasks[args.task.id] = nil
        end

        if TaskBoard_mainWindowFurniture == taskBoard then
            TaskBoard_Core.reloadAllTables(getPlayer(), taskBoard)
        end
    end,

    TaskBoardDeleted = function(args, taskBoard)
        if TaskBoard_mainWindowFurniture == taskBoard then
            TaskBoard_Utils.closeTaskBoardMainWindow()
        end
    end
}

local function onServerCommand(module, command, args)
    if module == "TaskBoard" and commandHandlers[command] then
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        local taskBoard = TaskBoard_Utils.findTaskBoardOnSquare(square)
        if taskBoard then
            commandHandlers[command](args, taskBoard)
        end
    end
end

Events.OnServerCommand.Add(onServerCommand)
