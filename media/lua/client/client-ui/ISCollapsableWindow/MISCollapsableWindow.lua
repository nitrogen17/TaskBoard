require "ISUI/ISCollapsableWindow"

kb_MISCollapsableWindow = ISCollapsableWindow:derive("MISCollapsableWindow");

local originalNew = kb_MISCollapsableWindow.new

local function layoutHeaderPanel(panel, x, y, width, height, title)
    panel:setX(x)
    panel:setY(y)
    panel:setWidth(width)
    panel:setHeight(height)
    if title then
        panel:setTitle(title)
    end
end

local function layoutChildPanel(panel, listBox, x, y, width, height)
    panel:setX(x)
    panel:setY(y)
    panel:setWidth(width)
    panel:setHeight(height)

    if listBox then
        listBox:setWidth(width)
        listBox:setHeight(height)
    end
end

function kb_MISCollapsableWindow:new()
    local width = getCore():getScreenWidth() * 0.5
    local height = getCore():getScreenHeight() * 0.6
    local x = width - width * 0.5
    local y = height - height * 0.5 - 25
    local o = originalNew(self, x, y, width, height)
    o:setVisible(false)
    o:setResizable(true)
    return o
end

function kb_MISCollapsableWindow:onResize()
    self:updateTaskBoardLayout()
end

function kb_MISCollapsableWindow:updateTaskBoardLayout()
    local layout = TaskBoard_Utils.computeLayout(self)

    if kb_sectionHeaderPanel then
        layoutHeaderPanel(kb_sectionHeaderPanel,
                          0, self:titleBarHeight(),
                          layout.newWidth, layout.headerHeight)
    end

    if kb_sectionLeftHeaderPanel then
        layoutHeaderPanel(kb_sectionLeftHeaderPanel,
                          0, self:titleBarHeight(),
                          layout.sectionWidth, layout.headerHeight)
    end

    if kb_sectionMiddleHeaderPanel then
        layoutHeaderPanel(kb_sectionMiddleHeaderPanel,
                          layout.sectionWidth, self:titleBarHeight(),
                          layout.sectionWidth, layout.headerHeight)
    end

    if kb_sectionRightHeaderPanel then
        layoutHeaderPanel(kb_sectionRightHeaderPanel,
                          layout.sectionWidth * 2, self:titleBarHeight(),
                          layout.sectionWidth, layout.headerHeight)
    end

    if kb_childLeftPanel and kb_sectionLeftHeaderPanel then
        layoutChildPanel(kb_childLeftPanel, kb_leftListBox,
                         0, self:titleBarHeight() + layout.headerHeight,
                         layout.sectionWidth, layout.availableHeight)
    end

    if kb_childMiddlePanel and kb_sectionMiddleHeaderPanel then
        layoutChildPanel(kb_childMiddlePanel, kb_middleListBox,
                         layout.sectionWidth, self:titleBarHeight() + layout.headerHeight,
                         layout.sectionWidth, layout.availableHeight)
    end

    if kb_childRightPanel and kb_sectionRightHeaderPanel then
        layoutChildPanel(kb_childRightPanel, kb_rightListBox,
                         layout.sectionWidth * 2, self:titleBarHeight() + layout.headerHeight,
                         layout.sectionWidth, layout.availableHeight)
    end
end
