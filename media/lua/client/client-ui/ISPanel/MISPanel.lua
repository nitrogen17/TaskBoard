require('ISUI/ISPanel')

kb_MISPanel = ISPanel:derive("MISPanel");

function kb_MISPanel:prerender()
    ISPanel.prerender(self);

    local text = self.title
    local font = UIFont.Medium
    local textWidth = getTextManager():MeasureStringX(font, text)
    local textHeight = getTextManager():MeasureStringY(font, text)

    local xPos = (self:getWidth() - textWidth) / 2
    local yPos = (self:getHeight() - textHeight) / 2

    self:drawText(text, xPos, yPos, 1, 1, 1, 1, font);
end

function kb_MISPanel:setTitle(newTitle)
    self.title = newTitle
end
