-- MISCollapsableWindow
-- MISPanel

-- Prerequisite: Pass by reference
-- Debug: 
-- panel.backgroundColor = {r=0, g=0, b=1, a=1}

require('ISUI/ISPanel')

function printhere()
    print("Print Here!")
end

function main()
    drawKanbanBoard()

    function drawKanbanBoard()
        local mainWindow = drawMainWindow()
        drawAllSections(mainWindow)
    end
    
    function drawAllSections(mainWindow)
        local sectionHeaderPanel = drawSectionHeaderPanel(mainWindow)
    
        local leftSection = drawLeftSection(mainWindow, sectionHeaderPanel)
        local middleSection = drawMiddleSection(mainWindow, leftSection)
        drawRightSection(mainWindow, middleSection)
    end
    
    function drawMainWindow() 
        local mainWindow = MISCollapsableWindow:new(0, 0, getCore():getScreenWidth() * 0.5, getCore():getScreenHeight() * 0.6)
        mainWindow:setX((getCore():getScreenWidth() * 0.5) - (mainWindow:getWidth() * 0.5))
        mainWindow:setY((getCore():getScreenHeight() * 0.5) - (mainWindow:getHeight() * 0.5))
    
        mainWindow:initialise()
        mainWindow:addToUIManager()
    
        return mainWindow
    end
    
    function drawSectionHeaderPanel(mainWindow) 
        local sectionHeaderPanel = ISPanel:new(0, mainWindow:titleBarHeight(), mainWindow.width, mainWindow:titleBarHeight() * 2)
        sectionHeaderPanel:initialise()
        sectionHeaderPanel.backgroundColor = {r=0, g=0, b=0, a=1}
        mainWindow:addChild(sectionHeaderPanel)
    
        local leftHeaderSection = drawLeftHeaderSection(mainWindow)
        local middleHeaderSection = drawMiddleHeaderSection(mainWindow, leftHeaderSection)
        drawRightHeaderSection(mainWindow, middleHeaderSection)
    
        return sectionHeaderPanel
    end
    
    function drawLeftHeaderSection(mainWindow)
        local sectionLeftHeaderPanel = MISPanel:new(0, mainWindow:titleBarHeight(), mainWindow.width / 3, mainWindow:titleBarHeight() * 2)
        sectionLeftHeaderPanel:initialise()
        sectionLeftHeaderPanel:setTitle("To Do")
    
        mainWindow:addChild(sectionLeftHeaderPanel)
        
        return sectionLeftHeaderPanel
    end
    
    function drawMiddleHeaderSection(mainWindow, leftHeaderSection) 
        local sectionMiddleHeaderPanel = MISPanel:new(leftHeaderSection:getWidth(), mainWindow:titleBarHeight(), mainWindow.width / 3, mainWindow:titleBarHeight() * 2)
        sectionMiddleHeaderPanel:initialise()
        sectionMiddleHeaderPanel:setTitle("In Progress")
        mainWindow:addChild(sectionMiddleHeaderPanel)
    
        return sectionMiddleHeaderPanel
    end
    
    function drawRightHeaderSection(mainWindow, middleHeaderSection) 
        local sectionRightHeaderPanel = MISPanel:new(middleHeaderSection:getWidth() * 2, mainWindow:titleBarHeight(), mainWindow.width / 3, mainWindow:titleBarHeight() * 2)
        sectionRightHeaderPanel:initialise()
        sectionRightHeaderPanel:setTitle("Done")
        mainWindow:addChild(sectionRightHeaderPanel)
    end
    
    function drawLeftSection(mainWindow, sectionHeaderPanel)
        local childLeftPanel = ISPanel:new(0, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindow.width / 3, mainWindow.height - (mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight()))
        childLeftPanel:initialise()
    
        local leftListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
        leftListBox:initialise()
    
        childLeftPanel:addChild(leftListBox)
        mainWindow:addChild(childLeftPanel)
        
        return childLeftPanel
    end
    
    function drawMiddleSection(mainWindow, leftSection)
        local childMiddlePanel = ISPanel:new(mainWindow.width / 3, leftSection:getY(), mainWindow.width / 3, leftSection:getHeight())
        childMiddlePanel:initialise()
    
        local middleListBox = MISScrollingListBox:new(0, 0, childMiddlePanel:getWidth(), childMiddlePanel:getHeight())
        middleListBox:initialise()
    
        childMiddlePanel:addChild(middleListBox)
        mainWindow:addChild(childMiddlePanel)
    
        return childMiddlePanel
    end
    
    function drawRightSection(mainWindow, middleSection)
        local childRightPanel = ISPanel:new((mainWindow.width / 3) * 2, middleSection:getY(), mainWindow.width / 3, middleSection:getHeight())
        childRightPanel:initialise()
    
        local rightListBox = MISScrollingListBox:new(0, 0, childRightPanel:getWidth(), childRightPanel:getHeight())
        rightListBox:initialise()
    
        childRightPanel:addChild(rightListBox)
        mainWindow:addChild(childRightPanel)
    end
end

