---生物技能工具
---author Chen Muru
local SkillUtil = {}

local Dash = {}

--- 冲锋到某个点
--- @param obj Object 实施冲锋动作的节点
--- @param srcPos Vector3 起始点
--- @param dstPos Vector3 终点
--- @param posY mixed 最高点y轴坐标
--- @param horizontalSpd mixed 水平速度
--- @param verticalSpd mixed 起跳速度
--- @param G mixed 起跳重力
--- @param g mixed 下落重力
function Dash:DashToPoint(obj,srcPos,dstPos,posY,horizontalSpd,verticalSpd,G,g)
    self.obj = obj
	self.riseG = G or 0.8
	self.fallG = g or self.riseG
    srcPos = srcPos or self.obj.Position
    self.dstPos = dstPos
    self.middlePos = Vector3((srcPos.x + dstPos.x)/2, posY, (srcPos.z + dstPos.z)/2)
    self.bOnRise = true
    self.spd = Vector3(dstPos.x - srcPos.x,0,dstPos.z-srcPos.z).Normalized * horizontalSpd
    self.spd.y = verticalSpd
    self.verticalSpd = verticalSpd
    self.horizontalSpd = horizontalSpd
    self.run = true
end

function Dash:DashToDirection(obj,srcPos,direction,dashLength,posY,horizontalSpd,verticalSpd,G,g)
    local dstPos = srcPos + direction * dashLength
    self:DashToPoint(obj,srcPos,dstPos,posY,horizontalSpd,verticalSpd,G,g)
end

local MoveToTargetPos = function(self,dstPos,spd)
    spd = spd or self.spd
    if spd == 0 then
        spd = 2
    end
    local obj = self.obj
    local objPos = obj.Position
    local dist = (Vector2(objPos.x,objPos.z) - Vector2(dstPos.x,dstPos.z)).Magnitude
    obj:MoveTo(dstPos,dist/spd)
    SkillUtil.RotateTo(dstPos,self.obj)
end

function Dash:OnDashEnter()
    MoveToTargetPos(self,self.middlePos,self.horizontalSpd)
    if self.handlerOnDashBegin then
        self.handlerOnDashBegin(table.unpack(self.argsOnDashBegin))
    end
end

function Dash:OnDashUpdate()
    local obj = self.obj
    local objPos = obj.Position
    local dir = GetDirBetweenObjs(objPos,self.dstPos)
    if GetDistBetweenObj(objPos,self.dstPos) <= 0.3 then
        self:OnDashLeave()
        return
    end
    if not self.run then
        return
    end
    if self.handlerOnDashUpdate then
        self.handlerOnDashUpdate(table.unpack(self.argsOnDashUpdate))
    end
    if self.bOnRise and GetDistBetweenObj(objPos,self.middlePos) <= 0.3 then
        self.bOnRise = false
        MoveToTargetPos(self,self.dstPos,self.horizontalSpd)
    end
end

function Dash:OnDashLeave()
    self.run = false
    local obj = self.obj
    local curLinearVelocity = obj.LinearVelocity
    obj.LinearVelocity = Vector3(curLinearVelocity.x,0,curLinearVelocity.z)
    local curPos = obj.Position
    obj.Position = Vector3(curPos.x,self.dstPos.y,curPos.z)
    if self.handlerOnDashEnd then
        self.handlerOnDashEnd(table.unpack(self.argsOnDashEnd))
    end
end

function Dash:BindEventOnDashBegin(handler,...)
    self.handlerOnDashBegin = handler
    self.argsOnDashBegin = {...}
end

function Dash:BindEventOnDashEnd(handler,...)
    self.handlerOnDashEnd = handler
    self.argsOnDashEnd = {...}
end

function Dash:BindEventOnDashUpdate(handler,...)
    self.handlerOnDashUpdate = handler
    self.argsOnDashUpdate = {...}
end

local RadianMove = {}

function RadianMove:Initialize(obj,dstPos,spd,...)
    local args = {...}
    self.obj = obj
    self.spd = spd or 5
    self:CreateRadianMovePointTable(dstPos,table.unpack(args))
    self.run = true
end

function RadianMove:CreateRadianMovePointTable(dstPos,srcPos,posY,radius,angle)
    srcPos = srcPos or self.obj.Position
    local a = 15
    if not angle then
        local v = math.random(0,1)
        if v == 0 then
            angle = math.random(1,180)
        else
            angle = math.random(-180,-1)
        end
    end
    radius = radius or math.random(3,5)
    local remainder = angle % a
    local angleNum = math.abs((angle - remainder)/a)
    local bRemainder = false
    if remainder > 0 then
        angleNum = angleNum + 1
        bRemainder = true
    end
    self.radianMovePosPoint = {}
    local srcPosX = srcPos.x
    local srcPosZ = srcPos.z
    local addPoint = function(num)
        for ii = num, 1, -1 do
            local y = posY
            if not posY then
                y = ii * (dstPos.y - srcPos.y)/angleNum + srcPos.y
            end
            local a_ = math.rad(a * ii)
            table.insert(self.radianMovePosPoint,Vector3(srcPosX + radius* math.sin(a_),y,srcPosZ + radius * math.cos(a_)))
        end
    end
    if not bRemainder then
        addPoint(angleNum)
    else
        addPoint(angleNum - 1)
        local remainAngle = math.rad(remainder)
        if not posY then
            posY = dstPos.y
        end
        local a_ = math.rad(angle)
        table.insert(self.radianMovePosPoint,1,Vector3(srcPosX + radius * math.sin(a_),posY,srcPosZ + radius * math.cos(a_)))
    end
end

function RadianMove:OnEnter()
    local targetPos = self.radianMovePosPoint[#self.radianMovePosPoint]
    MoveToTargetPos(self,targetPos)
end

function RadianMove:OnUpdate()
    if not self.run then
        return false
    end
    local tableLength = #self.radianMovePosPoint
    if tableLength < 1 then
        self:OnEnd()
        return true
    end
    local objPos = self.obj.Position
    local targetPos = self.radianMovePosPoint[tableLength]
    if GetDistBetweenObj(objPos, targetPos) < 0.3 then
        table.remove(self.radianMovePosPoint,tableLength)
        if tableLength < 2 then
            self:OnEnd()
            return true
        end
        self:OnEnter()
    end
    return false
end

function RadianMove:OnEnd()
    self.run = false
end

local constDefPointDash = "point"
local constDefDirectionDash = "direction"
--- 创建一个冲锋动作对象
function SkillUtil.CreateDash(dashType,...)
    local d = {}
    local args = {...}
    setmetatable(d,{__index = Dash})
    if dashType == constDefPointDash then
        d:DashToPoint(table.unpack(args))
    elseif dashType == constDefDirectionDash then
        d:DashToDirection(table.unpack(args))
    end
    return d
end

function SkillUtil.CreateRadianMove(...)
    return CreateNewObject(RadianMove,...)
end

--local dummy = world.dummy
function SkillUtil.RotateTo(targetPos,obj)
    if GetDistBetweenObj(targetPos,obj.Position) < 0.1 then
        return
    end
    local dummy = obj.dummy
    local targetForward = (targetPos - obj.Position).Normalized
    dummy.Forward = targetForward
    ModifyForward(dummy)
    local animatedMesh = obj.animatedMesh
    if animatedMesh then
        animatedMesh:RotateTo(dummy.Rotation,0.2)
    end
    --obj:RotateTo(dummy.Rotation,0.1)
end

return SkillUtil