function onCustomUIKeyPressed(key)
    if key == 22 then
        print("$$ press key")

        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
            sendClientCommand(MODDATA_KEY, "ReloadAllTables", {})
        end
    end

    if key == 25 then
        print("$$ press ke 25")
        local task = {
            id = generateUUIDWithRetries(),
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
        }
        
        sendClientCommand(MODDATA_KEY, "CreateTask", task)
    end

    if key == 26 then
        sendClientCommand(MODDATA_KEY, "UpdateTask", task)
    end

    if key == 27 then
        print("$$ press key 27")
        sendClientCommand(MODDATA_KEY, "DeleteTask", { id = taskID })
    end

    if key == 43 then
        print("$$ press key 43")
        -- sendClientCommand("SimpleModData", "SayHello", { text = "Hi Server - New!" })
        sendClientCommand(MODDATA_KEY, "RequestAllTasks", {})
    end

    if key == 40 then
        print("$$ press key 40")
        sendClientCommand(MODDATA_KEY, "DeleteAllTasks", {})
    end
end
