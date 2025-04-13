require('ISUI/ISScrollingListBox')
require("main")

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

local PersistencyManager = require("helper/PersistencyManager")

local TaskCardPanel = require('client-ui/ISPanel/TaskCardPanel')
local TaskFormPanel = require('client-ui/ISPanel/TaskFormPanel')
 
-- Global selected data
selectedData = { x = -1, y = -1 }

Events.OnMouseDown.Add(onGlobalMouseDown)

function MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true)
end

function MISScrollingListBox:doDrawItem(y, item, alt)
    self.selected = -1

    -- if item.index == selectedData.y and self.tableTasks[1].sectionID == selectedData.x then
    --     self:drawRect(0, y, self.width, item.height, 1, 0.25, 0, 0)
    -- end

    if item.index == selectedData.y and self.tableTasks[1].sectionID == selectedData.x then
        self:drawRectBorder(0, y, self.width, item.height, 1, 0.2, 1.0, 0.2)
        self:drawRect(0, y, self.width, item.height, 0.25, 0.2, 1.0, 0.1) -- subtle green overlay
    end

    -- Optional: White border when selected
    if self.selected == item.index then
        self:drawRectBorder(0, y, self.width, item.height, 1, 1, 1, 1)
    end

    -- Custom selected highlight (e.g. green)
    if self.selected == item.index then
        self:drawRectBorder(0, y, self.width, item.height, 1, 0.2, 1.0, 0.2) -- green border
        self:drawRect(0, y, self.width, item.height, 0.25, 0.2, 1.0, 0.2) -- subtle green overlay
    end

    -- Call default drawing (text, border, selection highlight)
    ISScrollingListBox.doDrawItem(self, y, item, alt)

    return y + item.height
end

function MISScrollingListBox:addItem(title, todo)
    table.insert(self.tableTasks, todo)
    ISScrollingListBox.addItem(self, title)  
end

function MISScrollingListBox:onMouseDown(x, y)
    selectedData = { x = -1, y = -1 }
    ISScrollingListBox.onMouseDown(self, x, y)
end

-- Global mouse listener function (to detect clicks outside the listbox)
function onGlobalMouseDown(x, y)
    selectedData = { x = -1, y = -1 }
end


function MISScrollingListBox:onRightMouseDown(x, y)
    local itemIndex = self:rowAt(x, y)

    if itemIndex and self.tableTasks[itemIndex] then
        local context = ISContextMenu.get(0, getMouseX(), getMouseY())
        local task = self.tableTasks[itemIndex]
        local sectionID = self.tableTasks[itemIndex].sectionID

        local o = context

        -- Store the selected item and its sectionID globally
        selectedData.x = sectionID
        selectedData.y = itemIndex

        o.borderColor = {r=0.6, g=0.0, b=0.0, a=0.4}
        o.backgroundColor = {r=0.2, g=0.0, b=0.0, a=0.9}
        o.backgroundColorMouseOver = {r=0.4, g=0.0, b=0.0, a=1.0}
        

        context:addOption("View Task", self, self.onViewTask, task)
        context:addOption("Edit Task", self, self.onEditTask, task)
        context:addOption("Delete", self, self.onDeleteTask, task)

        local moveSubMenu = ISContextMenu:getNew(context)
        context:addSubMenu(context:addOption("Move", self, nil), moveSubMenu)

        o = moveSubMenu

        o.borderColor = {r=0.7, g=0.1, b=0.1, a=0.5}
        o.backgroundColor = {r=0.15, g=0.0, b=0.0, a=0.95}
        o.backgroundColorMouseOver = {r=0.5, g=0.0, b=0.0, a=1.0}
        
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

    selectedData = { x = -1, y = -1 }

    PersistencyManager.updateTodo(newTask.id, newTask)

    clearDataToSections()
    renderDataToSections() 
end

function MISScrollingListBox:onViewTask(task)
    print("[CONTEXT] View Task clicked:")
    local taskCard = TaskCardPanel:new()
    taskCard:initialise(task)
    taskCard:addToUIManager()

    selectedData = { x = -1, y = -1 }
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

    selectedData = { x = -1, y = -1 }
end

function MISScrollingListBox:onDeleteTask(task)
    PersistencyManager.deleteTodo(task.id)

    clearDataToSections()
    renderDataToSections() 

    selectedData = { x = -1, y = -1 }
end