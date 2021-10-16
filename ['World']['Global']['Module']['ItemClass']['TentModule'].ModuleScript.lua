-- 线上版本不会有帐篷了

local Tent = {
    --displayName = 'tent',
}

--- @param _tent Object 
function Tent:PickUp(_tent)

    --region Disappear Effect
    local tweener1 = Tween:TweenProperty(_tent, {Scale = 0.0}, 0.25, Enum.EaseCurve.BackIn)
    tweener1.OnComplete:Connect(function()
        tweener1:Destroy()
        _tent:Destroy()

        -- Notice:ShowMessage(Config.ItemInfo[self.id].Cname ..'+1')
    end)
    tweener1:Play()
    --endregion

    ItemTestGui.tentUsing = false

end

--- 放置帐篷
function Tent:Setup(_pos)

    Notice:ShowMessage('帐篷搭好了！')

    local tent = world:CreateInstance('Tent', 'Tent', localPlayer.Independent, _pos, localPlayer.LocalRotation)
    tent.SurfaceGUI.BgImg.NameTxt.Text = localPlayer.Name

    --region Appear Effect
    tent.Scale = 0
    local tweener1 = Tween:TweenProperty(tent, {Scale = 1.0}, 0.25, Enum.EaseCurve.BackOut) --Backout
    tweener1.OnComplete:Connect(function()
        tweener1:Destroy()
    end)
    tweener1:Play()
    --endregion
end

function Tent:Use()
    -- 这里也太奇怪了
    local pos = localPlayer.Position + Vector3(0,10,0)
    self:Setup(pos)
end

return Tent

--[[
local Tent = {}--class('Tent',Item)
setmetatable(Tent, Item)
Tent.__index = Tent


function Tent:SetProperty()
    self.type = Const.ItemType.TOOL
    self.class = 'Tent'
    self.archetypeName = 'Tent'
    self.maxNum = 20
    self.source = Const.ItemSource.WORLD
    self.state = Const.ItemState.NORMAL

    self.pickable = true
end


--- 实例化模型
function Tent:Instantiate(_o, _pos)
    _o.inst = world:CreateInstance(_o.archetypeName, _o.class, world.Items, _pos)
    _o.inst.ItemId.Value = _o.itemId


    local tent = _o.inst
    tent.SurfaceGUI.BgImg.NameTxt.Text = localPlayer.Name

    --region Appear Effect
    tent.Scale = 0
    local tweener1 = Tween:TweenProperty(tent, {Scale = 1.0}, 0.25, Enum.EaseCurve.BackOut) --Backout
    tweener1.OnComplete:Connect(function()
        tweener1:Destroy()
    end)
    tweener1:Play()
    --endregion

end

--- 拾取帐篷
function Tent:PickUp()
    
    if self.inst then 
        local tent = self.inst

        --region Disappear Effect
        local tweener1 = Tween:TweenProperty(tent, {Scale = 0.0}, 0.25, Enum.EaseCurve.BackIn)
        tweener1.OnComplete:Connect(function()
            tweener1:Destroy()
            tent:Destroy()

            Notice:ShowMessage(self.class..'+1')
        end)
        tweener1:Play()
        --endregion
    end
end

return Tent
]]--
