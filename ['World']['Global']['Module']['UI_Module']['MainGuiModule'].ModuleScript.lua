---主页面ui
---author Chen Muru
local MainGui, this = ModuleUtil.New('MainGui', ClientBase)

function MainGui:Init()
    self.mainGui = localPlayer.Local.ControlGui
    self.openCamBtn = self.mainGui.OpenCamBtn
    self.openMainMission = self.mainGui.OpenMainMission
    self.openAlbumBtn = self.mainGui.AlbumBtn
    self:BindBtnEventCallback()
end


--- Update函数
-- @param dt delta time 每帧时间
function MainGui:Update(dt)
end

function MainGui:BindBtnEventCallback()
    self.openCamBtn.OnClick:Connect(function()
		PlayerCtrl:DisableMovementInput()
        AudioUtil:Play(localPlayer.Local.Sfx.OpenCamera)
        C_GuiMgr:OpenGui("CamGui")
        CamGui:PlayOpenCamGuiTween()
		
		---举起相机
		MainGui:TakeCamera()
		
        CamMgr:ChangeCamera('CamCam')
        CamMgr:SetCamLookAtTarget(localPlayer)

        ---一川 波纹特效停止播放
        CollectionGui:StopClickEffect(CollectionGui.collectionGuiEnterClickEffect)
		GuideSystem:DestroyRipple(self.openCamBtn)

        ---region 数据埋点 一川
        if not QuestMgr.tutorialComplete then
            UploadLog("tutorial_photograph_click","C1004") 
        else
            UploadLog("photograph_click","C1004")
        end
        ---endregion
    end)
    self.openMainMission.OnClick:Connect(function()
        AudioUtil:Play(localPlayer.Local.Sfx.Click)
		C_GuiMgr:OpenGui("MainMissionGui")
        ---region 数据埋点 一川
        UploadLog("achievement_click","C1004")
        ---endregion
    end)

    self.openAlbumBtn.OnClick:Connect(function()
        AudioUtil:Play(localPlayer.Local.Sfx.Click)
		AlbumGui:SetAlbumGuiActivity(true)
        ---region 数据埋点 一川
        UploadLog("photograph_album_click","C1004")
        ---endregion
    end)
end

---举起并保持相机动作 关兆辉
function MainGui:TakeCamera()
	localPlayer.Avatar.Bone_R_Hand.Camera_Red:SetActive(true)
	FsmMgr.playerActCtrl.takeCameraLoop = true
	PlayerAnimMgr:Play('TakeCamera', 1, 1, 0.5, 0.1, true, false, 1)
end
---放下相机 关兆辉
function MainGui:PutCamera()
	PlayerAnimMgr:Play('PutCamera', 2, 1, 0, 0.2, true, false, 1)
	FsmMgr.playerActCtrl.takeCameraLoop = false
	localPlayer.Avatar:StopBlendSpaceNode(1)
end

function MainGui:SetMainGuiActivity(_val)
    self.mainGui:SetActive(_val)
end

function MainGui:SetHintActivity(_btnName,_val)
    self[_btnName].Hint:SetActive(_val)
end

return MainGui