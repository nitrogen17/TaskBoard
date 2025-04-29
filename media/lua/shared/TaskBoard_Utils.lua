TaskBoard_Utils = {}

function TaskBoard_Utils.getCurrentGameTime()
    return string.format(
        "%04d-%02d-%02dT%02d:%02d:00Z",
        getGameTime():getYear(),
        getGameTime():getMonth() + 1,
        getGameTime():getDay(),
        getGameTime():getHour(),
        getGameTime():getMinutes()
    )
end

function TaskBoard_Utils.getCurrentRealTime()
    return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

function TaskBoard_Utils.getCharacterName(player)
    local playerDescriptor = player:getDescriptor()
    local fullName = playerDescriptor:getForename() .. " " .. playerDescriptor:getSurname()
    return fullName:match("^%s*(.-)%s*$") -- Trim leading and trailing whitespaces
end

return TaskBoard_Utils
