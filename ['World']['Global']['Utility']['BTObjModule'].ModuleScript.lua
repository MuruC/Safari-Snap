---行为树对象
---author Chen Muru
local BTObj = {}

local nodeTypes = BTNode.Type

local typeSequence = nodeTypes.Sequence
local typeSelector = nodeTypes.Selector
local typeEvaluator = nodeTypes.Evaluator
local typeAction = nodeTypes.Action
local typeDecorator = nodeTypes.Decorator

local nodeStatus = BTNode.Status
local statusSuccess = nodeStatus.Success
local statusFailure = nodeStatus.Failure
local statusRunning = nodeStatus.Running
local statusReady = nodeStatus.Ready

local nodeDecoratorType = BTNode.DecoratorTypes
local decoratorTypeRepeat = nodeDecoratorType.Repeat

function BTObj:Init(_id, _name)
	self.id = _id
	self.name = _name or ''

	self.rootNode = nil
	self.curNode = nil
end

function BTObj:SetRootNode(_node)
	self.rootNode = _node
end

function BTObj:SetCurNode(_node)
	self.curNode = _node
end

function BTObj:GetCurNode()
	return self.curNode
end


function BTObj:RunNode(_node)
	--print("node name: ", _node.name,"_node type: ", _node.type)
	if _node.status ~= statusReady then
		print('node status is not ready!!!!! the node is: ', _node.name)
		return
	end
	local thisNode = _node
	self.curNode = _node
	local nodeType = _node:GetType()
	if nodeType == typeAction then
		_node:RunActionFunc()
		_node:SetStatus(statusRunning)
	elseif nodeType == typeEvaluator then
		_node:SetStatus(statusRunning)
		_node:RunEvaluator()
	elseif nodeType == typeSequence or nodeType == typeSelector then
		if #_node.children < 1 then
			print("node name: ", _node.name, ' warning:节点排序错误!!')
			_node:SetStatus(statusSuccess)
		else
			_node:SetStatus(statusRunning)
			thisNode = self:RunNode(_node:GetChildNode(1))
		end
	elseif nodeType == typeDecorator then
		_node:SetStatus(statusRunning)
		_node:RunDecoratorFunc(self)
	end
	return thisNode
end

function BTObj:RunNxtNode(_node)
	--print("node name: ", _node.name,"_node type: ", _node.type, ' ========')
	if _node:GetType() == typeDecorator then	-- 判断该节点是否为循环节点
		if _node:GetDecoratorType() == decoratorTypeRepeat then
			if _node:GetStatus() == statusSuccess then
				self:ResetBTObj()
			end
			self:RunNode(_node)
			return _node
		end
	end
	local nodeParent = _node:GetParent()
	if not nodeParent then
		print('warning: no parent!')
		return nil
	end
	local nodeParentType = nodeParent:GetType()
	local childrenOfParent = nodeParent:GetChildren()
	local nodeIndexInParent = _node:GetNodeIndexInParent()
	--if _node:GetType() == typeSelector then
	--	if nodeParent:GetDecoratorType() == decoratorTypeRepeat then
	--		self:ResetBTObj()
	--	end
	--	return self:RunNxtNode(nodeParent)
	--end
	if nodeIndexInParent < #childrenOfParent then	-- 运行弟弟节点
		if nodeParentType == typeSelector and _node:GetStatus() ~= statusFailure then
			return self:RunNxtNode(nodeParent)
		end
		local broNode = nodeParent:GetChildNode(nodeIndexInParent + 1)
		broNode = self:RunNode(broNode)
		return broNode
	else
		if nodeParentType == typeDecorator then	-- 判断父节点是否为循环节点
			if nodeParent:GetDecoratorType() == decoratorTypeRepeat then
				self:ResetBTObj()
				self.curNode = nodeParent
				return nodeParent
			end
		end
		nodeParent:SetStatus(statusSuccess)
		local grandParentNode = nodeParent:GetParent()	--查找爷爷节点
		if not grandParentNode then
			print('warning: no grand parent!')
			return nil
		end
		return self:RunNxtNode(nodeParent)
	end
end

function BTObj:GetParentNodeWhenNodeFail(_node)
	_node:SetStatus(statusFailure)
	local nodeParent = _node:GetParent()
	if not nodeParent then
		print('this node does not have parent! ', _node.name)
		return nil,_node
	end
	--print('nodeParent Name: ', nodeParent.name, ' nodeParent type: ', nodeParent.type)
	local parentNodeType = nodeParent:GetType()
	if parentNodeType == typeSequence then
		nodeParent:SetStatus(statusFailure)
		return self:GetParentNodeWhenNodeFail(nodeParent)
	elseif parentNodeType == typeSelector or parentNodeType == typeDecorator then
		local thisNode = _node
		if thisNode:GetNodeIndexInParent() == thisNode:GetChildrenLengthOfParent() then
			nodeParent, thisNode = self:GetParentNodeWhenNodeFail(nodeParent)
			if nodeParent then
				nodeParent:SetStatus(statusFailure)
			else
				self:ResetBTObj()
				if thisNode:GetType() == typeDecorator and 
				thisNode:GetDecoratorType() == decoratorTypeRepeat then
					self.curNode = thisNode
				end
			end
		end
		--print('this node name: ',thisNode.name, 'parent node name: ',nodeParent.name)
		return nodeParent,thisNode
	elseif parentNodeType == typeAction or parentNodeType == typeEvaluator then
		print('warning:节点排列错误!!')
		return false
	else
		print('出现了未知的节点类型！！ ', _node.name)
	end
end

function BTObj:CheckCurNodeStatus()	--每帧运算
	local curNode = self.curNode
	if not curNode then
		print('current Node is nil!!!!!!!')
		return
	end
	local curNodeStatus = curNode:GetStatus()
	--print('curNode name: ', curNode.name, ' status: ', curNodeStatus)
	if curNodeStatus == statusRunning then
		return
	end
	if curNodeStatus == statusReady then
		self:RunNode(curNode)
	elseif curNodeStatus == statusSuccess then
		local nxtNode = self:RunNxtNode(curNode)
		if not nxtNode then
			print('no nxt Node!!')
			self:ResetBTObj()
			return
		end
	elseif curNodeStatus == statusFailure then
		--print('当前节点运行失败： ', curNode.name)
		local parentNode, childNode = self:GetParentNodeWhenNodeFail(curNode)
		if not parentNode then
			self:ResetBTObj()
		end
		if childNode then
			--print('child node name is: ', childNode.name)
			local nxtNode = self:RunNxtNode(childNode)
		end
	end
end

function BTObj:ResetBTObj()
	self.curNode = nil
	self.rootNode:ResetNode()
	if self.rootNode:GetDecoratorType() == decoratorTypeRepeat then
		self.curNode = self.rootNode
	end
end

function BTObj:SetCurNodeSuccess()
	self.curNode:SetStatus(statusSuccess)
end

function BTObj:SetCurActionNodeSuccess()
	if self.curNode:GetType() == typeAction then
		self.curNode:SetStatus(statusSuccess)
	end
end

return BTObj