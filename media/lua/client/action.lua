function onCustomUIKeyPressed(key)
    if key == 22 then
        print("$$ press key")
        
        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
        end
    end
end
