-- PersistencyManager.lua

-- Note:
-- When calling ModData.getOrCreate(TABLE_NAME) multiple times with the same TABLE_NAME, 
-- it does not create a new instance each time. Instead, it ensures that we always get
-- the same table that is associated with that TABLE_NAME.

local PersistencyManager = {}
local TABLE_NAME = "MyMod_TodoList"

-- Initialize to-do map if it doesn't exist
if ModData.getOrCreate(TABLE_NAME).todos == nil then
    ModData.getOrCreate(TABLE_NAME).todos = {}
    print("Initialized to-do map!")
end

-- CREATE
function PersistencyManager.createTodo(todo)
    ModData.getOrCreate(TABLE_NAME).todos[todo.id] = todo
    print("Created task with id " .. todo.id)
end

-- FETCH
function PersistencyManager.fetchTodos()
    return ModData.getOrCreate(TABLE_NAME).todos
end

-- READ
function PersistencyManager.readTodos()
    print("Current To-Dos:")
    for id, todo in pairs(ModData.getOrCreate(TABLE_NAME).todos) do
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
            todo.id, todo.title, todo.description, todo.status, todo.color, 
            todo.sectionID, todo.createdAt, todo.updatedAt, 
            todo.lastUserModifiedName, todo.lastUserModifiedID))
    end
end

-- READ ONE
function PersistencyManager.readTodo(id)
    print("Reading todo with id " .. id)
    local todo = ModData.getOrCreate(TABLE_NAME).todos[id]
    if todo then
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
            todo.id, todo.title, todo.description, todo.status, todo.color, 
            todo.sectionID, todo.createdAt, todo.updatedAt, 
            todo.lastUserModifiedName, todo.lastUserModifiedID))
    else
        print("No task found with id " .. id)
    end
end

-- UPDATE
function PersistencyManager.updateTodo(id, fields)
    local todo = ModData.getOrCreate(TABLE_NAME).todos[id]
    if todo then
        for k, v in pairs(fields) do
            todo[k] = v
        end
        todo.updatedAt = os.date("!%Y-%m-%dT%H:%M:%SZ")
        print("Updated task " .. id)
    else
        print("Task with id " .. id .. " not found.")
    end
end

-- DELETE
function PersistencyManager.deleteTodo(id)
    print("delete this id: ", id)

    if ModData.getOrCreate(TABLE_NAME).todos[id] then
        ModData.getOrCreate(TABLE_NAME).todos[id] = nil
        print("Deleted task with id " .. id)
    else
        print("Task with id " .. id .. " not found.")
    end
end

-- DELETE ALL
function PersistencyManager.deleteAll()
    if ModData.getOrCreate(TABLE_NAME).todos then
        ModData.getOrCreate(TABLE_NAME).todos = {}
        print("Deleted all tasks.")
    else
        print("No tasks to delete.")
    end
end

-- MOCK DATA
function PersistencyManager.addMockTodos()
    local now = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local mockTodos = {
        {
            id = "1000000001",
            title = "1 - Scout the Area",
            description = "Explore the nearby houses for supplies.",
            color = "blue",
            sectionID = 1,
            tableIndex = 1,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1234",
            lastUserModifiedName = "Alex",
            status = "Requested"
        },
        {
            id = "1000000002",
            title = "2 - Barricade Base",
            description = "Use planks and nails to secure windows.",
            color = "red",
            sectionID = 2,
            tableIndex = 2,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1235",
            lastUserModifiedName = "Jamie",
            status = "In Progress"
        },
        {
            id = "1000000003",
            title = "3 - Collect Rainwater",
            description = "Set up rain collectors on the roof.",
            color = "green",
            sectionID = 3,
            tableIndex = 3,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1236",
            lastUserModifiedName = "Morgan",
            status = "Done"
        },
        {
            id = "1000000004",
            title = "4 - Scavenge Grocery Store",
            description = "Find canned goods and bottled water.",
            color = "orange",
            sectionID = 1,
            tableIndex = 4,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1237",
            lastUserModifiedName = "Nina",
            status = "Requested"
        },
        {
            id = "1000000005",
            title = "5 - Repair Broken Door",
            description = "Replace the front door of the safehouse.",
            color = "red",
            sectionID = 2,
            tableIndex = 5,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1238",
            lastUserModifiedName = "Omar",
            status = "In Progress"
        },
        {
            id = "1000000006",
            title = "6 - Refuel Generator",
            description = "Add gasoline to keep the generator running.",
            color = "blue",
            sectionID = 2,
            tableIndex = 6,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1239",
            lastUserModifiedName = "Leah",
            status = "In Progress"
        },
        {
            id = "1000000007",
            title = "7 - Explore Hardware Store",
            description = "Search for nails, hammers, and tools.",
            color = "purple",
            sectionID = 1,
            tableIndex = 7,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1240",
            lastUserModifiedName = "Zane",
            status = "Requested"
        },
        {
            id = "1000000008",
            title = "8 - Cook Dinner",
            description = "Prepare a meal using available ingredients.",
            color = "green",
            sectionID = 3,
            tableIndex = 8,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1241",
            lastUserModifiedName = "Tess",
            status = "Done"
        },
        {
            id = "1000000009",
            title = "9 - Clean Up Blood",
            description = "Sanitize the floors to prevent infection.",
            color = "red",
            sectionID = 2,
            tableIndex = 9,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1242",
            lastUserModifiedName = "Riley",
            status = "In Progress"
        },
        {
            id = "1000000010",
            title = "10 - Set Up Perimeter Traps",
            description = "Lay traps around the base for defense.",
            color = "orange",
            sectionID = 1,
            tableIndex = 10,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1243",
            lastUserModifiedName = "Jesse",
            status = "Requested"
        },
        {
            id = "1000000011",
            title = "11 - Patch Roof Holes",
            description = "Fix the leaking roof to keep out rain.",
            color = "blue",
            sectionID = 2,
            tableIndex = 11,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1244",
            lastUserModifiedName = "Taylor",
            status = "In Progress"
        },
        {
            id = "1000000012",
            title = "12 - Organize Medical Supplies",
            description = "Sort and catalog all bandages and meds.",
            color = "green",
            sectionID = 3,
            tableIndex = 12,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1245",
            lastUserModifiedName = "Sasha",
            status = "Done"
        },
        {
            id = "1000000013",
            title = "13 - Check Radio for Broadcasts",
            description = "Scan frequencies for survivor updates.",
            color = "purple",
            sectionID = 1,
            tableIndex = 13,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1246",
            lastUserModifiedName = "Milo",
            status = "Requested"
        },
        {
            id = "1000000014",
            title = "14 - Harvest Crops",
            description = "Collect tomatoes and potatoes from garden.",
            color = "green",
            sectionID = 3,
            tableIndex = 14,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1247",
            lastUserModifiedName = "Eva",
            status = "Done"
        },
        {
            id = "1000000015",
            title = "15 - Check Water Supply",
            description = "Inspect rain barrels for usable water.",
            color = "blue",
            sectionID = 2,
            tableIndex = 15,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1248",
            lastUserModifiedName = "Noah",
            status = "In Progress"
        },
        {
            id = "1000000016",
            title = "16 - Craft More Bandages",
            description = "Rip clothing to make emergency bandages.",
            color = "red",
            sectionID = 2,
            tableIndex = 16,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1249",
            lastUserModifiedName = "Ivy",
            status = "In Progress"
        },
        {
            id = "1000000017",
            title = "17 - Secure Second Floor",
            description = "Board up windows upstairs.",
            color = "orange",
            sectionID = 1,
            tableIndex = 17,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1250",
            lastUserModifiedName = "Finn",
            status = "Requested"
        },
        {
            id = "1000000018",
            title = "18 - Train with Melee Weapons",
            description = "Practice using bats and knives.",
            color = "purple",
            sectionID = 3,
            tableIndex = 18,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1251",
            lastUserModifiedName = "Aria",
            status = "Done"
        },
        {
            id = "1000000019",
            title = "19 - Reinforce Main Gate",
            description = "Add scrap metal for extra protection.",
            color = "red",
            sectionID = 2,
            tableIndex = 19,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1252",
            lastUserModifiedName = "Logan",
            status = "In Progress"
        },
        {
            id = "1000000020",
            title = "20 - Build Compost Bin",
            description = "Start converting waste into fertilizer.",
            color = "green",
            sectionID = 3,
            tableIndex = 20,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1253",
            lastUserModifiedName = "Nova",
            status = "Done"
        }
    }

    for _, todo in ipairs(mockTodos) do
        PersistencyManager.createTodo(todo)
    end
end

return PersistencyManager