-- Keyboard Reference: 
-- https://theindiestone.com/forums/index.php?/topic/9799-key-code-reference/

function onCustomUIKeyPressed(key)
    if key == 22 then
        print("[Debug] press key 22")

        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
            sendClientCommand(MODDATA_KEY, "ReloadAllTables", {})
        else
            mainWindow = nil
        end
    end

    -- if key == 25 then
    --     print("[Debug] press key 25")
    -- end

    -- if key == 26 then
    --     print("[Debug] press key 26")
    --     sendClientCommand(MODDATA_KEY, "UpdateTask", task)
    -- end

    -- if key == 27 then
    --     print("[Debug] press key 27")
    --     sendClientCommand(MODDATA_KEY, "DeleteTask", { id = taskID })
    -- end

    -- if key == 43 then
    --     print("[Debug] press key 43")
    --     sendClientCommand(MODDATA_KEY, "RequestAllTasks", {})
    -- end

    -- if key == 40 then
    --     print("[Debug] press key 40")
    --     sendClientCommand(MODDATA_KEY, "DeleteAllTasks", {})
    -- end
end
