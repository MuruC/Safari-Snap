local Mushroom = {
    --totalTypes = 1,
}

--- 生成蘑菇
--- @param _pos Vector3
--- @param _parent Node
function Mushroom:Instantiate(_pos, _parent, _archetypeName)

    --local className = 'Mushroom'
    --local type = math.random(1, self.totalTypes)
    --local archetypeName = className..type

    local className = 'Mushroom'
    local item = Item:Instantiate(_archetypeName, _pos, _parent)
    item.Rotation = _parent.Rotation
    item.Scale = _parent.Scale
    item.ClsName.Value = className
end

--- 捡起蘑菇
--- @param _mushroom Object
function Mushroom:PickUp(_mushroom)

    BagpackData:GetItem(_mushroom.ItemId.Value, 1)
    
    _mushroom:Destroy()
end

function Mushroom:Use(_itemId)
    --Item:Instantiate('Mushroom1', localPlayer.Position)
end

return Mushroom