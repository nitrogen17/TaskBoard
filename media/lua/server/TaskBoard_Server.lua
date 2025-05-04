TaskBoard_Server = {}

local function findTaskBoardOnSquare(square)
    if not square then return nil end
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object:getModData().isTaskBoard then
            return object
        end
    end
    return nil
end

local function sendTaskBoardCommand(command, furniture)
    if isServer() and furniture and instanceof(furniture, "IsoObject") then
        local square = furniture:getSquare()
        if square then
            sendServerCommand("TaskBoard", command, {
                x = square:getX(),
                y = square:getY(),
                z = square:getZ()
            })
        end
    end
end

local function updateOpenTaskBoard(furniture)
    sendTaskBoardCommand("TaskBoardUpdated", furniture)
end

local function forceCloseBoard(furniture)
    sendTaskBoardCommand("TaskBoardDeleted", furniture)
end

local function onReceivePackets(module, command, player, args)
    if module == "TaskBoard" then
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        local taskBoard = findTaskBoardOnSquare(square)

        if command == "TaskBoardUpdated" and taskBoard then
            updateOpenTaskBoard(taskBoard)
        elseif command == "TaskBoardDeleted" and taskBoard then
            forceCloseBoard(taskBoard)
        end
    end
end

function TaskBoard_Server.getPacket(packetType, furniture)
    if isClient() and (packetType == "TaskBoardUpdated" or packetType == "TaskBoardDeleted") then
        local square = furniture:getSquare()
        if square then
            sendClientCommand("TaskBoard", packetType, {
                x = square:getX(),
                y = square:getY(),
                z = square:getZ()
            })
        end
    end
end

Events.OnClientCommand.Add(onReceivePackets)

return TaskBoard_Server