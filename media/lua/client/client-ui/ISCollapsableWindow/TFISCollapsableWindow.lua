require "ISUI/ISCollapsableWindow"

kb_TFISCollapsableWindow = ISCollapsableWindow:derive("TFISCollapsableWindow");

function kb_TFISCollapsableWindow:new(x, y, width, height)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o:setResizable(false)
    return o
end
