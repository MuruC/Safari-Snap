-- 注意节点顺序放到最后

local ItemMgr = {

    ClsTbl = {
        FloatingBottle = FloatingBottle,
        Mushroom = Mushroom,
        Flower = Flower,
        CookingPot = CookingPot,
        Tent = Tent,
        Apple = Apple,
        Torch = Torch,
        Food = Food,
        MiniPiano = MiniPiano,
        Locator = Locator,
        Berry = Berry,
        Pineapple = Pineapple,
    },

}

function ItemMgr:GetClassById(_itemId)
    local clsName = Config.ItemInfo[_itemId].ClsName 
    --print(clsName)
    return self:GetItemClass(clsName)
end

function ItemMgr:GetItemClass(_clsName)
    return self.ClsTbl[_clsName]
end

--- @param _itemName string 
function ItemMgr:GetIdByItemName(_itemName) 
    for _id = 1, #Config.ItemInfo do 
        if Config.ItemInfo[_id].ItemName == _itemName then 
            return _id
        end
    end

    -- 什么也没找到
    print('ERROR: 没找到Item')
    return 1;
end

return ItemMgr