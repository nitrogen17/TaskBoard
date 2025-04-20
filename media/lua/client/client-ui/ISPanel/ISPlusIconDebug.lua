require('ISUI/ISPanel')

local ISPlusIconDebug = ISPanel:derive("ISPlusIconDebug");

function ISPlusIconDebug:initialise()
    ISPanel.initialise(self);
end

function ISPlusIconDebug:render()
    ISPanel.render(self);

    local font = UIFont.Large;
    local text = "+";

    local textWidth = getTextManager():MeasureStringX(font, text);
    local textHeight = getTextManager():getFontFromEnum(font):getLineHeight();

    local x = (self:getWidth() - textWidth) / 2;
    local y = (self:getHeight() - textHeight) / 2;

    self:drawText(text, x, y, 1, 1, 1, 1, font);
end

function ISPlusIconDebug:onMouseDown(x, y)
    for _, task in pairs(kb_DataManager.getMockTasks()) do
        sendClientCommand(MODDATA_KEY, "CreateTask", task)
    end
end

return ISPlusIconDebug