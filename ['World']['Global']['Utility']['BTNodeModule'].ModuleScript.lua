---行为树节点
---author Chen Muru
local BTNode = {}

BTNode.Type = {
	Sequence = 'Sequence',
	Selector = 'Selector',
	Evaluator = 'Evaluator',
	Action = 'Action',
	Decorator = 'Decorator'
}
 
BTNode.Status = {
	Success = 'Success',
	Failure = 'Failure',
	Running = 'Running',
	Ready = 'Ready'
}

BTNode.DecoratorTypes = {
	Repeat = 'Repeat'
}

--- 初始化
function BTNode:Init(_name, _type, _owner,_args)
    self.name = _name or ''
	self.type = _type or self.Type.Action
	
	self.status = self.Status.Ready
	
	self.parent = nil
	self.children = {}
	self.owner = _owner
	
	self.action = nil
	self.evaluator = nil
	self.args = _args
	self.decoratorType = nil
	self.decorator = nil
end

function BTNode:GetType()
	return self.type
end

function BTNode:SetStatus(_status)
	self.status = self.Status[_status]
end

function BTNode:GetStatus()
	return self.status
end

function BTNode:ResetNode()
	self.status = BTNode.Status.Ready
	for _, v in pairs(self.children) do
		v:ResetNode()
	end
end

function BTNode:SetParent(_parent)
	self.parent = _parent
end

function BTNode:GetParent()
	return self.parent
end

function BTNode:AddChildNode(_child,_index)
	local index = _index or #self.children + 1
	table.insert(self.children,index,_child)
	_child.parent = self
	_child.owner = self.owner
end

function BTNode:GetChildNode(_index)
	return self.children[_index]
end

function BTNode:GetChildren()
	return self.children
end

function BTNode:SetAction(_action)
	self.action = _action
end

function BTNode:RunActionFunc()
	local action = self.action
	self.owner[action](self.owner,table.unpack(self.args))
end

function BTNode:SetEvaluator(_evaluator)
	self.evaluator = _evaluator
end

function BTNode:RunEvaluator()
	local evaluator = self.evaluator
	local result = self.owner[evaluator](self.owner,table.unpack(self.args))
	if result then
		self:SetStatus(self.Status.Success)
	else
		self:SetStatus(self.Status.Failure)
	end
end

function BTNode:GetNodeIndexInParent()
	if self.parent then
		local allChildNodeOfParent = self.parent.children
		for ii = 1, #allChildNodeOfParent, 1 do
			if allChildNodeOfParent[ii] == self then
				return ii
			end
		end
	end
	return -1
end

function BTNode:GetChildrenLengthOfParent()
	if self.parent then
		return #self.parent:GetChildren()
	end
	return -1
end

function BTNode:RepeatNodeFunc(_btObj)
	if self.status == BTNode.Status.Running then
		if #self.children < 1 then
			print('warning: no child node!!!!')
			return
		end
		_btObj:RunNode(self.children[1])
		return
	end
	_btObj:RunNode(self)
end

BTNode.decoratorFunc = {
	Repeat = BTNode.RepeatNodeFunc,
	--self.DecoratorTypes.Repeat = self.RepeatNodeFunc,
}

function BTNode:SetDecorator(_decoratorType)
	self.decoratorType = _decoratorType
	self.decorator = self.decoratorFunc[_decoratorType]
end

function BTNode:GetDecoratorType()
	return self.decoratorType
end

function BTNode:RunDecoratorFunc(...)
	local args = {...}
	self:decorator(table.unpack(args))
end

return BTNode