local Berry = {
    totalTypes = 2,
}

--- 生成
--- @param _pos Vector3
--- @param _parent Node
function Berry:Instantiate(_pos, _parent, _archetypeName)

    --local className = 'Apple'
    --local type = math.random(1, self.totalTypes)
    --local archetypeName = className..type

    local className = 'Berry'
    local item = Item:Instantiate(_archetypeName, _pos, _parent)
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
--- @param _berry Object
function Berry:PickUp(_berry)
    BagpackData:GetItem(_berry.ItemId.Value, 1)
    _berry:Destroy()
end

--- 使用
--- @param _itemId Int
function Berry:Use(_itemId)

    local itemName = Config.ItemInfo[_itemId].ItemName

    Notice:ShowMessage(itemName + "的使用功能没做。")

    --[[
    if _itemId == 'Apple' then 
        -- 红苹果
        Item:Instantiate('Apple1', localPlayer.Position)
    elseif _itemId == 'BlackApple' then 
        -- 黑苹果
        Item:Instantiate('Apple2', localPlayer.Position)
    end
    ]]--
end

return Berry