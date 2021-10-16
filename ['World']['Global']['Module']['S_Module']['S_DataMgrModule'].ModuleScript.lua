local S_DataMgr,this = ModuleUtil.New('S_DataMgr', ServerBase)

function S_DataMgr:DataInit()
	this = self
	---获取长期存储数据库
	--this.PlayerConfig = {}
	---服务器本地
	this.allPlayerData = {}
	this.allPlayerTimeStamp = {}

	-----------------临时数值---------------------------------
	---是否处于数据清除状态
	this.clearDataTrigger = false
end

function S_DataMgr:Update()
	-- body
end

---返回玩家长期存储数据
function S_DataMgr:ReturnPlayerDataEventHandler(_player)
	---获取长期存储数据库
	local id = _player.UserId
	local callBackCode = nil
	local data  = DataStore:GetSheet("PlayerData")
	--print(data)
	
	data:GetValue(id,function(_value,_msg)
		if _msg == 0 or _msg == 101 then
			if _value then
				local json = S_DataMgr:LuaToJson(_value)
				NetUtil.Fire_C("GetDataStorgeFromServerEvent",_player,json)
				print("玩家第N次登录服务器，发送客户端数据")
			else
				this.allPlayerData[id] = {}
				print("玩家第一次登录服务器")
				NetUtil.Fire_C("GetDataStorgeFromServerEvent",_player,nil)
			end
		else
			print("获取玩家数据失败，1秒后重试", _player.Name, _msg)
			invoke(function() 
				S_DataMgr:ReturnPlayerDataEventHandler(_player)
			end,1)
		end
	end)
end

---接收玩家间歇性上传数据
function S_DataMgr:GetPlayerDataEventHandler(_player,_data,_currentTime)
	local id = _player.UserId
	--print(_data.collection[10].isFound_)
	if this.allPlayerTimeStamp[id] then
		if _currentTime > this.allPlayerTimeStamp[id]  then
			--print("最新数据存储至服务器")
			---json转lua
			local playerData = S_DataMgr:JsonToLua(_data)
			this.allPlayerData[id] = playerData
			this.allPlayerTimeStamp[id] = _currentTime
		else
			--print("数据舍弃")
		end
	else
		print("数据首次存储至服务器")
		---json转lua
		local playerData = S_DataMgr:JsonToLua(_data)
		this.allPlayerData[id] = playerData
		this.allPlayerTimeStamp[id] = _currentTime
	end
end



function S_DataMgr:OnPlayerLeaveEventHandler(_player,_uid)

	local id = _uid
	--print("服务器记录玩家退出游戏",id)
	local data = DataStore:GetSheet("PlayerData")

	--if not this.clearDataTrigger then
		if this.allPlayerData[id] then
			data:SetValue(id,this.allPlayerData[id],function(_value,_msg)
				if _msg == 0 then
					print("保存玩家数据成功",id)
					---清除服务器数据
					--ClearTable(this.allPlayerTimeStamp[id])
					--ClearTable(this.allPlayerData[id])
					--print(this.allPlayerTimeStamp[id],this.allPlayerData[id])
					this.allPlayerTimeStamp[id] = nil
					this.allPlayerData[id] = nil
				else
					print("获取玩家数据失败，1秒后重试", id, _msg)
					S_DataMgr:OnPlayerLeaveEventHandler(_player)
				end
			end)
		else
			print("没有在服务器数据总表找到该玩家的数据", id)
		end
	--else
		--print("数据清除时玩家退出不保存数据")
	--end
	
	
end

---将上传的Json转成lua
function S_DataMgr:JsonToLua(_json)
	local table = LuaJsonUtil:decode(_json)

	return table
end

---将玩家数据转成Json
function S_DataMgr:LuaToJson(_playerData)
    local luaTable = {}
    for key, value in pairs(_playerData) do
        luaTable[key] = value
    end
    local json = LuaJsonUtil:encode(luaTable)

    return json
end

---清除长期存储中玩家数据
function S_DataMgr:ClearPlayerDataEventHandler(_player)
	---获取长期存储数据库
	local id = _player.UserId
	local callBackCode = nil
	local data  = DataStore:GetSheet("PlayerData")
	--print(data)

	this.allPlayerTimeStamp[id] = nil
	this.allPlayerData[id] = nil

	data:Remove(id,function(_value,_msg)
		if _msg == 0 then
			print("清除成功")
		else
			print("清除失败",_msg)
		end
	end)

	--this.clearDataTrigger = true
end
return S_DataMgr