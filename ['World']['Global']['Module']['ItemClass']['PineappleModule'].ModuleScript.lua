local Pineapple = {
    totalTypes = 1,
}

--- 生成蘑菇
--- @param _pos Vector3
--- @param _parent Node
function Pineapple:Instantiate(_pos, _parent, _archetypeName)

    local className = 'Pineapple'
    local item = Item:Instantiate(_archetypeName, _pos, _parent)
    item.Rotation = _parent.Rotation
    item.Scale = _parent.Scale
    item.ClsName.Value = className
end

--- 捡起蘑菇
--- @param _pineapple Object
function Pineapple:PickUp(_pineapple)
    BagpackData:GetItem(_pineapple.ItemId.Value, 1)
    _pineapple:Destroy()
end

function Pineapple:Use(_itemId)
end

return Pineapple