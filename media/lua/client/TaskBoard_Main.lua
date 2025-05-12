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

local function updateTaskBoardLayout(window)
    local newWidth = window:getWidth()
    local newHeight = window:getHeight()

    if kb_sectionHeaderPanel then
        kb_sectionHeaderPanel:setWidth(newWidth)
    end

    if kb_sectionLeftHeaderPanel then
        kb_sectionLeftHeaderPanel:setWidth(newWidth / 3)
    end

    if kb_sectionMiddleHeaderPanel then
        kb_sectionMiddleHeaderPanel:setX(newWidth / 3)
        kb_sectionMiddleHeaderPanel:setWidth(newWidth / 3)
    end

    print("kb_sectionRightHeaderPanel: " .. tostring(kb_sectionRightHeaderPanel))
    if kb_sectionRightHeaderPanel then
        print("it exists")
        kb_sectionRightHeaderPanel:setX((newWidth / 3) * 2)
        kb_sectionRightHeaderPanel:setWidth(newWidth / 3)
    end

    if kb_childLeftPanel and kb_sectionLeftHeaderPanel then
        kb_childLeftPanel:setWidth(newWidth / 3)
        kb_childLeftPanel:setHeight(newHeight - (window:titleBarHeight() + kb_sectionLeftHeaderPanel:getHeight() + window:resizeWidgetHeight()) - 24)
        if kb_leftListBox then
            kb_leftListBox:setWidth(kb_childLeftPanel:getWidth())
            kb_leftListBox:setHeight(kb_childLeftPanel:getHeight())
        end
    end

    if kb_childMiddlePanel and kb_sectionMiddleHeaderPanel then
        kb_childMiddlePanel:setX(newWidth / 3)
        kb_childMiddlePanel:setWidth(newWidth / 3)
        kb_childMiddlePanel:setHeight(newHeight - (window:titleBarHeight() + kb_sectionMiddleHeaderPanel:getHeight() + window:resizeWidgetHeight()) - 24)
        if kb_middleListBox then
            kb_middleListBox:setWidth(kb_childMiddlePanel:getWidth())
            kb_middleListBox:setHeight(kb_childMiddlePanel:getHeight())
        end
    end

    if kb_childRightPanel and kb_sectionRightHeaderPanel then
        kb_childRightPanel:setX((newWidth / 3) * 2)
        kb_childRightPanel:setWidth(newWidth / 3)
        kb_childRightPanel:setHeight(newHeight - (window:titleBarHeight() + kb_sectionRightHeaderPanel:getHeight() + window:resizeWidgetHeight()) - 24)
        if kb_rightListBox then
            kb_rightListBox:setWidth(kb_childRightPanel:getWidth())
            kb_rightListBox:setHeight(kb_childRightPanel:getHeight())
        end
    end
end

local function drawLeftHeaderSection(window)
    kb_sectionLeftHeaderPanel = kb_MISPanel:new(0, window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    kb_sectionLeftHeaderPanel:initialise()
    kb_sectionLeftHeaderPanel:setTitle("To Do")

    window:addChild(kb_sectionLeftHeaderPanel)

    return kb_sectionLeftHeaderPanel
end

local function drawMiddleHeaderSection(window, leftHeaderSection)
    kb_sectionMiddleHeaderPanel = kb_MISPanel:new(leftHeaderSection:getWidth(), window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    kb_sectionMiddleHeaderPanel:initialise()
    kb_sectionMiddleHeaderPanel:setTitle("In Progress")
    window:addChild(kb_sectionMiddleHeaderPanel)

    return kb_sectionMiddleHeaderPanel
end

local function drawRightHeaderSection(window, middleHeaderSection)
    kb_sectionRightHeaderPanel = kb_MISPanel:new(middleHeaderSection:getWidth() * 2, window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    kb_sectionRightHeaderPanel:initialise()
    kb_sectionRightHeaderPanel:setTitle("Done")
    window:addChild(kb_sectionRightHeaderPanel)

    return kb_sectionRightHeaderPanel
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

local function drawSectionHeaderPanel(window)
    kb_sectionHeaderPanel = ISPanel:new(0, window:titleBarHeight(), window.width, window:titleBarHeight() * 2)
    kb_sectionHeaderPanel:initialise()
    kb_sectionHeaderPanel.backgroundColor = {r=0, g=0, b=0, a=1}
    window:addChild(kb_sectionHeaderPanel)

    kb_sectionLeftHeaderPanel = drawLeftHeaderSection(window)
    drawPlusIcon(kb_sectionLeftHeaderPanel)

    kb_sectionMiddleHeaderPanel = drawMiddleHeaderSection(window, kb_sectionLeftHeaderPanel)
    -- drawPlusIconDebug(kb_sectionMiddleHeaderPanel)

    kb_sectionRightHeaderPanel = drawRightHeaderSection(window, kb_sectionMiddleHeaderPanel)

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

local function drawLeftSection(window, sectionHeaderPanel)
    kb_childLeftPanel = ISPanel:new(0, window:titleBarHeight() + sectionHeaderPanel:getHeight(), window.width / 3, window.height - (window:titleBarHeight() + sectionHeaderPanel:getHeight() + window:resizeWidgetHeight()) - 24)
    kb_childLeftPanel:initialise()

    kb_leftListBox = kb_MISScrollingListBox:new(0, 0, kb_childLeftPanel:getWidth(), kb_childLeftPanel:getHeight())
    kb_leftListBox:initialise()

    kb_childLeftPanel:addChild(kb_leftListBox)
    window:addChild(kb_childLeftPanel)

    return kb_childLeftPanel
end

local function drawMiddleSection(window, leftSection)
    kb_childMiddlePanel = ISPanel:new(window.width / 3, leftSection:getY(), window.width / 3, leftSection:getHeight())
    kb_childMiddlePanel:initialise()

    kb_middleListBox = kb_MISScrollingListBox:new(0, 0, kb_childMiddlePanel:getWidth(), kb_childMiddlePanel:getHeight())
    kb_middleListBox:initialise()

    kb_childMiddlePanel:addChild(kb_middleListBox)
    window:addChild(kb_childMiddlePanel)

    return kb_childMiddlePanel
end

local function drawRightSection(window, middleSection)
    kb_childRightPanel = ISPanel:new((window.width / 3) * 2, middleSection:getY(), window.width / 3, middleSection:getHeight())
    kb_childRightPanel:initialise()

    kb_rightListBox = kb_MISScrollingListBox:new(0, 0, kb_childRightPanel:getWidth(), kb_childRightPanel:getHeight())
    kb_rightListBox:initialise()

    kb_childRightPanel:addChild(kb_rightListBox)
    window:addChild(kb_childRightPanel)

    return kb_childRightPanel
end

local function drawAllSections(window)
    local sectionHeaderPanel = drawSectionHeaderPanel(window)

    local leftSection = drawLeftSection(window, sectionHeaderPanel)
    local middleSection = drawMiddleSection(window, leftSection)
    drawRightSection(window, middleSection)
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