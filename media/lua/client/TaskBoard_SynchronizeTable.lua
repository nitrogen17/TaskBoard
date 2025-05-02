local function onSynchronizeFurniture(object)
    if not object or TaskBoard_mainWindowFurniture ~= object or not TaskBoard_Utils.isFurnitureWhitelisted(object) then
        return
    end

    local modData = object:getModData()
    if modData.isTaskBoard then
        TaskBoard_Core.reloadAllTables(getPlayer(), object)
    end
end

Events.OnObjectModDataChanged.Add(onSynchronizeFurniture)
