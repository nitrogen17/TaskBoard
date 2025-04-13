require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISLabel"
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"
require("main")

MISPanel = ISPanel:derive("MISPanel")

local PersistencyManager = require("helper/PersistencyManager")

colorOptions = {"Red", "Green", "Blue", "Yellow"}

function MISPanel:prerender()
    ISPanel.prerender(self)
    local text = self.title
    local font = UIFont.Medium
    local textWidth = getTextManager():MeasureStringX(font, text)
    local textHeight = getTextManager():MeasureStringY(font, text)
    local xPos = (self:getWidth() - textWidth) / 2
    local yPos = (self:getHeight() - textHeight) / 2 - 4
    self:drawText(text, xPos, yPos, 1, 1, 1, 1, font)
end

function MISPanel:setTitle(newTitle)
    self.title = newTitle
end

TaskFormPanel = ISPanel:derive("TaskFormPanel")

function TaskFormPanel:new(x, y, width, height, mode, task)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = {r=1, g=1, b=1, a=0.9}
    o.backgroundColor = {r=0.1, g=0.1, b=0.1, a=0.9}
    o.moveWithMouse = true
    o.colorDropdown = {}
    o.mode = mode or "create"
    o.task = task
    return o
end

function TaskFormPanel:initialise()
    ISPanel.initialise(self)

    local function centerX(parentWidth, elementWidth)
        return (parentWidth - elementWidth) / 2
    end

    local fieldWidth = 220
    local fieldHeight = 22
    local labelWidth = 100
    local labelHeight = 22
    local startX = 20
    local fieldX = startX + labelWidth + 120
    local paddingY = 32
    local startY = 40

    local titleHeight = 35
    local titlePanel = MISPanel:new(0, 0, self:getWidth(), titleHeight)
    local panelTitle = self.mode == "update" and "Edit Task" or "Create Task"
    titlePanel:setTitle(panelTitle)
    titlePanel.moveWithMouse = true  
    titlePanel:initialise()
    self:addChild(titlePanel)

    local fields = {
        {name="Title", key="title"},
        {name="Description", key="description"},
        {name="Color", key="color", type="dropdown"}
    }

    local newTask = createCardInstance()

    self.fields = {}

    for i, field in ipairs(fields) do
        local y = startY + (i - 1) * paddingY

        local label = ISLabel:new(startX, y, labelHeight, field.name, 1, 1, 1, 1, UIFont.Small, true)
        self:addChild(label)

        if field.type == "dropdown" then
            self.colorDropdown = ISComboBox:new(fieldX, y, fieldWidth, fieldHeight)
            for _, color in ipairs(colorOptions) do
                self.colorDropdown:addOption(color)
            end
            self.colorDropdown:initialise()
            self.colorDropdown:instantiate()
            self:addChild(self.colorDropdown)
            self.fields[field.key] = self.colorDropdown
        else
            local input = ISTextEntryBox:new("", fieldX, y, fieldWidth, fieldHeight)
            input:initialise()
            input:instantiate()
            self:addChild(input)
            self.fields[field.key] = input
        end
    end

    local buttonY = startY + #fields * paddingY + 20
    local buttonWidth = 100
    local buttonHeight = 26
    local buttonSpacing = 12
    local totalButtonWidth = buttonWidth * 2 + buttonSpacing
    local buttonStartX = centerX(self:getWidth(), totalButtonWidth)

    self.saveButton = ISButton:new(buttonStartX, buttonY, buttonWidth, buttonHeight, "Save", self, TaskFormPanel.onSave)
    self.saveButton:initialise()
    self:addChild(self.saveButton)

    self.closeButton = ISButton:new(buttonStartX + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight, "Close", self, TaskFormPanel.onClose)
    self.closeButton:initialise()
    self:addChild(self.closeButton)

    if self.mode == "update" then
        self:setData(self.task)
    end

end

function TaskFormPanel:setData(task)
        for key, input in pairs(self.fields) do
            if key == "color" then
                local selectedIndex = 1
                for i, color in ipairs(colorOptions) do
                    if string.lower(color) == string.lower(self.task.color or "") then
                        selectedIndex = i
                    end
                end
                self.colorDropdown.selected = selectedIndex
            elseif key == "description" then
                input:setText(self.task.description)
            elseif key == "title" then
                input:setText(self.task.title)
            end
        end    
end

function TaskFormPanel:onSave()
    local card = createCardInstance()

    for key, input in pairs(self.fields) do
        if key ~= "color" then
            card[key] = input:getText()
        else 
            local selectedIndex = self.colorDropdown.selected
            local selectedColor = self.colorDropdown:getOptionText(selectedIndex)
            card[key] = selectedColor
        end
    end

    if self.mode == "create" then
        local player = getSpecificPlayer(0)

        card.id = generateUUIDWithRetries(PersistencyManager.fetchTodos())
        card.sectionID = 1
        card.lastUserModifiedID = player:getOnlineID()
        card.lastUserModifiedName = player:getDisplayName()

        PersistencyManager.createTodo(card)

        clearDataToSections()
        renderDataToSections() 

        self:removeFromUIManager()
    elseif self.mode == "update" then
        for key, input in pairs(self.fields) do
            if key == "color" then
                local selectedIndex = input.selected
                local selectedColor = input:getOptionText(selectedIndex)
                self.task.color = selectedColor
            elseif key == "description" then
                self.task.description = input:getText()
            elseif key == "title" then
                self.task.title = input:getText()
            end
        end

        PersistencyManager.updateTodo(self.task.id, self.task)

        clearDataToSections()
        renderDataToSections() 

        self:removeFromUIManager()
    end

    print("Saved Task (Card Instance):")
    for k, v in pairs(card) do
        if type(v) ~= "table" then
            print(k .. ": " .. tostring(v))
        end
    end    
end

function TaskFormPanel:onClose()
    self:removeFromUIManager()
end

return TaskFormPanel