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

local function drawLeftHeaderSection(window)
    local sectionLeftHeaderPanel = kb_MISPanel:new(0, window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    sectionLeftHeaderPanel:initialise()
    sectionLeftHeaderPanel:setTitle("To Do")

    window:addChild(sectionLeftHeaderPanel)

    return sectionLeftHeaderPanel
end

local function drawMiddleHeaderSection(window, leftHeaderSection)
    local sectionMiddleHeaderPanel = kb_MISPanel:new(leftHeaderSection:getWidth(), window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    sectionMiddleHeaderPanel:initialise()
    sectionMiddleHeaderPanel:setTitle("In Progress")
    window:addChild(sectionMiddleHeaderPanel)

    return sectionMiddleHeaderPanel
end

local function drawRightHeaderSection(window, middleHeaderSection)
    local sectionRightHeaderPanel = kb_MISPanel:new(middleHeaderSection:getWidth() * 2, window:titleBarHeight(), window.width / 3, window:titleBarHeight() * 2)
    sectionRightHeaderPanel:initialise()
    sectionRightHeaderPanel:setTitle("Done")
    window:addChild(sectionRightHeaderPanel)
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
    local sectionHeaderPanel = ISPanel:new(0, window:titleBarHeight(), window.width, window:titleBarHeight() * 2)
    sectionHeaderPanel:initialise()
    sectionHeaderPanel.backgroundColor = {r=0, g=0, b=0, a=1}
    window:addChild(sectionHeaderPanel)

    local leftHeaderSection = drawLeftHeaderSection(window)
    drawPlusIcon(leftHeaderSection)


    local middleHeaderSection = drawMiddleHeaderSection(window, leftHeaderSection)
    -- drawPlusIconDebug(middleHeaderSection)

    drawRightHeaderSection(window, middleHeaderSection)

    return sectionHeaderPanel
end

local function drawMainWindow()
    local window = kb_MISCollapsableWindow:new(0, 0, getCore():getScreenWidth() * 0.5, getCore():getScreenHeight() * 0.6)
    window:setX((getCore():getScreenWidth() * 0.5) - (window:getWidth() * 0.5))
    window:setY((getCore():getScreenHeight() * 0.5) - (window:getHeight() * 0.5) - 25)

    window:initialise()
    window:addToUIManager()
    window:setVisible(false)

    TaskBoard_Title.patchWindowForRename(window)

    return window
end

local function drawLeftSection(window, sectionHeaderPanel)
    local childLeftPanel = ISPanel:new(0, window:titleBarHeight() + sectionHeaderPanel:getHeight(), window.width / 3, window.height - (window:titleBarHeight() + sectionHeaderPanel:getHeight()))
    childLeftPanel:initialise()

    kb_leftListBox = kb_MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    kb_leftListBox:initialise()

    childLeftPanel:addChild(kb_leftListBox)
    window:addChild(childLeftPanel)

    return childLeftPanel
end

local function drawMiddleSection(window, leftSection)
    local childMiddlePanel = ISPanel:new(window.width / 3, leftSection:getY(), window.width / 3, leftSection:getHeight())
    childMiddlePanel:initialise()

    kb_middleListBox = kb_MISScrollingListBox:new(0, 0, childMiddlePanel:getWidth(), childMiddlePanel:getHeight())
    kb_middleListBox:initialise()

    childMiddlePanel:addChild(kb_middleListBox)
    window:addChild(childMiddlePanel)

    return childMiddlePanel
end

local function drawRightSection(window, middleSection)
    local childRightPanel = ISPanel:new((window.width / 3) * 2, middleSection:getY(), window.width / 3, middleSection:getHeight())
    childRightPanel:initialise()

    kb_rightListBox = kb_MISScrollingListBox:new(0, 0, childRightPanel:getWidth(), childRightPanel:getHeight())
    kb_rightListBox:initialise()

    childRightPanel:addChild(kb_rightListBox)
    window:addChild(childRightPanel)
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

function TaskBoard_Debug_InitializeMainWindow()
    if TaskBoard_mainWindow then
        TaskBoard_mainWindow:setVisible(false)
    end
    TaskBoard_mainWindow = nil
    main()
    print("Re-initialized TaskBoard Main Window.")
end
