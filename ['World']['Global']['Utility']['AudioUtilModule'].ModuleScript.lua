local AudioUtil = {}

--- 播放音效
--- @param _aud object 音效节点
function AudioUtil:Play(_aud)
    if not _aud then return end
    --如果正在播放，先停止
    if _aud:GetAudioState() == Enum.AudioSourceState.Playing then
        _aud:Stop()
    end
    _aud:Play()
end

--- 停止播放音效
--- @param _aud object 音效节点
function AudioUtil:Stop(_aud)
if not _aud then return end
_aud:Stop()
end

--- 先设置音效位置再播放音效
--- @param _aud object 音效节点
function AudioUtil:SetPosAndPlay(_aud, _pos)
if not _aud then return end
_aud.Position = _pos
self:Play(_aud)
end

--- 播放默认的点击音效
function AudioUtil:PlayDefaultClickSfx() 
    self:Play(localPlayer.Local.Sfx.Click)
end

-- 播放错误点击音效
function AudioUtil:PlayWrongClickSfx() 
    self:Play(localPlayer.Local.Sfx.WrongClick)
end

-- 播放需要循环的音效
function AudioUtil:PlayLoopSfx(_aud,isLoop)
    if not _aud then return end
    --如果正在播放，先停止
    if _aud:GetAudioState() == Enum.AudioSourceState.Playing then
        _aud:Stop()
    end
    _aud.Loop = isLoop
    _aud:Play()
end
return AudioUtil