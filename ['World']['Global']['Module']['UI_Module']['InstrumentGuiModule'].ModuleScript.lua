local InstrumentGui = {}

-- 初始化
function InstrumentGui:Init()
    
    self.effectCountdown = 0

    self.rootUI = localPlayer.Local.InstrumentGui
    self.AudioFolder = localPlayer.InstrumentAudio.Ukulele
    self.instrumentBtn = localPlayer.Local.ItemTestGui.BgImg.InstrumentBtn

    self:BindAction()
    --]]
end

function InstrumentGui:BindAction()

    -- 测试入口（DELETE LATER）
    self.instrumentBtn.OnClick:Connect(function()
        MiniPiano:Use()
    end)

    -- 点击退出按钮
    self.rootUI.CloseBtn.OnClick:Connect(function()
        MiniPiano:UnUse()
    end)

    local allBtns = self.rootUI.Buttons:GetChildren()
    for _, _btn in pairs(allBtns) do
        _btn.OnClick:Connect(function()
            self:KeyBtnClicked(_btn)
        end)
    end

    -- 琴谱开关
    local refButtons = self.rootUI.RefButtons:GetChildren()
    for _, _btn in pairs(refButtons) do
        _btn.OnClick:Connect(function()
            self.rootUI.RefImg:SetActive(not self.rootUI.RefImg.ActiveSelf)
        end)
    end

    -- TODO: 琴谱
    self.rootUI.RefImg.R1Txt.Text = 'B3 B2 B3 B2 B3 B5 B5 - A5 B1 B2 B1'
    self.rootUI.RefImg.R2Txt.Text = 'B1 B1 B2 B3 B1 - A5 B1 B2 B3 B1 A5 B2 B3'

end

--- 按下琴键
--- @param _keyBtn UiButtonObject 琴键按钮
function InstrumentGui:KeyBtnClicked(_keyBtn)

    -- 播放声音
    local audioName = _keyBtn.Name --string.gsub(_btn.Name, 'Btn', '')
    local audio = self.AudioFolder:GetChild(audioName)
    if audio then 
        AudioUtil:Play(audio)
    end

    -- 按键动效
    local ripple = world:CreateInstance('RippleImg', 'Ripple', _keyBtn)
    local rippleTweener = Tween:TweenProperty(ripple, {Size = Vector2.One * 200, Alpha = 0}, 1, Enum.EaseCurve.CircularOut)
    rippleTweener.OnComplete:Connect(function()
        rippleTweener:Destroy()
        ripple:Destroy()
    end)
    rippleTweener:Play()

    -- 音符特效
    if world:GetDevicePlatform() == Enum.Platform.Windows then
        self.effectCountdown = 30
    else 
        self.effectCountdown = 15
    end
    localPlayer.Avatar.Effects.MusicEffect:SetActive(true)

end

-- Update
function InstrumentGui:Update()
    -- 音符特效显示
    if self.effectCountdown > 0 then 
        self.effectCountdown = self.effectCountdown - 1 
        if self.effectCountdown <= 0 then 
            localPlayer.Avatar.Effects.MusicEffect:SetActive(false)
        end
    end
end

return InstrumentGui