local Flower = {}

--- 生成花朵
--- @param _pos Vector3
--- @param _parent Node
function Flower:Instantiate(_pos, _parent, _archetypeName)

    local className = 'Flower'
    local item = Item:Instantiate(_archetypeName, _pos, _parent)
    item.Rotation = _parent.Rotation
    item.Scale = _parent.Scale
    item.ClsName.Value = className

end


--- 捡起花朵
--- @param _flower Object
function Flower:PickUp(_flower)

    BagpackData:GetItem(_flower.ItemId.Value, 1)
    _flower:Destroy()

end

function Flower:Use(_itemId)
    -- TODO:分类
    Item:Instantiate('Flower1', localPlayer.Position)
end

return Flower