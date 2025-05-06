require('ISUI/ISScrollingListBox')

kb_MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

local TaskCardPanel = require('client-ui/ISPanel/TaskCardPanel')

function kb_MISScrollingListBox:new(x, y, width, height)
    local object = ISScrollingListBox.new(self, x, y, width, height)
    object.tableTasks = {}

    return object
end

function kb_MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true)
end

function kb_MISScrollingListBox:addItem(task)
    table.insert(self.tableTasks, task)
    ISScrollingListBox.addItem(self, task.title)
end

function kb_MISScrollingListBox:doDrawItem(y, item, alt)
    self.selected = -1
    ISScrollingListBox.doDrawItem(self, y, item, alt)
    return y + item.height
end

function kb_MISScrollingListBox:onRightMouseDown(x, y)
    local itemIndex = self:rowAt(x, y)

    if itemIndex and self.tableTasks[itemIndex] then
        local context = ISContextMenu.get(0, getMouseX(), getMouseY())
        local task = self.tableTasks[itemIndex]
        local sectionID = self.tableTasks[itemIndex].sectionID

        context:addOption("View Task", self, self.onViewTask, task)
        context:addOption("Edit Task", self, self.onEditTask, task)
        context:addOption("Delete", self, self.onDeleteTask, task)

        local moveSubMenu = ISContextMenu:getNew(context)
        context:addSubMenu(context:addOption("Move", self, nil), moveSubMenu)

        if sectionID == 1 then
            moveSubMenu:addOption("In Progress", self, self.onMoveTask, task, 2)
            moveSubMenu:addOption("Done", self, self.onMoveTask, task, 3)
        elseif sectionID == 2 then
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
            moveSubMenu:addOption("Done", self, self.onMoveTask, task, 3)
        elseif sectionID == 3 then
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
            moveSubMenu:addOption("In Progress", self, self.onMoveTask, task, 2)
        end
    end
    return false
end

function kb_MISScrollingListBox:onViewTask(task)
    local panel = TaskCardPanel:new()
    panel:initialise(task)
    panel:addToUIManager()
end

function kb_MISScrollingListBox:onEditTask(task)
    kb_TaskFormPanel.createForm("edit", task)
end

function kb_MISScrollingListBox:onDeleteTask(task)
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local dialogWidth = 200
    local dialogHeight = 100
    local dialogX = (screenWidth - dialogWidth) / 2
    local dialogY = (screenHeight - dialogHeight) / 2

    local modal = ISModalDialog:new(
        dialogX, dialogY, dialogWidth, dialogHeight,
        "Are you sure you want to delete this task?",
        true, nil,
        function(dialog, button)
            if button.internal == "YES" then
                TaskBoard_Core.delete(TaskBoard_mainWindowFurniture, task)
            end
        end
    )
    modal:initialise()
    modal:addToUIManager()
end

function kb_MISScrollingListBox:onMoveTask(task, targetSection)
    local newTask = task
    newTask.sectionID = targetSection

    local player = getPlayer(0)
    newTask.lastUserModifiedName = player:getUsername()
    newTask.lastUserModifiedCharacterName = TaskBoard_Utils.getCharacterName(player)
    newTask.updatedAt = TaskBoard_Utils.getCurrentRealTime()
    newTask.updatedAtGame = TaskBoard_Utils.getCurrentGameTime()

    TaskBoard_Core.update(TaskBoard_mainWindowFurniture, newTask)
end

function formatISODateForCard(isoString)
    local year, month, day, hour, min, sec = isoString:match("^(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
    if year and month and day and hour and min and sec then
        local timestamp = os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec),
            isdst = false
        })
        return os.date("%B %d, %Y", timestamp)
    end
    return isoString
end

function formatISODate(isoString)
    local year, month, day, hour, min, sec = isoString:match("^(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
    if year and month and day and hour and min and sec then
        local timestamp = os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec),
            isdst = false
        })
        return os.date("%B %d, %Y at %I:%M %p", timestamp)
    end
    return isoString
end
