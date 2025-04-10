require('ISUI/ISPanel')

function main()
    drawKanbanBoard()
end

function drawKanbanBoard()
    drawMainWindow()
    drawAllSections()
end

function drawAllSections()
    drawSectionHeaderPanel()
    drawLeftSection()
    drawMiddleSection()
    drawRightSection()
end

function drawMainWindow() 
    mainWindow = MISCollapsableWindow:new(0, 0, getCore():getScreenWidth() * 0.5, getCore():getScreenHeight() * 0.6)
    mainWindow:setX((getCore():getScreenWidth() * 0.5) - (mainWindow:getWidth() * 0.5))
    mainWindow:setY((getCore():getScreenHeight() * 0.5) - (mainWindow:getHeight() * 0.5))
    
    mainWindow:initialise();
    mainWindow:addToUIManager();
end

function drawSectionHeaderPanel() 
    sectionHeaderPanel = ISPanel:new(0, mainWindow:titleBarHeight(), mainWindow.width, mainWindow:titleBarHeight() * 2)
    sectionHeaderPanel:initialise()
    mainWindow:addChild(sectionHeaderPanel)  
end

function drawLeftSection()
    sectionPanelWidth = sectionHeaderPanel:getWidth() / 3
    
    childLeftPanel = ISPanel:new(0, 0, sectionPanelWidth, mainWindow.height)
    childLeftPanel:initialise()
    mainWindow:addChild(childLeftPanel)
end

function drawMiddleSection()
    childMiddlePanel = ISPanel:new(sectionPanelWidth, 0, sectionPanelWidth, mainWindow.height)
    childMiddlePanel:initialise()
    mainWindow:addChild(childMiddlePanel)
end

function drawRightSection()
    childRightPanel = ISPanel:new(sectionPanelWidth * 2, 0, sectionPanelWidth, mainWindow.height)
    childRightPanel:initialise()
    mainWindow:addChild(childRightPanel)
end