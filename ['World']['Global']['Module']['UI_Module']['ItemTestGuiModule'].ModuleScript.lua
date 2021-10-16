-- 临时测试功能UI
local ItemTestGui = {}

--- 初始化
function ItemTestGui:Init()

    self.testBtn = localPlayer.Local.ControlGui.TestBtn
    self.rootUI = localPlayer.Local.ItemTestGui 
    self.rootUI:SetActive(false)
    self:BindAction()

    self.tentUsing = false

    Input.OnKeyDown:Connect(function()
        if Input.GetPressKeyData(Enum.KeyCode.T) == Enum.KeyState.KeyStatePress then
            Const.TestMode = not Const.TestMode
            self:ShowTestButtons()
        end
    end)

    self:ShowTestButtons()

end

function ItemTestGui:ShowTestButtons()
    self.testBtn:SetActive(Const.TestMode)
    localPlayer.Local.ControlGui.ShopBtn:SetActive(Const.TestMode)
    localPlayer.Local.ControlGui.ClearDataBtn:SetActive(Const.TestMode)
end

function ItemTestGui:BindAction()

    --
    self.testBtn.OnClick:Connect(function()
        C_GuiMgr:OpenGui('ItemTestGui')
        --self.rootUI:SetActive(true)
        --self.testBtn:SetActive(false)
    end)

    self.rootUI.BgImg.CloseBtn.OnClick:Connect(function()
        --self.rootUI:SetActive(false)
        C_GuiMgr:BackToMainInterface()
    end)

    -- 传送至沼泽
    self.rootUI.BgImg.GoToMarshBtn.OnClick:Connect(function() 
        localPlayer.Position = world.RebornPlaces.GoToMarsh.Position
    end)

    -- Reset 
    self.rootUI.BgImg.ResetBtn.OnClick:Connect(function()
        localPlayer.Position = world.RebornPlaces.GoToTreehouse.Position
    end)

    -- 增加物品
    self.rootUI.BgImg.AddItemBtn.OnClick:Connect(function()
        print(self.rootUI.BgImg.InputField.Text)
        local itemId = tonumber(self.rootUI.BgImg.InputField.Text)
        BagpackData:GetItem(itemId, 1)
    end)

    --region 各种按钮



    -- 帐篷
    --[[
    self.rootUI.BgImg.TentBtn.OnClick:Connect(function()
        --self:Setup()
        --Tent:New(localPlayer.Position)
        if self.tentUsing == false then 
            Tent:Setup(localPlayer.Position)
            self.tentUsing = true
        end
    end)
    ]]--

    -- 竹蜻蜓
    self.rootUI.BgImg.DragonFlyBtn.OnClick:Connect(function()

        DragonFly:Equip()

        --localPlayer.Avatar.Bone_Head.DragonFly:SetActive(not localPlayer.Avatar.Bone_Head.DragonFly.ActiveSelf)
        --DragonFly.running = localPlayer.Avatar.Bone_Head.DragonFly.ActiveSelf
    end)
    --endregion

    -- 定位器
    self.rootUI.BgImg.LocatorBtn.OnClick:Connect(function()
        Locator:Use()
    end)

    -- 变小
    self.rootUI.BgImg.SmallBtn.OnClick:Connect(function()
        PlayerBuff:ChangeSize(0.6)
    end)

    -- 闪光效果
    self.rootUI.BgImg.ShiningBtn.OnClick:Connect(function()
        PlayerBuff:SetBuff(localPlayer.Avatar.Effects.ShiningStarEffect, true)
    end)

end


function ItemTestGui:Update()
    --printTable( GlobalData.allItems)

end

return ItemTestGui