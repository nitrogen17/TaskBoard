require('ISUI/ISScrollingListBox')
require("main")

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")
local PersistencyManager = require("helper/PersistencyManager")

function MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true) -- allow capturing mouse input
end

-- Overriding the addItem function
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

        print("[#######]", self.items[itemIndex].title)

        context:addOption("Title: " .. task.title, self, self.onContextOption, itemIndex)
        context:addOption("View Task", self, self.onViewTask)
        context:addOption("Edit Task", self, self.onEditTask)
        context:addOption("Delete", self, self.onDeleteTask)

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

    return false -- safely handle empty space clicks
end

function MISScrollingListBox:new(x, y, width, height)
    local object = ISScrollingListBox.new(self, x, y, width, height)

    -- Add new property under self instance
    object.tableTasks = {}

    -- Deselect any item initially
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
