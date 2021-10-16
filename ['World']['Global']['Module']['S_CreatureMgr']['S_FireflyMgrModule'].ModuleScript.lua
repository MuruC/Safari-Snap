---萤火虫管理模块
---author Chen Muru
local S_FireflyMgr, this = ModuleUtil.New("S_FireflyMgr", ServerBase)

function S_FireflyMgr:Init()
    S_FireflyMgr.allCaveFirefly = S_Duplicate.allCreature.CaveFirefly
    S_FireflyMgr.allRestPoint = world.CaveFireflyShapePoint:GetChildren()
    S_FireflyMgr:InitShapePoint()
    S_FireflyMgr:InitCaveFireflyFormShapeRtEvent()
end

function S_FireflyMgr:InitShapePoint()
    self.allShape = {}
    for k, v in pairs(world.CaveFireflyShapePoint:GetChildren()) do
        self.allShape[k] = {}
        for _k,_v in pairs(v:GetChildren()) do
            table.insert(self.allShape[k],{pos = _v.Position,fireflyId = nil})
        end
    end
end

function S_FireflyMgr:CaveFireflyFormShape()
    local allViableShape = {}
    for _, v in pairs(S_FireflyMgr.allShape) do
        if not v[1].fireflyId then
            table.insert(allViableShape,v)
        end
    end
    local allViableShapeLen = #allViableShape
    if allViableShapeLen < 1 then
        return
    end
    local ranShape = allViableShape[math.random(1,allViableShapeLen)]
    local allPointNum = #ranShape
    local chosenFirefly = {}
    for id, v in pairs(S_FireflyMgr.allCaveFirefly or {}) do
        if not v:IsInState("formShape") then
            table.insert(chosenFirefly,id)
            if #chosenFirefly == allPointNum then
                break
            end
        end
    end
    if #chosenFirefly < allPointNum then
        return
    end
    local delayTime = math.random(10,20) * 1000
    for k, v in ipairs(chosenFirefly) do
        local shapePointInfo = ranShape[k]
        S_FireflyMgr.allCaveFirefly[v]:ProcessEvent("formShape",shapePointInfo.pos)
        shapePointInfo.fireflyId = v
        S_TimeMgr:AddDelayTimeEvent(delayTime,function() 
            S_FireflyMgr.allCaveFirefly[v]:ProcessEvent("deformShape")
            shapePointInfo.fireflyId = nil
        end)
    end
end

function S_FireflyMgr:InitCaveFireflyFormShapeRtEvent()
    S_TimeMgr:AddRTEvent(15000, S_FireflyMgr.CaveFireflyFormShape)
end

function S_FireflyMgr:SetRestPoint()

end

return S_FireflyMgr