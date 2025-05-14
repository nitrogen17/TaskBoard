-- Child Class from the Java UI:
-- MISCollapsableWindow
-- MISScrollingListBox
-- MISPanel

-- Prerequisite: Pass by reference
-- All functions acts as fileprivate since the file must be require first to other lua files.
-- All properties were declare local or private except the 3 table reference.

-- Debug:
-- panel.backgroundColor = {r=0, g=0, b=1, a=1}

-- Global Properties:
-- kb_leftListBox = Left Table
-- kb_middleListBox = Middle Table
-- kb_rightListBox = Right Table

require('ISUI/ISPanel')
require('TaskBoard_CardTemplate')

local ISPlusIcon = require('client-ui/ISPanel/ISPlusIcon')
local ISPlusIconDebug = require('client-ui/ISPanel/ISPlusIconDebug')

TaskBoard_mainWindow = nil

local function drawPlusIcon(sectionLeftHeaderPanel)
    local plusPanel = ISPlusIcon:new(0, 0, sectionLeftHeaderPanel:getHeight(), sectionLeftHeaderPanel:getHeight())
    plusPanel:initialise();
    sectionLeftHeaderPanel:addChild(plusPanel)
end

local function drawPlusIconDebug(middleHeaderSection)
    local plusPanelDebug = ISPlusIconDebug:new(0, 0, middleHeaderSection:getHeight(), middleHeaderSection:getHeight())
    plusPanelDebug:initialise();
    middleHeaderSection:addChild(plusPanelDebug)
end

local function drawLeftHeaderSection(window, layout)
    kb_sectionLeftHeaderPanel = kb_MISPanel:new(0, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    kb_sectionLeftHeaderPanel:initialise()
    kb_sectionLeftHeaderPanel:setTitle("To Do")
    window:addChild(kb_sectionLeftHeaderPanel)
    drawPlusIcon(kb_sectionLeftHeaderPanel)
end

local function drawMiddleHeaderSection(window, layout)
    kb_sectionMiddleHeaderPanel = kb_MISPanel:new(layout.sectionWidth, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    kb_sectionMiddleHeaderPanel:initialise()
    kb_sectionMiddleHeaderPanel:setTitle("In Progress")
    window:addChild(kb_sectionMiddleHeaderPanel)
    -- drawPlusIconDebug(kb_sectionMiddleHeaderPanel)
end

local function drawRightHeaderSection(window, layout)
    kb_sectionRightHeaderPanel = kb_MISPanel:new(layout.sectionWidth * 2, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    kb_sectionRightHeaderPanel:initialise()
    kb_sectionRightHeaderPanel:setTitle("Done")
    window:addChild(kb_sectionRightHeaderPanel)
end

local function drawSectionHeaderPanel(window, layout)
    kb_sectionHeaderPanel = ISPanel:new(0, window:titleBarHeight(), layout.newWidth, layout.headerHeight)
    kb_sectionHeaderPanel:initialise()
    kb_sectionHeaderPanel.backgroundColor = {r = 0, g = 0, b = 0, a = 1}
    window:addChild(kb_sectionHeaderPanel)

    drawLeftHeaderSection(window, layout)
    drawMiddleHeaderSection(window, layout)
    drawRightHeaderSection(window, layout)

    return kb_sectionHeaderPanel
end

local function drawMainWindow()
    local window = kb_MISCollapsableWindow:new()

    window:initialise()
    window:addToUIManager()

    TaskBoard_Title.patchWindowForRename(window)

    return window
end

local function drawLeftSection(window, layout)
    kb_childLeftPanel = ISPanel:new(0, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    kb_childLeftPanel:initialise()

    kb_leftListBox = kb_MISScrollingListBox:new(0, 0, kb_childLeftPanel:getWidth(), kb_childLeftPanel:getHeight())
    kb_leftListBox:initialise()

    kb_childLeftPanel:addChild(kb_leftListBox)
    window:addChild(kb_childLeftPanel)

    return kb_childLeftPanel
end

local function drawMiddleSection(window, layout)
    kb_childMiddlePanel = ISPanel:new(layout.sectionWidth, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    kb_childMiddlePanel:initialise()

    kb_middleListBox = kb_MISScrollingListBox:new(0, 0, kb_childMiddlePanel:getWidth(), kb_childMiddlePanel:getHeight())
    kb_middleListBox:initialise()

    kb_childMiddlePanel:addChild(kb_middleListBox)
    window:addChild(kb_childMiddlePanel)

    return kb_childMiddlePanel
end

local function drawRightSection(window, layout)
    kb_childRightPanel = ISPanel:new(layout.sectionWidth * 2, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    kb_childRightPanel:initialise()

    kb_rightListBox = kb_MISScrollingListBox:new(0, 0, kb_childRightPanel:getWidth(), kb_childRightPanel:getHeight())
    kb_rightListBox:initialise()

    kb_childRightPanel:addChild(kb_rightListBox)
    window:addChild(kb_childRightPanel)

    return kb_childRightPanel
end

local function bringResizeWidgetToFront(window)
    if window.resizeWidget2 then
        window:removeChild(window.resizeWidget2)
        window:addChild(window.resizeWidget2)
    end

    if window.resizeWidget then
        window:removeChild(window.resizeWidget)
        window:addChild(window.resizeWidget)
    end
end

local function drawAllSections(window)
    local layout = TaskBoard_Utils.computeLayout(window, window.minWidth, window.minHeight)

    drawSectionHeaderPanel(window, layout)
    drawLeftSection(window, layout)
    drawMiddleSection(window, layout)
    drawRightSection(window, layout)
    bringResizeWidgetToFront(window)
end

local function drawKanbanBoard()
    TaskBoard_mainWindow = drawMainWindow()
    drawAllSections(TaskBoard_mainWindow)
    TaskBoard_mainWindow:updateTaskBoardLayout()
end

local function main()
    drawKanbanBoard()
end

Events.OnGameStart.Add(main)

function TaskBoard_Debug_InitializeMainWindow()
    if TaskBoard_mainWindow then
        TaskBoard_mainWindow:setVisible(false)
    end
    TaskBoard_mainWindow = nil
    main()
    print("Re-initialized TaskBoard Main Window.")
end
