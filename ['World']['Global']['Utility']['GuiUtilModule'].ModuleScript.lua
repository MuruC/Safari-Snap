---Gui工具类
---author Chen Muru
local GuiUtil = {}

--- 按钮排列
--- @param _tbl table 按钮所属的按钮表
--- @param _rowInterval int 每行间隔
--- @param _columnInterval int 每列间隔
--- @param _rowStartPoint int 行开头y坐标
--- @param _columnStartPoint int 列开头x坐标
--- @param _maxBtnInRow int 每行最多按钮的数量
--- @param _objKey string gui在_table中的Key
function GuiUtil.ArrangeGui(_tbl,_rowInterval,_columnInterval,_rowStartPoint,_columnStartPoint,_maxBtnInRow,_objKey)
    local rowIndex = 0
    local columnIndex = -1
    for k, v in pairs(_tbl) do
        columnIndex = columnIndex + 1
        if columnIndex > _maxBtnInRow - 1 then
            columnIndex = 0
            rowIndex = rowIndex + 1
        end
        local pos = Vector2(_columnStartPoint + columnIndex * _columnInterval, _rowStartPoint - rowIndex * _rowInterval)
        if _objKey then
            v[_objKey].Offset = pos
        else
            v.Offset = pos
        end
    end
end

local DisplayUiAtTarget = function(gui,targetPos)
    gui.AnchorsX = Vector2(targetPos.x,targetPos.x)
    gui.AnchorsY = Vector2(targetPos.y,targetPos.y)
end

local GetFingerPos = function(_touchInfo,root)
    local fingerPos
    for k,v in pairs(_touchInfo) do
        ---触摸信息
        fingerPos = v.Position
    end
    if not root then
        return world.CurrentCamera:ScreenToViewportPoint(Vector3(fingerPos.x, fingerPos.y, 0))
    else
        local offset = root.Offset
        local VPX = root.Size.x
        local VPY = root.Size.y
        local originPointX = offset.x - VPX/2
        local originPointY = offset.y - VPY/2
        return Vector2((fingerPos.x + originPointX - 500) / VPX, (fingerPos.y + originPointY + 100) / VPY)
    end
end

local GetMousePos = function(root)
    local mouseHit = Input.GetMouseScreenPos()
    if not root then
        return world.CurrentCamera:ScreenToViewportPoint(Vector3(mouseHit.x, mouseHit.y, 0))
    else
        local offset = root.Offset
        local VPX = root.Size.x
        local VPY = root.Size.y
        local originPointX = offset.x - VPX/2
        local originPointY = offset.y - VPY/2
        return Vector2((mouseHit.x + originPointX) / VPX, (mouseHit.y + originPointY + 200) / VPY)
    end
end

--- 创建滑动条
function GuiUtil.CreateSlider(_type,minPosVal,maxPosVal,minVal,maxVal,pressedSilderBtn,showBtn)
    showBtn = showBtn or pressedSilderBtn
    local coe = (maxVal - minVal) / (maxPosVal - minPosVal)
    local curPos = minPosVal
    local viewportPos
    local MoveGui = function()
        if _type == Const.SliderTypeNum.Vertical then
            local newPosY = viewportPos.y
            if newPosY >= minPosVal and newPosY <= maxPosVal then
                DisplayUiAtTarget(showBtn,Vector2(showBtn.AnchorsX.x,newPosY))
                curPos = newPosY
            end
        end
        pressedSilderBtn.Output.Value = coe * (curPos - minPosVal) + minVal
    end
    pressedSilderBtn.OnTouched:Connect(function(_touchInfo)
        viewportPos = GetFingerPos(_touchInfo)
        MoveGui()
    end)
    pressedSilderBtn.OnDown:Connect(function()
        pressedSilderBtn.bDown.Value = true
    end)
    pressedSilderBtn.OnUp:Connect(function()
        pressedSilderBtn.bDown.Value = false
    end)
    world.OnRenderStepped:Connect(function()
        if not pressedSilderBtn.bDown.Value then
            return
        end
        local mouseHit = Input.GetMouseScreenPos()
        viewportPos = GetMousePos()
        MoveGui()
	end)
end

local DragUi = {}
function DragUi:Initialize(identifyBtn,showBtn,root)
    self.identifyBtn = identifyBtn
    self.showBtn = showBtn
    self.root = root
    self:BindBtnEventCallback()
end

function DragUi:BindBtnEventCallback()
    self.identifyBtn.OnTouched:Connect(function(_touchInfo)
        DisplayUiAtTarget(self.showBtn,GetFingerPos(_touchInfo,self.root))
    end)
    self.identifyBtn.OnDown:Connect(function()
        if world:GetDevicePlatform() == Enum.Platform.Windows then
            self.MouseIn = true
        end
        self:OnDragBegin()
    end)
    self.identifyBtn.OnUp:Connect(function()
        if world:GetDevicePlatform() == Enum.Platform.Windows then
            self.MouseIn = false
        end
        self:OnDragEnd()
    end)
    world.OnRenderStepped:Connect(function()
        if self.MouseIn then
            DisplayUiAtTarget(self.showBtn,GetMousePos(self.root))
        end
	end)
end

function DragUi:OnDragBegin()
end
function DragUi:OnDragEnd()
end
function GuiUtil.CreateDragUi(...)
    return CreateNewObject(DragUi,...)
end

function GuiUtil.OnResAddedTween(_obj,_addingVal,_dstAchorX,_dstAchorY)
    _obj.AnchorsY = Vector2(-1,-1)
    local ran1, ran2 = 0,0
    while ran1 == 0 or ran2 == 0 do ran1, ran2 = math.random(-1,1), math.random(-1,1) end
    local figObj = _obj.Fig
    local pnlTxtFig = _obj.PnlText.Fig
    pnlTxtFig.Text.Text = "+ " .. ShowAbbreviationNum(_addingVal)
    pnlTxtFig.BigText.Text = "+ " .. ShowAbbreviationNum(_addingVal)
    local tweener00 = Tween:TweenProperty(_obj, {AnchorsY = Vector2(0.5,0.5)}, 0.2, Enum.EaseCurve.BackOut)
    local tweener01 = Tween:TweenProperty(figObj, {Size = Vector2(ran1*400,ran2*180)}, 0.5, Enum.EaseCurve.BackOut)
    local tweener02 = Tween:TweenProperty(_obj, {AnchorsY = _dstAchorY,AnchorsX = _dstAchorX}, 0.3, 1)
    local tweener03 = Tween:TweenProperty(pnlTxtFig.Text, {Alpha = 0}, 0.3, 1)
	local tweener04 = Tween:TweenProperty(figObj, {Size = Vector2(1,1)}, 0.2, Enum.EaseCurve.BackOut)
    tweener00.OnComplete:Connect(function() tweener02:Play() tweener00:Destroy() end)
    tweener01.OnComplete:Connect(function() tweener01:Destroy() end)
    tweener02.OnComplete:Connect(function()
		tweener04:Play()
        tweener03:Play()
        tweener02:Destroy()
        for _, v in pairs(figObj:GetChildren()) do
            local tweener = Tween:TweenProperty(v, {Alpha = 0}, 0.2, 1)
            tweener.OnComplete:Connect(function()
                tweener:Destroy()
            end)
            tweener:Play()
        end
    end)
    tweener03.OnComplete:Connect(function()
        tweener03:Destroy()
        _obj:Destroy()
    end)
	tweener04.OnComplete:Connect(function() tweener04:Destroy() end)
    tweener00:Play()
	tweener01:Play()
end

function GuiUtil.ResetGuiSizeByProportion(guiObj,proportion)
    local oldSize = guiObj.Size
    guiObj.Size = Vector2(oldSize.x, oldSize.x * 1/proportion)
end

function GuiUtil.ResetSizeYByCoe(guiObj,coe)
    local oldSize = guiObj.Size
    guiObj.Size = Vector2(oldSize.x, oldSize.y * coe)
end

function GuiUtil.ResetSizeXByCoe(guiObj,coe)
    local oldSize = guiObj.Size
    guiObj.Size = Vector2(oldSize.x * coe, oldSize.y)
end

return GuiUtil