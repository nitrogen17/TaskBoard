require("ISUI/ISPanel")
require("ISUI/ISButton")
require("ISUI/ISTextBox")

TaskBoard_Title = {}

local function showRenameDialog(window)
    -- The callback signature should match what ISTextBox.onClick is passing
    local function onDialogResult(target, button)
        -- Only process OK button clicks
        if button and button.internal == "OK" then
            -- Get text from the entry field
            local newTitle = target.entry:getText()

            if newTitle and newTitle:match("%S") then
                -- Update the window title
                window:setTitle(newTitle)
                window:bringToTop()
                window:dirtyUI()

                -- Save to modData if furniture exists
                if TaskBoard_mainWindowFurniture then
                    local modData = TaskBoard_Core.fetchModData(TaskBoard_mainWindowFurniture)
                    modData.boardTitle = newTitle
                    TaskBoard_mainWindowFurniture:transmitModData()
                end
            end
        end
    end

    -- Create the ISTextBox (matches original signature exactly)
    local textBox = ISTextBox:new(
        getCore():getScreenWidth() / 2 - 150,   -- x
        getCore():getScreenHeight() / 2 - 50,   -- y
        300, 100,                               -- width, height
        "Rename Board",                         -- text
        window:getTitle(),                      -- defaultEntryText
        nil,                                    -- target (we don't use this)
        onDialogResult,                         -- onclick callback
        nil                                     -- player
    )
    textBox:initialise()
    textBox:addToUIManager()
end

function TaskBoard_Title.patchWindowForRename(window)
    -- Store original handlers
    local orig_onMouseDown = window.onMouseDown
    local orig_onMouseUp = window.onMouseUp
    local orig_onMouseMove = window.onMouseMove

    -- Add tracking variables
    window.titleBarClicked = false
    window.wasDragged = false

    -- Override mouse down to track title bar clicks
    window.onMouseDown = function(self, x, y)
        if y < self:titleBarHeight() then
            self.titleBarClicked = true
            self.wasDragged = false
        end
        if orig_onMouseDown then orig_onMouseDown(self, x, y) end
    end

    -- Override mouse move to track dragging
    window.onMouseMove = function(self, dx, dy)
        if self.titleBarClicked and (math.abs(dx) > 2 or math.abs(dy) > 2) then
            self.wasDragged = true
        end
        if orig_onMouseMove then orig_onMouseMove(self, dx, dy) end
    end

    -- Override mouse up to handle rename on click
    window.onMouseUp = function(self, x, y)
        if self.titleBarClicked and not self.wasDragged and y < self:titleBarHeight() then
            showRenameDialog(self)
        end
        self.titleBarClicked = false
        if orig_onMouseUp then orig_onMouseUp(self, x, y) end
    end
end

return TaskBoard_Title
