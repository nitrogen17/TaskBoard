require('TaskBoard_Core')
require('TaskBoard_Server')
require('TaskBoard_Utils')

local function onMakeTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    local modData = TaskBoard_Core.fetchModData(furniture)
    modData.isTaskBoard = true
    modData.tasks = {}
    modData.boardTitle = TaskBoard_Utils.getFurnitureName(furniture) .. " Task Board"
    -- more data here to create.

    furniture:transmitModData()
    TaskBoard_Utils.openTaskBoard(furniture)

    getPlayer():Say("I created a task board here.")
end

local function onConfirmRemoveTaskBoard(worldobjects, square, furniture)
    if not furniture then return end

    local modData = TaskBoard_Core.fetchModData(furniture)
    modData.isTaskBoard = nil
    modData.tasks = nil
    -- more data here to remove.

    furniture:transmitModData()
    TaskBoard_Utils.closeTaskBoardMainWindow()
    TaskBoard_Core.sendTaskCommand("TaskBoardDeleted", furniture)

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

local function onPreFillWorldObjectContextMenu(playerNum, context, worldobjects, test)
    local player = getPlayer(playerNum)
    local processedObjects = {}
    for _, object in ipairs(worldobjects) do
        if object and instanceof(object, "IsoObject") and not processedObjects[object] then
            processedObjects[object] = true
            local modData = TaskBoard_Core.fetchModData(object)
            local square = object:getSquare()

            if TaskBoard_Utils.isWithinRange(player, square, 1) then
                local currentName = "Error Fetching Name"
                local isTaskBoardAble = TaskBoard_Utils.isFurnitureWhitelisted(object) and not modData.isTaskBoard
                local isTaskBoard = modData.isTaskBoard
                if isTaskBoardAble or isTaskBoard then
                    currentName = TaskBoard_Utils.getFurnitureName(object)
                end
                if isTaskBoardAble then
                    context:addOption("Make Task Board (" .. currentName .. ")", worldobjects, onMakeTaskBoard, square, object)
                end
                if isTaskBoard then
                    context:addOption("Open Task Board (" .. currentName .. ")", object, TaskBoard_Utils.openTaskBoard, object)
                    context:addOption("Remove Task Board (" .. currentName .. ")", worldobjects, onRemoveTaskBoard, square, object)
                end
            end
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(onPreFillWorldObjectContextMenu)
