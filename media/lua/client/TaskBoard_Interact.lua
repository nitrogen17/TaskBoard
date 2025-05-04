require("TaskBoard_Utils")

local function onInteractKeyPressed(key)
    if key == getCore():getKey("Interact") then
        local player = getPlayer()
        local square = player:getSquare()

        if not square or player:isPerformingAnAction() then return end

        local objects = square:getObjects()
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            if object:getModData().isTaskBoard then
                TaskBoard_Utils.onOpenTaskBoard(object)
                return
            end
        end
    end
end

Events.OnKeyPressed.Add(onInteractKeyPressed)