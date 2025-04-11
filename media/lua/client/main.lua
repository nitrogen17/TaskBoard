require('ISUI/ISPanel')
require('PersistencyWorker')

function main()
    drawKanbanBoard()

    --PersistencyManager.readTasks()

    PersistencyManager.readById("1000000005")  -- Read task by ID
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

    -- Read directly on Persistency Manager
    local tasks = PersistencyManager.data.tasks

    if tasks then
        for _, task in ipairs(tasks) do
            print(task.title)
        end
    else
        print("No tasks found.")
    end

    leftListBox:addItem("Get Water", {})
    leftListBox:addItem("Get Water", {})
    leftListBox:addItem("Get Water", {})

    childLeftPanel:addChild(leftListBox)
    mainWindow:addChild(childLeftPanel)
end

function drawMiddleSection()
    childMiddlePanel = ISPanel:new(mainWindowSplitIntoThree, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childMiddlePanel:initialise()

    middleListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    middleListBox:initialise()
    middleListBox:addItem("Get Water", {})

    childMiddlePanel:addChild(middleListBox)
    mainWindow:addChild(childMiddlePanel)
end

function drawRightSection()
    childRightPanel = ISPanel:new(mainWindowSplitIntoThree * 2, mainWindow:titleBarHeight() + sectionHeaderPanel:getHeight(), mainWindowSplitIntoThree, mainWindow.height)
    childRightPanel:initialise()

    rightListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    rightListBox:initialise()
    rightListBox:addItem("Get Water", {})

    childRightPanel:addChild(rightListBox)
    mainWindow:addChild(childRightPanel)
end