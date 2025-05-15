require('TaskBoard_Utils')
require('TaskBoard_Title')

local commandHandlers = {
    TaskBoardTaskUpdated = function(player, args, taskBoard)
        TaskBoard_Core.syncTaskAction(taskBoard, args)
        sendServerCommand("TaskBoard", "TaskBoardTaskUpdated", args)
    end,

    TaskBoardDeleted = function(player, args, taskBoard)
        sendServerCommand("TaskBoard", "TaskBoardDeleted", {
            x = args.x,
            y = args.y,
            z = args.z
        })
    end,

    TaskBoardTitleUpdated = function(player, args, taskBoard)
        TaskBoard_Title.set(taskBoard, args.title)
        sendServerCommand("TaskBoard", "TaskBoardTitleUpdated", {
            x = args.x,
            y = args.y,
            z = args.z,
            title = args.title
        })
    end,
}

local function onReceivePackets(module, command, player, args)
    if module == "TaskBoard" and commandHandlers[command] then
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        local taskBoard = TaskBoard_Utils.findTaskBoardOnSquare(square)
        if taskBoard then
            commandHandlers[command](player, args, taskBoard)
        end
    end
end

Events.OnClientCommand.Add(onReceivePackets)
