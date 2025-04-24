require('ISUI/ISCollapsableWindow')
require('ISUI/ISPanel')
require('ISUI/ISScrollingListBox')
require('ISUI/ISRichTextPanel')
require('ISUI/ISButton')

local TaskCardPanel = ISPanel:derive("TaskCardPanel")

function TaskCardPanel:initialise(taskData)
    ISPanel.initialise(self)
    self:create(taskData)
end

local function formatISODate(isoString)
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

function TaskCardPanel:create(task)
    local padding = 16
    local innerWidth = self.width - padding * 2

    self.header = ISPanel:new(0, 0, self.width, 40)
    self.header.backgroundColor = {r=0.15, g=0.15, b=0.15, a=1}
    self.header.moveWithMouse = true
    self:addChild(self.header)

    local sectionStatus

    if task.sectionID == 1 then
        sectionStatus = "To Do"
    elseif task.sectionID == 2 then
        sectionStatus = "In Progress"
    elseif task.sectionID == 3 then
        sectionStatus = "Done"
    else
        sectionStatus = "Unknown"
    end

    self.statusLabel = ISLabel:new(16, 12, 20, sectionStatus, 1, 1, 1, 1, UIFont.Medium, true)
    self.header:addChild(self.statusLabel)

    self.richText = ISRichTextPanel:new(padding, 50, innerWidth, self.height - 110)
    self.richText:initialise()
    self.richText.autosetheight = false
    self.richText.clip = true
    self.richText:addScrollBars()
    self.richText.moveWithMouse = true
    self.richText.backgroundColor = {r=0.1, g=0.1, b=0.1, a=1}

    self.richText.text = string.format(
        "%s\n\n%s\n\n\n%s\n\nCreated at:\n%s\n%s\n\nModified at:\n%s\n%s\n",
        task.title,
        task.description,
        task.priority,
        formatISODate(task.createdAt),
        task.createdByName,
        formatISODate(task.updatedAt),
        task.lastUserModifiedName
    )

    self.richText:paginate()
    self:addChild(self.richText)

    local buttonWidth = 100
    local buttonHeight = 30
    self.okButton = ISButton:new(
        (self.width - buttonWidth) / 2,
        self.height - buttonHeight - padding,
        buttonWidth, buttonHeight,
        "OK",
        self,
        TaskCardPanel.onOKButtonClick
    )
    self.okButton:initialise()
    self.okButton.font = UIFont.Medium
    self.okButton.borderColor = {r=0.6, g=0.6, b=0.6, a=1}
    self.okButton.backgroundColor = {r=0.2, g=0.2, b=0.2, a=1}
    self.okButton.backgroundColorMouseOver = {r=0.3, g=0.3, b=0.3, a=1}
    self.okButton.backgroundColorClicked = {r=0.1, g=0.1, b=0.1, a=1}
    self:addChild(self.okButton)
end

function TaskCardPanel:onOKButtonClick()
    self:removeFromUIManager()
end

function TaskCardPanel:new()
    local o = ISPanel:new(0, 0, 360, 420)
    setmetatable(o, self)
    self.__index = self

    o:setX((getCore():getScreenWidth() * 0.5) - (o:getWidth() * 0.5))
    o:setY((getCore():getScreenHeight() * 0.5) - (o:getHeight() * 0.5))

    o.borderColor = {r=0.5, g=0.5, b=0.5, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=1}
    o.moveWithMouse = true

    return o
end

function TaskCardPanel:onMouseDown(x, y)
    ISPanel.onMouseDown(self, x, y)
    self.dragging = true
end

function TaskCardPanel:onMouseUp(x, y)
    ISPanel.onMouseUp(self, x, y)
    self.dragging = false
end

return TaskCardPanel
