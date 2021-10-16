---服务端副本
---author Chen Muru
local S_Duplicate, this = ModuleUtil.New('S_Duplicate', ServerBase)

function S_Duplicate:Init()
    self.allCreature = {}
	S_TimeMgr:AddDelayTimeEvent(1000,function()
        self:InitAllCreature()
        ModuleUtil.LoadModules(Module.S_CreatureMgr,nil,"Init")
        self:GenCreatureByProb()
    end)
end

local animalNum = {
    --Reindeer = 2,
    Jaguar = 1,
    --Brownbear = 1,
    Butterfly = 15,
    CaveFirefly = 15,
    Crocodile = 1,
    Chameleon = 1,
    ForestFirefly = 15,
    Seagull = 5,

    Pecker = 2,
    Tocan = 3,
    Frog = 6,
    Mallard = 1,
    LittleMallard = 2,
    Flamingo = 6,
    Pairrot = 5,
    Bat = 6,
    Squirrel = 4,
}

function S_Duplicate:CreateNewCreature(Cls,tableName,num)
    num = num or 1
    for ii = num, 1, -1 do
        local o = {}
        setmetatable(o,{__index = Cls})
        o:Initialize()
        self.allCreature[tableName][o.id] = o
    end
end

function S_Duplicate:InitAllCreature()
    for k, v in pairs(animalNum) do
        if not self.allCreature[k] then
            self.allCreature[k] = {}
        end
        self:CreateNewCreature(_G[k],k,v)
    end
end

function S_Duplicate:InitCreature(creatureCls,...)
    if not self.allCreature[creatureCls] then
        self.allCreature[creatureCls] = {}
    end
    local o = CreateNewObject(_G[creatureCls],...)
    self.allCreature[creatureCls][o.id] = o
    return o
end

function S_Duplicate:Update(dt)
    for _, v in pairs(self.allCreature) do
        for _, obj in pairs(v) do
            if obj.RunCreatureBase then
                obj:RunCreatureBase()
            else
                obj:Run()
            end
        end
    end
end

--- @param userId string 玩家id
--- @param name string 生物名，储存在生物节点下的ClsName节点
--- @param id string 生物id，储存在生物节点下的id节点
--- @param photoId string 照片id
function S_Duplicate:GetCreatureInfoEventHandler(userId,name,id,photoId)
    local state = self.allCreature[name][id]:GetSpecialState()
    NetUtil.Fire_C("SetCreatureInfoEvent",world:GetPlayerByUserId(userId),photoId,state)
end

--- 按照概率生成生物
function S_Duplicate:GenCreatureByProb()
    for cls, creatureData in pairs(Config.CreatureCluster) do
        local creatureRarityConfig = Config.CreatureRarityProb[cls]
        --遍历栖息地
        for _, habitat in pairs(world.Habitat[cls]:GetChildren()) do
            local clusterTmp = {}
            local creatureTmp = {}
            for species, speciesData in pairs(creatureData) do
                if species == cls then
                    for clusterNum,clusterData in pairs(speciesData) do
                        table.insert(clusterTmp,{weight = clusterData.ClusterProb, value = clusterData.ClusterNum})
                    end
                end
            end
            local clusterNum = math.WeightRandom(clusterTmp) -- 决定每个栖息地生成多少只生物
            for species, speciesData in pairs(creatureRarityConfig) do
                table.insert(creatureTmp,{weight = speciesData.SubspeciesWeight, value = species})
            end
            for ii = clusterNum,1,-1 do
                local speciesName =  math.WeightRandom(creatureTmp)
                if speciesName ~= "none" then
                    local o = self:InitCreature(cls,speciesName)
                end
            end
        end
    end
end

--- 刷新生物



return S_Duplicate