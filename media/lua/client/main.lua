require('ISUI/ISPanel')

local PersistencyManager = require("helper/PersistencyManager")

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

    renderDataToSections() 
end

function renderDataToSections() 
    for id, todo in pairs(PersistencyManager.fetchTodos()) do
        if todo.sectionID == 1 then
            leftListBox:addItem(todo.title, todo)
        elseif todo.sectionID == 2 then
            middleListBox:addItem(todo.title, todo)
        elseif todo.sectionID == 3 then
            rightListBox:addItem(todo.title, todo)
        end
    end
end

function clearDataToSections()
    leftListBox.items = {}
    leftListBox.tableTasks = {}

    middleListBox.items = {}
    middleListBox.tableTasks = {}

    rightListBox.items = {}
    rightListBox.tableTasks = {}
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
    sectionLeftHeaderPanel:setTitle("To Do")
    mainWindow:addChild(sectionLeftHeaderPanel)
end

function drawMiddleHeaderSection() 
    sectionMiddleHeaderPanel = MISPanel:new(sectionLeftHeaderPanel:getWidth(), mainWindow:titleBarHeight(), mainWindowSplitIntoThree, mainWindow:titleBarHeight() * 2)
    sectionMiddleHeaderPanel:initialise()
    sectionMiddleHeaderPanel:setTitle("In Progress")
    mainWindow:addChild(sectionMiddleHeaderPanel)
end

function drawRightHeaderSection() 
    sectionRightHeaderPanel = MISPanel:new(sectionLeftHeaderPanel:getWidth() * 2, mainWindow:titleBarHeight(), mainWindowSplitIntoThree, mainWindow:titleBarHeight() * 2)
    sectionRightHeaderPanel:initialise()
    sectionRightHeaderPanel:setTitle("Done")
    mainWindow:addChild(sectionRightHeaderPanel)
end

function drawLeftSection()
    childLeftPanel = ISPanel:new(0, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childLeftPanel:initialise()
    --childLeftPanel.backgroundColor = {r=0.3, g=0, b=0, a=1}

    leftListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    leftListBox:initialise()

    childLeftPanel:addChild(leftListBox)
    mainWindow:addChild(childLeftPanel)
end

function drawMiddleSection()
    childMiddlePanel = ISPanel:new(mainWindowSplitIntoThree, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childMiddlePanel:initialise()

    middleListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    middleListBox:initialise()

    childMiddlePanel:addChild(middleListBox)
    mainWindow:addChild(childMiddlePanel)
end

function drawRightSection()
    childRightPanel = ISPanel:new(mainWindowSplitIntoThree * 2, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childRightPanel:initialise()

    rightListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    rightListBox:initialise()

    childRightPanel:addChild(rightListBox)
    mainWindow:addChild(childRightPanel)
end