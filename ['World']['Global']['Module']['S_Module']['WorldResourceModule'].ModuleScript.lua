local WorldResource = {}

--- 初始化
function WorldResource:Init()
    -- 服务端刷新的资源：各种植物
    -- 客户端资源：星星、漂流瓶

    --[[
    self:Grow(world.ItemPivots.BerryRed, 'Berry', 'BerryRed', 1)
    self:Grow(world.ItemPivots.BerryYellow, 'Berry', 'BerryYellow', 1)
    self:Grow(world.ItemPivots.BerryBlue, 'Berry', 'BerryBlue', 1)

    self:Grow(world.ItemPivots.MushroomRed, 'Mushroom', 'MushroomRed', 1)
    self:Grow(world.ItemPivots.MushroomBlue, 'Mushroom', 'MushroomBlue', 1)

    self:Grow(world.ItemPivots.FlowerYellow, 'Flower', 'FlowerYellow', 1)
    self:Grow(world.ItemPivots.FlowerPurple, 'Flower', 'FlowerPurple', 1)
    self:Grow(world.ItemPivots.FlowerWhite, 'Flower', 'FlowerWhite', 1)

    self:Grow(world.ItemPivots.Pineapple, 'Pineapple', 'Pineapple', 1)

    ]]--
    self:Grow(world.ItemPivots.Bottles, 'FloatingBottle', 'FloatingBottle', 0.6)

end

--- 资源生成
--- @param _parentNode Node 
--- @param _clsName string 
--- @param _archetypeName string
--- @param _chance float 生成概率
function WorldResource:Grow(_parentNode, _clsName, _archetypeName, _chance)

    if _parentNode == nil then return end

    print(_parentNode.Name)

    -- 默认100%生成
    _chance = _chance or 1 

    local itemCls = ItemMgr.ClsTbl[_clsName]

    local itemPivots = _parentNode:GetChildren() 

    for _, _pivot in pairs(itemPivots) do

        if math.random() < _chance then 
            local existObj = _pivot:GetChildByIndex(1)
            if not existObj then

                itemCls:Instantiate(_pivot.Position, _pivot, _archetypeName)
            end
        end
    end
end

--- 资源消失
--- @param _parentNode Node 
function WorldResource:Disappear(_parentNode)

    if _parentNode == nil then return end

    local itemPivots = _parentNode:GetChildren()
    for _, _pivot in pairs(itemPivots) do
        local obj = _pivot:GetChildByIndex(1) 
        if obj then 
            obj:Destroy()
        end
    end
end

--- 夜晚资源刷新
function WorldResource:NightUpdate()
    S_TimeMgr:AddDelayTimeEvent(100, function()
        self:Grow(world.ItemPivots.MushroomRed, 'Mushroom', 'MushroomRed', 1)
        self:Grow(world.ItemPivots.MushroomBlue, 'Mushroom', 'MushroomBlue', 1)
        self:Grow(world.ItemPivots.MushroomPurple, 'Mushroom', 'MushroomPurple', 1)
    end)
end

--- 早晨资源刷新
function WorldResource:MorningUpdate()
    S_TimeMgr:AddDelayTimeEvent(600, function()
        -- self:Disappear(world.ItemPivots.Mushroom)

        self:Grow(world.ItemPivots.FlowerYellow, 'Flower', 'FlowerYellow', 1)
        self:Grow(world.ItemPivots.FlowerPurple, 'Flower', 'FlowerPurple', 1)
        self:Grow(world.ItemPivots.FlowerWhite, 'Flower', 'FlowerWhite', 1)

        self:Grow(world.ItemPivots.BerryRed, 'Berry', 'BerryRed', 1)
        self:Grow(world.ItemPivots.BerryYellow, 'Berry', 'BerryYellow', 1)
        self:Grow(world.ItemPivots.BerryBlue, 'Berry', 'BerryBlue', 1)
    

    end)
end

--- 清晨资源刷新
function WorldResource:DawnUpdate()
    S_TimeMgr:AddDelayTimeEvent(600, function()
        self:Grow(world.ItemPivots.Pineapple, 'Pineapple', 'Pineapple', 1)
        self:Grow(world.ItemPivots.Bottles, 'FloatingBottle', 'FloatingBottle', 0.6)
    end)
end

return WorldResource 