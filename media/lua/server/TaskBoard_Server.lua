TaskBoard_Server = {}

local commandHandlers = {
    TaskBoardTaskUpdated = function(player, args, taskBoard)
        local modData = taskBoard:getModData()
        modData.tasks = modData.tasks or {}

        if args.action == "CreateTask" then
            modData.tasks[args.task.id] = args.task
        elseif args.action == "UpdateTask" and args.task.id then
            modData.tasks[args.task.id] = args.task
        elseif args.action == "DeleteTask" and args.task.id then
            modData.tasks[args.task.id] = nil
        end

        sendServerCommand("TaskBoard", "TaskBoardTaskUpdated", args)
    end,

    TaskBoardDeleted = function(player, args, taskBoard)
        sendServerCommand("TaskBoard", "TaskBoardDeleted", {
            x = args.x,
            y = args.y,
            z = args.z
        })
    end
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

function TaskBoard_Server.getPacket(packetType, args)
    if isClient() then
        if packetType == "TaskBoardUpdated" then
            local square = args.furniture:getSquare()
            if square then
                sendClientCommand("TaskBoard", "TaskBoardTaskUpdated", {
                    x = square:getX(),
                    y = square:getY(),
                    z = square:getZ(),
                    action = args.action,
                    task = args.task,
                })
            end
        elseif packetType == "TaskBoardDeleted" then
            local square = args.furniture:getSquare()
            if square then
                sendClientCommand("TaskBoard", "TaskBoardDeleted", {
                    x = square:getX(),
                    y = square:getY(),
                    z = square:getZ()
                })
            end
        end
    end
end

Events.OnClientCommand.Add(onReceivePackets)

return TaskBoard_Server