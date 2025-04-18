require('ISUI/ISPanel')
require('ISUI/ISTextEntryBox')
require('ISUI/ISButton')
require('ISUI/ISComboBox')

require('ISUI/ISPanel')

TaskFormPanel = ISPanel:derive("ISPanel");

function TaskFormPanel:prerender()
    -- ISPanel.prerender(self);
    
    -- Use the title set from the client
    local text = self.title
    local font = UIFont.Small
    local textWidth = getTextManager():MeasureStringX(font, text) -- Get text width
    local textHeight = getTextManager():MeasureStringY(font, text) -- Get text height
    
    -- Calculate the position to center the text
    local xPos = 10
    local yPos = (self:getHeight() - textHeight) / 2
    
    self:drawText(text, xPos, yPos, 1, 1, 1, 1, font);
end

-- Setter function to update the title from the client
function TaskFormPanel:setTitle(newTitle)
    self.title = newTitle
end

kb_priorityOptions = {"Low", "Medium", "High"}

-- Define the kb_TaskFormPanel table
kb_TaskFormPanel = {}

-- Declare the form panel and inputs inside the table
kb_TaskFormPanel.formPanel = nil
kb_TaskFormPanel.titleLabel = nil
kb_TaskFormPanel.descriptionLabel = nil
kb_TaskFormPanel.priorityLabel = nil
kb_TaskFormPanel.moreinfo = nil

kb_TaskFormPanel.action = nil
kb_TaskFormPanel.task = nil

-- This function creates the form and adds it to the UI
function kb_TaskFormPanel.createForm(action, task)
    kb_TaskFormPanel.action = action


    -- Create a new panel for the form
    kb_TaskFormPanel.formPanel = ISPanel:new(0, 0, 300, 400)
    kb_TaskFormPanel.formPanel:initialise()
    kb_TaskFormPanel.formPanel:setAnchorLeft(true)
    kb_TaskFormPanel.formPanel:setAnchorTop(true)

    kb_TaskFormPanel.formPanel.moveWithMouse = true

    kb_TaskFormPanel.titleTag = TaskFormPanel:new(0, 15, 280, 20)
    kb_TaskFormPanel.titleTag:initialise()
    kb_TaskFormPanel.titleTag:setTitle("Title")
    -- kb_TaskFormPanel.titleTag.backgroundColor = {r=1, g=0, b=0, a=1} -- Deep black
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.titleTag)

    -- Title Textbox
    kb_TaskFormPanel.titleLabel = ISTextEntryBox:new("", 10, kb_TaskFormPanel.titleTag:getY() + kb_TaskFormPanel.titleTag:getHeight() + 10, 280, 20)
    kb_TaskFormPanel.titleLabel:initialise()
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.titleLabel)


    kb_TaskFormPanel.descriptionTag = TaskFormPanel:new(0, kb_TaskFormPanel.titleLabel:getY() + kb_TaskFormPanel.titleLabel:getHeight() + 10, 280, 20)
    kb_TaskFormPanel.descriptionTag:initialise()
    kb_TaskFormPanel.descriptionTag:setTitle("Description")
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.descriptionTag)

    -- -- Description Textbox
    kb_TaskFormPanel.descriptionLabel = ISTextEntryBox:new("", 10, kb_TaskFormPanel.descriptionTag:getY() + kb_TaskFormPanel.descriptionTag:getHeight() + 10, 280, 60)
    kb_TaskFormPanel.descriptionLabel:initialise()
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.descriptionLabel)

    kb_TaskFormPanel.priorityTag = TaskFormPanel:new(0, kb_TaskFormPanel.descriptionLabel:getY() + kb_TaskFormPanel.descriptionLabel:getHeight() + 30, 280, 20)
    kb_TaskFormPanel.priorityTag:initialise()
    kb_TaskFormPanel.priorityTag:setTitle("Priority")
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.priorityTag)


    kb_TaskFormPanel.priorityLabel = ISComboBox:new(10, kb_TaskFormPanel.priorityTag:getY() + kb_TaskFormPanel.priorityTag:getHeight() + 10, 280, 27)
    for _, priority in ipairs(kb_priorityOptions) do
        kb_TaskFormPanel.priorityLabel:addOption(priority)
    end

    kb_TaskFormPanel.priorityLabel:initialise()
    kb_TaskFormPanel.priorityLabel:instantiate()
    kb_TaskFormPanel.formPanel:addChild(kb_TaskFormPanel.priorityLabel)

    -- Submit Button
    local submitButton = ISButton:new(10, 320, 280, 30, "Submit", nil, kb_TaskFormPanel.onSubmit)
    submitButton:initialise()
    kb_TaskFormPanel.formPanel:addChild(submitButton)

    if kb_TaskFormPanel.action == "edit" then
        kb_TaskFormPanel.task = task

        kb_TaskFormPanel.titleLabel:setText(task.title)
        kb_TaskFormPanel.descriptionLabel:setText(task.description)

        local selectedIndex = 1
        for i, priority in ipairs(kb_priorityOptions) do
            if string.lower(priority) == string.lower(task.priority or "") then
                selectedIndex = i
            end
        end
        kb_TaskFormPanel.priorityLabel.selected = selectedIndex
    end


    kb_TaskFormPanel.moreinfo = MISCollapsableWindow:new(0, 0, kb_TaskFormPanel.formPanel:getWidth(), kb_TaskFormPanel.formPanel:getHeight());
    kb_TaskFormPanel.moreinfo:initialise();
    kb_TaskFormPanel.moreinfo:setX((getCore():getScreenWidth() * 0.5) - (kb_TaskFormPanel.moreinfo:getWidth() * 0.5))
    kb_TaskFormPanel.moreinfo:setY((getCore():getScreenHeight() * 0.5) - (kb_TaskFormPanel.moreinfo:getHeight() * 0.5))
    kb_TaskFormPanel.moreinfo:setTitle("Task");

    kb_TaskFormPanel.formPanel:setY(kb_TaskFormPanel.moreinfo:titleBarHeight())
    
    kb_TaskFormPanel.moreinfo:addChild(kb_TaskFormPanel.formPanel)     

    kb_TaskFormPanel.moreinfo:addToUIManager()
    kb_TaskFormPanel.moreinfo:bringToTop()
end

function kb_TaskFormPanel.onSubmit()
    local title = kb_TaskFormPanel.titleLabel:getText() or ""        -- Default to empty string if nil or empty
    local description = kb_TaskFormPanel.descriptionLabel:getText() or ""  -- Default to empty string if nil or empty
    local selectedIndex = kb_TaskFormPanel.priorityLabel.selected
    local priority = kb_TaskFormPanel.priorityLabel.options[selectedIndex]

    if kb_TaskFormPanel.action == "create" then
        local createdTask = createCardInstance()
        createdTask.id = generateUUIDWithRetries()
        createdTask.title = title
        createdTask.description = description
        createdTask.priority = priority

        createdTask.createdByName = getPlayer(0):getUsername()
        createdTask.lastUserModifiedName = getPlayer(0):getUsername()

        sendClientCommand(MODDATA_KEY, "CreateTask", createdTask)
    elseif kb_TaskFormPanel.action == "edit" then
        -- kb_TaskFormPanel.task.lastUserModifiedID = 
        -- kb_TaskFormPanel.task.
        -- kb_TaskFormPanel.task.

        kb_TaskFormPanel.task.title = title
        kb_TaskFormPanel.task.description = description
        kb_TaskFormPanel.task.priority = priority
        kb_TaskFormPanel.task.lastUserModifiedName = getPlayer(0):getUsername()
        kb_TaskFormPanel.task.updatedAt = os.date("!%Y-%m-%dT%H:%M:%SZ")

        sendClientCommand(MODDATA_KEY, "UpdateTask", kb_TaskFormPanel.task)
        kb_TaskFormPanel.task = nil  
    end

    -- Process the data (For example, printing to the console)
    print("Title: " .. title)
    print("Description: " .. description)
    print("Priority: " .. priority)

    

    -- You can save this data, send it to a server, etc.
    -- You can also close the form after submission
    kb_TaskFormPanel.moreinfo:removeFromUIManager()
end