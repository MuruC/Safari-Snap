local SocialGui = {}

--- 初始化
function SocialGui:Init()

    self.rootUI = localPlayer.Local.SocialGui

    -- 弹出的气泡列表
    self.bubbleList = {}

    -- 弹出的表情
    self.activeEmoji = nil

    -- 思考状态默认关闭
    self:SetThinkingState(false)   

    self:BindAction()

end

-- 绑定事件
function SocialGui:BindAction()

    -- 关闭社交面板
    self.rootUI.CloseBtn.OnClick:Connect(function()
        self:Close()
    end)
    --[[
    self.rootUI.BgImg.CloseBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()
        self:Close()
    end)
    ]]--

    -- 打开社交面板
    localPlayer.Local.ControlGui.SocialBtn.OnClick:Connect(function()
        AudioUtil:PlayDefaultClickSfx()
        self:Open()
    end)

    -- 气泡文字
    local textBtns = self.rootUI.BgImg.ChatImg:GetChildren()
    for _i, _btn in ipairs(textBtns) do

        _btn.Text = ""
        local key = Config.SocialPhrase[_i].LocalizeKey
        if key then 
            _btn.Txt.LocalizeKey = key
        else 
            _btn.Txt.Text = Config.SocialPhrase[_i].Content
        end

        _btn.OnClick:Connect(function()
            self:CreateBubble(localPlayer, _btn.Txt.Text)
            self:Close()
            ---region 数据埋点 一川
	        UploadLog("social_phrase_{"..tostring(_i).."}_click","C1004",_i,C_PlayerDataMgr:GetSkyPeriod(),C_PlayerDataMgr:GetPlayerPos())
            ---endregion
            
        end)
    end

    --region 表情（暂时不搞了）
    local emojiBtns = self.rootUI.BgImg.EmoImg:GetChildren()
    for  _i, _emoBtn in ipairs(emojiBtns) do

        local path = 'UI/Social/Emoji/Emoji'.._i --.._emoBtn.Name
        --_emoBtn.Image = ResourceManager.GetTexture(path)
        --_emoBtn.Text = ''

        _emoBtn.OnClick:Connect(function()
            if _emoBtn.LockImg and _emoBtn.LockImg.ActiveSelf == false then 
                self:CreateEmoji(localPlayer, ResourceManager.GetTexture(path))
                self:Close()

                ---region 数据埋点 一川
                UploadLog("social_emoji_{"..tostring(_i).."}_click","C1004",_i,C_PlayerDataMgr:GetSkyPeriod(),C_PlayerDataMgr:GetPlayerPos())
                ---endregion

                --C_GuiMgr:BackToMainInterface()
            else 
                Notice:ShowMessage('表情未解锁')
            end
        end)
    end
    --endregion

    --region 姿势
    local animBtns = self.rootUI.BgImg.PosePnl:GetChildren()

    for _i, _btn in ipairs(animBtns) do
        self:InitPoseButton(_btn, false)
    end

    local selfiePoseBtns = localPlayer.Local.CamGui.CamBg.PoseBgImg:GetChildren()
    for _, _btn in pairs(selfiePoseBtns) do 
        self:InitPoseButton(_btn, true)
    end
    --endregion

end

--- 初始化动作按钮
function SocialGui:InitPoseButton(_btn, _cam)

        local animId = _btn.AnimId.Value
        local anim = SocialMgr.anims[animId]

        -- 贴图
        if _cam == false then 
            local normalPath = 'UI/Social/Pose/'..Config.PlayerAnimation[animId].AnimName..'_Normal'
            local pressedPath = 'UI/Social/Pose/'..Config.PlayerAnimation[animId].AnimName..'_Pressed'
            Interaction:SetBtnTexture(_btn, normalPath, pressedPath)
        end

        _btn.Text = ''
        _btn.LockImg:SetActive(anim.locked)

        -- 点击姿势按钮
        _btn.OnClick:Connect(function()
            -- 玩家处于Idle状态才可做动作
            if localPlayer.State == Enum.CharacterState.Idle then 
                
                if anim.locked == false then 
                    anim:Play()

                    ---region 数据埋点 一川
                    UploadLog("social_action_{"..tostring(animId).."}_click","C1004",animId,C_PlayerDataMgr:GetSkyPeriod(),C_PlayerDataMgr:GetPlayerPos())
                    ---endregion

                    if _cam == false then 
                        self:Close()
                    else
						localPlayer.Avatar.Bone_R_Hand.Camera_Red:SetActive(false)
					end
                else 
                    Notice:ShowMessage('动作未解锁')
                end

            end
        end)
end

--- 生成文字气泡框
--- @param _speaker Object 说话的人
--- @param _content string 内容
--- @param _localizeKey string 本地化Key
--- @param _deltaPos Vector3 位置偏移
function SocialGui:CreateBubble(_speaker, _content, _localizeKey, _deltaPos)

    -- 现有消息上移
    for _, _bubble in ipairs(self.bubbleList) do
        _bubble.Position = _bubble.Position + Vector3(0, 0.3, 0)
    end

    -- 默认位移
    if _deltaPos == nil then 
        _deltaPos = Vector3(0, 2.3, 0)
    end

    -- 气泡音效
    AudioUtil:Play(localPlayer.Sfx.SocialBubble)

    local Bubble = world:CreateInstance('BubbleText', 'BubbleText', _speaker, _speaker.Position + _deltaPos, EulerDegree(0,0,0))

    if _localizeKey == nil then 
        Bubble.Txt.Text = _content
    else 
        Bubble.Txt.LocalizeKey = _localizeKey
    end

    local Length = string.len(_content)
    Bubble.BgImg.Size = Vector2(Length * 25, 65)
    table.insert(self.bubbleList, Bubble)

    -- TODO：弹出 & 收回动效（非必要）

    C_TimeMgr:AddDelayTimeEvent(5000, function() 
        table.remove(self.bubbleList, 1)
        Bubble:Destroy()
    end)

end

--- 生成表情气泡
--- @param _speaker Object 说话的人
--- @param _emojiTexture TextureRef 
--- @param _deltaPos Vector3 位置偏移
function SocialGui:CreateEmoji(_speaker, _emojiTexture, _deltaPos)
    if _deltaPos == nil then 
        _deltaPos = Vector3(0, 2.4, 0)
    end

    -- 音效
    AudioUtil:Play(localPlayer.Sfx.SocialBubble)

    if self.activeEmoji then 
        self.activeEmoji:Destroy()
    end

    local emo = world:CreateInstance('BubbleEmoji', 'BubbleEmoji', _speaker, _speaker.Position + _deltaPos, EulerDegree(0,0,0))
    emo.EmoImg.Texture = _emojiTexture 
    emo.EmoImg.Size = Vector2.One * 100

    self.activeEmoji = emo

    C_TimeMgr:AddDelayTimeEvent(4000, function() 
        if emo then 
            emo:Destroy() 
            self.activeEmoji = nil
        end
    end)
end

-- 打开社交面板
function SocialGui:Open()

    -- 更新所有按钮的解锁状态显示
    local animBtns = self.rootUI.BgImg.PosePnl:GetChildren()
    for _, _animBtn in pairs(animBtns) do 
        local unlocked = table.exists(SocialMgr.unlockedAnims, _animBtn.AnimId.Value)
        _animBtn.LockImg:SetActive(not unlocked)
    end

	PlayerCtrl:DisableMovementInput()
    C_GuiMgr:OpenGui('SocialGui')	
    self:SetThinkingState(true)   

    ---region 数据埋点 一川
    UploadLog("social_click","C1004")
    print("social_click")
    ---endregion
end

function SocialGui:SetThinkingState(_thinking)
    if _thinking == true then 
        localPlayer.StateGui:SetActive(true)   
        localPlayer.DisplayName = false
    else 
        localPlayer.StateGui:SetActive(false)   
        localPlayer.DisplayName = true
    end
end

-- 关闭社交面板
function SocialGui:Close()
    self:SetThinkingState(false)
	PlayerCtrl:DisableMovementInput(false)
    C_GuiMgr:BackToMainInterface()
end

return SocialGui