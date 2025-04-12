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
            title = "Scout the Area",
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
            title = "Barricade Base",
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
            title = "Collect Rainwater",
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
            title = "Scavenge Grocery Store",
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
            title = "Repair Broken Door",
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
            title = "Refuel Generator",
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
            title = "Explore Hardware Store",
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
            title = "Cook Dinner",
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
            title = "Clean Up Blood",
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
            title = "Set Up Perimeter Traps",
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
            title = "Patch Roof Holes",
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
            title = "Organize Medical Supplies",
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
            title = "Check Radio for Broadcasts",
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
            title = "Harvest Crops",
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
            title = "Check Water Supply",
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
            title = "Craft More Bandages",
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
            title = "Secure Second Floor",
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
            title = "Train with Melee Weapons",
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
            title = "Reinforce Main Gate",
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
            title = "Build Compost Bin",
            description = "Start converting waste into fertilizer.",
            color = "green",
            sectionID = 3,
            tableIndex = 20,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1253",
            lastUserModifiedName = "Nova",
            status = "Done"
        },
        {
            id = "1000000021",
            title = "Make Noise Trap",
            description = "Create a sound distraction for zombies.",
            color = "orange",
            sectionID = 1,
            tableIndex = 21,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1254",
            lastUserModifiedName = "Kai",
            status = "Requested"
        },
        {
            id = "1000000022",
            title = "Clear Nearby Forest",
            description = "Cut trees for wood and improve sightlines.",
            color = "blue",
            sectionID = 2,
            tableIndex = 22,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1255",
            lastUserModifiedName = "Sage",
            status = "In Progress"
        },
        {
            id = "1000000023",
            title = "Set Up Storage Room",
            description = "Organize all food and supplies in one place.",
            color = "purple",
            sectionID = 1,
            tableIndex = 23,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1256",
            lastUserModifiedName = "Drew",
            status = "Requested"
        },
        {
            id = "1000000024",
            title = "Clean Water Filters",
            description = "Ensure filters are working properly.",
            color = "green",
            sectionID = 3,
            tableIndex = 24,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1257",
            lastUserModifiedName = "Quinn",
            status = "Done"
        },
        {
            id = "1000000025",
            title = "Rescue Trapped Survivor",
            description = "Check gas station basement for signs of life.",
            color = "red",
            sectionID = 2,
            tableIndex = 25,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1258",
            lastUserModifiedName = "Rae",
            status = "In Progress"
        },
        {
            id = "1000000026",
            title = "Craft Metal Barriers",
            description = "Forge makeshift armor for windows.",
            color = "blue",
            sectionID = 2,
            tableIndex = 26,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1259",
            lastUserModifiedName = "Blake",
            status = "In Progress"
        },
        {
            id = "1000000027",
            title = "Build Chicken Coop",
            description = "Raise chickens for sustainable food.",
            color = "green",
            sectionID = 3,
            tableIndex = 27,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1260",
            lastUserModifiedName = "Harper",
            status = "Done"
        },
        {
            id = "1000000028",
            title = "Map Local Area",
            description = "Document roads, buildings, and threats.",
            color = "purple",
            sectionID = 1,
            tableIndex = 28,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1261",
            lastUserModifiedName = "Jordan",
            status = "Requested"
        },
        {
            id = "1000000029",
            title = "Craft Herbal Medicine",
            description = "Use foraged herbs to create remedies.",
            color = "green",
            sectionID = 3,
            tableIndex = 29,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1262",
            lastUserModifiedName = "Emery",
            status = "Done"
        },
        {
            id = "1000000030",
            title = "Dig Latrine",
            description = "Set up a proper outdoor toilet system.",
            color = "blue",
            sectionID = 2,
            tableIndex = 30,
            createdAt = now,
            updatedAt = now,
            lastUserModifiedID = "1263",
            lastUserModifiedName = "Charlie",
            status = "In Progress"
        }
    }    

    for _, todo in ipairs(mockTodos) do
        PersistencyManager.createTodo(todo)
    end
end

return PersistencyManager