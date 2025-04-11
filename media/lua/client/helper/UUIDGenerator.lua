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

function generateUUIDWithRetries(tbl, maxRetries)
    local retryCount = 0
    local value = tostring(ZombRand(1000000000, 9999999999)) -- Start with a random value

    while retryCount < maxRetries do
        local found = false

        -- Check if the value exists in the table
        for _, val in pairs(tbl) do
            if val == value then
                found = true
                break
            end
        end

        if not found then
            -- Value not found, return it
            return value
        else
            -- Value exists, increment retry count and generate a new value
            retryCount = retryCount + 1
            print("[$$] Attempt " .. retryCount .. ": Value exists. Retrying...")
            value = tostring(ZombRand(1000000000, 9999999999))
        end
    end

    -- Max retries exceeded
    return nil
end