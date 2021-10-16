---客户端Ui管理
---author Chen Muru
local C_GuiMgr = {}
local dieGuiRun = false
function C_GuiMgr:Init()
    self.allGui = {}
    self:InitAllGui()
end

function C_GuiMgr:InitAllGui()
    local allLocalGui = localPlayer.Local:GetChildren()
    for _, v in pairs(allLocalGui) do
        local nameLen = string.len(v.Name)
        local name = string.sub(v.Name,nameLen - 2, nameLen)
        if name == "Gui" then
            self.allGui[v.Name] = v
        end
    end
end

--- 打开某一个screen gui
--- @param guiName mixed string或者table，储存screen gui的名字，e.g.{"ControlGui","ItemTestGui"}
function C_GuiMgr:OpenGui(guiName)
    for k, v in pairs(self.allGui) do
        v:SetActive(false)
    end
    if type(guiName) == "table" then
        for _, name in pairs(guiName) do
            if self.allGui[name] then
                self.allGui[name]:SetActive(true)
            end
        end
    else
        if self.allGui[guiName] then
            self.allGui[guiName]:SetActive(true)
        end
    end
end

--- 返回主界面
function C_GuiMgr:BackToMainInterface()
    -- 这里添加主界面存在的gui
	if DialogueMgr.dialogueActive and not QuestMgr.tutorialComplete then
		invoke(function()
			IntroGuiMgr:HideInterludeGui()
		end)
	else
		self:OpenGui({"ControlGui"})
	end
end

--- 玩家死亡后的过场动画
function C_GuiMgr:DieGuiController(_isOpen)
    if dieGuiRun then
        return
    end
    
    local camImgSizeY = 3900
	local camImgSizeX = 7000
	if _isOpen then
        --- 关闭背包UI
        if not dieGuiRun then
            dieGuiRun = true
            BagpackGui:CloseBtnLogic()
             --- 重置各Figure的位置
		    localPlayer.Local.DieGUI.CamImg.Size = Vector2(camImgSizeX,camImgSizeY)
		    localPlayer.Local.DieGUI:SetActive(true)
            local tweener = Tween:TweenProperty(localPlayer.Local.DieGUI.CamImg,{Size = Vector2(0,0)},1.2,Enum.EaseCurve.QuarticOut):Play()
            tweener.OnComplete:Clear()
            tweener.OnComplete:Connect(function() 
                dieGuiRun = false
            end)
        end
    else
		local tweener2 = Tween:TweenProperty(localPlayer.Local.DieGUI.CamImg,{Size = Vector2(camImgSizeX,camImgSizeY)},1.2,Enum.EaseCurve.QuarticOut)
        tweener2.OnComplete:Clear()
        tweener2.OnComplete:Connect(function() 
            --- 当玩家在死亡前打开了背包，需要多加一层UI保护
            BagpackGui:OtherPnlControl(true)
            localPlayer.Local.DieGUI:SetActive(false)   
            dieGuiRun = false
        end)
        tweener2:Play()
	end
end


return C_GuiMgr