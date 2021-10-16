--- @module CookingGui, Client-side
--- @copyright Lilith Games, Avatar Team
--- @author Chao C
local CookingGui = {}

-- 初始化
function CookingGui:Init()

    self.rootUI = localPlayer.Local.CookingGui

    -- 烹饪按钮
    self.cookBtn = self.rootUI.BgImg.CookBtn

    self.bagSlots = self.rootUI.BgImg.BagBgImg:GetChildren()
    self.potSlots = self.rootUI.BgImg.PotBgImg:GetChildren()

    self:BindAction()

    -- 烹饪结果
    self.foodId = -1

    -- 我的食材
    self.ingredients = {}

    self:Localization()

    self.foodsUnlocked = {}
    self:GetCookSystemData()
end

function CookingGui:GetCookSystemData()
    print('读取烹饪解锁进度')
    printTable(self.foodsUnlocked)
    self.foodsUnlocked =  C_PlayerDataMgr.playerData.foodsUnlocked or self.foodsUnlocked
end

function CookingGui:NewDataStorgeTable()
    C_PlayerDataMgr.playerData.foodsUnlocked = self.foodsUnlocked or C_PlayerDataMgr.playerData.foodsUnlocked
    --print('存储烹饪解锁进度')
end

-- 本地化
function CookingGui:Localization()
    -- 烹饪准备
    self.rootUI.BgImg.TitleImg.Txt.LocalizeKey = 'ProjectDarwin_Cooking_1'
    self.rootUI.BgImg.TitleTxt.LocalizeKey = 'ProjectDarwin_Cooking_6'
    self.cookBtn.Txt.LocalizeKey = 'ProjectDarwin_Cooking_1'
    -- 烹饪中
    self.rootUI.CookingImg.TitleTxt.LocalizeKey = 'ProjectDarwin_Cooking_3'
    -- 烹饪结果
    self.rootUI.ResultImg.TitleImg.Txt.LocalizeKey = 'ProjectDarwin_Cooking_1'
    self.rootUI.ResultImg.PotImg.GotTxt.LocalizeKey = 'ProjectDarwin_Cooking_4'
end

-- 打开烹饪界面
function CookingGui:Open()
    self:InitIngredientsAndPot()
    self.cookBtn.Alpha = 0.5
    C_GuiMgr:OpenGui('CookingGui')
    ---region 数据埋点 一川
    UploadLog("cook_click","C1004")
    print("cook_click")
    ---endregion
end

-- 初始化食材&锅子
function CookingGui:InitIngredientsAndPot()

    --region Ingredent Slots
    local slotIndex = 1
    local slots = self.bagSlots

    -- 清除数据
    for _, _slot in pairs(slots) do
        _slot.Btn.Texture = nil
        _slot.NumTxt:SetActive(false)
        _slot.Id.Value = 0
        _slot.Num.Value = 0
    end

    self:LoadIngredientDataFromBackpack()

    -- 载入数据
    for _i, _item in ipairs(self.ingredients) do
        if _item.num > 0 and slotIndex <= #self.bagSlots then 
            local id = _item.id
            local canCook = Config.ItemInfo[id].CanCook or false
            if canCook then 
                slots[slotIndex].Id.Value = id
                slots[slotIndex].Num.Value = _item.num

                local texturePath = Config.ItemInfo[id].SmallTextureRoot
                slots[slotIndex].Btn.Texture = ResourceManager.GetTexture(texturePath)
                slots[slotIndex].NumTxt.Text = '×'.._item.num
                slots[slotIndex].NumTxt:SetActive(true)
                slotIndex = slotIndex + 1
            end
        end
    end
    --endregion

    --region Pot Slots
    local potSlots = self.potSlots

    -- 清除数据
    for _, _slot in pairs(potSlots) do
        _slot.Btn.Texture = nil
        _slot.Id.Value = 0
        _slot.Num.Value = 0
    end
    --endregion

end

-- 将食材加入格子
---@param _slot Object 格子节点
---@param _ingredientId Int 食材ID
---@param _num Int 食材数量
function CookingGui:AddIngredientToSlot(_slot, _ingredientId, _num)

    -- 数据
    _slot.Id.Value = _ingredientId
    _slot.Num.Value = _slot.Num.Value + _num

    -- 表现
    local texturePath = Config.ItemInfo[_ingredientId].SmallTextureRoot

    _slot.Btn.Texture = ResourceManager.GetTexture(texturePath)
    if _slot.NumTxt then 
        _slot.NumTxt.Text = _slot.Num.Value
        _slot.NumTxt:SetActive(true)
    end
end

-- 将食材从格子A移动到格子B
---@param _fromSlot Object 格子节点
---@param _toSlot Object 格子节点
---@param _ingredientId Int 食材ID
---@param _num Int 食材数量
function CookingGui:MoveIngredient(_fromSlot, _toSlot, _ingredientId, _num)
    
    -- 从旧的格子取出
    local currentNum = _fromSlot.Num.Value 
    currentNum = currentNum - 1
    _fromSlot.Num.Value = currentNum

    if currentNum <= 0 then 
        _fromSlot.Btn.Texture = nil
        _fromSlot.Id.Value = 0 
    end

    if _fromSlot.NumTxt then 
        _fromSlot.NumTxt.Text = '×'..currentNum
    end

    -- 放进新格子
    self:AddIngredientToSlot(_toSlot, _ingredientId, 1)

    if self:FindEmptyPotSlot() == nil then
        self.cookBtn.Alpha = 1
    else 
        self.cookBtn.Alpha = 0.5
    end
end

-- 绑定各种点击事件
function CookingGui:BindAction()

    local slots = self.bagSlots
    for _, _slot in pairs(slots) do
        _slot.Btn.OnClick:Connect(function()
            if _slot.Id.Value > 0 then 
                local emptyPotSlot = self:FindEmptyPotSlot()
                if emptyPotSlot then 
                    AudioUtil:PlayDefaultClickSfx()
                    local ingredientId = _slot.Id.Value
                    self:MoveIngredient(_slot, emptyPotSlot, ingredientId, 1)

                else 
                    AudioUtil:PlayWrongClickSfx()
                    --Notice:ShowMessage('已有足够的食材，可以开始烹饪了！')
                end
            end
        end)
    end

    local potSlots = self.potSlots
    for _, _slot in pairs(potSlots) do
        _slot.Btn.OnClick:Connect(function()
            -- 格子里有点东西
            if _slot.Id.Value > 0 then 

                local ingredientId = _slot.Id.Value
                local bagSlot = self:FindBagSlotForIngredient(ingredientId)
                self:MoveIngredient(_slot, bagSlot, ingredientId, 1)

            end
        end)
    end

    -- 退出烹饪
    self.rootUI.BgImg.CloseBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()
        self.rootUI.CookingImg:SetActive(false)
        C_GuiMgr:BackToMainInterface()
    end)

    -- 点击烹饪按钮
    self.rootUI.BgImg.CookBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()
        self:Cook()
    end)

    -- 收下料理
    self.rootUI.ResultImg.TakeBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()

        C_GuiMgr:BackToMainInterface()
        self.rootUI.CookingImg:SetActive(false)
        self.rootUI.ResultImg:SetActive(false)

        BagpackData:GetItem(self.foodId, 1) 

        ---region 数据埋点 一川
        UploadLog("item_cook_{"..tostring(self.foodId).."}_click","C1004",self.foodId)
        
        ---endregion

    end)
end

-- 找到锅里第一个空格子
function CookingGui:FindEmptyPotSlot()
    local potSlots = self.rootUI.BgImg.PotBgImg:GetChildren()
    for _i, _slot in ipairs(potSlots) do 
        if potSlots[_i].Id.Value < 1 then 
            return _slot
        end
    end
    return nil
end

-- 找到背包中放回食材的格子
---@param _ingredientId Int 食材ID
function CookingGui:FindBagSlotForIngredient(_ingredientId)
    local bagSlots = self.bagSlots 
    
    -- 找第一个未堆满的相同物品格子
    for _i, _slot in ipairs(bagSlots) do 
        if _slot.Id.Value == _ingredientId then 
            -- 再加一层堆叠上限的判断
            return _slot
        end
    end

    -- 找第一个空格子
    for _i, _slot in ipairs(bagSlots) do 
        if _slot.Id.Value == 0 then 
            return _slot
        end
    end
end

-- 尝试烹饪
function CookingGui:Cook()

    if self:FindEmptyPotSlot() then 
        Notice:ShowMessage(nil, 'ProjectDarwin_Cooking_2')
    else 

        --消耗食材
        for _, _potSlot in pairs(self.potSlots) do 
           -- NewBagManage:ItemNumberChange('Reduce', _potSlot.Id.Value, 1)
            BagpackData:UseItem(_potSlot.Id.Value,1)
        end

        -- 计算烹饪结果
        self.foodId = self:CaculateCookResult()

        --region 烹饪过程

        self.rootUI.CookingImg:SetActive(true)
        AudioUtil:Play(localPlayer.Local.Sfx.Cooking)

        local interval = 30
    
        local angle = 0
        local delta = 5
        local timer = 0
        
        self.SetPotImgAngle(angle)

        for k = 1, 3 do
    
            while angle > -24 do
                angle = angle - delta
                timer = timer + interval
                C_TimeMgr:AddDelayTimeEvent(timer, CookingGui.SetPotImgAngle, angle)
            end
    
            while angle < 16 do 
                angle = angle + delta
                timer = timer + interval
                C_TimeMgr:AddDelayTimeEvent(timer, CookingGui.SetPotImgAngle, angle)
    
            end
    
            while angle > 0 do
                angle = angle - delta 
                timer = timer + interval
                C_TimeMgr:AddDelayTimeEvent(timer, CookingGui.SetPotImgAngle, angle)
            end
    
            timer = timer + 500
        end
        --endregion
    
        -- 烹饪结果展示
        C_TimeMgr:AddDelayTimeEvent(timer, function()
            self:ShowCookResult(self.foodId)
        end)
    end
    
end

-- 设置图片角度（视觉效果）
--- @param _angle Float 角度
function CookingGui.SetPotImgAngle(_angle)
    CookingGui.rootUI.CookingImg.PotImg.PotLidImg.Angle = _angle
end

-- 读取背包中的食材
function CookingGui:LoadIngredientDataFromBackpack()
    
    self.ingredients = {}

    local itemsInBag = BagpackData.bagDataTable   
    for _, _item in pairs(itemsInBag) do 
        local canCook = Config.ItemInfo[_item.id]
        if canCook then 
            local ingredient = {
                id = _item.id,
                num = _item.num,
            }
            table.insert(self.ingredients, ingredient)
        end
    end

end

--- @param _foodId Int 食物编号
function CookingGui:ShowCookResult(_foodId)
    
    if Config.ItemInfo[_foodId].ItemName == 'FoodRubbish' then 
        -- 成就：真正的烹饪大师
        C_MainMission:AddCurProgress("RealCookMaster")
        AudioUtil:Play(localPlayer.Local.Sfx.FailedCooking)
    else 
        if table.exists(self.foodsUnlocked, _foodId) == false then 
            table.insert(self.foodsUnlocked, _foodId)
            C_MainMission:AddCurProgress("CookMaster")
        end
        AudioUtil:Play(localPlayer.Local.Sfx.SuccessfulCooking)
    end

    local foodName = Config.ItemInfo[_foodId].LocalizeNameKey
    local foodDesc = Config.ItemInfo[_foodId].LocalizeDescriptionKey

    self.rootUI.ResultImg.FoodNameImg.FoodNameTxt.LocalizeKey = foodName
    self.rootUI.ResultImg.FoodInfoImg.FoodDescTxt.LocalizeKey = foodDesc
    self.rootUI.ResultImg.PotImg.FoodImg.Texture = ResourceManager.GetTexture(Config.ItemInfo[_foodId].BigTextureRoot)
    self.rootUI.ResultImg:SetActive(true)
end

--- 计算烹饪结果
function CookingGui:CaculateCookResult()
    
    local berryCounter, flowerCounter, mushroomCounter, fruitCounter

    local food = {
        MUSHROOM = 0,
        BERRY = 0,
        FRUIT = 0,
        FLOWER = 0,
    }

    for _, _potSlot in pairs(self.potSlots) do 
        local id = _potSlot.Id.Value
        local ingredientType = Config.ItemInfo[id].IngredientType
        food[ingredientType] = food[ingredientType] + 1
    end

    local p = math.random()

    if p > 0.95 then 
        -- 煮糊了
        return ItemMgr:GetIdByItemName('FoodRubbish')
    --elseif p > 0.9 then 
        -- 神秘自然杂烩
        -- return ItemMgr:GetIdByItemName('FoodFantastic')
    else 
        if food.FLOWER > 1 then 
            --return 21;
            return ItemMgr:GetIdByItemName('FoodFlower')
        elseif food.BERRY > 1 then 
            --return 22;
            return ItemMgr:GetIdByItemName('FoodBerry')
        elseif food.FRUIT > 1 then 
            --return 24;
            return ItemMgr:GetIdByItemName('FoodFruit')
        elseif food.MUSHROOM > 1 then 
            --return 23;
            return ItemMgr:GetIdByItemName('FoodMushroom')
        else
            --return math.random(21,24)
            local foods = { ItemMgr:GetIdByItemName('FoodFlower'),
                            ItemMgr:GetIdByItemName('FoodBerry'),
                            ItemMgr:GetIdByItemName('FoodFruit'),
                            ItemMgr:GetIdByItemName('FoodMushroom'),
            }
            return foods[math.random(1, #foods)]
        end
    end

end

return CookingGui

