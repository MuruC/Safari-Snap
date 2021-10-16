local FloatingBottle = {
    totalTypes = 1,
}

--- 生成
--- @param _pos Vector3
--- @param _parent Node
function FloatingBottle:Instantiate(_pos, _parent, _archetypeName)

    --[[
    local className = 'FloatingBottle'
    local type = math.random(1, self.totalTypes)
    local archetypeName = className..type
    ]]--

    local className = 'FloatingBottle'
    local item = Item:Instantiate(_archetypeName, _pos, _parent)
    item.ClsName.Value = className
end


--- 捡起漂流瓶
--- @param _bottle Object
function FloatingBottle:PickUp(_bottle)

    -- Read
    local i = math.random(1, #Config.Message)
    local content = Config.Message[i].Content
    local localizeKey = Config.Message[i].LocalizeKey
    --SocialGui:CreateBubble(localPlayer, content, localizeKey) 
    FloatingBottleGui:Open(content, localizeKey)

    -- 成就进度 
    C_MainMission:AddCurProgress('GetDriftBottle')

    -- 音效
    AudioUtil:Play(localPlayer.Local.Sfx.OpenDriftingBottle)

    _bottle:Destroy()
end

return FloatingBottle