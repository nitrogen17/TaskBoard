require('ISUI/ISPanel')

MISPanel = ISPanel:derive("MISPanel");

function MISPanel:prerender()
    ISPanel.prerender(self);
    
    -- Use the title set from the client
    local text = self.title
    local font = UIFont.Medium
    local textWidth = getTextManager():MeasureStringX(font, text) -- Get text width
    local textHeight = getTextManager():MeasureStringY(font, text) -- Get text height
    
    -- Calculate the position to center the text
    local xPos = (self:getWidth() - textWidth) / 2
    local yPos = (self:getHeight() - textHeight) / 2
    
    self:drawText(text, xPos, yPos, 1, 1, 1, 1, font);
end

-- Setter function to update the title from the client
function MISPanel:setTitle(newTitle)
    self.title = newTitle
end