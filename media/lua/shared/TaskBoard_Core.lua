TaskBoard_Core = {}

TaskBoard_allowedTaskBoardFurnitures = {
    "location_business_office_generic_01_7",
    "location_business_office_generic_01_15",
    "location_business_office_generic_01_36",
    "location_business_office_generic_01_37",
    "location_business_office_generic_01_38",
    "location_business_office_generic_01_39",
    "location_business_office_generic_01_53",
    "location_business_office_generic_01_54",
    "location_business_office_generic_01_55",
    "location_business_office_generic_01_50",
    "location_business_office_generic_01_51",
    "location_business_office_generic_01_52",
}

local function generateUUID(furniture)
    local modData = TaskBoard_Core.fetchModData(furniture)
    modData.tasks = modData.tasks or {}

    local function padWithZeros(num)
        return string.format("%010d", num)
    end

    for i = 1, 1000 do
        local id = padWithZeros(ZombRand(0, 1000000000))
        if not modData.tasks[id] then return id end
    end

    error("Failed to generate a unique ID after 1000 attempts.")
end

local function addTasksToListBox(tasks, listBox)
    listBox:clear()
    listBox.tableTasks = {}

    table.sort(tasks, function(a, b)
        return a.updatedAt > b.updatedAt
    end)

    for _, task in ipairs(tasks) do
        listBox:addItem(task)
    end
end

local function reloadAllTablesInClient(furniture)
    if not furniture then return end

    local tasks = TaskBoard_Core.fetchModData(furniture).tasks or {}

    local sectionMap = {
        [1] = {},
        [2] = {},
        [3] = {}
    }

    for _, task in pairs(tasks) do
        if sectionMap[task.sectionID] then
            table.insert(sectionMap[task.sectionID], task)
        end
    end

    addTasksToListBox(sectionMap[1], kb_leftListBox)
    addTasksToListBox(sectionMap[2], kb_middleListBox)
    addTasksToListBox(sectionMap[3], kb_rightListBox)
end

local function processTaskAction(furniture, action, task)
    local modData = TaskBoard_Core.fetchModData(furniture)
    modData.tasks = modData.tasks or {}

    if action == "CreateTask" then
        task.id = generateUUID(furniture)
        modData.tasks[task.id] = task
    elseif action == "UpdateTask" and task.id then
        modData.tasks[task.id] = task
    elseif action == "DeleteTask" and task.id then
        modData.tasks[task.id] = nil
    end

    if TaskBoard_Utils.isSinglePlayer() then
        reloadAllTablesInClient(furniture)
    end
end

function TaskBoard_Core.reloadAllTables(player, furniture)
    if not furniture then return end

    TaskBoard_mainWindowFurniture = furniture
    reloadAllTablesInClient(furniture)
end

function TaskBoard_Core.create(furniture, task)
    if not furniture then return end

    processTaskAction(furniture, "CreateTask", task)
    TaskBoard_Core.sendTaskCommand("TaskBoardTaskUpdated", furniture, "CreateTask", task)
end

function TaskBoard_Core.update(furniture, task)
    if not furniture or not task.id then return end

    processTaskAction(furniture, "UpdateTask", task)
    TaskBoard_Core.sendTaskCommand("TaskBoardTaskUpdated", furniture, "UpdateTask", task)
end

function TaskBoard_Core.delete(furniture, task)
    if not furniture or not task.id then return end

    processTaskAction(furniture, "DeleteTask", task)
    TaskBoard_Core.sendTaskCommand("TaskBoardTaskUpdated", furniture, "DeleteTask", task)
end


function TaskBoard_Core.sendTaskCommand(command, furniture, action, task)
    local square = furniture:getSquare()
    if not square then return end

    local data = {
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
        action = action,
        task = task
    }

    if isClient() then
        sendClientCommand("TaskBoard", command, data)
    elseif isServer() then
        sendServerCommand("TaskBoard", command, data)
    end
end

function TaskBoard_Core.syncTaskAction(taskBoard, args)
    local modData = TaskBoard_Core.fetchModData(taskBoard)
    modData.tasks = modData.tasks or {}

    if args.action == "CreateTask" then
        modData.tasks[args.task.id] = args.task
    elseif args.action == "UpdateTask" and args.task.id then
        modData.tasks[args.task.id] = args.task
    elseif args.action == "DeleteTask" and args.task.id then
        modData.tasks[args.task.id] = nil
    end
end

function TaskBoard_Core.fetchModData(furniture)
    if not furniture then return nil end

    local modData = furniture:getModData()
    modData.movableData = modData.movableData or {}

    if not modData.movableData.isTaskBoard and modData.isTaskBoard then
        modData.movableData.isTaskBoard = modData.isTaskBoard
        modData.isTaskBoard = nil
    end
    if not modData.movableData.tasks and modData.tasks then
        modData.movableData.tasks = modData.tasks
        modData.tasks = nil
    end

    return modData.movableData
end
