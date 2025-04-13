require('ISUI/ISCollapsableWindow')
require('ISUI/ISPanel')
require('ISUI/ISScrollingListBox')
require('ISUI/ISRichTextPanel')
require('ISUI/ISButton')

local TaskCardPanel = ISPanel:derive("TaskCardPanel")

-- Constructor to accept dynamic task data
function TaskCardPanel:initialise(taskData)
    ISPanel.initialise(self)
    self:create(taskData)
end

function TaskCardPanel:create(taskData)
    local padding = 16
    local innerWidth = self.width - padding * 2

    -- Header: Status Bar
    self.header = ISPanel:new(0, 0, self.width, 40)
    self.header.backgroundColor = {r=0.15, g=0.15, b=0.15, a=1}
    self.header.moveWithMouse = true
    self:addChild(self.header)

    local sectionStatus

    if taskData.sectionID == 1 then
        sectionStatus = "To Do"
    elseif taskData.sectionID == 2 then
        sectionStatus = "In Progress"
    elseif taskData.sectionID == 3 then
        sectionStatus = "Done"
    else
        sectionStatus = "Unknown"
    end

    self.statusLabel = ISLabel:new(16, 12, 20, sectionStatus, 1, 1, 1, 1, UIFont.Medium, true)
    self.header:addChild(self.statusLabel)

    -- Content Area (Rich Text Panel)
    self.richText = ISRichTextPanel:new(padding, 50, innerWidth, self.height - 110)
    self.richText:initialise()
    self.richText.autosetheight = false
    self.richText.clip = true
    self.richText:addScrollBars()
    self.richText.moveWithMouse = true
    self.richText.backgroundColor = {r=0.1, g=0.1, b=0.1, a=1}

    self.richText.text = string.format(
        "<TEXTSIZE:medium>" ..
        "<RGB:0.7,0.7,0.7>Task Title:<LINE><RGB:1,1,1>%s<LINE>" ..
        "<RGB:0.7,0.7,0.7>Description:<LINE><RGB:1,1,1>%s<LINE><LINE>" ..
        "<RGB:0.7,0.7,0.7>Last Modified By:<LINE><RGB:1,1,1>%s (%s)",
        taskData.title,
        tostring(taskData.description),
        taskData.lastUserModifiedName,
        taskData.lastUserModifiedID
    )

    self.richText:paginate()
    self:addChild(self.richText)

    -- OK Button
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
    o.backgroundColor = {r=0, g=0, b=0, a=1} -- Deep black
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
