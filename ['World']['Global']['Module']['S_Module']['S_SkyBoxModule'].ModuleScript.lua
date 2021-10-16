local S_SkyBox = {}

function S_SkyBox:Init()
    this = self
	
    ---天空盒配置表
    this.configSkyBox = Config.SkyBox
	---当前天空盒
	this.skyBox = world.ProceduralSky
    ---游戏内当前时间（24h）
	this.constantTime = 8
    ---表格格式时间
    this.configTime = 0
    ---游戏24h等于现实8分钟 (24h,8min,60换算 180)
    this.timeScale = 24 / (8 / 60) 
    this.skyBox.TimeScale = this.timeScale

    ---游戏24h等于现实8分钟(用于模拟时间流动)
    this.dayTime = 8
    ---数值物体
    this.skyValueObj = world.SkyTime

    ---白天开始时间 
    this.dayStartTime = 6.5
    ---白天结束时间
    this.dayEndTime = 17
    ---夜晚开始时间
    this.nightStartTime = 19
    ---夜晚结束时间
    this.nightEndTime = 5.8
    ---傍晚开始时间
    this.eveningStartTime = this.dayEndTime
    ---傍晚结束时间
    this.eveningEndTime = this.nightStartTime
    ---黎明开始时间
    this.dawnStartTime = this.nightEndTime
    ---黎明结束时间
    this.dawnEndTime = this.dayStartTime

    ---异常发红开始时间
    this.redFaceStartTime = 17.8
    ---异常发红结束时间
    this.redFaceEndTime = 18.3
    ---异常发红TimeScale
    this.redFaceTimeScale = this.timeScale * 10

    ---模拟时间流动
    S_SkyBox:TimeMove()
end

---返回当前时间段名字
function S_SkyBox:GetSkyPeriod()
    if this.constantTime >= this.dayStartTime and this.constantTime < this.dayEndTime then
        return 'morning'
    elseif this.constantTime >= this.eveningStartTime and this.constantTime < this.eveningEndTime then
        return 'evening'
    elseif this.constantTime >= this.nightStartTime or this.constantTime < this.nightEndTime then
        return 'night'
    else
        return 'dawn'
    end
end

---返回当前时间段是否是白天
function S_SkyBox:CheckIfAtMorning()   
    if this.constantTime >= this.dayStartTime and this.constantTime < this.dayEndTime then
        return true
    else
        return false
    end
end

---返回当前时间段是否是夜晚
function S_SkyBox:CheckIfAtNight()
    if this.constantTime >= this.nightStartTime or this.constantTime < this.nightEndTime then
        return true
    else
        return false
    end
end

---返回当前时间段是否是黎明
function S_SkyBox:CheckIfAtDawn()
    if this.constantTime >= this.dawnStartTime and this.constantTime <= this.dawnEndTime then
        return true
    else
        return false
    end
end

---返回当前时间段是否是傍晚
function S_SkyBox:CheckIfAtDawn()
    if this.constantTime >= this.eveningStartTime and this.constantTime < this.eveningEndTime then
        return true
    else
        return false
    end
end

local prevTimeName = 'dawn'
local curTimeName = 'morning'

function S_SkyBox:OnTimeNameChange(_prevTime,_curTime)
    if _prevTime == 'night' and _curTime == 'dawn' then
        
        WorldResource:DawnUpdate()
    elseif _prevTime == 'dawn' and _curTime == 'morning' then    
        
        WorldResource:MorningUpdate()
    elseif _prevTime == 'morning' and _curTime == 'evening' then 
        
    elseif _prevTime == 'evening' and _curTime == 'night' then 
        
        WorldResource:NightUpdate()
    end
end


function S_SkyBox:ChangeTimeName()
    curTimeName = S_SkyBox:GetSkyPeriod()
    if curTimeName ~= prevTimeName then
        S_SkyBox:OnTimeNameChange(prevTimeName,curTimeName)
    end
    prevTimeName = curTimeName
end

function S_SkyBox:Update()
    ---获取最新的TimeScale
    this.constantTime = this.skyValueObj.Value
    ---一天阶段变更事件
    S_SkyBox:ChangeTimeName()

    S_SkyBox:ChangeFogColor()

    --print(this.constantTime)
end

---update时，根据当前ConstantTime更换skybox的FogColor
function S_SkyBox:ChangeFogColor()
    ---将当前时间转换成表格指定格式
    local time = tonumber(string.format("%6.1f",this.constantTime))
    local sT = this.configSkyBox[time]

    if sT then
        this.skyBox.FogColor  = sT["fogColor"]
        --this.skyBox.FogStart  = sT["fogStart"]
        --this.skyBox.FogEnd  = sT["fogEnd"]
    else
        --print(time)
    end
    
    ---异常发红时间处理
    --[[
    if tonumber(time) < this.redFaceEndTime and tonumber(time) >= this.redFaceStartTime then
        this.skyBox.TimeScale = this.redFaceTimeScale
    elseif tonumber(time) == this.redFaceEndTime then
        this.skyBox.TimeScale = this.timeScale
    end
    --]]
end

---天空盒时间读取错误绕行
function S_SkyBox:TimeMove()
    local durarion = ((24 - this.skyValueObj.Value) / 24 ) * 8 * 60
    local skyTween = Tween:TweenProperty(this.skyValueObj,{Value = 24},durarion,Enum.EaseCurve.Linear)
    skyTween.OnComplete:Connect(
        function ()
            this.skyValueObj.Value = 0
            skyTween:Destroy()
            S_SkyBox:TimeMove()
        end
    )
    skyTween:Play()
    --print(this.constantTime)
    --print(durarion)
    --print(skyTween)
end

return S_SkyBox