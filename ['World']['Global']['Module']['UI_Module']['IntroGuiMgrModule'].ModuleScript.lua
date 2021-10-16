--- 新手引导UI模块
--- @module Intro UI Manager, Client-side
--- @copyright Lilith Games, Avatar Team
--- @author Jack Perry
local IntroGuiMgr, this = ModuleUtil.New('IntroGuiMgr', ClientBase)

--- 初始化
function IntroGuiMgr:Init()
	
	this = self

	self.maskAlpha = 175
	self.fadeDuration = 0.3

	self.controlGui = localPlayer.Local.ControlGui
	self.camGui = localPlayer.Local.CamGui
	self.collectionGui = localPlayer.Local.CollectionGui
	self.socialGui = localPlayer.Local.SocialGui

	self.maskPhoto = self.camGui.CamBg.TutorialMaskPhoto
	self.maskCollection = self.collectionGui.CollectionPanel.CollectionGui_Rainforest_Ima.TutorialMaskCollection
	self.maskCreature = self.collectionGui.CreatureBackground_Ima.TutorialMaskCreature

	self.touchFig = self.controlGui.TouchFig
	self.jumpBtn = self.controlGui.JumpBtn
	self.joystick = self.controlGui.Joystick
	self.testBtn = self.controlGui.TestBtn
	self.socialBtn = self.controlGui.SocialBtn
	self.curEquipBtn = self.controlGui.CurEquipBgImg
	self.openNewBagBtn = self.controlGui.OpenNewBagBtn
	self.shopBtn = self.controlGui.ShopBtn

	self.albumBtn = self.controlGui.AlbumBtn
	self.camBtn = self.controlGui.OpenCamBtn
	self.collectionBtn = self.controlGui.EnterCollectionGui_Btn
	self.collectionBtn_Cam = self.camGui.CamBg.OpenCreatureBtn
	self.albumBtn_Cam = self.camGui.CamBg.OpenAlbumBtn
	self.switchCamBtn = self.camGui.CamBg.SwitchCam
	self.poseBgImg = self.camGui.CamBg.PoseBgImg
	self.openFilterBtn = self.camGui.CamBg.OpenFilterBtn
	self.filterBgImg = self.camGui.CamBg.FilterBgImg
	self.collectionPanelLeft = self.collectionGui.Left_CollectionPanel_Btn
	self.collectionPanelRight = self.collectionGui.Right_CollectionPanel_Btn
	self.creaturePanelLeft = self.collectionGui.CreatureBackground_Ima.BookBackground_Ima.Previous_Btn
	self.creaturePanelRight = self.collectionGui.CreatureBackground_Ima.BookBackground_Ima.Next_Btn
	self.missionBtn = self.controlGui.OpenMainMission
	self.reactionBtn = self.socialGui.ChatBtn
	self.animationBtn = self.socialGui.SocialBtn
	self.controlGuiNodeStatus = {}
	self.controlGuiNodeClickable = {}

	--- to do: update to DataMgr / myData when possible
	self.unlockedGui = {}

	self:InitLockedGui()

end

--- 新手引导隐藏UI初始化
function IntroGuiMgr:InitLockedGui()

	if QuestMgr.tutorialComplete then
		return
	end

	--- to do: data save / update to myData
	if not(QuestMgr:CheckTableForValue(self.unlockedGui, 'camera')) then
		self.camBtn:SetActive(false)
		self.touchFig:SetActive(false)
	end
	if not(QuestMgr:CheckTableForValue(self.unlockedGui, 'collection')) then
		self.collectionBtn:SetActive(false)
		self.collectionBtn_Cam:SetActive(false)
		self.albumBtn_Cam:SetActive(false)
		self.switchCamBtn:SetActive(false)
		self.poseBgImg:SetActive(false)
		self.openFilterBtn:SetActive(false)
		self.filterBgImg:SetActive(false)
	end
	if not(QuestMgr:CheckTableForValue(self.unlockedGui, 'mission')) then
		self.missionBtn:SetActive(false)
		self.albumBtn:SetActive(false)
		self.collectionPanelLeft:SetActive(false)
		self.collectionPanelRight:SetActive(false)
		self.creaturePanelLeft:SetActive(false)
		self.creaturePanelRight:SetActive(false)
		self.jumpBtn:SetActive(false)
		self.joystick:SetActive(false)
		self.testBtn:SetActive(false)
		self.socialBtn:SetActive(false)
		self.curEquipBtn:SetActive(false)
		self.openNewBagBtn:SetActive(false)
		self.shopBtn:SetActive(false)
	end
	--if not(QuestMgr:CheckTableForValue(self.unlockedGui, 'reaction')) then self.reactionBtn:SetActive(false) end
	--if not(QuestMgr:CheckTableForValue(self.unlockedGui, 'animation')) then self.animationBtn:SetActive(false) end

end

--- 解锁某系统的UI入口
--- @param _guiName UI名字
function IntroGuiMgr:UnlockGui(_guiName)

	if QuestMgr:CheckTableForValue(self.unlockedGui, _guiName) then
		return
	end

	--- to do: add more systems (i.e. cooking, social), unlock ui animation
	if _guiName == 'camera' then
		self.camBtn:SetActive(true)
		self.touchFig:SetActive(true)
	elseif _guiName == 'collection' then
		self.collectionBtn:SetActive(true)
		self.collectionBtn_Cam:SetActive(true)
		self.albumBtn_Cam:SetActive(true)
		self.switchCamBtn:SetActive(true)
		self.openFilterBtn:SetActive(true)
	elseif _guiName == 'mission' then
		self.missionBtn:SetActive(true)
		self.albumBtn:SetActive(true)
		self.collectionPanelLeft:SetActive(true)
		self.collectionPanelRight:SetActive(true)
		self.creaturePanelLeft:SetActive(true)
		self.creaturePanelRight:SetActive(true)
		self.jumpBtn:SetActive(true)
		self.joystick:SetActive(true)
		self.socialBtn:SetActive(true)
		self.curEquipBtn:SetActive(true)
		self.openNewBagBtn:SetActive(true)
		self.shopBtn:SetActive(true and Const.TestMode)
		self.testBtn:SetActive(true and Const.TestMode)
	else
		return
	end

	table.insert(self.unlockedGui, _guiName)
	--- to do: sync data to server

end

--- 显示新手引导蒙板
--- @param _mask 蒙板UI节点
--- @param _alpha 目标透明度
--- @param _fadeDuration UI动画时长
function IntroGuiMgr:ShowMask(_mask, _alpha, _fadeDuration)


	local maskTweener = Tween:TweenProperty(_mask, {Color = Color(0,0,0,_alpha)}, _fadeDuration, Enum.EaseCurve.Linear)

	TweenController:DestroyOnComplete(maskTweener)

	_mask.Color = Color(0,0,0,0)
	_mask:SetActive(true)

	maskTweener:Play()

end


function IntroGuiMgr:ShowInterludeGui(_guiName, _mask, _ripple)

	local interludeGui = self.controlGui[_guiName]
	local maskGui = self.controlGui[_mask]
	local defaultSize = interludeGui.Size

	-- currently not strictly needed since all control gui nodes are hidden by default in IntroGuiMgr:InitLockedGui()
	-- but still used for mask nodes
	for k,v in pairs(self.controlGui:GetChildren()) do
		self.controlGuiNodeStatus[k] = v.ActiveSelf
		self.controlGuiNodeClickable[k] = v.ClassName == 'UiButtonObject' and v.Clickable or nil
		if v.ActiveSelf == true and v.Name ~= _guiName then
			if v.ClassName == 'UiButtonObject' then v.Clickable = false end
			--v:SetActive(false) -- comment out to show already unlocked buttons
		end
	end

	local buttonTweener = Tween:TweenProperty(interludeGui, {Size = defaultSize}, self.fadeDuration, Enum.EaseCurve.Linear)

	TweenController:DestroyOnComplete(buttonTweener)

	buttonTweener.OnComplete:Connect(function()

		interludeGui.Size = defaultSize

		if _ripple then
			GuideSystem:RippleGuide(interludeGui, Vector2(0.5,0.5))
			interludeGui.RippleGuide.CloseBtn:SetActive(false)
		end

		interludeGui.Clickable = true

	end)

	interludeGui.Size = defaultSize * 0.75
	interludeGui.Clickable = false
	self.controlGui:SetActive(true)

	buttonTweener:Play()
	self:ShowMask(maskGui, self.maskAlpha, self.fadeDuration)

end


function IntroGuiMgr:HideInterludeGui()

	for k, v in pairs(C_GuiMgr.allGui) do
		v:SetActive(false)
	end

	self.maskPhoto:SetActive(false)
	self.maskCollection:SetActive(false)
	self.maskCreature:SetActive(false)

	for k,v in pairs(self.controlGui:GetChildren()) do
		v:SetActive(self.controlGuiNodeStatus[k])
		if v.ClassName == 'UiButtonObject' then
			v.Clickable = self.controlGuiNodeClickable[k]
		end
	end

	DialogueMgr:ShowDialogue(QuestMgr:GetDialogueStartPoint(NpcMgr.currentNPC.ID.Value), 0)

end

return IntroGuiMgr