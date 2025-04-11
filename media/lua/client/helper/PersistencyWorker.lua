-- Define the PersistencyManager class
PersistencyManager = {}

-- Initialize the data table
PersistencyManager.data = ModData.getOrCreate("MyMod_TaskList")

-- CREATE / ADD a single task
function PersistencyManager.createTask(task)
    print("[DEBUG] perform createTask")
    if PersistencyManager.data.tasks == nil then
        PersistencyManager.data.tasks = {}
    end

    local now = os.date("!%Y-%m-%dT%H:%M:%SZ")
    task.createdAt = now
    task.updatedAt = now

    table.insert(PersistencyManager.data.tasks, task)
end


-- READ all tasks
function PersistencyManager.readTasks()
    print("[DEBUG] perform readTasks")
    for _, task in ipairs(PersistencyManager.data.tasks) do
        print(string.format([[
ID: %s
Title: %s
Description: %s
Status: %s
Color: %s
SectionID: %d
Created At: %s
Updated At: %s
Last Modified by: %s (%s)

]], 
        task.id, task.title, task.description, task.status, task.color, task.sectionID, task.createdAt, task.updatedAt, task.lastUserModifiedName, task.lastUserModifiedID))
    end
end

-- READ a task by ID
function PersistencyManager.readById(taskId)
    print("[DEBUG] perform readById: ", taskId)
    for _, task in ipairs(PersistencyManager.data.tasks) do
        if task.id == taskId then
            print(string.format([[
ID: %s
Title: %s
Description: %s
Status: %s
Color: %s
SectionID: %d
Created At: %s
Updated At: %s
Last Modified by: %s (%s)

]], 
            task.id, task.title, task.description, task.status, task.color, task.sectionID, task.createdAt, task.updatedAt, task.lastUserModifiedName, task.lastUserModifiedID))
            return
        end
    end
    print("[DEBUG] Task with ID " .. taskId .. " not found.")
end

-- UPDATE a task by ID
function PersistencyManager.updateTaskById(taskId, updatedFields)
    print("[DEBUG] perform updateTaskById: ", taskId)
    for _, task in ipairs(PersistencyManager.data.tasks) do
        if task.id == taskId then
            for key, value in pairs(updatedFields) do
                task[key] = value
            end
            task.updatedAt = os.date("!%Y-%m-%dT%H:%M:%SZ")
            print("Updated task with ID " .. taskId)
            return
        end
    end
    print("[DEBUG] Task with ID " .. taskId .. " not found for update.")
end

-- DELETE a task by ID
function PersistencyManager.deleteTaskById(taskId)
    print("[DEBUG] perform deleteTaskByID: ", taskId)
    for i = #PersistencyManager.data.tasks, 1, -1 do
        if PersistencyManager.data.tasks[i].id == taskId then
            table.remove(PersistencyManager.data.tasks, i)
            print("Deleted task with ID " .. taskId)
            return
        end
    end
    print("[DEBUG] Task with ID " .. taskId .. " not found for deletion.")
end

return PersistencyWorker