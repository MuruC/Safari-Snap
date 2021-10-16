local MiniPiano = {}

--region Move to another place later
local Lerp = function(_a, _b, _t)
    return _a + (_b - _a) * _t
end

local CamRotate = function(_player, _cam)
    _time = _time or 0
    local dir =  _cam.Position - _player.Position
    local forward = _player.Forward 
    local alpha = Vector2.Angle(Vector2(dir.x, dir.z), Vector2(forward.x, forward.z))
		
    local left = _player.Left
    if Vector3.Angle(left, dir) > 90 then
        alpha =  alpha * (-1)
    end

    invoke(function()
        local a, prea = 0, 0
        local b = alpha
        local delta = 360
        while math.abs(delta) > 1 do
            a = Lerp(a, alpha, 0.1)
            delta = a - prea
            prea = a
            _cam:CameraMoveInDegree(Vector2(delta, 0))
            wait()
        end
    end)
end 
--endregion

function MiniPiano:Use(_itemId)

    CamRotate(localPlayer, world.CurrentCamera)

    self:SetAudioFolder(_itemId)

    C_GuiMgr:OpenGui('InstrumentGui')
end

function MiniPiano:UnUse()
    -- ## 打开主界面的其他显示按钮
    BagpackGui:OtherPnlControl(true)
    C_GuiMgr:BackToMainInterface()
end

--- 设置音色
function MiniPiano:SetAudioFolder(_itemId)

    local itemName = 'Ukulele'
    if _itemId then 
       itemName = Config.ItemInfo[_itemId].ItemName
    end

    if itemName == 'Ukulele' then 
        -- 尤克里里
        InstrumentGui.AudioFolder = localPlayer.InstrumentAudio.Ukulele
    elseif itemName == 'Marimba' then 
        -- 手敲琴
        InstrumentGui.AudioFolder = localPlayer.InstrumentAudio.Marimba
    elseif itemName == 'Panpipe' then 
        -- 笛子（已废弃）
        InstrumentGui.AudioFolder = localPlayer.InstrumentAudio.Panpipe
    end
end

return MiniPiano