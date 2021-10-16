---行为树管理
---author Chen Muru
local BTMgr = {}

local CreateNewNode = function()
	local o = {}
	setmetatable(o, {__index = BTNode})
	return o
end

function BTMgr.CreateSequence(_name,_owner)
	local newNode = CreateNewNode()
	newNode:Init(_name, newNode.Type.Sequence,_owner)
	return newNode
end

function BTMgr.CreateSelector(_name,_owner)
	local newNode = CreateNewNode()
	newNode:Init(_name, newNode.Type.Selector,_owner)
	return newNode
end

function BTMgr.CreateAction(_name,_action,_owner,...)
	local args = {...}
	local newNode = CreateNewNode()
	newNode:Init(_name, newNode.Type.Action,_owner,args)
	newNode:SetAction(_action)
	return newNode
end

function BTMgr.CreateServPermanentAction(_name,_action,_delay,_owner)
	local actionNode = BTMgr.CreateAction(_name,_action,_owner)
	--S_TimeMgr:AddDelayTimeEvent(_delay,function() print(_name, '$$$$$$') actionNode:SetStatus(BTNode.Status.Success) end)
	return actionNode
end

function BTMgr.CreateClientPermanentAction(_name,_action,_delay,_owner)
	local actionNode = BTMgr.CreateAction(_name,_action,_owner)
	--C_TimeMgr:AddDelayTimeEvent(_delay,function() actionNode:SetStatus(BTNode.Status.Success) end)
	return actionNode
end

function BTMgr.CreateEvaluator(_name,_evaluator,_owner,...)
	local args = {...}
	local newNode = CreateNewNode()
	newNode:Init(_name, newNode.Type.Evaluator,_owner,args)
	newNode:SetEvaluator(_evaluator)
	return newNode
end

function BTMgr.CreateDecorator(_name,_decoratorType,_owner)
	local newNode = CreateNewNode()
	newNode:Init(_name,newNode.Type.Decorator,_owner)
	newNode:SetDecorator(_decoratorType)
	return newNode
end

function BTMgr.CreateNewBTObj(_id,_name)
	local newBtObj = {}
	setmetatable(newBtObj, {__index = BTObj})
	newBtObj:Init(_id,_name)
	return newBtObj
end

return BTMgr