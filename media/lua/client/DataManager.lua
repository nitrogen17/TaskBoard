kb_DataManager = {}

-- A table to store all tasks
kb_DataManager.tasks = {}

-- Method to add a task
function kb_DataManager.addTask(task)
    table.insert(kb_DataManager.tasks, task)
end

-- Method to get all tasks
function kb_DataManager.getAllTasks()
    return kb_DataManager.tasks
end

-- Method to print all tasks (optional utility)
function kb_DataManager.printAllTasks()
    for _, task in ipairs(kb_DataManager.tasks) do
        printTable(task)
    end
end

-- Utility to print table contents recursively
function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(prefix .. tostring(key) .. " = {")
            printTable(value, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(key) .. " = " .. tostring(value))
        end
    end
end

-- Method to get mock tasks
function kb_DataManager.getMockTasks()
    local mockTasks = {
        {
            id = "1000000011",
            title = "Fortify Base",
            description = "Nail planks on all windows and doors of the safehouse to improve defenses.",
            color = "red",
            sectionID = 1,
            createdAt = "2025-04-15T10:32:00Z",
            updatedAt = "2025-04-15T10:32:00Z",
            dueDate = "2025-04-18",
            startDate = "",
            completedDate = "",
            lastUserModifiedID = "u001",
            lastUserModifiedName = "Alex",
            createdByID = "u001",
            createdByName = "Alex",
            assigneeID = "u002",
            assigneeName = "Jordan",
            watchers = { "u003", "u004" },
            priority = "High",
            type = "Task",
            category = "Crafting",
            tags = { "base", "urgent" },
            attachments = {},
            checklist = {},
            comments = {},
            relatedCards = {},
            parentCardID = "",
            dependencies = {},
            status = "Requested",
            customFields = {
                estimateHours = 3,
                difficulty = "Medium",
                xpReward = 50
            },
            automationRules = {}
        },
        {
            id = "1000000012",
            title = "Loot Nearby Warehouse",
            description = "Gather nails, planks, and tools from the warehouse two blocks north.",
            color = "blue",
            sectionID = 2,
            createdAt = "2025-04-15T11:05:00Z",
            updatedAt = "2025-04-16T08:30:00Z",
            dueDate = "2025-04-19",
            startDate = "2025-04-16",
            completedDate = "",
            lastUserModifiedID = "u002",
            lastUserModifiedName = "Jordan",
            createdByID = "u001",
            createdByName = "Alex",
            assigneeID = "u002",
            assigneeName = "Jordan",
            watchers = { "u001" },
            priority = "Medium",
            type = "Task",
            category = "Exploration",
            tags = { "loot", "supplies" },
            attachments = {},
            checklist = {},
            comments = {},
            relatedCards = {},
            parentCardID = "",
            dependencies = {},
            status = "In Progress",
            customFields = {
                estimateHours = 2,
                difficulty = "Easy",
                xpReward = 30
            },
            automationRules = {}
        },
        {
            id = "1000000013",
            title = "Clear Nearby Zombies",
            description = "Clear zombies lurking near the parking lot to ensure safe travel routes.",
            color = "purple",
            sectionID = 2,
            createdAt = "2025-04-15T12:20:00Z",
            updatedAt = "2025-04-16T09:15:00Z",
            dueDate = "",
            startDate = "2025-04-16",
            completedDate = "",
            lastUserModifiedID = "u003",
            lastUserModifiedName = "Sam",
            createdByID = "u001",
            createdByName = "Alex",
            assigneeID = "u003",
            assigneeName = "Sam",
            watchers = {},
            priority = "High",
            type = "Task",
            category = "Combat",
            tags = { "combat", "dangerous" },
            attachments = {},
            checklist = {},
            comments = {},
            relatedCards = {},
            parentCardID = "",
            dependencies = {},
            status = "In Progress",
            customFields = {
                estimateHours = 1,
                difficulty = "Hard",
                xpReward = 80
            },
            automationRules = {}
        },
        {
            id = "1000000014",
            title = "Build Rain Collector Barrels",
            description = "Construct at least 2 rain collectors for future water needs.",
            color = "green",
            sectionID = 3,
            createdAt = "2025-04-14T15:45:00Z",
            updatedAt = "2025-04-16T13:00:00Z",
            dueDate = "2025-04-16",
            startDate = "2025-04-15",
            completedDate = "2025-04-16",
            lastUserModifiedID = "u002",
            lastUserModifiedName = "Jordan",
            createdByID = "u001",
            createdByName = "Alex",
            assigneeID = "u002",
            assigneeName = "Jordan",
            watchers = { "u004" },
            priority = "Medium",
            type = "Feature",
            category = "Crafting",
            tags = { "water", "sustainability" },
            attachments = {},
            checklist = {},
            comments = {},
            relatedCards = {},
            parentCardID = "",
            dependencies = {},
            status = "Done",
            customFields = {
                estimateHours = 1,
                difficulty = "Easy",
                xpReward = 25
            },
            automationRules = {}
        },
        {
            id = "1000000015",
            title = "Assign Guard Duty",
            description = "Organize team members to rotate guard shifts overnight.",
            color = "orange",
            sectionID = 1,
            createdAt = "2025-04-15T18:00:00Z",
            updatedAt = "2025-04-15T18:00:00Z",
            dueDate = "2025-04-17",
            startDate = "",
            completedDate = "",
            lastUserModifiedID = "u004",
            lastUserModifiedName = "Chris",
            createdByID = "u001",
            createdByName = "Alex",
            assigneeID = "u004",
            assigneeName = "Chris",
            watchers = { "u001", "u003" },
            priority = "Low",
            type = "Task",
            category = "Survival",
            tags = { "night", "security" },
            attachments = {},
            checklist = {},
            comments = {},
            relatedCards = {},
            parentCardID = "",
            dependencies = {},
            status = "Requested",
            customFields = {
                estimateHours = 1,
                difficulty = "Medium",
                xpReward = 20
            },
            automationRules = {}
        }
    }

    return mockTasks
end

return kb_DataManager
