-- Keyboard Reference: 
-- https://theindiestone.com/forums/index.php?/topic/9799-key-code-reference/

function onCustomUIKeyPressed(key)
    if key == 22 then
        print("[Debug] press key 22")

        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
            TaskBoard_PersistencyManager.action("ReloadAllTables", task)
        else
            mainWindow = nil
        end
    end
end
