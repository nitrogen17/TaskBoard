function onCustomUIKeyPressed(key)
    if key == 22 then
        print("$$ press key")

        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
        end
    end

    if key == 25 then
        print("$$ press ke 25")
        
        isWindowVisible = not isWindowVisible
        if mainWindow then
            mainWindow:setVisible(isWindowVisible)
        end
    end

    if key == 26 then
        print("$$ press key 26")
    end

    if key == 27 then
        print("$$ press key 27")
        
    end

    if key == 43 then
        print("$$ press key 43")
        
    end
end
