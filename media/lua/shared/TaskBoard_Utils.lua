TaskBoard_Utils = {}

TaskBoard_mainWindowFurniture = nil

function TaskBoard_Utils.getCurrentGameTime()
    return string.format(
        "%04d-%02d-%02dT%02d:%02d:00Z",
        getGameTime():getYear(),
        getGameTime():getMonth() + 1,
        getGameTime():getDay(),
        getGameTime():getHour(),
        getGameTime():getMinutes()
    )
end

function TaskBoard_Utils.getCurrentRealTime()
    return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

function TaskBoard_Utils.getCharacterName(player)
    local playerDescriptor = player:getDescriptor()
    local fullName = playerDescriptor:getForename() .. " " .. playerDescriptor:getSurname()
    return fullName:match("^%s*(.-)%s*$") -- Trim leading and trailing whitespaces
end

function TaskBoard_Utils.setMainWindowFurniture(furniture)
    TaskBoard_mainWindowFurniture = furniture -- refactor?
end

function TaskBoard_Utils.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = TaskBoard_Utils.deepCopy(v)
        end
    else
        copy = orig
    end
    return copy
end

function TaskBoard_Utils.isFurnitureWhitelisted(furniture)
    if not furniture then return false end

    local sprite = furniture:getSprite()
    if sprite then
        local spriteName = sprite:getName()
        for _, allowedSpriteName in ipairs(TaskBoard_allowedTaskBoardFurnitures) do
            if spriteName == allowedSpriteName then
                return true
            end
        end
    end

    return false
end

function TaskBoard_Utils.onOpenTaskBoard(furniture)
    if not furniture then return end

    TaskBoard_Core.reloadAllTables(getPlayer(), furniture)
    TaskBoard_mainWindow:setVisible(true)
end

function TaskBoard_Utils.getFurnitureName(furniture)
    if not furniture then return "Unknown Furniture" end

    local sprite = furniture:getSprite()
    if sprite then
        local translationKey = sprite:getProperties():Val("CustomName")
        if translationKey then
            local translatedName = getText(translationKey)
            if translatedName and translatedName ~= "" then
                return translatedName
            end
        end

        return sprite:getName()
    end

    return "Unknown Furniture"
end

return TaskBoard_Utils
