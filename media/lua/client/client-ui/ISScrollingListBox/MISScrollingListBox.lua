require('ISUI/ISScrollingListBox')

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

local TaskCardPanel = require('client-ui/ISPanel/TaskCardPanel')

function MISScrollingListBox:new(x, y, width, height)
    local object = ISScrollingListBox.new(self, x, y, width, height)
    object.tableTasks = {}
    
    return object
end

function MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true)
end

function MISScrollingListBox:addItem(task)
    table.insert(self.tableTasks, task)
    ISScrollingListBox.addItem(self, task.title)  
end

function MISScrollingListBox:doDrawItem(y, item, alt)
    self.selected = -1
    ISScrollingListBox.doDrawItem(self, y, item, alt)
    return y + item.height
end

function MISScrollingListBox:onRightMouseDown(x, y)
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
            moveSubMenu:addOption("Done", self, self.onMoveTask, task, 3)
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
        elseif sectionID == 3 then
            moveSubMenu:addOption("In Progress", self, self.onMoveTask, task, 2)
            moveSubMenu:addOption("To Do", self, self.onMoveTask, task, 1)
        end
    end
    return false
end

function MISScrollingListBox:onViewTask(task)
    local panel = TaskCardPanel:new()
    panel:initialise(task)
    panel:addToUIManager()
end

function MISScrollingListBox:onEditTask(task)
    kb_TaskFormPanel.createForm("edit", task)
end

function MISScrollingListBox:onDeleteTask(task)
    sendClientCommand(MODDATA_KEY, "DeleteTask", task)
end

function MISScrollingListBox:onMoveTask(task, targetSection)
    local newTask = task
    newTask.sectionID = targetSection
    newTask.lastUserModifiedName = getPlayer(0):getUsername()
    newTask.updatedAt = os.date("!%Y-%m-%dT%H:%M:%SZ")
    sendClientCommand(MODDATA_KEY, "UpdateTask", task)
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

require('ISUI/ISPanel');
require('ISUI/ISRichTextPanel');
require('ISUI/ISCollapsableWindow');

kb_TaskFormPanel1 = {};

function kb_TaskFormPanel1.new(task)
    local title = "Task"

    local text = string.format(
        "Task: %s\n\n%s\n\n%s\n\nCreated by:\n%s\n%s\n\nUpdated by:\n%s\n%s\n",
        task.title,
        task.description,
        task.priority,
        formatISODate(task.createdAt),
        task.createdByName,
        formatISODate(task.updatedAt),
        task.lastUserModifiedName
    )

    local self = {};
    self.tut = ISRichTextPanel:new(0, 0, 380, 300);
    self.tut:initialise();
    self.tut:setAnchorBottom(true);
    self.tut:setAnchorRight(true);
    self.moreinfo = self.tut:wrapInCollapsableWindow();
    self.moreinfo:setX((getCore():getScreenWidth() * 0.5) - (self.tut.width * 0.5));
    self.moreinfo:setY((getCore():getScreenHeight() * 0.5) - (self.tut.height * 0.5));
    self.moreinfo:setTitle(title);

    self.moreinfo:addToUIManager();
    self.tut:setWidth(self.moreinfo:getWidth());
    self.tut:setHeight(self.moreinfo:getHeight() - self.moreinfo:titleBarHeight());
    self.tut:setY(self.moreinfo:titleBarHeight());
    self.tut.autosetheight = false;
    self.tut.clip = true;
    self.tut:addScrollBars();

    self.tut.textDirty = true;
    self.tut.text = text;
    self.tut:paginate();
    return self;
end