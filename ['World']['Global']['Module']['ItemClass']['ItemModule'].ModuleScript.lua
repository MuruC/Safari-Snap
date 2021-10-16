local Item = {}

--- 生成新的Item
--- @param _archetype String Archetype名称
--- @param _pos Vector3 生成位置
--- @param _parentNode Node 父节点
function Item:Instantiate(_archetype, _pos, _parentNode)
    _parentNode = _parentNode or world
    local o = world:CreateInstance(_archetype, _archetype, _parentNode, _pos)

    --region 生成动效
    o.Scale = 0
    local tweener1 = Tween:TweenProperty(o, {Scale = 1.0}, 0.25, Enum.EaseCurve.BackOut) --Backout
    tweener1.OnComplete:Connect(function()
        tweener1:Destroy()
    end)
    tweener1:Play()
    --endregion

    return o
end

return Item

--local Item = class('Item')
--[[
local Item = {}
Item.__index = Item

function Item:SetProperty()
    self.type = Const.ItemType.COMMON
    self.class = 'Item'
    self.archetypeName = 'Item'
    self.maxNum = 20
    self.source = Const.ItemSource.WORLD
    self.state = Const.ItemState.NORMAL

    self.pickable = true
end

--- 新建一个Item
function Item:New(_pos)
    local o = {}
    setmetatable(o, self)
    o:SetProperty()

    -- 加入列表维护
    o.itemId = UUID()
    
    --WorldResource.allItems[o.itemId] = o
    GlobalData.allItems[o.itemId] = o

    o:Instantiate(o, _pos)

    return o
end

--- 实例化模型
function Item:Instantiate(_o, _pos)
    _o.inst = world:CreateInstance(_o.archetypeName, _o.class, world.Items, _pos)
    _o.inst.ItemId.Value = _o.itemId
end

--- 物品拾取
function Item:PickUp()
    Notice:ShowMessage(self.class..'+1')
    
    QuickBarManage:ChangeQuickBarEventHandler(Const.QuickBar.GetStuff, self)

    if self.inst then 
        self.inst:Destroy() 
    end
end

--- 头顶
--- @param _deltaPos Vector3 
function Item:HeadHold(_deltaPos)
    self:New(localPlayer.Position + _deltaPos)
end


return Item
]]--
