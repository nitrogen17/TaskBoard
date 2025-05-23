require("TaskBoard_Core")
require("TaskBoard_Utils")

local function onInteractKeyPressed(key)
    local useInteractKey = SandboxVars.TaskBoard.UseInteractKeyWithTaskBoards
    if not useInteractKey then return end

    if key == getCore():getKey("Interact") then
        local player = getPlayer()
        local square = player:getSquare()

        if not square or player:isPerformingAnAction() then return end

        local objects = square:getObjects()
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            if TaskBoard_Core.fetchModData(object).isTaskBoard then
                TaskBoard_Utils.openTaskBoard(object)
                return
            end
        end
    end
end

Events.OnKeyPressed.Add(onInteractKeyPressed)
