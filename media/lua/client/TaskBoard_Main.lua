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

TaskBoard_mainWindow = {}

local function layoutHeaderPanel(panel, x, y, width, height, title)
    panel:setX(x)
    panel:setY(y)
    panel:setWidth(width)
    panel:setHeight(height)
    if title then
        panel:setTitle(title)
    end
end

local function layoutChildPanel(panel, listBox, x, y, width, height)
    panel:setX(x)
    panel:setY(y)
    panel:setWidth(width)
    panel:setHeight(height)

    if listBox then
        listBox:setWidth(width)
        listBox:setHeight(height)
    end
end

local function updateTaskBoardLayout(window)
    local layout = TaskBoard_Utils.computeLayout(window)

    if kb_sectionHeaderPanel then
        layoutHeaderPanel(kb_sectionHeaderPanel, 0, window:titleBarHeight(), layout.newWidth, layout.headerHeight)
    end

    if kb_sectionLeftHeaderPanel then
        layoutHeaderPanel(kb_sectionLeftHeaderPanel, 0, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    end

    if kb_sectionMiddleHeaderPanel then
        layoutHeaderPanel(kb_sectionMiddleHeaderPanel, layout.sectionWidth, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    end

    if kb_sectionRightHeaderPanel then
        layoutHeaderPanel(kb_sectionRightHeaderPanel, layout.sectionWidth * 2, window:titleBarHeight(), layout.sectionWidth, layout.headerHeight)
    end

    if kb_childLeftPanel and kb_sectionLeftHeaderPanel then
        layoutChildPanel(kb_childLeftPanel, kb_leftListBox, 0, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    end

    if kb_childMiddlePanel and kb_sectionMiddleHeaderPanel then
        layoutChildPanel(kb_childMiddlePanel, kb_middleListBox, layout.sectionWidth, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    end

    if kb_childRightPanel and kb_sectionRightHeaderPanel then
        layoutChildPanel(kb_childRightPanel, kb_rightListBox, layout.sectionWidth * 2, window:titleBarHeight() + layout.headerHeight, layout.sectionWidth, layout.availableHeight)
    end
end

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
    local window = kb_MISCollapsableWindow:new(0, 0, getCore():getScreenWidth() * 0.5, getCore():getScreenHeight() * 0.6)
    window:setX((getCore():getScreenWidth() * 0.5) - (window:getWidth() * 0.5))
    window:setY((getCore():getScreenHeight() * 0.5) - (window:getHeight() * 0.5) - 25)

    window:initialise()
    window:addToUIManager()
    window:setVisible(false)
    window:setResizable(true)

    function window:onResize()
        updateTaskBoardLayout(self)
    end

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
    local layout = TaskBoard_Utils.computeLayout(window)

    drawSectionHeaderPanel(window, layout)
    drawLeftSection(window, layout)
    drawMiddleSection(window, layout)
    drawRightSection(window, layout)
    bringResizeWidgetToFront(window)
end

local function drawKanbanBoard()
    TaskBoard_mainWindow = drawMainWindow()
    drawAllSections(TaskBoard_mainWindow)
    updateTaskBoardLayout(TaskBoard_mainWindow)
end

local function main()
    drawKanbanBoard()
end

local function closeTaskBoardWindow()
    if not isServer() then
        local player = getPlayer()
        if not player or not TaskBoard_mainWindowFurniture then return end
        local square = TaskBoard_mainWindowFurniture:getSquare()

        if not TaskBoard_Utils.isWithinRange(player, square, 1) then
            TaskBoard_Utils.closeTaskBoardMainWindow()
        end
    end
end

Events.OnGameStart.Add(main)
Events.OnTick.Add(closeTaskBoardWindow)

function TaskBoard_Debug_InitializeMainWindow()
    if TaskBoard_mainWindow then
        TaskBoard_mainWindow:setVisible(false)
    end
    TaskBoard_mainWindow = nil
    main()
    print("Re-initialized TaskBoard Main Window.")
end