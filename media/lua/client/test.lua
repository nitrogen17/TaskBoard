require('PersistencyWorker')

function test() 
-- Example usage:
PersistencyManager.createTask({
    id = "1000000001",
    title = "Scavenge grocery store",
    description = "Find canned goods and bottled water",
    color = "orange",
    sectionID = 1,
    tableIndex = 1,
    createdAt = "2025-04-10T08:00:00Z",
    updatedAt = "2025-04-10T08:00:00Z",
    lastUserModifiedID = "2001",
    lastUserModifiedName = "Nina",
    status = "Requested"
})

PersistencyManager.createTask({
    id = "1000000002",
    title = "Repair broken door",
    description = "Replace the front door of the safehouse",
    color = "red",
    sectionID = 2,
    tableIndex = 2,
    createdAt = "2025-04-10T09:30:00Z",
    updatedAt = "2025-04-10T09:30:00Z",
    lastUserModifiedID = "2002",
    lastUserModifiedName = "Omar",
    status = "In Progress"
})

PersistencyManager.createTask({
    id = "1000000003",
    title = "Refuel generator",
    description = "Add gasoline to keep the generator running",
    color = "blue",
    sectionID = 2,
    tableIndex = 3,
    createdAt = "2025-04-10T10:15:00Z",
    updatedAt = "2025-04-10T10:15:00Z",
    lastUserModifiedID = "2003",
    lastUserModifiedName = "Leah",
    status = "In Progress"
})

PersistencyManager.createTask({
    id = "1000000004",
    title = "Explore hardware store",
    description = "Search for nails, hammers, and tools",
    color = "purple",
    sectionID = 1,
    tableIndex = 4,
    createdAt = "2025-04-10T11:00:00Z",
    updatedAt = "2025-04-10T11:00:00Z",
    lastUserModifiedID = "2004",
    lastUserModifiedName = "Zane",
    status = "Requested"
})

PersistencyManager.createTask({
    id = "1000000005",
    title = "Cook dinner",
    description = "Prepare a meal using available ingredients",
    color = "green",
    sectionID = 3,
    tableIndex = 5,
    createdAt = "2025-04-10T12:30:00Z",
    updatedAt = "2025-04-10T12:30:00Z",
    lastUserModifiedID = "2005",
    lastUserModifiedName = "Tess",
    status = "Done"
})

--PersistencyManager.readTasks()    -- Read all tasks

print("[date today]: ", os.date("!%Y-%m-%dT%H:%M:%SZ"))

PersistencyManager.readById("1000000005")  -- Read task by ID

PersistencyManager.updateTaskById("1000000005", {
    title = "Refuel backup generator",
    description = "Ensure both generators are topped off",
    status = "Done",
    color = "green",
    sectionID = 3,
    tableIndex = 3,
    updatedAt = "2025-04-11T15:00:00Z",
    lastUserModifiedID = "3001",
    lastUserModifiedName = "Alex"
})

PersistencyManager.readById("1000000005")  -- Read task by ID

--PersistencyManager.deleteTaskById("1000000006")  -- Delete task

end