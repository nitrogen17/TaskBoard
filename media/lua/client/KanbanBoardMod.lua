require('ISUI/ISCollapsableWindow')
require('ISUI/ISPanel')
require('ISUI/ISScrollingListBox')

local MyListBox = ISScrollingListBox:derive("MyListBox")

function MyListBox:doDrawItem(y, item, alt)
    -- Red for items 1 and 5
    if item.index == 1 or item.index == 5 then
        self:drawRect(0, y, self.width, item.height, 1, 0.25, 0, 0)

    -- Random color for everything else
    else
        local r = 0.1
        local g = 0.9
        local b = 0.6
        self:drawRect(0, y, self.width, item.height, 1, r, g, b)
    end

    -- Call default drawing (text, border, selection highlight)
    ISScrollingListBox.doDrawItem(self, y, item, alt)

            -- Create a button
            local myButton = ISButton:new(0, 0, 100, 100, "Click Me", self, function()
                print("Button was clicked!")
            end)
            myButton:initialise()
            myButton:instantiate()
        
            self:addChild(myButton)

    return y + item.height
end

local KanbanViewController = ISCollapsableWindow:derive("KanbanViewController");

function KanbanViewController:initialise()
    print("KanbanViewController:initialise()")
    ISCollapsableWindow.initialise(self); 
    self:viewDidAppear();
end

function KanbanViewController:viewDidAppear()
    ----------------------------------------------------------------------------------------------------------------
    -- Main Parent Panel
    local parentPanel = ISPanel:new(0, self:titleBarHeight(), self.width, self.height * 0.08)
    parentPanel:initialise()
    --parentPanel.backgroundColor = {r=0.3, g=0, b=0, a=1}
    self:addChild(parentPanel)

    ----------------------------------------------------------------------------------------------------------------
    -- Compute exact widths
    local childWidth = parentPanel.width / 3

    -- Child Left Panel
    local childLeftPanel = ISPanel:new(0, 0, childWidth, parentPanel.height)
    childLeftPanel:initialise()
    --childLeftPanel.backgroundColor = {r=0, g=0.3, b=0, a=1}
    parentPanel:addChild(childLeftPanel)

    -- Child Middle Panel
    local childMiddlePanel = ISPanel:new(childWidth, 0, childWidth, parentPanel.height)
    childMiddlePanel:initialise()
    --childMiddlePanel.backgroundColor = {r=0, g=0.3, b=0.7, a=1}
    parentPanel:addChild(childMiddlePanel)

    -- Child Right Panel
    local childRightPanel = ISPanel:new(childWidth * 2, 0, childWidth, parentPanel.height)
    childRightPanel:initialise()
    --childRightPanel.backgroundColor = {r=0, g=0, b=0.3, a=1}
    parentPanel:addChild(childRightPanel)

    ----------------------------------------------------------------------------------------------------------------
    -- Content Left Panel
    local contentLeftPanel = ISPanel:new(0, childLeftPanel:getHeight() + self:titleBarHeight(), childWidth, self.height - (childLeftPanel:getHeight() + self:titleBarHeight()))
    contentLeftPanel:initialise()

    local scrollView1= ISScrollingListBox:new(0, 0, contentLeftPanel:getWidth(), contentLeftPanel:getHeight())
    scrollView1:initialise()
    contentLeftPanel:addChild(scrollView1)

    self:addChild(contentLeftPanel)

    -- Content Middle Panel
    local contentMiddlePanel = ISPanel:new(childWidth, childLeftPanel:getHeight() + self:titleBarHeight(), childWidth, self.height - (childLeftPanel:getHeight() + self:titleBarHeight()))
    contentMiddlePanel:initialise()

    local scrollView2 = ISScrollingListBox:new(0, 0, contentMiddlePanel:getWidth(), contentMiddlePanel:getHeight())
    scrollView2:initialise()
    contentMiddlePanel:addChild(scrollView2)

    self:addChild(contentMiddlePanel)

    -- Content Right Panel
    local contentRightPanel = ISPanel:new(childWidth * 2, childLeftPanel:getHeight() + self:titleBarHeight(), childWidth, self.height - (childLeftPanel:getHeight() + self:titleBarHeight()))
    contentRightPanel:initialise()

    local scrollView3 = MyListBox:new(0, 0, contentRightPanel:getWidth(), contentRightPanel:getHeight())
    scrollView3:initialise()
    contentRightPanel:addChild(scrollView3)

    self:addChild(contentRightPanel)

    ----------------------------------------------------------------------------------------------------------------
    -- Add global tasks
    for i = 1, 30 do
        local task = {
            uuid = i,
            title = "Task "
        }
        scrollView1:addItem(task.title, task)
        scrollView2:addItem(task.title, task)
        scrollView3:addItem(task.title, task)
    end    
end

function KanbanViewController:new()
    print("KanbanViewController:new()")
    local o = {};
    x = getMouseX() + 10;
    y = getMouseY() + 10;
    o = ISCollapsableWindow:new(x, y, getCore():getScreenWidth() * 0.5, getCore():getScreenHeight() * 0.6);
    o:setX((getCore():getScreenWidth() * 0.5) - (o:getWidth() * 0.5))
    o:setY((getCore():getScreenHeight() * 0.5) - (o:getHeight() * 0.5))
    setmetatable(o, self);
    self.__index = self;
    
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=1};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = false;

    return o;
end

Events.OnGameStart.Add(function()
    KanbanViewController = KanbanViewController:new()
    KanbanViewController:initialise();
    KanbanViewController:addToUIManager();
end)