--- UI 动效
local UIAnimation,this = ModuleUtil.New('UIAnimation', ClientBase)

function UIAnimation:Init()
    self.baseFrame = 0.04

end    
--- UI 节点大小变化
--- @param node userdata 节点
--- @param size userdata 目标大小
--- @param time float 持续帧数
function UIAnimation:SizeChangeTween(node,sizeX,sizeY,time)
    local tweener = Tween:TweenProperty(node,{Size = Vector2(sizeX,sizeY)},self.baseFrame *time,Enum.EaseCurve.Linear):Play()
end    

--- UI 节点位置变化
--- @param node userdata 节点
--- @param posX userdata 目标AnchorsX
--- @param posY userdata 目标AnchorsY
--- @param time float 持续帧数
function UIAnimation:PosChangeTween(node,posX,posY,time)
    local tweener = Tween:TweenProperty(node,{AnchorsX = Vector2(posX,posX),AnchorsY = Vector2(posY,posY)},self.baseFrame *time,Enum.EaseCurve.QuinticInOut):Play()
end
--- UI 节点透明度变化
--- @param node userdata 节点
--- @param alpha userdata 目标透明度
--- @param time float 持续帧数
function UIAnimation:AlphaChangeTween(node,alpha,time)
    local tweener = Tween:TweenProperty(node,{Color = Color(255,255,255,alpha)},self.baseFrame*time,Enum.EaseCurve.QuinticInOut):Play()
end

function UIAnimation:FontSizeChangeTween(node,fontSize,time)
    local tweener = Tween:TweenProperty(node,{FontSize = fontSize},self.baseFrame*time,Enum.EaseCurve.QuinticInOut):Play()
end
--- UI 节点透明度更改
--- @param node userdata 节点
--- @param alpha userdata 目标透明度
function UIAnimation:AlphaChange(node,alpha)
    node.Color = Color(255,255,255,alpha)
end

function UIAnimation:Rotate(node,rotate, time)
end

return UIAnimation