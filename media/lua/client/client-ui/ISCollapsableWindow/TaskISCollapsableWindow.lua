require('ISUI/ISCollapsableWindow')
require('ISUI/ISRichTextPanel')
local PersistencyManager = require("helper/PersistencyManager")

TaskWindow = ISCollapsableWindow:derive("TaskWindow")

function TaskWindow:initialise()
    ISCollapsableWindow.initialise(self)
    self:create()
end

function TaskWindow:create()
    local margin = 10

    self.richText = ISRichTextPanel:new(
        margin,
        20 + margin,
        self.width - margin * 2,
        self.height - (margin * 2 + 20)
    )
    self.richText:initialise()
    self.richText.autosetheight = false
    self.richText.clip = true
    self.richText:addScrollBars()
    self.richText.backgroundColor = {r=0, g=0, b=0, a=0}

    self:updateText()

    self:addChild(self.richText)
end

function TaskWindow:updateText()
    local task = self.taskData

    PersistencyManager.readTodo(task.id)

    local title = task.title or "Untitled Task"
    local description = task.description or "No description."
    local status = task.status or "Unknown"
    local createdAt = type(task.createdAt) == "number" and os.date("%Y-%m-%d %H:%M:%S", task.createdAt) or tostring(task.createdAt or "Unknown")
    local updatedAt = type(task.updatedAt) == "number" and os.date("%Y-%m-%d %H:%M:%S", task.updatedAt) or tostring(task.updatedAt or "Unknown")
    local lastUserName = task.lastUserModifiedName or "Unknown"

    self.richText.text =
        "<B>Title:</B> " .. title ..
        "<LINE><LINE><B>Description:</B> " .. description ..
        "<LINE><LINE><B>Status:</B> " .. status ..
        "<LINE><LINE><B>Created at:</B> " .. createdAt ..
        "<LINE><B>Updated at:</B> " .. updatedAt ..
        "<LINE><B>Last modified by:</B> " .. lastUserName

    self.richText:paginate()
end



function TaskWindow:onResize()
    ISCollapsableWindow.onResize(self)

    local margin = 10
    local newRichTextWidth = self.width - margin * 2
    local newRichTextHeight = self.height - (margin * 2 + 20)

    self.richText:setWidth(newRichTextWidth)
    self.richText:setHeight(newRichTextHeight)
    self.richText:paginate()
end

function TaskWindow:new(x, y, width, height, taskData)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.taskData = taskData or {}
    o.title = o.taskData.windowTitle or "Task"
    o.resizable = true
    o.pin = true

    o:addToUIManager()

    return o
end
