--- 解谜模块
--- @module Filter
--- @copyright Lilith Games, Avatar Team
--- @author Magnus Guan
local PuzzleMgr = {}

function PuzzleMgr:Init()
	PuzzleMgr.Used = {}
	self.Triggers = world.Puzzle.Triggers
	self.MovableWalls = world.Puzzle.Doors
	self.High = 16.5
	self.Low = 16.4
	self.MoveTime = 5
	self.TriggerTime = 1
	self.StayTime = 20000
	self.switch = 1
	self.change1 = 2
	self.change2 = 8
	for _,trigger in pairs(self.Triggers:GetChildren()) do
		trigger.Collision.OnCollisionBegin:Connect(function(_hitObject)
			if _hitObject then
				local players = world:FindPlayers()
				for _,_player in pairs(players) do
					if _hitObject == _player then
						trigger.num.Value = trigger.num.Value + 1
					end
				end
			end
		end)
		trigger.Collision.OnCollisionEnd:Connect(function(_hitObject)
			if _hitObject then
				local players = world:FindPlayers()
				for _,_player in pairs(players) do
					if _hitObject == _player then
						if trigger.num and trigger.num.Value > 0 then
							trigger.num.Value = trigger.num.Value - 1
						elseif trigger.num and trigger.num.Value <= 0 then
							trigger.num.Value = 0
						end
					end
				end
			end
		end)
	end
end

function PuzzleMgr:Update()
	local trigger1 = self.Triggers.Trigger1.Position.y
	local trigger2 = self.Triggers.Trigger2.Position.y
	local trigger3 = self.Triggers.Trigger3.Position.y
	local trigger4 = self.Triggers.Trigger4.Position.y
	if self.switch == 1 then
		for _,trigger in pairs(self.Triggers:GetChildren()) do
			if trigger.num then
				if trigger.num.Value == 0 then
					if math.abs((trigger.Position.y) - (self.Low)) <= 0.01 and trigger.Movable.Value == true then
					--if trigger.Position.y == self.Low and trigger.Movable.Value == true then
						trigger.Movable.Value = false
						local Tweener1=Tween:TweenProperty(trigger, {Position=Vector3(trigger.Position.x,16.5,trigger.Position.z)}, self.TriggerTime, Enum.EaseCurve.Linear)
						Tweener1.OnComplete:Connect(function()
							trigger.Position = Vector3(trigger.Position.x,16.5,trigger.Position.z)
							trigger.Movable.Value = true
							Tweener1:Destroy()
						end)
						Tweener1:Play()
					end
				elseif trigger.num.Value > 0 then
					--if ((trigger.Position.y) - (trigger.Position.y) % 0.01) == self.High and trigger.Movable.Value == true then
					if math.abs((trigger.Position.y) - (self.High)) <= 0.01 and trigger.Movable.Value == true then
						trigger.Movable.Value = false
						local Tweener1=Tween:TweenProperty(trigger, {Position=Vector3(trigger.Position.x,16.4,trigger.Position.z)}, self.TriggerTime, Enum.EaseCurve.Linear)
						Tweener1.OnComplete:Connect(function()
							trigger.Position = Vector3(trigger.Position.x,16.4,trigger.Position.z)
							trigger.Movable.Value = true
							Tweener1:Destroy()
						end)
						Tweener1:Play()
					end
				end
			end
		end
		-- 踩第一个机关，大猩猩雕像出现
		if math.abs(trigger1-self.Low)<=0.01 and math.abs(trigger2-self.High)<=0.01 and math.abs(trigger3-self.High)<=0.01 and math.abs(trigger4-self.High)<=0.01 and self.MovableWalls.OrangutanStatue.Movable.Value then
			local door = self.MovableWalls.OrangutanStatue
			door.Movable.Value = false
			AudioUtil:Play(door.Audio)
			local Tweener1=Tween:TweenProperty(door, {Position=door.Position+Vector3(0,self.change1,0)}, self.MoveTime, Enum.EaseCurve.Linear)
			local Tweener2=Tween:TweenProperty(door, {Position=Vector3(door.pos.Value.x,door.pos.Value.y,door.pos.Value.z)}, self.MoveTime, Enum.EaseCurve.Linear)
			Tweener1.OnComplete:Connect(function()
				door.Effect:SetActive(false)
				door.Effect:SetActive(true)
				S_TimeMgr:AddDelayTimeEvent(self.StayTime,function() 
					Tweener2:Play()
					AudioUtil:Play(door.Audio)
				end)
				Tweener1:Destroy()
			end)
			Tweener2.OnComplete:Connect(function()
				door.Movable.Value = true
				door.OrangutanStatue.CollisionGroup = 1
				door.Effect:SetActive(false)
				Tweener2:Destroy()
			end)
			door.OrangutanStatue.CollisionGroup = 6
			Tweener1:Play()
		-- 踩第1、3机关，鳄鱼雕像出现
		elseif math.abs(trigger1-self.Low)<=0.01 and math.abs(trigger2-self.High)<=0.01 and math.abs(trigger3-self.Low)<=0.01 and math.abs(trigger4-self.High)<=0.01 and self.MovableWalls.CrocodileStatue.Movable.Value then
			local door = self.MovableWalls.CrocodileStatue
			door.Movable.Value = false
			AudioUtil:Play(door.Audio)
			local Tweener1=Tween:TweenProperty(door, {Position=door.Position+Vector3(0,self.change2,0)}, self.MoveTime, Enum.EaseCurve.Linear)
			local Tweener2=Tween:TweenProperty(door, {Position=Vector3(door.pos.Value.x,door.pos.Value.y,door.pos.Value.z)}, self.MoveTime, Enum.EaseCurve.Linear)
			Tweener1.OnComplete:Connect(function()
				door.Effect:SetActive(false)
				door.Effect:SetActive(true)
				S_TimeMgr:AddDelayTimeEvent(self.StayTime,function() 
					Tweener2:Play()
					AudioUtil:Play(door.Audio)
				end)
				Tweener1:Destroy()
			end)
			Tweener2.OnComplete:Connect(function()
				door.Movable.Value = true
				door.CrocodileStatue.CollisionGroup = 1
				door.Effect:SetActive(false)
				Tweener2:Destroy()
			end)
			door.CrocodileStatue.CollisionGroup = 6
			Tweener1:Play()
		-- 踩第2、3、4机关，巨嘴鸟雕像出现
		elseif math.abs(trigger1-self.High)<=0.01 and math.abs(trigger2-self.Low)<=0.01 and math.abs(trigger3-self.Low)<=0.01 and math.abs(trigger4-self.Low)<=0.01 and self.MovableWalls.ToucanStatue.Movable.Value then
			local door = self.MovableWalls.ToucanStatue
			door.Movable.Value = false
			AudioUtil:Play(door.Audio)
			local Tweener1=Tween:TweenProperty(door, {Position=door.Position+Vector3(0,self.change2,0)}, self.MoveTime, Enum.EaseCurve.Linear)
			local Tweener2=Tween:TweenProperty(door, {Position=Vector3(door.pos.Value.x,door.pos.Value.y,door.pos.Value.z)}, self.MoveTime, Enum.EaseCurve.Linear)
			Tweener1.OnComplete:Connect(function()
				door.Effect:SetActive(false)
				door.Effect:SetActive(true)
				S_TimeMgr:AddDelayTimeEvent(self.StayTime,function() 
					Tweener2:Play()
					AudioUtil:Play(door.Audio)
				end)
				Tweener1:Destroy()
			end)
			Tweener2.OnComplete:Connect(function()
				door.Movable.Value = true
				door.ToucanStatue.CollisionGroup = 1
				door.Effect:SetActive(false)
				Tweener2:Destroy()
			end)
			door.ToucanStatue.CollisionGroup = 6
			Tweener1:Play()
		-- 踩第2个机关，鹿雕像出现
		elseif math.abs(trigger1-self.High)<=0.01 and math.abs(trigger2-self.Low)<=0.01 and math.abs(trigger3-self.High)<=0.01 and math.abs(trigger4-self.High)<=0.01 and self.MovableWalls.DeerStatue.Movable.Value then
			local door = self.MovableWalls.DeerStatue
			door.Movable.Value = false
			AudioUtil:Play(door.Audio)
			local Tweener1=Tween:TweenProperty(door, {Position=door.Position+Vector3(0,self.change2,0)}, self.MoveTime, Enum.EaseCurve.Linear)
			local Tweener2=Tween:TweenProperty(door, {Position=Vector3(door.pos.Value.x,door.pos.Value.y,door.pos.Value.z)}, self.MoveTime, Enum.EaseCurve.Linear)
			Tweener1.OnComplete:Connect(function()
				door.Effect:SetActive(false)
				door.Effect:SetActive(true)
				S_TimeMgr:AddDelayTimeEvent(self.StayTime,function() 
					Tweener2:Play()
					AudioUtil:Play(door.Audio)
				end)
				Tweener1:Destroy()
			end)
			Tweener2.OnComplete:Connect(function()
				door.Movable.Value = true
				door.DeerStatue.CollisionGroup = 1
				door.Effect:SetActive(false)
				Tweener2:Destroy()
			end)
			door.DeerStatue.CollisionGroup = 6
			Tweener1:Play()
		-- 踩第4个机关，美洲豹雕像出现
		elseif math.abs(trigger1-self.High)<=0.01 and math.abs(trigger2-self.High)<=0.01 and math.abs(trigger3-self.High)<=0.01 and math.abs(trigger4-self.Low)<=0.01 and self.MovableWalls.JaguarStatue.Movable.Value then
			local door = self.MovableWalls.JaguarStatue
			door.Movable.Value = false
			AudioUtil:Play(door.Audio)
			local Tweener1=Tween:TweenProperty(door, {Position=door.Position+Vector3(0,self.change2,0)}, self.MoveTime, Enum.EaseCurve.Linear)
			local Tweener2=Tween:TweenProperty(door, {Position=Vector3(door.pos.Value.x,door.pos.Value.y,door.pos.Value.z)}, self.MoveTime, Enum.EaseCurve.Linear)
			Tweener1.OnComplete:Connect(function()
				door.Effect:SetActive(false)
				door.Effect:SetActive(true)
				S_TimeMgr:AddDelayTimeEvent(self.StayTime,function() 
					Tweener2:Play()
					AudioUtil:Play(door.Audio)
				end)
				Tweener1:Destroy()
			end)
			Tweener2.OnComplete:Connect(function()
				door.Movable.Value = true
				door.JaguarStatue.CollisionGroup = 1
				door.Effect:SetActive(false)
				Tweener2:Destroy()
			end)
			door.JaguarStatue.CollisionGroup = 6
			Tweener1:Play()
		end
	end
end

return PuzzleMgr