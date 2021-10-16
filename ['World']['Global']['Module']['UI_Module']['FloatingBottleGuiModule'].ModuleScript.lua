local FloatingBottleGui = {}

function FloatingBottleGui:Init()
    self.rootUI = localPlayer.Local.FloatingBottleGui
    self.content = self.rootUI.PaperImg.Txt
    self:BindAction()
end

function FloatingBottleGui:BindAction()
    self.rootUI.CloseBtn.OnClick:Connect(function()
        self:Close()     
    end)
end

---@param _content string 
---@param _localizeKey string 
function FloatingBottleGui:Open(_content, _localizeKey)
    if _localizeKey then 
        self.content.LocalizeKey = _localizeKey
    elseif _content then 
        self.content.Text = _content 
    end
    C_GuiMgr:OpenGui("FloatingBottleGui")
end

function FloatingBottleGui:Close()
	C_GuiMgr:BackToMainInterface()
end

return FloatingBottleGui