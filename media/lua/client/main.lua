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
require('CardTemplate')

local ISPlusIcon = require('client-ui/ISPanel/ISPlusIcon')

mainWindow = {}

function main()
    if isClient then
        print("This code is running on the client.")
    elseif isServer then
        print("This code is running on the server")
    end
    drawKanbanBoard()
end

function drawKanbanBoard()
    mainWindow = drawMainWindow()
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
    mainWindow:setY((getCore():getScreenHeight() * 0.5) - (mainWindow:getHeight() * 0.5) - 25)

    mainWindow:initialise()
    mainWindow:addToUIManager()
    mainWindow:setVisible(false)

    return mainWindow
end

function drawSectionHeaderPanel(mainWindow) 
    local sectionHeaderPanel = ISPanel:new(0, mainWindow:titleBarHeight(), mainWindow.width, mainWindow:titleBarHeight() * 2)
    sectionHeaderPanel:initialise()
    sectionHeaderPanel.backgroundColor = {r=0, g=0, b=0, a=1}
    mainWindow:addChild(sectionHeaderPanel)

    local leftHeaderSection = drawLeftHeaderSection(mainWindow)

    drawPlusIcon(leftHeaderSection)

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

function drawPlusIcon(sectionLeftHeaderPanel) 
    local plusPanel = ISPlusIcon:new(0, 0, sectionLeftHeaderPanel:getHeight(), sectionLeftHeaderPanel:getHeight())
    plusPanel:initialise();
    sectionLeftHeaderPanel:addChild(plusPanel)
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

    kb_leftListBox = MISScrollingListBox:new(0, 0, childLeftPanel:getWidth(), childLeftPanel:getHeight())
    kb_leftListBox:initialise()

    childLeftPanel:addChild(kb_leftListBox)
    mainWindow:addChild(childLeftPanel)
    
    return childLeftPanel
end

function drawMiddleSection(mainWindow, leftSection)
    local childMiddlePanel = ISPanel:new(mainWindow.width / 3, leftSection:getY(), mainWindow.width / 3, leftSection:getHeight())
    childMiddlePanel:initialise()

    kb_middleListBox = MISScrollingListBox:new(0, 0, childMiddlePanel:getWidth(), childMiddlePanel:getHeight())
    kb_middleListBox:initialise()

    childMiddlePanel:addChild(kb_middleListBox)
    mainWindow:addChild(childMiddlePanel)

    return childMiddlePanel
end

function drawRightSection(mainWindow, middleSection)
    local childRightPanel = ISPanel:new((mainWindow.width / 3) * 2, middleSection:getY(), mainWindow.width / 3, middleSection:getHeight())
    childRightPanel:initialise()

    kb_rightListBox = MISScrollingListBox:new(0, 0, childRightPanel:getWidth(), childRightPanel:getHeight())
    kb_rightListBox:initialise()

    childRightPanel:addChild(kb_rightListBox)
    mainWindow:addChild(childRightPanel)
end