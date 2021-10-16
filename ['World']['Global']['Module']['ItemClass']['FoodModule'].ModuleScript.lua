local Food = {}

function Food:Use(_itemId)

	local itemName = Config.ItemInfo[_itemId].ItemName
	local node = PlayerAnimMgr:CreateSingleClipNode('Drink', 1, 'player_drink', 0)
	local drinkAni = node:AddAnimationEvent(0.95) -- 0.99

	--drinkAni:Clear()

    drinkAni:Connect(function()

        if itemName == 'FoodFlower' then 
            -- 闪光效果（荧光花香特饮）
            print('itemName ', itemName)
            PlayerBuff:SetBuff(localPlayer.Avatar.Effects.ShiningStarEffect, true)
        elseif itemName == 'FoodBerry' then
            -- 变小（复合莓果酱）
            PlayerBuff:ChangeSize(0.6)
        elseif itemName == 'FoodMushroom' then 
            -- 变大（水管工蘑菇沙拉）
            PlayerBuff:ChangeSize(1.3)
        elseif itemName == 'FoodFruit' then 
            -- 加速（自制热带罐头）
            PlayerBuff:ChangeSpeed(10)
            PlayerBuff:SetBuff(localPlayer.Avatar.FootEffect, true)
        elseif itemName == 'FoodFantastic' then 
            -- 先不做这个了（神秘自然杂烩）
            Notice:ShowMessage('这个料理不会出现在线上版本。')
        elseif itemName == 'FoodRubbish' then
            -- 模糊（煮糊了）
            PlayerBuff.drunkBuff.BeginBuff()
        end
        
        drinkAni:Clear()

    end)

	PlayerAnimMgr:Play('player_drink', 2, 1, 0.1, 0.1, true, false, 2.5)

end

return Food