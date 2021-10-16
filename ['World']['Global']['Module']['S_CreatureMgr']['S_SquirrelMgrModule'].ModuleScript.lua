local S_SquirrelMgr, this = ModuleUtil.New('S_SquirrelMgr',ServerBase)

function S_SquirrelMgr:Init()
    S_SquirrelMgr.habitatCube = {}
    S_SquirrelMgr:GetHabitatCube()                     --- 获得松鼠的碰撞盒
    S_SquirrelMgr:HabitatCubeCollisionConnect()        --- 给松鼠的碰撞盒添加碰撞后事件
end
--- 获取松鼠栖息地的碰撞盒
function S_SquirrelMgr:GetHabitatCube()
    for _,v in pairs(world.Habitat.Squirrel:GetChildren()) do
        table.insert(self.habitatCube,v)
        v.hasAnimal.Value = false
    end  
end    
--- 给松鼠栖息地的碰撞盒添加碰撞后事件
function S_SquirrelMgr:HabitatCubeCollisionConnect()
    for _,v in pairs(self.habitatCube) do
        v.OnCollisionBegin:Connect(function(_hitObject,v) 
            self:OccupyHabitat(_hitObject,v) 
        end)
        v.OnCollisionEnd:Connect(function(_hitObject,v) 
            self:LeaveHabitat(_hitObject,v) 
            
        end)
    end
end

 
function  S_SquirrelMgr:OccupyHabitat(_hitObject,_habitat)
    --print("_hitObject",_hitObject)
    if _hitObject.CollisionGroup == 5 then 
        if  _hitObject.Parent ~= nil and _hitObject.Parent == 'Animal' then 
            _habitat.hasAnimal.Value = true
        end    
    end
end
function  S_SquirrelMgr:LeaveHabitat(_hitObject,_habitat)
    if _hitObject.CollisionGroup == 5 then 
        if  _hitObject.Parent ~= nil and _hitObject.Parent == 'Animal' then 
            _habitat.hasAnimal.Value = false
        end    
    end
end

return S_SquirrelMgr