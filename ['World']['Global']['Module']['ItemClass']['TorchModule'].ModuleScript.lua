local Torch = {
    displayName = 'torch',
    id = 1,
    type = 1,           --- 工具大类
    class = 1,          --- 工具小类
    maxNum = 100,       --- 最大可持有数量
    totalTypes = 1,
}

--- 生成
--- @param _pos Vector3
--- @param _parent Node
function Torch:Instantiate(_pos, _parent)

    local className = 'Torch'
    local type = math.random(1, self.totalTypes)
    local archetypeName = className..type

    local o = world:CreateInstance(archetypeName, archetypeName, _parent, _pos)
    o.ClsName.Value = className
    
    --[[
    --region Appear Effect
    o.Scale = 0
    local tweener1 = Tween:TweenProperty(o, {Scale = 1.0}, 0.25, Enum.EaseCurve.BackOut) --Backout
    tweener1.OnComplete:Connect(function()
        tweener1:Destroy()
    end)
    tweener1:Play()
    --endregion
    ]]--
end

--- 捡起
--- @param _item Object
function Torch:PickUp(_item)
    BagpackData:GetItem(_item.ItemId.Value, 1)
    _item:Destroy()
end

return Torch