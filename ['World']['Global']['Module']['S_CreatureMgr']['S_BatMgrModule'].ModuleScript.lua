local S_BatMgr, this = ModuleUtil.New('S_BatMgr', ServerBase)

function S_BatMgr:Init()
    S_BatMgr.allBat = S_Duplicate.allCreature.Bat
end

return S_BatMgr