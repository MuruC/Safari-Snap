local S_AudioMgr= {}

function S_AudioMgr:Init()
	self.Audios = world.Audios
end

function S_AudioMgr:Update()
	--print(Audios.Wind1.State)
	for _,audio in pairs(self.Audios:GetChildren()) do
		if audio.Time then
			if audio.Time.Value =='Day' and S_SkyBox:GetSkyPeriod()=='night' then
				audio.Time.Value ='Night'
				audio:FadeStop(1)
				S_TimeMgr:AddDelayTimeEvent(1000,function()
					audio.SoundClip = ResourceManager.GetSoundClip('Audio/Sfx/Env/Sfx_Rainforest2')
					audio.Volume = 50
					audio:FadePlay(1)
				end)
			elseif 	audio.Time.Value =='Night' and S_SkyBox:GetSkyPeriod()~='night' then
				audio.Time.Value ='Day'
				audio:FadeStop(1)
				S_TimeMgr:AddDelayTimeEvent(1000,function()
					audio.SoundClip = ResourceManager.GetSoundClip('Audio/Sfx/Env/Sfx_Rainforest1')
					audio.Volume = 30
					audio:FadePlay(1)
				end)
			end
		end
		if audio.State == 3 then
			--print(audio.Name)
			local players = world:FindPlayers()
			for _,_player in pairs(players) do
				local distance = (_player.Position - audio.Position).Magnitude
				if distance <= audio.MaxDistance then
					audio:Play()
				end
			end
		end
	end
end

return S_AudioMgr