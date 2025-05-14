TaskBoard_Title = {}

local function showRenameDialog(window)
    local function onDialogResult(textBox, button)
        if button and button.internal == "OK" then
            local newTitle = textBox.entry:getText()
            if newTitle and newTitle:match("%S") then
                window:setTitle(newTitle)
                if TaskBoard_mainWindowFurniture then
                    TaskBoard_Title.set(TaskBoard_mainWindowFurniture, newTitle)
                    TaskBoard_mainWindowFurniture:transmitModData()
                    TaskBoard_Core.sendTaskCommand("TaskBoardTitleUpdated", TaskBoard_mainWindowFurniture, newTitle)
                end
            end
        end
    end

    local textBox = ISTextBox:new(
        getCore():getScreenWidth() / 2 - 150,
        getCore():getScreenHeight() / 2 - 50,
        300, 100,
        "Rename Board",
        window:getTitle()
    )
    textBox.onclick = onDialogResult
    textBox.target = textBox

    textBox:initialise()
    textBox:addToUIManager()
end

function TaskBoard_Title.patchWindowForRename(window)
    local orig_onMouseDown = window.onMouseDown
    local orig_onMouseUp = window.onMouseUp
    local orig_onMouseMove = window.onMouseMove

    window.titleBarClicked = false
    window.wasDragged = false

    window.onMouseDown = function(self, x, y)
        if y < self:titleBarHeight() then
            self.titleBarClicked = true
            self.wasDragged = false
        end
        if orig_onMouseDown then orig_onMouseDown(self, x, y) end
    end

    window.onMouseMove = function(self, dx, dy)
        if self.titleBarClicked and (math.abs(dx) > 2 or math.abs(dy) > 2) then
            self.wasDragged = true
        end
        if orig_onMouseMove then orig_onMouseMove(self, dx, dy) end
    end

    window.onMouseUp = function(self, x, y)
        if self.titleBarClicked and not self.wasDragged and y < self:titleBarHeight() then
            showRenameDialog(self)
        end
        self.titleBarClicked = false
        if orig_onMouseUp then orig_onMouseUp(self, x, y) end
    end
end

function TaskBoard_Title.set(furniture, newTitle)
    local modData = TaskBoard_Core.fetchModData(furniture)
    modData.boardTitle = newTitle
end

return TaskBoard_Title
