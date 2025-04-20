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

-- function MISScrollingListBox:doDrawItem(y, item, alt)
--     self.selected = -1
--     ISScrollingListBox.doDrawItem(self, y, item, alt)
--     return y + item.height
-- end

-- function MISScrollingListBox:doDrawItem(y, item, alt)
--     local x = 10
--     local width = self.width - 20
--     local height = 64
--     local padding = 6

--     -- Card background
--     local bgColor = self.selected == item.index and {r=0.2, g=0.4, b=0.8, a=0.3} or {r=0.1, g=0.1, b=0.1, a=0.6}
--     self:drawRect(x, y + padding, width, height - padding * 2, bgColor.a, bgColor.r, bgColor.g, bgColor.b)

--     -- Optional card border
--     self:drawRectBorder(x, y + padding, width, height - padding * 2, 0.9, 1, 1, 1)

--     -- Draw item text inside the card
--     if item.text then
--         self:drawText(item.text, x + padding, y + padding + 4, 1, 1, 1, 1, UIFont.Medium)
--     end

--     return y + height
-- end

function MISScrollingListBox:doDrawItem(y, item, alt)
    self.selected = -1

    local x = 30  -- Increased left padding by 30 (previously 10)
    local width = self.width - 60-- Decreased width by 60 to add 30 units of space on both sides

    local height = 200
    local padding = 15
    local lineHeight = 35

    local card = self.tableTasks[item.index]

    local bgColor = self.selected == item.index and {r=0.2, g=0.4, b=0.8, a=0.3} or {r=0.1, g=0.1, b=0.1, a=0.6}
    self:drawRect(x, y + padding, width, height - padding * 2, bgColor.a, bgColor.r, bgColor.g, bgColor.b)
    self:drawRectBorder(x, y + padding, width, height - padding * 2, 0.9, 1, 1, 1)

    local textX = x + padding
    local textY = y + padding + 10

    -- Title
    self:drawText(card.title or "Untitled", textX, textY, 1, 1, 1, 1, UIFont.Medium)
    textY = textY + lineHeight

    -- Description (shortened)
    if card.description and card.description ~= "" then
        local shortDesc = string.sub(card.description, 1, 35)
        self:drawText(shortDesc .. "...", textX, textY, 0.8, 0.8, 0.8, 1, UIFont.Small)
        textY = textY + lineHeight
    end

    -- print("card.updatedAt", card.updatedAt)
    -- print("formatISODate exists?", type(formatISODate))

    -- Assignee and Due Date
    local assigneeText = (card.lastUserModifiedName or "Unassigned")
    -- local dueText = (card.updatedAt or "No Due Date")
    local dueText = (formatISODate(card.updatedAt) or "No Due Date")
    
    self:drawText(assigneeText, textX, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)
    self:drawTextRight(dueText, x + width - padding, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)
    textY = textY + lineHeight

    -- Priority and Tags
    local priorityColor = card.priority == "High" and {r=1, g=0.2, b=0.2}
                          or card.priority == "Medium" and {r=1, g=0.6, b=0.2}
                          or {r=0.6, g=1, b=0.6}
    self:drawText((card.priority or "Normal"), textX, textY, priorityColor.r, priorityColor.g, priorityColor.b, 1, UIFont.Small)

    if card.tags and #card.tags > 0 then
        local tagsText = table.concat(card.tags, ", ")
        self:drawTextRight(tagsText, x + width - padding, textY, 0.7, 0.7, 0.7, 1, UIFont.Small)
    end

    return y + height
end

-- function MISScrollingListBox:doDrawItem(y, item, alt)
--     local x = 10
--     local width = self.width - 20
--     local height = 200
--     local padding = 15
--     local lineHeight = 18

--     local card = kb_mockTaks
--     local bgColor = self.selected == item.index and {r=0.2, g=0.4, b=0.8, a=0.3} or {r=0.1, g=0.1, b=0.1, a=0.6}
--     self:drawRect(x, y + padding, width, height - padding * 2, bgColor.a, bgColor.r, bgColor.g, bgColor.b)
--     self:drawRectBorder(x, y + padding, width, height - padding * 2, 0.9, 1, 1, 1)

--     local textX = x + padding
--     local textY = y + padding + 10

--     -- Title
--     self:drawText(card.title or "Untitled", textX, textY, 1, 1, 1, 1, UIFont.Medium)
--     textY = textY + lineHeight + 4

--     -- Description (truncated)
--     if card.description and card.description ~= "" then
--         local shortDesc = string.sub(card.description, 1, 100)
--         self:drawText(shortDesc .. "...", textX, textY, 0.85, 0.85, 0.85, 1, UIFont.Small)
--         textY = textY + lineHeight + 2
--     end

--     -- Assignee and Due Date
--     local assigneeText = "👤 " .. (card.assigneeName or "Unassigned")
--     self:drawText(assigneeText, textX, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)

--     local dueText = "📅 " .. (card.dueDate or "No Due Date")
--     local dueTextWidth = getTextManager():MeasureStringX(UIFont.Small, dueText)
--     self:drawText(dueText, x + width - padding - dueTextWidth, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)
--     textY = textY + lineHeight + 2

--     -- Priority
--     local priorityText = "⚡ " .. (card.priority or "Normal")
--     local priorityColor = card.priority == "High" and {r=1, g=0.2, b=0.2}
--                           or card.priority == "Medium" and {r=1, g=0.6, b=0.2}
--                           or {r=0.6, g=1, b=0.6}
--     self:drawText(priorityText, textX, textY, priorityColor.r, priorityColor.g, priorityColor.b, 1, UIFont.Small)

--     -- Tags
--     if card.tags and #card.tags > 0 then
--         local tagsText = "🏷 " .. table.concat(card.tags, ", ")
--         local tagsWidth = getTextManager():MeasureStringX(UIFont.Small, tagsText)
--         self:drawText(tagsText, x + width - padding - tagsWidth, textY, 0.7, 0.7, 0.7, 1, UIFont.Small)
--     end

--     return y + height
-- end


-- function MISScrollingListBox:doDrawItem(y, item, alt)
--     local x = 10
--     local width = self.width - 20
--     local height = 200
--     local padding = 15
--     local lineHeight = 18

--     local card = 

--     local bgColor = self.selected == item.index and {r=0.2, g=0.4, b=0.8, a=0.3} or {r=0.1, g=0.1, b=0.1, a=0.6}
--     self:drawRect(x, y + padding, width, height - padding * 2, bgColor.a, bgColor.r, bgColor.g, bgColor.b)
--     self:drawRectBorder(x, y + padding, width, height - padding * 2, 0.9, 1, 1, 1)

--     local textX = x + padding
--     local textY = y + padding + 4

--     -- Title
--     self:drawText(card.title or "Untitled", textX, textY, 1, 1, 1, 1, UIFont.Medium)
--     textY = textY + lineHeight

--     -- Description (shortened)
--     if card.description and card.description ~= "" then
--         local shortDesc = string.sub(card.description, 1, 40)
--         self:drawText(shortDesc .. "...", textX, textY, 0.8, 0.8, 0.8, 1, UIFont.Small)
--         textY = textY + lineHeight
--     end

--     -- Assignee and Due Date
--     local assigneeText = "👤 " .. (card.assigneeName or "Unassigned")
--     local dueText = "📅 " .. (card.dueDate or "No Due Date")
--     self:drawText(assigneeText, textX, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)
--     self:drawTextRight(dueText, x + width - padding, textY, 0.9, 0.9, 0.9, 1, UIFont.Small)
--     textY = textY + lineHeight

--     -- Priority and Tags
--     local priorityColor = card.priority == "High" and {r=1, g=0.2, b=0.2}
--                           or card.priority == "Medium" and {r=1, g=0.6, b=0.2}
--                           or {r=0.6, g=1, b=0.6}
--     self:drawText("⚡ " .. (card.priority or "Normal"), textX, textY, priorityColor.r, priorityColor.g, priorityColor.b, 1, UIFont.Small)

--     if card.tags and #card.tags > 0 then
--         local tagsText = table.concat(card.tags, ", ")
--         self:drawTextRight("🏷 " .. tagsText, x + width - padding, textY, 0.7, 0.7, 0.7, 1, UIFont.Small)
--     end

--     return y + height
-- end


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


-- -- Utility to print both attribute names and their values
-- function printTask(task)
--     for key, value in pairs(task) do
--         if type(value) ~= "table" then
--             print(tostring(key) .. " = " .. tostring(value))
--         end
--     end
-- end

function MISScrollingListBox:onViewTask(task)
    -- kb_TaskFormPanel1.new(task)

    -- printTask(task)

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