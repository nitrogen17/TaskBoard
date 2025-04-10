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

    mainWindowSplitIntoThree = mainWindow.width / 3
    
    mainWindow:initialise();
    mainWindow:addToUIManager();
end

function drawSectionHeaderPanel() 
    sectionHeaderPanel = ISPanel:new(0, mainWindow:titleBarHeight(), mainWindow.width, mainWindow:titleBarHeight() * 2)
    sectionHeaderPanel:initialise()
    sectionHeaderPanel.backgroundColor = {r=0, g=0, b=0, a=1}
    mainWindow:addChild(sectionHeaderPanel)

    drawLeftHeaderSection()
    drawMiddleHeaderSection()
    drawRightHeaderSection() 
end

function drawLeftHeaderSection()
    sectionLeftHeaderPanel = MISPanel:new(0, mainWindow:titleBarHeight(), mainWindowSplitIntoThree, mainWindow:titleBarHeight() * 2)
    sectionLeftHeaderPanel:initialise()
    sectionLeftHeaderPanel:setTitle("Hello World!")
    mainWindow:addChild(sectionLeftHeaderPanel)
end

function drawMiddleHeaderSection() 
    sectionMiddleHeaderPanel = ISPanel:new(sectionLeftHeaderPanel:getWidth(), mainWindow:titleBarHeight(), mainWindowSplitIntoThree, mainWindow:titleBarHeight() * 2)
    sectionMiddleHeaderPanel:initialise()
    mainWindow:addChild(sectionMiddleHeaderPanel)
end

function drawRightHeaderSection() 
    sectionRightHeaderPanel = ISPanel:new(sectionLeftHeaderPanel:getWidth() * 2, mainWindow:titleBarHeight(), mainWindowSplitIntoThree, mainWindow:titleBarHeight() * 2)
    sectionRightHeaderPanel:initialise()
    mainWindow:addChild(sectionRightHeaderPanel)
end

function drawLeftSection()
    childLeftPanel = ISPanel:new(0, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childLeftPanel:initialise()
    --childLeftPanel.backgroundColor = {r=0.3, g=0, b=0, a=1}
    mainWindow:addChild(childLeftPanel)
end

function drawMiddleSection()
    childMiddlePanel = ISPanel:new(mainWindowSplitIntoThree, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childMiddlePanel:initialise()
    mainWindow:addChild(childMiddlePanel)
end

function drawRightSection()
    childRightPanel = ISPanel:new(mainWindowSplitIntoThree * 2, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childRightPanel:initialise()
    mainWindow:addChild(childRightPanel)
end