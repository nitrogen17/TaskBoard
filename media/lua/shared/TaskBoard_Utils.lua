require("TaskBoard_Core")

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
    return fullName:match("^%s*(.-)%s*$")
end

function TaskBoard_Utils.setMainWindowFurniture(furniture)
    TaskBoard_mainWindowFurniture = furniture
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

function TaskBoard_Utils.openTaskBoard(furniture)
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

function TaskBoard_Utils.closeTaskBoardMainWindow()
    TaskBoard_mainWindow:setVisible(false)
    TaskBoard_mainWindowFurniture = nil
end

function TaskBoard_Utils.isWithinRange(player, square, range)
    if not player or not square then return false end
    local playerSquare = player:getSquare()
    if not playerSquare then return false end

    local dx = math.abs(playerSquare:getX() - square:getX())
    local dy = math.abs(playerSquare:getY() - square:getY())
    return dx <= range and dy <= range
end

function TaskBoard_Utils.findTaskBoardOnSquare(square)
    if not square then return nil end
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if TaskBoard_Core.fetchModData(object).isTaskBoard then
            return object
        end
    end
    return nil
end

function TaskBoard_Utils.isSinglePlayer()
    return not isClient() and not isServer()
end

function TaskBoard_Utils.computeLayout(window)
    local newWidth = window:getWidth()
    local newHeight = window:getHeight()
    local titleBarHeight = window:titleBarHeight()
    local headerHeight = titleBarHeight * 2
    local widgetHeight = window:resizeWidgetHeight()
    local widgetMarginConstant = 2

    return {
        sectionWidth = newWidth / 3,
        headerHeight = headerHeight,
        availableHeight = newHeight - titleBarHeight - headerHeight - widgetHeight - widgetMarginConstant,
        newWidth = newWidth,
        newHeight = newHeight
    }
end

return TaskBoard_Utils
