local Apple = {
    totalTypes = 2,
}

--- 生成
--- @param _pos Vector3
--- @param _parent Node
function Apple:Instantiate(_pos, _parent)

    local className = 'Apple'
    local type = math.random(1, self.totalTypes)
    local archetypeName = className..type

    local item = Item:Instantiate(archetypeName, _pos, _parent)
    item.ClsName.Value = className

    --[[
    local o = world:CreateInstance(archetypeName, archetypeName, _parent, _pos)
    o.ClsName.Value = className
    
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
--- @param _apple Object
function Apple:PickUp(_apple)
    BagpackData:GetItem(_apple.ItemId.Value, 1)

    _apple:Destroy()
    
end

--- 使用
--- @param _itemId Int
function Apple:Use(_itemId)
    if _itemId == 'Apple' then 
        -- 红苹果
        Item:Instantiate('Apple1', localPlayer.Position)
    elseif _itemId == 'BlackApple' then 
        -- 黑苹果
        Item:Instantiate('Apple2', localPlayer.Position)
    end
end

return Apple