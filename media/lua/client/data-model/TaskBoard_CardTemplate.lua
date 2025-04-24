-- Task Data model
-- Type: CardTemplate
-- Pass by value

-- Usage:
--local card1 = createCardInstance()
--card1.title = "Build Barricades"

--local card2 = createCardInstance()
--card2.title = "Search for Food"

CardTemplate = {
    id = "", -- string: unique identifier (e.g. "1000000018")
    title = "", -- string: short title of the card
    description = "", -- string: longer explanation or notes

    color = "", -- string: label color (e.g. "red", "blue", "green", "purple")

    sectionID = 1, -- number: ID of the section/column (e.g. 1 = To Do, 2 = In Progress, 3 = Done)

    createdAt = "", -- string (timestamp): when card was created (real time)
    updatedAt = "", -- string (timestamp): when card was last modified (real time)
    createdAtGame = "", -- string (timestamp): when card was created (game time)
    updatedAtGame = "", -- string (timestamp): when card was last modified (game time)
    dueDate = "", -- string (e.g. "2025-04-20") or nil
    startDate = "", -- string (optional): planned start date
    completedDate = "", -- string: date when task was completed
    datesSetInRealTime = true, -- boolean: true if dates are set in real time, false if in-game time

    lastUserModifiedID = "", -- string: user ID of the last person who modified the card
    lastUserModifiedName = "", -- string: name of the last modifier
    createdByID = "", -- string: user ID of the creator
    createdByName = "", -- string: name of the creator
    assigneeID = "", -- string: ID of the person assigned to the card
    assigneeName = "", -- string: name of the assignee

    watchers = {}, -- table of string user IDs: people watching the card for updates

    priority = "", -- string: "Low", "Medium", "High", etc.
    type = "", -- string: "Task", "Bug", "Feature", etc.
    category = "", -- string: e.g. "Combat", "Crafting", "Exploration"
    tags = {}, -- table of strings: any tag names like {"combat", "urgent"}

    attachments = {}, -- table of tables: { id = "", name = "", url = "" }
    checklist = {}, -- table of tables: { id = "", text = "", completed = true/false }
    comments = {}, -- table of tables: { userID = "", userName = "", message = "", createdAt = os.time() }

    relatedCards = {}, -- table of string card IDs: other cards this one is related to
    parentCardID = "", -- string: ID of parent/epic card, if applicable
    dependencies = {}, -- table of string card IDs: tasks this one depends on

    status = "", -- string: "Requested", "In Progress", "Done"

    customFields = {
        estimateHours = 0, -- number: estimated time in hours
        difficulty = "", -- string: "Easy", "Medium", "Hard"
        xpReward = 0 -- number: custom reward points (e.g., XP)
    },

    automationRules = {} -- table of rule objects: { trigger = "", action = "", params = {} }
}

function createCardInstance()
    local function deepCopy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for k, v in pairs(orig) do
                copy[k] = deepCopy(v)
            end
        else
            copy = orig
        end
        return copy
    end

    return deepCopy(CardTemplate)
end
