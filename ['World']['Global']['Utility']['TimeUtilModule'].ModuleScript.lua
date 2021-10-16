---时间工具
---author Chen Muru
local TimeUtil = {}

local Event = {}
local eventId = 1

function Event:Init(_delay,_loop,_startTime,_handler,...)
	self.delay = _delay
	self.startTime = _startTime
	self.loop = _loop
	self.handler = _handler
	self.id = eventId
	self.args = {...}
    eventId = eventId + 1
end

function TimeUtil.CreateNewEvent(_delay,_loop,_startTime,_handler,...)
	local o = {}
	setmetatable(o, {__index = Event})
    o:Init(_delay,_loop,_startTime,_handler,...)
    return o
end

function TimeUtil.AddEvent(_allEvent,_event)
	_allEvent[_event.id] = _event
end

function TimeUtil.RemoveEvent(_allEvent,_id)
	_allEvent[_id] = nil
end

function TimeUtil:RegisterDelayTimeEvent(_delay,_handler,_allEvent,...)
	local delayTimeEvent = TimeUtil.CreateNewEvent(_delay, false, Timer.GetTimeMillisecond(), _handler,...)
	self.AddEvent(_allEvent,delayTimeEvent)
	return delayTimeEvent
end

function TimeUtil:RegisterRTEvent(_gapTime, _handler, _startDelayTime,_allEvent,...)
	_startDelayTime = _startDelayTime or 0
	local rtEvent = TimeUtil.CreateNewEvent(_gapTime, true, Timer.GetTimeMillisecond() + _startDelayTime, _handler,...)
	self.AddEvent(_allEvent,rtEvent)
end

function TimeUtil:UpdateEvent(_allEvents,_activeEvents)
	local curTime = Timer.GetTimeMillisecond()
	for k, v in pairs(_allEvents) do
		if curTime > v.startTime + v.delay then
			_activeEvents[k] = v
			if not v.loop then
				_allEvents[k] = nil
			else
				v.startTime = curTime
			end
		end
	end
	
	for k, v in pairs(_activeEvents) do
		local result = v.handler(table.unpack(v.args))
		_activeEvents[k] = nil
		if result then
			self.RemoveEvent(_allEvents,v.id)
		end
	end
end

return TimeUtil