---服务器计时器
---author Chen Muru
local S_TimeMgr, this = ModuleUtil.New('S_TimeMgr', ServerBase)

function S_TimeMgr:Init()    
    -- 所有待触发的事件
    self.allEvent = {}
    -- 所有正在触发的事件
    self.activeEvent = {}

    self.dayTime = 12
	self:CheckDayTime()
end

function S_TimeMgr:Update(dt)
	TimeUtil:UpdateEvent(self.allEvent,self.activeEvent)
end

function S_TimeMgr:AddDelayTimeEvent(_delay,_handler,...)
	TimeUtil:RegisterDelayTimeEvent(_delay,_handler,self.allEvent,...)
end

function S_TimeMgr:AddRTEvent(_gapTime, _handler, _startDelayTime,...)
	_startDelayTime = _startDelayTime or 0
	TimeUtil:RegisterRTEvent(_gapTime, _handler, _startDelayTime,self.allEvent,...)
end

function S_TimeMgr:CheckDayTime()
	local dayTimeEvent = function()
		self.dayTime = self.dayTime + 1
		if self.dayTime >= 24 then
			self.dayTime = 0
		end
		--print('当前时间: ', self.dayTime, ' 点')
	end
	self:AddRTEvent(1000, dayTimeEvent)
end

function S_TimeMgr:GetDayTime()
	return self.dayTime
end

function S_TimeMgr.CheckIfAtNight()
    return S_TimeMgr.dayTime <= 6
end

return S_TimeMgr