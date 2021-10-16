---鸭子管理模块
---author Chen Muru
local S_MallardMgr, this = ModuleUtil.New('S_MallardMgr',ServerBase)

function S_MallardMgr:Init()
    S_MallardMgr.allMallard = S_Duplicate.allCreature.Mallard
    S_MallardMgr.allBaby = S_Duplicate.allCreature.LittleMallard
    S_MallardMgr:AssignBaby()
end

--- 分配小鸭子
function S_MallardMgr:AssignBaby()
    local babyNum = 2 --- 一只大鸭子分派的小鸭子数量
    local n = 1
    local tmpMallardTbl = {}
    for _,  v in pairs(self.allMallard) do
        table.insert(tmpMallardTbl,v)
    end
    local allMallardNum = #tmpMallardTbl
    local curMallardIndex = 1
    for _, v in pairs(self.allBaby) do
        if curMallardIndex > allMallardNum then
            local mallard = tmpMallardTbl[math.random(allMallardNum)]
            mallard:AssignBaby(v)
            v:AssignParent(#mallard.baby,mallard)
        else
            local mallard = tmpMallardTbl[curMallardIndex]
            mallard:AssignBaby(v)
            v:AssignParent(n,mallard)
        end
        n = n + 1
        if n > babyNum then
            n = 1
            curMallardIndex = curMallardIndex + 1
        end
    end    
end

return S_MallardMgr