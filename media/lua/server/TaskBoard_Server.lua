TaskBoard_Server = {}

local function onReceivePackets(module, command, player, args)
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

                        sendServerCommand("TaskBoard", "TaskBoardTaskUpdated", args)
                        break
                    end
                end
            end
        elseif command == "TaskBoardDeleted" then
            -- todo
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
            -- todo
        end
    end
end

Events.OnClientCommand.Add(onReceivePackets)

return TaskBoard_Server