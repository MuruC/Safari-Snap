local LocatorGui = {}

function LocatorGui:Init()
    self.timer = 0

    self.rootUI = localPlayer.Local.MinimapGui
    self.arrow = self.rootUI.RangeImg.ArrowImg
    self.closeBtn = self.rootUI.MapImg.CloseBtn

    self:BindAction()
end

--- 绑定事件
function LocatorGui:BindAction()
    self.closeBtn.OnClick:Connect(function()
        self:CloseMinimap()
    end)
end

--- 打开小地图
--- @param _arrowAnchor Vector2
--- @param _arrowAngle Float
function LocatorGui:OpenMinimap(_arrowAnchor, _arrowAngle)
    
    self.arrow.AnchorsX = Vector2.One * _arrowAnchor.X
    self.arrow.AnchorsY = Vector2.One * _arrowAnchor.Y
    self.arrow.Offset = Vector2.Zero

    self.arrow.Angle = _arrowAngle

    --self.rootUI.LocatorImg:SetActive(not localPlayer.Local.ControlGui.LocatorImg.ActiveSelf)
    self.rootUI.LocatorImg.PosTxt.Text = 'X:'.. math.round(localPlayer.Position.X)..' Y:'..math.round(localPlayer.Position.Y)..' Z:'.. math.round(localPlayer.Position.Z)

    C_GuiMgr:OpenGui("MinimapGui")
end

--- 关闭小地图
function LocatorGui:CloseMinimap()
    -- ## 打开主界面的其他显示按钮
    BagpackGui:OtherPnlControl(true)
	C_GuiMgr:BackToMainInterface()
end

return LocatorGui