local S_CrocodileMgr, this = ModuleUtil.New('S_CrocodileMgr',ServerBase)

function S_CrocodileMgr:Init()
    S_CrocodileMgr.playersInMarsh = {}                --- 进入沼泽的玩家列表,放ID
    S_CrocodileMgr.allCrocodile = S_Duplicate.allCreature.Crocodile
    S_CrocodileMgr.marshCube = {}
    S_CrocodileMgr:GetMarshCube()                     --- 获得沼泽地的碰撞盒
    S_CrocodileMgr:MarhsCubeCollisionConnect()        --- 给沼泽地的碰撞盒添加碰撞后事件
end

--- 获取沼泽地的碰撞盒
function S_CrocodileMgr:GetMarshCube()
    for _,v in pairs(world.Habitat.Crocodile:GetChildren()) do
        table.insert(self.marshCube,v)
    end  
end    
--- 给沼泽地的碰撞盒添加碰撞后事件
function S_CrocodileMgr:MarhsCubeCollisionConnect()
    for _,v in pairs(self.marshCube) do
        v.OnCollisionBegin:Connect(function(_hitObject) 
        self:AddPlayerInMarsh(_hitObject) 
          
        end)
        v.OnCollisionEnd:Connect(function(_hitObject) 
            self:PlayerLeaveMarsh(_hitObject) 
            
        end)
    end
end

--- 玩家进入沼泽,加入沼泽列表
function S_CrocodileMgr:AddPlayerInMarsh(_hitObject)
    if _hitObject:IsA("PlayerInstance") then
      --  print("玩家落入沼泽")
        if _hitObject.Parent.Name ~= 'NPCs' then
            if #self.playersInMarsh <= 0 then
                self.playersInMarsh[_hitObject.UserId] = _hitObject
            else
                local isInMarshTable = self:IfItemInTable(_hitObject.UserId,self.playersInMarsh)
                if not isInMarshTable then
                    self.playersInMarsh[_hitObject.UserId] = _hitObject
                end    
            end
            
            for k1,v1 in pairs(self.allCrocodile) do
                v1:ProcessEvent('PlayerInMarsh',_hitObject)
                break
            end  
        end
    end    
end     

--- 玩家离开沼泽，从沼泽列表中去除
function S_CrocodileMgr:PlayerLeaveMarsh(_hitObject)
    if _hitObject:IsA("PlayerInstance") then
        local isInMarshTable = self:IfItemInTable(_hitObject.UserId, self.playersInMarsh)
        if isInMarshTable then
            for k,v in pairs(self.playersInMarsh) do 
                if v == _hitObject then
                    self.playersInMarsh[k] = nil
                    --table.remove(self.playersInMarsh, _hitObject.UserId)
                end
            end    
            
        end    

        if #self.playersInMarsh ~= 0 then 
            for _,v1 in pairs(self.allCrocodile) do 
                for _,v2 in pairs(self.playersInMarsh) do
                    v1:ProcessEvent('PlayerInMarsh',v2)
                    break
                end    
            end
            return
        end    

        for k2,v2 in pairs(self.allCrocodile) do 
            v2:ProcessEvent('PlayerOutOfMarsh',_hitObject)
        end
    end    
end    


 

--- 查看表中是否存在某个值
function S_CrocodileMgr:IfItemInTable(_key,_table)
    local isExis = false

    if _table[_key] ~= nil then
        isExis = true
        return isExis
    end

    if _table == nil or #_table == 0 then
        print("_table 空") 
        return isExis
    end    
    if _key == nil then
        print("_itme 为空")
        return isExis
    end    

   
    
    
    
end    

return S_CrocodileMgr