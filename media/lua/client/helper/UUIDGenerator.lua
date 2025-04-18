-- UUID Generator
-- Parameters: (table, maxRetries)
-- Return: string / nil
-- Usage: generateUUIDWithRetries(usedUUIDs, 5)

-- local usedUUIDs = {
--     ["1234567890"] = {
--         taskName = "Build shelter",
--         status = "In Progress",
--         assignedTo = "Bob"
--     },
--     ["2345678901"] = {
--         taskName = "Find food",
--         status = "Done",
--         assignedTo = "Alice"
--     }
-- }

function generateUUIDWithRetries()
    local retryCount = 0
    local maxRetries = 5

    -- request latest tasks from the server
    -- must implement callback here before proceeding on the next lines 
    sendClientCommand(MODDATA_KEY, "RequestAllTasks", {})

    local value = tostring(ZombRand(1000000000, 9999999999)) -- Start with a random value

    while retryCount < maxRetries do
        if not kb_DataManager.tasks[value] then
            -- Value not found in the table, return it
            return value
        else
            -- Value exists, retry with a new one
            retryCount = retryCount + 1
            print("[$$] Attempt " .. retryCount .. ": Value exists. Retrying...")
            value = tostring(ZombRand(1000000000, 9999999999))
        end
    end

    -- Max retries exceeded
    return tostring(ZombRand(1000000000, 9999999999))
end