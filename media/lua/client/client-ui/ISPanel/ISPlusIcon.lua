require('ISUI/ISPanel')

-- Create a new panel class
local ISPlusIcon = ISPanel:derive("ISPlusIcon");

function ISPlusIcon:initialise()
    ISPanel.initialise(self);
end

function ISPlusIcon:render()
    ISPanel.render(self);

    -- Set the font and text
    local font = UIFont.Large;
    local text = "+";

    -- Measure the text size
    local textWidth = getTextManager():MeasureStringX(font, text);
    local textHeight = getTextManager():getFontFromEnum(font):getLineHeight();

    -- Calculate position to center the text
    local x = (self:getWidth() - textWidth) / 2;
    local y = (self:getHeight() - textHeight) / 2;

    -- Draw the "+" centered
    self:drawText(text, x, y, 1, 1, 1, 1, font);
end

function ISPlusIcon:onMouseDown(x, y)
    print("Plus icon clicked at:", x, y);
end

return ISPlusIcon