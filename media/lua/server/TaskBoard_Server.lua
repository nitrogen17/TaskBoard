MODDATA_KEY = "KB.KanbanBoard"

Events.OnClientCommand.Add(function(module, command, player, task)
    if module ~= MODDATA_KEY then return end

    local db = ModData.getOrCreate(MODDATA_KEY)

    if command == "CreateTask" then
        TaskBoard_Core.create(task)

    elseif command == "UpdateTask" then
        TaskBoard_Core.update(task)

    elseif command == "DeleteTask" then
        TaskBoard_Core.delete(task)

    elseif command == "ReloadAllTables" then
        TaskBoard_Core.reloadAllTables(player)
    end
end)