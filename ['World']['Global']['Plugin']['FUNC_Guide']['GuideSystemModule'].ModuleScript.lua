---引导系统
---@module GuideSystem
---@copyright Lilith Games, Avatar Team
---@author Sid Zhang, Yuancheng Zhang

local GuideSystem = {}

--- 引导的枚举类型
GuideSystem.Enum = {
    ClickGuide = 'ClickGuide'
}

--- 创建的tweener池
GuideSystem.Tweeners = {}

--- 显示强引导Ui
---@param _type Int 1:点击
---@param _position Vector2 生成引导UI在屏幕的位置,Anchors值
---@param _area Vector2 响应范围,Size
---@param _content String 文本介绍,nil则不显示文本
function GuideSystem:ShowGuide(_type, _position, _area, _content, _callBack, ...)
    local args = {...}
    if _type == GuideSystem.Enum.ClickGuide then
        local GuideNode = world:CreateInstance('ClickGuide', 'ClickGuide', localPlayer.Local)
        if _position then
            GuideNode.ImgDot.AnchorsX = Vector2(_position.X, _position.X)
            GuideNode.ImgDot.AnchorsY = Vector2(_position.Y, _position.Y)
        end
        if _content then
            GuideNode.ImgDot.FigTextBox.TxtContent.Text = _content
        else
            GuideNode.ImgDot.FigTextBox.Visible = false
        end
        if _area then
            GuideNode.ImgDot.BtnClose.Size = _area
        end
        GuideNode.ImgDot.BtnClose.OnClick:Connect(
            function()
                if _callBack and type(_callBack) == 'function' then
                    _callBack(table.unpack(args))
                end
                GuideNode:Destroy()
            end
        )
    else
        error('param #1 :_type error')
    end
end

--- 波纹提示
--- @param _parentNode Node 引导波纹的父节点
--- @param _position Vector2 波纹的位置, Anchors值
--- @param _area Vector2 响应范围
--- @param _callback function 回调函数
function GuideSystem:RippleGuide(_parentNode, _position, _area, _callback, ...)

    if (_parentNode == nil) then 
        error('lack of param #1')
    end

    local args = {...}
    local GuideNode = world:CreateInstance('RippleGuide', 'RippleGuide', _parentNode)
    if _position then
        GuideNode.AnchorsX = Vector2.One * _position.X
        GuideNode.AnchorsY = Vector2.One * _position.Y
    end
    if _area then
        GuideNode.CloseBtn.Size = _area
    end

    local ripple = GuideNode.RippleImg

    -- TODO: 这里的表现效果需要让小诗调一下
    local tweener = Tween:TweenProperty(ripple, {Size = Vector2.One * 150, Alpha = 0}, 1, Enum.EaseCurve.CircularOut)
    table.insert(GuideSystem.Tweeners, tweener)
	tweener.OnComplete:Connect(function()
        ripple.Alpha = 1
        ripple.Size = Vector2.One * 84
        tweener:Play()
    end)

    GuideNode.CloseBtn.OnClick:Connect(
        function()
            if _callback and type(_callback) == 'function' then
                _callback(table.unpack(args))
            end
            tweener:Destroy()
            GuideNode:Destroy()
        end
    )

    tweener:Play()
end

--- 摧毁临时波纹子节点
--- @_parentNode Node 波纹父节点
function GuideSystem:DestroyRipple(_parentNode)

	if _parentNode.RippleGuide then

		_parentNode.RippleGuide:Destroy()

		for k,v in pairs(GuideSystem.Tweeners) do

			v:Destroy()
			v = nil
			table.remove(GuideSystem.Tweeners,v)

		end

	end

end

return GuideSystem
