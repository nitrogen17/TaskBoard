require("TaskBoard_Server") --HMMM...

TaskBoard_Core = {}

TaskBoard_allowedTaskBoardFurnitures = {
    "location_business_office_generic_01_7",
    "location_business_office_generic_01_15",
}

local function generateUUID(furniture)
    local modData = furniture:getModData()
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

local function handleTaskAction(furniture, action, task)
    local modData = furniture:getModData()
    modData.tasks = modData.tasks or {}

    if action == "CreateTask" then
        task.id = generateUUID(furniture)
        modData.tasks[task.id] = task
    elseif action == "UpdateTask" and task.id and modData.tasks[task.id] ~= nil then
        modData.tasks[task.id] = task
    elseif action == "DeleteTask" and task.id then
        modData.tasks[task.id] = nil
    end

    furniture:transmitModData()
    TaskBoard_Server.sendPacket("TaskBoardUpdated", furniture)

    return modData.tasks
end

local function reloadAllTablesInClient(furniture)
    if not furniture then return end

    local tasks = furniture:getModData().tasks or {}

    kb_leftListBox:clear()
    kb_middleListBox:clear()
    kb_rightListBox:clear()

    kb_leftListBox.tableTasks = {}
    kb_middleListBox.tableTasks = {}
    kb_rightListBox.tableTasks = {}

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

    local function sortByUpdatedAtDesc(a, b)
        return a.updatedAt > b.updatedAt
    end

    table.sort(sectionMap[1], sortByUpdatedAtDesc)
    table.sort(sectionMap[2], sortByUpdatedAtDesc)
    table.sort(sectionMap[3], sortByUpdatedAtDesc)

    for _, task in ipairs(sectionMap[1]) do
        kb_leftListBox:addItem(task)
    end
    for _, task in ipairs(sectionMap[2]) do
        kb_middleListBox:addItem(task)
    end
    for _, task in ipairs(sectionMap[3]) do
        kb_rightListBox:addItem(task)
    end
end

function TaskBoard_Core.reloadAllTables(player, furniture)
    if not furniture then return end

    TaskBoard_mainWindowFurniture = furniture
    reloadAllTablesInClient(furniture)
end

-- Create a new task for a specific furniture
function TaskBoard_Core.create(furniture, task)
    if not furniture then return end

    handleTaskAction(furniture, "CreateTask", task)
    reloadAllTablesInClient(furniture)
end

function TaskBoard_Core.update(furniture, task)
    if not furniture or not task.id then return end

    handleTaskAction(furniture, "UpdateTask", task)
    reloadAllTablesInClient(furniture)
end

function TaskBoard_Core.delete(furniture, task)
    if not furniture or not task.id then return end

    handleTaskAction(furniture, "DeleteTask", task)
    reloadAllTablesInClient(furniture)
end
