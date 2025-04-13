-- Simplified Task Data model
-- Type: CardTemplate
-- Pass by value

-- Usage: 
-- local card = createCardInstance()
-- card.title = "Build Compost Bin"
local now = os.date("!%Y-%m-%dT%H:%M:%SZ")

CardTemplate = {
    id = "", -- string: unique identifier
    title = "", -- string: short title of the card
    description = "", -- string: longer explanation or notes
    color = "", -- string: label color (e.g. "green")
    sectionID = 0, -- number: section/column ID
    tableIndex = 0, -- number: position in the column
    createdAt = now, -- number: timestamp of creation
    updatedAt = now, -- number: timestamp of last update
    lastUserModifiedID = "", -- string: user ID
    lastUserModifiedName = "", -- string: user name
    status = "" -- string: task status ("Requested", "In Progress", "Done")
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
