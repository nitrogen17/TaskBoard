require('TaskBoard_Utils')

local function getFurnitureName(furniture)
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

local function onMakeTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    local modData = furniture:getModData()
    modData.isTaskBoard = true
    -- more data here to create.
    furniture:transmitModData()

    getPlayer():Say("I created a task board here.")
end

local function onConfirmRemoveTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    local modData = furniture:getModData()
    modData.isTaskBoard = nil
    -- more data here to remove.
    furniture:transmitModData()

    getPlayer():Say("I removed the task board here.")
end

local function onRemoveTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    local player = getPlayer()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local dialogWidth = 200
    local dialogHeight = 100
    local dialogX = (screenWidth - dialogWidth) / 2
    local dialogY = (screenHeight - dialogHeight) / 2
    local modal = ISModalDialog:new(
        dialogX, dialogY, dialogWidth, dialogHeight,
        "Are you sure? All tasks will be lost once confirmed.",
        true, nil,
        function(dialog, button)
            if button.internal == "YES" then
                onConfirmRemoveTaskBoard(worldobjects, square, furniture)
            end
        end
    )
    modal:initialise()
    modal:addToUIManager()
end

local function onOpenTaskBoard(furniture)
    if not furniture then return end

    TaskBoard_Core.reloadAllTables(getPlayer(), furniture)
    TaskBoard_mainWindow:setVisible(true)
end

local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    local square = getPlayer():getCurrentSquare()
    local processedObjects = {}
    for _, object in ipairs(worldobjects) do
        if object and instanceof(object, "IsoObject") and not processedObjects[object] then
            processedObjects[object] = true
            local modData = object:getModData()
            local currentName = getFurnitureName(object)
            local square = object:getSquare()

            if TaskBoard_Utils.isFurnitureWhitelisted(object) and not modData.isTaskBoard then
                context:addOption("Make Task Board (" .. currentName .. ")", worldobjects, onMakeTaskBoard, square, object)
            end
            if modData.isTaskBoard then
                context:addOption("Open Task Board (" .. currentName .. ")", object, onOpenTaskBoard, object)
                context:addOption("Remove Task Board (" .. currentName .. ")", worldobjects, onRemoveTaskBoard, square, object)
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
