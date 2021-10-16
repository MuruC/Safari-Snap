local Locator = {}

local ValueMapping = function(_oldValue, _oldMin, _oldMax, _newMin, _newMax)
    
    local oldRange = _oldMax - _oldMin
    local newRange = _newMax - _newMin
    local newValue = (_oldValue - _oldMin)/oldRange * newRange + _newMin
    
    return newValue
end

function Locator:Use()
    
    local arrowAnchor = self:PositionMapping(localPlayer)
    local forward = localPlayer.Forward
    local angle = math.deg(math.atan(forward.Z, forward.X)) -90

    LocatorGui:OpenMinimap(arrowAnchor, angle)
end

function Locator:PositionMapping(_player)

    local ax = ValueMapping(_player.Position.X, -165, 150, 0, 1)
    local ay = ValueMapping(_player.Position.Z, -151, 140, 0, 1)
    
    return Vector2(ax, ay)

end

return Locator