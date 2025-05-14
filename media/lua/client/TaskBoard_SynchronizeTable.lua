require('TaskBoard_Core')
require('TaskBoard_Utils')

local commandHandlers = {
    TaskBoardTaskUpdated = function(args, taskBoard)
        TaskBoard_Core.syncTaskAction(taskBoard, args)
        if TaskBoard_mainWindowFurniture == taskBoard then
            TaskBoard_Core.reloadAllTables(getPlayer(), taskBoard)
        end
    end,

    TaskBoardDeleted = function(args, taskBoard)
        if TaskBoard_mainWindowFurniture == taskBoard then
            TaskBoard_Utils.closeTaskBoardMainWindow()
        end
    end,

    TaskBoardTitleUpdated = function(args, taskBoard)
        TaskBoard_Title.set(taskBoard, args.title)
        if TaskBoard_mainWindowFurniture == taskBoard then
            TaskBoard_Core.reloadAllTables(getPlayer(), taskBoard)
        end
    end,
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
