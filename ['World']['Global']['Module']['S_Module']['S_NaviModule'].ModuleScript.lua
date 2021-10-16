---服务器生物寻路
---author Chen Muru


local S_Navi = {}

local agentHeight = 2.0
local agentRadius = 0.5
local maxStepHeight = 0.4
local maxSlope = 60
local updateDelay = 0

local acceptRadiusStart = 0.5
local acceptRadiusEnd = 0.5

local scenes = world.StaticSpace
local walkableRoots = {
	world.Walkable
}
local obstacleRoots = {
    scenes.Forest.Obstacle
}

local naviNpc = world.NaviNpc
function S_Navi:Init()
    Navigation.SetAgent(agentHeight, agentRadius, maxStepHeight, maxSlope)
	Navigation.SetUpdateDelay(updateDelay)
	Navigation.SetWalkableRoots(walkableRoots)
	Navigation.SetObstacleRoots(obstacleRoots)
    local _, r = naviNpc:GetWaypoints(Vector3.Zero, Vector3.Zero, 100)
end

local Navi = {}
function Navi:Initialize(parent,obj,spd)
    self.parent = parent
    self.obj = obj
    self.spd = spd or 5
    self.naviPointTable = {}
    self.bFindingPath = false
    self.finishNavi = false
    self.findPathResult = 0
    self.currentWaypointIndex = 1
	self.count = -1
    self.cosThreshold = 0.994
    self.bOnLand = true
    self.naviType = 0
end

local constDefWalkableCollisionGroup = Const.CollisionGroup.Walkable

function Navi:FindPath(startPos, endPos)
    local tmp
	local adjustStartPos
	local adjustEndPos = Navi.AdjustPointOnGround(endPos)
    tmp,self.findPathResult = naviNpc:GetWaypoints(startPos, endPos, 0.3, 2, 6)
    self.naviPointTable = {}
    local spd = self.spd
    for _, v in ipairs(tmp) do
        table.insert(self.naviPointTable, v.Position)
    end
    local naviPointTable = self.naviPointTable
    local n = #naviPointTable
    local n_ = n - 1
    local threshold = self.cosThreshold
    while n > 2 and n_ > 1 do
        local middlePos = naviPointTable[n_]
        if Vector3.Dot((naviPointTable[n] - middlePos).Normalized, (middlePos - naviPointTable[n_ - 1]).Normalized) > threshold then
            table.remove(naviPointTable,n_)
            n = n - 1
            n_ = n - 1
        else
            n = n_
            n_ = n_ - 1
        end
    end
end

function Navi.AdjustPointOnGround(_pos) 
	local hitResultDown = Physics:RaycastByGroup(_pos + 10 * Vector3.Up,_pos + 20 * Vector3.Down,{constDefWalkableCollisionGroup},false)
	if hitResultDown:HasHit() then
        return hitResultDown.HitPointAll[1]
    end
    return _pos
end

function Navi:FindFlyPath(startPos, endPos)
    local tmp
    local adjustStartPos = Navi.AdjustPointOnGround(startPos) or startPos
    local adjustEndPos = Navi.AdjustPointOnGround(endPos) or endPos
    tmp,self.findPathResult = naviNpc:GetWaypoints(adjustStartPos, adjustEndPos, 0.3, 2, 6)
    self.naviPointTable = {}
    for _, v in ipairs(tmp) do
        table.insert(self.naviPointTable, v.Position)
    end
    local naviPointTable = self.naviPointTable
    local n = #naviPointTable
    local n_ = n - 1
    while n > 2 and n_ > 1 do
        local middlePos = naviPointTable[n_]
        if Vector3.Dot((naviPointTable[n] - middlePos).Normalized, (middlePos - naviPointTable[n_ - 1]).Normalized) > 0.99 then
            table.remove(naviPointTable,n_)
            n = n - 1
            n_ = n - 1
        else
            n = n_
            n_ = n_ - 1
        end
    end
    local newTableLength = #naviPointTable
    local y = (endPos.y - startPos.y) / newTableLength
    for ii = newTableLength, 1, -1 do
        local pos = naviPointTable[ii]
        if ii == newTableLength then
            naviPointTable[ii] = endPos
        elseif ii == 1 then
            naviPointTable[ii] = Vector3(pos.x,startPos.y + y,pos.z)
        elseif ii > 1 then
            local prePos = naviPointTable[ii - 1]
            naviPointTable[ii] = Vector3(pos.x,prePos.y + y * ii,pos.z)
        end
    end
end

function Navi:AdjustFirstPoint()
    local naviPointTable = self.naviPointTable
    if #naviPointTable > 1 then
        if GetDistBetweenObj(naviPointTable[1],self.obj.Position) < 0.3 then
            table.remove(naviPointTable,1)
        end
    end
end

function Navi:MoveToTarget(target)
    self.naviType = 1
    self.target = target
    local MoveToTargetNaviEvent = function(self)
        if self.naviType ~= 1 then
            return true
        end
        if self.finishNavi then
            return true
        end
        if not self.target then
            return true
        end
        self:FindPath(self.obj.Position, self.target.Position)
        if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
            self.finishNavi = true
            self:Stop()
            return true
        end
        self:Start()
    end
    S_TimeMgr:AddRTEvent(1000, MoveToTargetNaviEvent, 0, self)  
    return MoveToTargetNaviEvent(self)
end

function Navi:FlyToTarget(target)
    self.naviType = 2
    self.bOnLand = false
    self.target = target
    local MoveToTargetNaviEvent = function(self)
        if self.naviType ~= 2 then
            return true
        end
        if self.finishNavi then
            return true
        end
        self:FindFlyPath(self.obj.Position, self.target.Position)
        if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
            self.finishNavi = true
            self:Stop()
            return true
        end
        self:Start()
    end
    S_TimeMgr:AddRTEvent(1000, MoveToTargetNaviEvent, 0, self)  
    return MoveToTargetNaviEvent(self)
end    

function Navi:FlyToPos(targetPos)
    self.naviType = 3
    self.bOnLand = false
    local flyToPosEvent = function(self)
        self.targetPos = targetPos
        if self.finishNavi then
            return true
        end
        self:FindFlyPath(self.obj.Position, self.targetPos)
        if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
            self.finishNavi = true
            self:Stop()
            return true
        end
        self:Start()
    end
    --S_TimeMgr:AddRTEvent(2000, flyToPosEvent, 0, self)
    return flyToPosEvent(self)
end

local MoveToPosNaviEvent = function(self)
    if self.naviType ~= 4 then
        return true
    end
    if self.finishNavi then
        return true
    end
    self:FindPath(self.obj.Position, self.targetPos)
    if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
        self.finishNavi = true
        self:Stop()
        return true
    end
    self:Start()
end

function Navi:MoveToRandomPos(targetPos)
    self.naviType = 4
    self.targetPos = targetPos
    S_TimeMgr:AddRTEvent(15000, MoveToPosNaviEvent, 0, self)
    return MoveToPosNaviEvent(self)
end

function Navi:EscapeToTargetPos(targetPos)
    self.naviType = 5
    self.targetPos = targetPos
    self:FindPath(self.obj.Position, self.targetPos)
    if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
        self.finishNavi = true
        self:Stop()
        return true
    end
    self:Start()
end

function Navi:Start()
    self.bFindingPath = true
    self.finishNavi = false
    self.count = -1
    --self.currentWaypointIndex = 1
	self.currentWaypointIndex = 1
end

function Navi:Pause()
    self.bFindingPath = false
    local obj = self.obj
    obj.LinearVelocity = Vector3.Zero
    --local curPos = obj.Position
    --obj:MoveTo(obj.Position,0.2)
    --obj.Position:Set(curPos.x,curPos.y,curPos.z)
    self:PauseNaviHandler()
	self.count = -1
end

function Navi:PauseNaviHandler()
end

function Navi:Stop()
    self:Pause()
    self.finishNavi = true
    self.bOnLand = true
    self.targetPos = nil
    self.target = nil
end

function Navi:Run()
    self:FollowPath()
end

function Navi:FollowPath()
    if not self.bFindingPath or self.finishNavi then
        return
    end
    if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
        return
    end
    local obj = self.obj
    local wayPoints = self.naviPointTable
    local currentWaypointIndex = self.currentWaypointIndex
    if obj.animatedMesh then
        if #wayPoints < 1 or not wayPoints[currentWaypointIndex] then
            return
        end
        if self.count == -1 or (obj.Position - wayPoints[currentWaypointIndex]).Magnitude < 0.1 then --0.1 then  
            currentWaypointIndex = currentWaypointIndex + 1
            --if self.count == -1 then
            --    currentWaypointIndex = 1
            --end
            self.currentWaypointIndex = currentWaypointIndex
            if not wayPoints[currentWaypointIndex] then
	    		self:Pause()
                return
            end
            local targetPos = wayPoints[currentWaypointIndex]
            if self.bOnLand then
			    targetPos = Navi.AdjustPointOnGround(targetPos)
			    wayPoints[currentWaypointIndex] = targetPos
            end
            local spd = self.spd
            local time = 1.8 / spd
            if currentWaypointIndex > 1 then
                time = 0.9 * 1 / spd * (targetPos - self.naviPointTable[currentWaypointIndex - 1]).Magnitude
            end
            obj:MoveTo(targetPos, time)
            SkillUtil.RotateTo(targetPos,obj)
            self.count = 0
        end
	
--[[
    if not self.bFindingPath or self.finishNavi then
        return
    end
    if self.findPathResult ~= 0 and self.findPathResult ~= 2 then
        return
    end
    local wayPoints = self.naviPointTable
    local currentWaypointIndex = self.currentWaypointIndex
    if #wayPoints < 1 or not self.naviPointTable[currentWaypointIndex] then
        return
    end
    local obj = self.obj
    if obj.Name == "Reindeer" then
        local pointPos = wayPoints[currentWaypointIndex]
        local direction3D = pointPos - obj.Position
		print(direction3D.Magnitude)
		if self.count == -1 or direction3D.Magnitude <= 0.6 then
            if currentWaypointIndex == #wayPoints then
                self:Pause()
				print("寻路暂停！！！！")
                return
            end
            self.currentWaypointIndex = currentWaypointIndex + 1
			obj:MoveTo(pointPos,0.1)
			self.count = 0
        end
		--obj:MoveTo(pointPos,0.1)
		--]]
		
    else
        local direction3D = wayPoints[currentWaypointIndex] - obj.Position
		--Vector3.Dot(direction3D, obj.LinearVelocity) < 0 or 
        if direction3D.Magnitude <= 0.5 then
            if currentWaypointIndex == #wayPoints then
                self:Pause()
                return
            end
            self.currentWaypointIndex = currentWaypointIndex + 1
            direction3D = wayPoints[currentWaypointIndex] - obj.Position
        end
        local dir = direction3D.Normalized
        --ChangeVelocityAndForwardInLinear(obj,dir,dir * self.spd)
		--self.obj.Forward = Vector3(dir.x,0,dir.z) 
    end
end


function Navi:AdjustPointToSky(_height,_endSkyPos)
	local tempNavPointTable = self.naviPointTable
   -- for k,v in pairs(self.naviPointTable) do
       -- self.naviPointTable[k] = Vector3(v.x, v.y +_height,v.z)
        --local wayPoint = world:CreateInstance("AdjustPos","AdjustPos",world.PeckerWay,v)
   -- end
	self.naviPointTable[#self.naviPointTable + 1] = _endSkyPos
   -- table.insert(self.naviPointTable,_endSkyPos)
    --local endWayPoint = world:CreateInstance("AdjustPos","AdjustPos",world.PeckerWay,_endSkyPos)
end    

function Navi:SetSpd(spd)
    self.spd = spd
end

function Navi:CheckIfGetSuccessfulResult()
    if self.findPathResult == 0 or self.findPathResult == 2 then
        return true
    end
    return false
end

function Navi:CheckIfFindingPath()
    if self.bFindingPath and self.finishNavi then
        return true
    end
    return false
end

function Navi:CheckIfPauseNavi()
    if not self.bFindingPath and not self.finishNavi then
        return true
    end
    return false
end

function Navi:GetCurWayPointIndex()
    return self.currentWaypointIndex, self.naviPointTable
end

function Navi:SetCosThreshold(val)
    self.cosThreshold = val
end

function S_Navi:CreateNavi(...)
    return CreateNewObject(Navi,...)
end

S_Navi.AdjustPointOnGround = Navi.AdjustPointOnGround
return S_Navi
