---蝴蝶管理
---author Chen Muru
local S_ButterflyMgr, this = ModuleUtil.New('S_ButterflyMgr', ServerBase)

function S_ButterflyMgr:Init()
    S_ButterflyMgr.playerWithFlower = {}
    S_ButterflyMgr.allButterfly = S_Duplicate.allCreature.Butterfly
end

function S_ButterflyMgr:AddPlayerWithFlower(_butterflyId,_playerId)
    if not self.playerWithFlower[_playerId] then
        self.playerWithFlower[_playerId] = {}
    end
    local player = self.playerWithFlower[_playerId]
    if #player >= 2 then
        -- 随机一只飞离玩家身边
        local tmp = {_butterflyId,player[1],player[2]}
        local leftButterfly = tmp[math.random(1,3)]
        self.allButterfly[leftButterfly]:ProcessEvent("LeavePlayer")
        for ii = 3, 1, -1 do
            if tmp[ii] == leftButterfly then
                table.remove(tmp,ii)
                break
            end
        end
        player = tmp
        return false
    end
    table.insert(player,_butterflyId)

    ---region 数据埋点 一川 
    UploadLog("animal_{"..tostring(_playerId).."}_attract","C1004",_playerId,S_Duplicate.allCreature.Butterfly[_butterflyId].collectionIndex)
    ---endregion
end

function S_ButterflyMgr:PlayerTakeOffFlowerEventHandler(_playerId)
    local player = self.playerWithFlower[_playerId]
    if not player then
        return
    end
    for _, v in pairs(player) do
        self.allButterfly[v]:ProcessEvent("LeavePlayer")
    end
    self.playerWithFlower[_playerId] = nil
end

function S_ButterflyMgr:ButterflyOnHead(_butterflyId, _playerId,_playPoint)
    local player = self.playerWithFlower[_playerId]
    if #player < 2 then
        return
    end
    if math.random(1,100) > 70 then
        return
    end
    local butterflyId = player[1]
    if butterflyId == _butterflyId then
        butterflyId = player[2]
    end
    local playPoint = Const.ButterflyPlayAroundPoint.HeadLeft
    if playPoint == _playPoint then
        playPoint = Const.ButterflyPlayAroundPoint.HeadRight
    end
    self.allButterfly[butterflyId]:ProcessEvent("ResetPlayPoint",playPoint)
end

function S_ButterflyMgr:ButterflyLeavePlayer(_butterflyId, _playerId)
    local player = self.playerWithFlower[_playerId]
    if not player then
        print("玩家不存在！！！！")
        return
    end
    for ii = #player, 1, -1 do
        if player[ii] == _butterflyId then
            table.remove(player,ii)
            break
        end
    end
end

return S_ButterflyMgr