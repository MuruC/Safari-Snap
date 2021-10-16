local AnimUtil = {}

local GetAnimationRef = function(animPath)
    local animRef = ResourceManager.GetAnimation(animPath)
    if not animRef then
        print("[warn]没有找到该动画, 路径: ",animPath)
    end
    return animRef
end

local GetCreatureAnimPath = function(creature,animName)
    if creature.archetypeName then
        return "Model/Creature/"..creature.archetypeName.."/"..animName
    else
        return "Model/Creature/"..creature.name.."/"..animName
    end
end

--- 导入动画
function AnimUtil.ImportAnim(obj,animPath)
    obj:ImportAnimation(GetAnimationRef(animPath))
end

--- 导入生物动画
function AnimUtil.CreatureImportAnim(creature,animName)

    if creature.obj.animatedMesh then
        creature.obj.animatedMesh:ImportAnimation(GetAnimationRef(GetCreatureAnimPath(creature,animName)))
    else
        if creature.obj.ImportAnimation then
            creature.obj:ImportAnimation(GetAnimationRef(GetCreatureAnimPath(creature,animName)))
        end
    end
    --if creature.name == "Reindeer" or creature.name == "Mallard" or creature.name == "Tocan" or creature.name == "Pecker" or creature.name == "Frog" or creature.name == "Butterfly" then
	--	creature.obj.animatedMesh:ImportAnimation(GetAnimationRef(GetCreatureAnimPath(creature,animName)))
	--else
    --    if creature.obj.ImportAnimation then
    --        creature.obj:ImportAnimation(GetAnimationRef(GetCreatureAnimPath(creature,animName)))
    --    end
    --end
end

--[[
---播放动画
function AnimUtil.PlayAnim(obj,animPath,layer,weight,transitionDuration,bInterrupt,bLoop,spdScale)
    local animRef = GetAnimationRef(animPath)
    layer = layer or 2
    weight = weight or 1
    transitionDuration = transitionDuration or 0.1
    if bInterrupt == nil then
        bInterrupt = true
    end
    if bLoop == nil then
        bLoop = true
    end
    spdScale = spdScale or 1
    obj:PlayAnimation(animRef, layer,weight,transitionDuration,bInterrupt,bLoop,spdScale)
end

---播放生物动画
function AnimUtil.PlayCreatureAnim(creature,animName,layer,weight,transitionDuration,bInterrupt,bLoop,spdScale)
    AnimUtil.PlayAnim(creature.obj,GetCreatureAnimPath(creature,animName),layer,weight,transitionDuration,bInterrupt,bLoop,spdScale)
end

---暂停动画
function AnimUtil.StopAnim(obj,animName,layer)
    obj:StopAnimation(animName, layer)
end

---添加触发事件
function AnimUtil.AddEvent(obj,animName,percent,handler,...)
    local tmp = obj:AddAnimationEvent(animName, percent)
    tmp:Connect(function()
        handler(...)
    end)
end
-]]

return AnimUtil