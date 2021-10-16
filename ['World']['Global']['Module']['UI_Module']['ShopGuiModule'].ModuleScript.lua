local ShopGui = {}

function ShopGui:Init()
    self.rootUI = localPlayer.Local.ItemShopGui
    self.itemPnl = self.rootUI.BgImg.ItemPnlBg.Panel
    self.buyBtn = self.rootUI.BgImg.BuyBtn
    self.detailImg = self.rootUI.BgImg.DetailImg
    self.selectingSlot = nil

    -- 购买按钮状态
    self.BuyButtonState = {
        BOUGHT = 1,
        UNAFFORDABLE = 2,
        AFFORDABLE = 3,
    }

    self.buyBtnState = nil

    self:BindAction()

    -- 记录物品种类是否被购买过
    self.itemsBeenBought = {}
    self:GetShopSystemData()

    -- 初始化商品列表
    self:InitGoodsList()
end

function ShopGui:GetShopSystemData()
    print('读取商品解锁进度')
    printTable(self.itemsBeenBought)
    self.itemsBeenBought =  C_PlayerDataMgr.playerData.itemsBeenBought or self.itemsBeenBought
end

function ShopGui:NewDataStorgeTable()
    C_PlayerDataMgr.playerData.itemsBeenBought = self.itemsBeenBought or C_PlayerDataMgr.playerData.itemsBeenBought
    --print('存储商品解锁进度')
end

function ShopGui:BindAction()

    -- 点击商店按钮
    localPlayer.Local.ControlGui.ShopBtn.OnClick:Connect(function()
        self:OpenShop()
    end)

    local goodSlots = self.itemPnl:GetChildren()
    for  _, _slot in pairs(goodSlots) do
        _slot.Btn.OnClick:Connect(function()
            AudioUtil:PlayDefaultClickSfx()
            self:SelectSlot(_slot)
        end)
    end

    -- 点击购买按钮
    self.buyBtn.OnClick:Connect(function()
        if self.buyBtnState == self.BuyButtonState.BOUGHT then 
            
            Notice:ShowMessage(nil, 'ProjectDarwin_Store_4')
            AudioUtil:PlayWrongClickSfx()
        elseif self.buyBtnState == self.BuyButtonState.AFFORDABLE then 
            
            AudioUtil:PlayDefaultClickSfx()

            -- 购买成功消息
            Notice:ShowMessage(nil, 'ProjectDarwin_Store_5')
            local id = self.selectingSlot.Id.Value

            -- 成就：哆啦A梦
            local buyOnce = Config.ItemInfo[id].BuyOnce or false
            if buyOnce then 
                C_MainMission:AddCurProgress("UseTool")
            end

            -- 更新探索币数量
            local price = Config.ItemInfo[id].GetPrice
            --C_MainMission.exploreCoin = C_MainMission.exploreCoin - price
            C_MainMission:RefrshExploreResData(price * -1)
            self:UpdateExploreCoin()

            ---region 数据埋点 一川
            UploadLog("item_buy_{"..tostring(id).."}_click","C1004",id,price)
            ---endregion

            -- 更新购买按钮状态
            self:SetBuyBtnState()

            -- 物品进包
            BagpackData:GetItem(id, 1) 

            -- 更新购买记录
            if table.exists(self.itemsBeenBought, id) == false then 
                table.insert(self.itemsBeenBought, id)
                self:UpdateOwnTag(self.selectingSlot)
            end

        elseif self.buyBtnState == self.BuyButtonState.UNAFFORDABLE then
            -- ‘探索币不足’
            Notice:ShowMessage(nil, 'ProjectDarwin_Store_6')
            AudioUtil:PlayWrongClickSfx()

        end
    end)

    -- 点击关闭按钮
    self.rootUI.BgImg.CloseBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()
    	if DialogueMgr.dialogueActive then
			self.rootUI:SetActive(false)
			DialogueMgr:ShowDialogue(Config.NPC[NpcMgr.currentNPC.ID.Value].VendorExitDialogueID, 0) -- dialogue options after leaving shop
		else
			C_GuiMgr:BackToMainInterface()
		end
    end)
end

function ShopGui:OpenShop()
    self:UpdateExploreCoin()
    -- 选定第一个商品
    self:SelectSlot(self.itemPnl:GetChildByIndex(1))
    C_GuiMgr:OpenGui('ItemShopGui')

    ---region 数据埋点 一川
    UploadLog("shop_click","C1004")
    print("shop_click")
    ---endregion

end

-- 更新探索币显示
function ShopGui:UpdateExploreCoin()
    self.rootUI.BgImg.CoinImg.CoinTxt.Text = C_MainMission.exploreCoin
end

-- 设置购买按钮状态
function ShopGui:SetBuyBtnState()
    local id = self.selectingSlot.Id.Value
    local price = Config.ItemInfo[id].GetPrice
    
    -- 是否只能购买一次
    local buyOnce = Config.ItemInfo[id].BuyOnce or false
    if table.exists(self.itemsBeenBought, id) and buyOnce then 
        --self.buyBtn.Text = '已购买'
        self.buyBtn.LocalizeKey = 'ProjectDarwin_Store_3'
        self.buyBtnState = self.BuyButtonState.BOUGHT
    else
        if C_MainMission.exploreCoin >= price then 
            --self.buyBtn.Text = '购买'
            self.buyBtn.LocalizeKey = 'ProjectDarwin_Store_1'
            self.buyBtnState = self.BuyButtonState.AFFORDABLE
        else 
            --self.buyBtn.Text = '买不起'
            self.buyBtn.LocalizeKey = 'ProjectDarwin_Store_2'
            self.buyBtnState = self.BuyButtonState.UNAFFORDABLE
        end
    end
end

-- 初始化商品列表
function ShopGui:InitGoodsList()
    local goodSlots = self.itemPnl:GetChildren()
    for  _, _slot in pairs(goodSlots) do
        --_slot.Alpha = 0
        _slot.SlotImg.Alpha = 0

        local itemName = _slot.ItemName.Value
        local id = ItemMgr:GetIdByItemName(itemName)
        _slot.Id.Value = id
        --local id = _slot.Id.Value
        local texturePath = Config.ItemInfo[id].SmallTextureRoot
        if texturePath then 
            _slot.Btn.Texture = ResourceManager.GetTexture(texturePath)
            _slot.Btn.Size = Vector2.One * 130
        end 

        _slot.PriceTxt.Text = Config.ItemInfo[id].GetPrice

        self:UpdateOwnTag(_slot)
    end

    -- 排列
    local index = 0
    for _i, _slot in ipairs(goodSlots) do 
        if _slot.ActiveSelf then 
            index = index + 1
            _slot.AnchorsX = Vector2.One * (0.25 + math.fmod((index-1), 3) * 0.24)
            _slot.AnchorsY = Vector2.One * (0.72 - math.floor((index-1)/3) * 0.23)
            print(_slot.ItemName.Value)
        end
    end
end

-- 显示商品信息
function ShopGui:DisplayGoodInfo()
    local id = self.selectingSlot.Id.Value
    --local price = Config.ItemInfo[id].GetPrice
    --local description = Config.ItemInfo[id].C_Description
    --local name = Config.ItemInfo[id].Cname

    --self.rootUI.BgImg.DescTxt.Text = description
    --self.rootUI.BgImg.NameTxt.Text = name

    self.rootUI.BgImg.DescTxt.LocalizeKey = Config.ItemInfo[id].LocalizeDescriptionKey
    self.rootUI.BgImg.NameTxt.LocalizeKey = Config.ItemInfo[id].LocalizeNameKey

end

-- 选中商品
function ShopGui:SelectSlot(_slot)
    if self.selectingSlot then 
        --self.selectingSlot.Alpha = 0
        local path = 'UI/Shop/Shop_NormalBgd_280_280'
        self.selectingSlot.Texture = ResourceManager.GetTexture(path)
    end
    self.selectingSlot = _slot
    --_slot.Alpha = 1
    local path = 'UI/Shop/Shop_ChosenBgd_280_280'
    self.selectingSlot.Texture = ResourceManager.GetTexture(path)
    self.detailImg.Texture = self.selectingSlot.Btn.Texture


    -- 更新购买按钮状态
    self:SetBuyBtnState()
    self:DisplayGoodInfo()
end

-- 更新已拥有标签
function ShopGui:UpdateOwnTag(_slot)
    local id = _slot.Id.Value
    local buyOnce = Config.ItemInfo[id].BuyOnce or false

    _slot.TagImg:SetActive(false)
    if table.exists(self.itemsBeenBought, id) and buyOnce then 
        _slot.TagImg:SetActive(true)

        --self.buyBtn.Text = '已购买'
        self.buyBtn.LocalizeKey = 'ProjectDarwin_Store_3'
        self.buyBtnState = self.BuyButtonState.BOUGHT
    end
end

return ShopGui