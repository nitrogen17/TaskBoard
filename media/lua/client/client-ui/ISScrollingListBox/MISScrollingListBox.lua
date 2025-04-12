require('ISUI/ISScrollingListBox')

MISScrollingListBox = ISScrollingListBox:derive("MISScrollingListBox")

function MISScrollingListBox:initialise()
    ISScrollingListBox.initialise(self)
    self:setCapture(true) -- allow capturing mouse input
end

-- Overriding the addItem function
function MISScrollingListBox:addItem(item)
    table.insert(self.tableTasks, item)
    print("Table insert")
    ISScrollingListBox.addItem(self, item)  
end

function MISScrollingListBox:onRightMouseDown(x, y)
    local itemIndex = self:rowAt(x, y)
    print("[DEBUG] pressed right click")
    print("[DEBUG@@@] ", self.tableName)

    print("[#######]", self.tableTasks[itemIndex].description)


    if itemIndex and self.items[itemIndex] then
        local context = ISContextMenu.get(0, getMouseX(), getMouseY())

        context:addOption("Title: ", self, self.onContextOption, itemIndex)
        context:addOption("View Task", self, self.onViewTask)
        context:addOption("Edit Task", self, self.onEditTask)
        context:addOption("Delete", self, self.onDeleteTask)

        local moveSubMenu = ISContextMenu:getNew(context)
        context:addSubMenu(context:addOption("Move", self, nil), moveSubMenu)

        moveSubMenu:addOption("In Progress", self, self.onMoveTask)
        moveSubMenu:addOption("Done", self, self.onMoveTask)
    end

    return false -- safely handle empty space clicks
end

function MISScrollingListBox:new(x, y, width, height)
    local object = ISScrollingListBox.new(self, x, y, width, height)
    object.tableID = 0
    object.tableName = ""
    object.tableTasks = {}

    -- Deselect any item initially
    object.selected = -1
    
    return object
end
