require('ISUI/ISPanel')

local ISPlusIcon = ISPanel:derive("ISPlusIcon");

function ISPlusIcon:initialise()
    ISPanel.initialise(self);
end

function ISPlusIcon:render()
    ISPanel.render(self);

    local font = UIFont.Large;
    local text = "+";

    local textWidth = getTextManager():MeasureStringX(font, text);
    local textHeight = getTextManager():getFontFromEnum(font):getLineHeight();

    local x = (self:getWidth() - textWidth) / 2;
    local y = (self:getHeight() - textHeight) / 2;

    self:drawText(text, x, y, 1, 1, 1, 1, font);
end

function ISPlusIcon:onMouseDown(x, y)
    kb_TaskFormPanel.createForm("create")
end

return ISPlusIcon