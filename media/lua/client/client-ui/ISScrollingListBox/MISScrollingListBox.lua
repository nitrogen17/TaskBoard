require('ISUI/ISScrollingListBox')
require("main")

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

local PersistencyManager = require("helper/PersistencyManager")

local TaskCardPanel = require('client-ui/ISPanel/TaskCardPanel')
local TaskFormPanel = require('client-ui/ISPanel/TaskFormPanel')

function MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true)
end

function MISScrollingListBox:addItem(title, todo)
    table.insert(self.tableTasks, todo)
    ISScrollingListBox.addItem(self, title)  
end

function MISScrollingListBox:onRightMouseDown(x, y)
    local itemIndex = self:rowAt(x, y)

    if itemIndex and self.tableTasks[itemIndex] then
        local context = ISContextMenu.get(0, getMouseX(), getMouseY())
        local task = self.tableTasks[itemIndex]
        local sectionID = self.tableTasks[itemIndex].sectionID

        context:addOption(task.title, self, self.onContextOption, itemIndex)
        context:addOption("View Task", self, self.onViewTask, task)
        context:addOption("Edit Task", self, self.onEditTask, task)
        context:addOption("Delete", self, self.onDeleteTask, task)

        local moveSubMenu = ISContextMenu:getNew(context)
        context:addSubMenu(context:addOption("Move", self, nil), moveSubMenu)

        if sectionID == 1 then
            moveSubMenu:addOption("In Progress", self, self.onMoveTask, task, 2)
            moveSubMenu:addOption("Done", self, self.onMoveTask, task, 3)
        elseif sectionID == 2 then
            moveSubMenu:addOption("Done", self, self.onMoveTask, task, 3)
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
        elseif sectionID == 3 then
            moveSubMenu:addOption("In Progress", self, self.onMoveTask, task, 2)
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
        end
    end

    return false
end

function MISScrollingListBox:new(x, y, width, height)
    local object = ISScrollingListBox.new(self, x, y, width, height)
    object.tableTasks = {}
    object.selected = -1
    
    return object
end

function MISScrollingListBox:onMoveTask(task, targetSection)
    local newTask = task
    newTask.sectionID = targetSection

    PersistencyManager.updateTodo(newTask.id, newTask)

    clearDataToSections()
    renderDataToSections() 
end

function MISScrollingListBox:onViewTask(task)
    print("[CONTEXT] View Task clicked:")
    local taskCard = TaskCardPanel:new()
    taskCard:initialise(task)
    taskCard:addToUIManager()
end

function MISScrollingListBox:onEditTask(task)
    print("[CONTEXT] Edit Task clicked:", task.title)
    local panelWidth, panelHeight = 500, 200
    local panel = TaskFormPanel:new(
        (getCore():getScreenWidth() - panelWidth) / 2,
        (getCore():getScreenHeight() - panelHeight) / 2,
        panelWidth,
        panelHeight,
        "update",
        task
    )
    panel:initialise()
    panel:addToUIManager()
end

function MISScrollingListBox:onDeleteTask(task)
    PersistencyManager.deleteTodo(task.id)

    clearDataToSections()
    renderDataToSections() 
end