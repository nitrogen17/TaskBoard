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

return TaskBoard_Utils
