---状态机工具类
---author Chen Muru
local FSMUtil = {}

function FSMUtil.Run(allStateTable,owner)
    local curState = allStateTable[owner.curState]
    if curState and curState.OnUpdate then
        curState.OnUpdate(owner)
    end
    if owner.btObj then
		owner.btObj:CheckCurNodeStatus()
	end
	--[[
	local expressionFx = owner.expressionFx
	if expressionFx and expressionFx.ActiveSelf then
		local objPos = owner.obj.Position
		expressionFx.Position = Vector3(objPos.x,expressionFx.Position.y,objPos.z)
	end
	--]]
end

function FSMUtil.ChangeState(allStateTable,owner,_nextState)
    local curState = allStateTable[owner.curState]
	if curState and curState.OnLeave then
		curState.OnLeave(owner)
	end
	local nextState = allStateTable[_nextState]
	owner.curState = _nextState
	if nextState and nextState.OnEnter then
		nextState.OnEnter(owner)
	end
end

function FSMUtil.ProcessEvent(allStateTable,owner,event)
    -- global process在类里单独写明
    -- local process
	local curState = allStateTable[owner.curState]
	if curState and curState.OnEvent then
		curState.OnEvent(owner,event)
	end
end

function FSMUtil.IsInState(owner,state)
	if owner.curState == state then
		return true
	end

	return false
end

function FSMUtil.QuitCurActionState(owner)
    owner.btObj:SetCurActionNodeSuccess()
    owner:ChangeState(nil)
end

return FSMUtil