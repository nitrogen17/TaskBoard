require('ISUI/ISScrollingListBox')

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

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

function MISScrollingListBox:onRightMouseDown(x, y)
    local itemIndex = self:rowAt(x, y)

    if itemIndex and self.tableTasks[itemIndex] then
        local context = ISContextMenu.get(0, getMouseX(), getMouseY())
        local task = self.tableTasks[itemIndex]
        local sectionID = self.tableTasks[itemIndex].sectionID

        print("[Srolling] contex: ", context)
        print("[Srolling] task: ", task.description)
        print("[Srolling] sectionID: ", sectionID)


        printTable(task)
    end
    return false
end

function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(prefix .. tostring(key) .. " = {")
            printTable(value, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(key) .. " = " .. tostring(value))
        end
    end
end