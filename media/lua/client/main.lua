require('ISUI/ISPanel')

local PersistencyManager = require("helper/PersistencyManager")
local ISPlusIcon = require('client-ui/ISPanel/ISPlusIcon')

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
    local leftTodos = {}
    local middleTodos = {}
    local rightTodos = {}

    -- Group todos by section
    for _, todo in pairs(PersistencyManager.fetchTodos()) do
        if todo.sectionID == 1 then
            table.insert(leftTodos, todo)
        elseif todo.sectionID == 2 then
            table.insert(middleTodos, todo)
        elseif todo.sectionID == 3 then
            table.insert(rightTodos, todo)
        end
    end

    -- -- Sort function by updatedAt descending
    -- local function sortByUpdatedAtDesc(a, b)
    --     return a.updatedAt > b.updatedAt
    -- end

    -- table.sort(leftTodos, sortByUpdatedAtDesc)
    -- table.sort(middleTodos, sortByUpdatedAtDesc)
    -- table.sort(rightTodos, sortByUpdatedAtDesc)

    -- Sort function by updatedAt ascending (older updates first, newer last)
    local function sortByUpdatedAtAsc(a, b)
        return a.updatedAt < b.updatedAt
    end

    table.sort(leftTodos, sortByUpdatedAtAsc)
    table.sort(middleTodos, sortByUpdatedAtAsc)
    table.sort(rightTodos, sortByUpdatedAtAsc)


    -- Clear existing items (optional, if your UI requires it)
    leftListBox:clear()
    middleListBox:clear()
    rightListBox:clear()

    -- Add sorted items to each list
    for _, todo in ipairs(leftTodos) do
        leftListBox:addItem(todo.title, todo)
    end
    for _, todo in ipairs(middleTodos) do
        middleListBox:addItem(todo.title, todo)
    end
    for _, todo in ipairs(rightTodos) do
        rightListBox:addItem(todo.title, todo)
    end

    -- Scroll to bottom of each list
    -- leftListBox.scrollPosition = #leftTodos * leftListBox.itemheight
    -- middleListBox.scrollPosition = #middleTodos * middleListBox.itemheight
    -- rightListBox.scrollPosition = #rightTodos * rightListBox.itemheight
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

    drawPlusIcon()

    mainWindow:addChild(sectionLeftHeaderPanel)
end

function drawPlusIcon() 
    local plusPanel = ISPlusIcon:new(0, 0, sectionLeftHeaderPanel:getHeight(), sectionLeftHeaderPanel:getHeight())
    plusPanel:initialise();
    sectionLeftHeaderPanel:addChild(plusPanel)
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

    leftListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight() - (mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight()))
    leftListBox:initialise()

    childLeftPanel:addChild(leftListBox)
    mainWindow:addChild(childLeftPanel)
end

function drawMiddleSection()
    childMiddlePanel = ISPanel:new(mainWindowSplitIntoThree, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childMiddlePanel:initialise()

    middleListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight() - (mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight()))
    middleListBox:initialise()

    childMiddlePanel:addChild(middleListBox)
    mainWindow:addChild(childMiddlePanel)
end

function drawRightSection()
    childRightPanel = ISPanel:new(mainWindowSplitIntoThree * 2, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childRightPanel:initialise()

    rightListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight() - (mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight()))
    rightListBox:initialise()

    childRightPanel:addChild(rightListBox)
    mainWindow:addChild(childRightPanel)
end