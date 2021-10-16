local S_Equipment, this = ModuleUtil.New('S_Equipment', ServerBase)

function S_Equipment:Init()
    self.itemPlayerHoldList = {}
end


function S_Equipment:Update()
end    

--- 记录玩家当前装备的物品Id 
--- 若_equippedItem = 0 则代表卸除装备
function S_Equipment:PlayerEquippedItemEventHandler(_playerId,_equippedItem)
    self.itemPlayerHoldList[_playerId]  = _equippedItem
end    

function S_Equipment:GetPlayerCurEquipment(_playerId)
    local playerItem = self.itemPlayerHoldList[_playerId]
    --print("玩家装备手持物品")
    --print(table.dump(self.itemPlayerHoldList))
	return playerItem
end

function S_Equipment:ClearPlayerItemEventHandler(_playerId)
    for k,v in pairs(self.itemPlayerHoldList) do
        if k == _playerId then 
            self.itemPlayerHoldList[_playerId] = 0
        end    
    end  
    --print("玩家卸除手持物品")
    --print(table.dump(self.itemPlayerHoldList))  
end


return S_Equipment