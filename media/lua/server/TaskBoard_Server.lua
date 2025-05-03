MODDATA_KEY = "KB.KanbanBoard"

TaskBoard_Server = {}

local function updateOpenTaskBoard(furniture)
    if isServer() and furniture and instanceof(furniture, "IsoObject") then
        local square = furniture:getSquare()
        if square then
            sendServerCommand("TaskBoard", "TaskBoardUpdated", {
                x = square:getX(),
                y = square:getY(),
                z = square:getZ()
            })
        end
    end
end

local function forceCloseBoard(furniture)
    if isServer() and furniture and instanceof(furniture, "IsoObject") then
        local square = furniture:getSquare()
        if square then
            sendServerCommand("TaskBoard", "TaskBoardDeleted", {
                x = square:getX(),
                y = square:getY(),
                z = square:getZ()
            })
        end
    end
end

function TaskBoardServer.sendPacket(packetType, args)
    if isServer() then
        if packetType == "TaskBoardUpdated" then
            updateOpenTaskBoard(args)
        elseif packetType == "TaskBoardDeleted" then
            forceCloseBoard(args)
        end
    end
end

return TaskBoard_Server
