TaskBoard_Title = {}

local function showRenameDialog(window)
    local textBox = ISTextBox:new(
        getCore():getScreenWidth() / 2 - 150,
        getCore():getScreenHeight() / 2 - 50,
        300, 100,
        "Rename Board",
        window:getTitle(),
        nil,
        function(button, newTitle)
            if button and button.internal == "OK" and newTitle and newTitle:match("%S") then
                window:setTitle(newTitle)
                window:bringToTop()
                window:dirtyUI()

                if TaskBoard_mainWindowFurniture then
                    local modData = TaskBoard_Core.fetchModData(TaskBoard_mainWindowFurniture)
                    modData.boardTitle = newTitle
                    TaskBoard_mainWindowFurniture:transmitModData()
                end
            end
        end,
        nil
    )
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
        return orig_onMouseDown(self, x, y)
    end

    window.onMouseMove = function(self, dx, dy)
        if self.titleBarClicked and (math.abs(dx) > 2 or math.abs(dy) > 2) then
            self.wasDragged = true
        end
        return orig_onMouseMove(self, dx, dy)
    end

    window.onMouseUp = function(self, x, y)
        if self.titleBarClicked and not self.wasDragged and y < self:titleBarHeight() then
            showRenameDialog(self)
        end
        self.titleBarClicked = false
        return orig_onMouseUp(self, x, y)
    end
end

return TaskBoard_Title
