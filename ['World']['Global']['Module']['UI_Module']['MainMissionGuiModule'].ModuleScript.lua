---成就ui
---author Chen Muru
local MainMissionGui, this = ModuleUtil.New('MainGui', ClientBase)

local MainMission = {}

function MainMission:Initialize(name,index)
	self.name = name
	self.index = index
	self.iconInAllMission = MainMissionGui.allMissionPnl[name]
	self.singleMissionBg = MainMissionGui.allSingleMission[name]
	self.missionHintText = self.singleMissionBg.MissionHint.MissionHint
	self.progHint = self.singleMissionBg.ProgHint
	self.maxStage = GetTableLength(Config.MainMission[self.name])
	self.allCircleIcon = {}
	self.allProgHint = {}
	self.allReward = {}
	self.allStampIcon = {}
	self.oldStage = 1
	self.showMissionMsg = false
	self:InitIcon()
	self:InitText()
	self:BindBtnEventCallback()
	--self:InitGetRewardTweener()
end

function MainMission:InitText()
	local missionConfig = Config.MainMission[self.name][1]
	self.missionInfoConfig = missionConfig
	self.title = self.iconInAllMission.Title.Text
	for k, v in pairs(self.allProgHint) do
		v.TotalProg.Text = tostring(Config.MainMission[self.name][k].TotalProg)
	end
	for k, v in pairs(self.allReward) do
		v.ExploreCoinTxt.Text = "+"..tostring(Config.MainMission[self.name][k].RewardExploreCoin)
	end
end

local oldShowGetExploreBtnSize

function MainMission:InitGetRewardTweener()
	local progHint = self.progHint
	local oldProgHintSize = Vector2(progHint.Size.x,progHint.Size.y)
	local showGetExploreBtn = self.showGetExploreBtn
	oldShowGetExploreBtnSize = Vector2(showGetExploreBtn.Size.x,showGetExploreBtn.Size.y)
	local getExploreBtn = self.getExploreBtn
	local oldGetExploreBtnSize = Vector2(getExploreBtn.Size.x,getExploreBtn.Size.y)
	local linear = Enum.EaseCurve.Linear
	local backInOut = Enum.EaseCurve.BackInOut
	local time = 0.2
	self.showGetExploreBtnShrinkTweener = Tween:TweenProperty(showGetExploreBtn,{Size = 0.01 * oldShowGetExploreBtnSize},time,linear)
	self.getExploreBtnEnlargeTweener = Tween:TweenProperty(getExploreBtn,{Size = oldGetExploreBtnSize},time,backInOut)
	self.getExploreBtnShrinkTweener = Tween:TweenProperty(getExploreBtn,{Size = 0.01 * oldGetExploreBtnSize},time,linear)
	self.progHintEnlargeTweener = Tween:TweenProperty(progHint,{Size = oldProgHintSize},time,backInOut)
	self.showGetExploreBtnEnlargeTweener = Tween:TweenProperty(showGetExploreBtn,{Size = oldShowGetExploreBtnSize},time,backInOut)
	self.showGetExploreBtnShrinkTweener.OnPlay:Connect(function()
		showGetExploreBtn.Size = oldShowGetExploreBtnSize
		showGetExploreBtn:SetActive(true)
	end)
	self.showGetExploreBtnShrinkTweener.OnComplete:Connect(function()
		showGetExploreBtn:SetActive(false)
		getExploreBtn.Size = 0.01 * oldGetExploreBtnSize
		getExploreBtn:SetActive(true)
		self.getExploreBtnEnlargeTweener:Play()
	end)
	self.getExploreBtnEnlargeTweener.OnComplete:Connect(function()
		progHint.Size = 0.001 * oldProgHintSize
		for _, v in pairs(progHint:GetChildren()) do
			v:SetActive(false)
		end
		self:UpdateStageGui()
		C_MainMission:GetMissionReward(self.name)
		C_TimeMgr:AddDelayTimeEvent(1000,function() self.getExploreBtnShrinkTweener:Play() end)
	end)
	self.getExploreBtnShrinkTweener.OnComplete:Connect(function()
		getExploreBtn:SetActive(false)
		progHint:SetActive(true)
		if self:CheckIfCanUpdateStageGui() then
			self.showGetExploreBtnEnlargeTweener:Play()
		else
			self.progHintEnlargeTweener:Play()
		end
	end)
	self.progHintEnlargeTweener.OnComplete:Connect(function()
		for _, v in pairs(progHint:GetChildren()) do
			v:SetActive(true)
		end
	end)
end

function MainMission:InitIcon()
	local singleMissionBg = self.singleMissionBg
	for ii = 1, self.maxStage, 1 do
		local index = tostring(ii)
		self.allCircleIcon[ii] = singleMissionBg.AllCircleIcon["CircleIcon"..index]
		self.allProgHint[ii] = singleMissionBg.ProgHint["ProgHint"..index]
		self.allProgHint[ii]:SetActive(false)
		self.allStampIcon[ii] = singleMissionBg.AllStampIcon["StampIcon"..index]
		self.allReward[ii] = singleMissionBg.Reward["Reward"..index]
	end
end

function MainMission:BindBtnEventCallback()
	self.iconInAllMission.OnClick:Connect(function()
		AudioUtil:Play(localPlayer.Local.Sfx.Click)
		OpenSingleMission(self)
		---region 数据埋点 一川
		MainMissionGui:EventTrackingForOpenSecondary(self.name)
		---endregion
	end)
	for ii, v in pairs(self.allReward) do
		v.GetRewardBtn.OnClick:Connect(function()
			AudioUtil:Play(localPlayer.Local.Sfx.GetExploreCoin)
			v:SetActive(false)
			self.allStampIcon[ii]:SetActive(false)
			self:UpdateStageGui()
			C_MainMission:GetMissionReward(self.name)
		end)
	end
end

function OpenSingleMission(self)
	self:ShowSingleMission(true)
	MainMissionGui:SetCurMainMissionGui(self.name,self.index)
end

function MainMission:ShowSingleMission(_val)
	MainMissionGui.singleMissionBg:SetActive(_val)
	self.singleMissionBg:SetActive(_val)
	--if _val then
	--	if C_MainMission:CompareProgData(self.name) then
	--		self:ShowGetReward()
	--	end
	--end
end

function MainMission:CloseSingleMission()
	self.singleMissionBg:SetActive(false)
end

function MainMission:ShowGetReward()
	self.showGetExploreBtn:SetActive(true)
	self.showGetExploreBtn.Size = oldShowGetExploreBtnSize
end

function MainMission:Run()
end

function MainMission:InitProgGui()
	local stage = C_MainMission:GetMissionStage(self.name)
	local curProg, rewardCoin, totalProg = C_MainMission:GetMainMissionData(self.name)
	self:UpdateMissionDataGui(curProg, rewardCoin, totalProg)
	self.oldStage = stage
end

function MainMission:UpdateStageGui()
	if not C_MainMission:CompareProgData(self.name) then
		return
	end

	C_TimeMgr:AddDelayTimeEvent(100,function()
		local oldStage = self.oldStage
		local newStage = oldStage + 1
		if newStage <= self.maxStage then
			self.allCircleIcon[newStage]:SetActive(true)
		end
		self.oldStage = newStage
	end)
end

function MainMission:CheckStageEquality()
	local curStage = C_MainMission:GetMissionStage(self.name)
	if self.oldStage == curStage then
		return true
	end
	return false
end

function MainMission:CheckIfCanUpdateStageGui()
	local stage = C_MainMission:GetMissionStage(self.name)
	if C_MainMission:CompareProgData(self.name) and self.maxStage >= stage then
		return true
	end
	return false
end

function MainMission:UpdateMissionDataGui(_curProg,_rewardCoin,_totalProg)
	local stage = C_MainMission:GetMissionStage(self.name)
	local preMissionHintText = self.missionHintText.Text
	--self.missionHintText.Text = string.gsub(preMissionHintText,"${var}",tostring(_curProg))
	--self.missionHintText.Variable1 = tostring(_curProg)
	if self.maxStage >= stage then
		self.missionHintText.Variable1  = tostring(Config.MainMission[self.name][stage].TotalProg)
		self.allCircleIcon[stage]:SetActive(true)
		self.allProgHint[stage].CurProg.Text = _curProg
	else
		self.missionHintText.LocalizeKey = "ProjectDarwin_Achievement_45"
	end
	if self:CheckIfCanUpdateStageGui() then
		MainGui:SetHintActivity('openMainMission',true)
		self.allReward[stage]:SetActive(true)
		self.allProgHint[stage]:SetActive(false)
		self.allStampIcon[stage]:SetActive(true)
		if not self.iconInAllMission.RippleGuide then
			GuideSystem:RippleGuide(self.iconInAllMission, Vector2(0.5,0.55), Vector2(468, 320), OpenSingleMission, self)
		end
		if not self.showMissionMsg then
			Notice:ShowMainMissionMessage(self.title)
			self.showMissionMsg = true
			---region 数据埋点 一川
			MainMissionGui:EventTrackingForCompleteSecondary(self.name)
			---endregion
		end
	else
		MainGui:SetHintActivity('openMainMission',false)
		if self.maxStage >= stage then
			self.allProgHint[stage]:SetActive(true)
		end
	end
end

function MainMissionGui:Init()
    self.mainMissionGui = localPlayer.Local.MainMissionGui
	self.allMissionBg = self.mainMissionGui.AllMissionBg
	self.progressReward = self.allMissionBg.ProgressReward
	self.progressBar = self.allMissionBg.ProgressBarBg.ProgressBar
	self.explorePointTxt = self.mainMissionGui.ExplorePointBg.ExplorePointTxt
	self.explorePointTxt_Brown = self.mainMissionGui.ExplorePointBg.ExplorePointTxt_Brown
	self.allMissionPnl = self.allMissionBg.Bgd.AllMissionPnl
	self.singleMissionBg = self.mainMissionGui.SingleMissionBg
	self.allSingleMission = self.singleMissionBg.AllSingleMission
	self.turnLeft = self.singleMissionBg.TurnLeft
	self.turnRight = self.singleMissionBg.TurnRight
	self.backToPrev = self.mainMissionGui.BackToPrev
	self.curMainMissionGuiIndex = nil
	self.allMainMission = {}
	self:InitAllMainMission()
	self:BindBtnEventCallback()
	--C_MainMission:UpdateAllMainMissionData()
	C_MainMission:DownloadDataStorge()
	self:InitAllMainMissionProgGui()
	self:InitExploreCoin()
end

function MainMissionGui:BindBtnEventCallback()
	self.turnLeft.OnClick:Connect(function()
		AudioUtil:Play(localPlayer.Local.Sfx.Click)
		self:SwitchMissionInterface(-1)
	end)
	self.turnRight.OnClick:Connect(function()
		AudioUtil:Play(localPlayer.Local.Sfx.Click)
		self:SwitchMissionInterface(1)
	end)
	self.backToPrev.OnClick:Connect(function()
		AudioUtil:Play(localPlayer.Local.Sfx.Click)
		if self.curMainMissionGuiIndex then
			self.allMainMission[self.curMainMissionGuiIndex.name]:ShowSingleMission(false)
			self.curMainMissionGuiIndex = nil
		else
			C_GuiMgr:BackToMainInterface()
		end
	end)
end

function MainMissionGui:CreateNewMainMission(_name,_index)
	local m = {}
	setmetatable(m,{__index = MainMission})
	m:Initialize(_name,_index)
	self.allMainMission[_name] = m
end

function MainMissionGui:InitAllMainMission()
	for index, v in pairs(self.allMissionPnl:GetChildren()) do
		self:CreateNewMainMission(v.Name,index)
	end
end

function MainMissionGui:UpdateMissionDataGui(_name,...)
	local args = {...}
	self.allMainMission[_name]:UpdateMissionDataGui(table.unpack(args))
end

function MainMissionGui:SetMainMissionGuiActivity(_val)
	self.mainMissionGui:SetActive(true)
end

function MainMissionGui:SetCurMainMissionGui(name,index)
	if not name then
		self.curMainMissionGuiIndex = nil
		return
	end
	self.curMainMissionGuiIndex = {
		name = name,
		index = index,
	}
end

--- @param val int 点击左侧-1，点击右侧为1
function MainMissionGui:SwitchMissionInterface(val)
	local nextPage = self.curMainMissionGuiIndex.index + val
	local allMainMission = self.allMissionPnl:GetChildren()
	if nextPage > #allMainMission - 1 or nextPage < 1 then
		return
	end
	self.allMainMission[self.curMainMissionGuiIndex.name]:CloseSingleMission()
	local curMainMissionGui = self.allMainMission[allMainMission[nextPage].Name]
	curMainMissionGui:ShowSingleMission(true)
	self:SetCurMainMissionGui(curMainMissionGui.name,nextPage)
end

function MainMissionGui:UpdateExploreProg(val)
	self.progressBar.FillAmount = val
end

function MainMissionGui:RefrshExploreCoinRes(val)
	self.explorePointTxt.Text = val
	self.explorePointTxt_Brown.Text = val
end

--- 初始化所有进度相关gui
function MainMissionGui:InitAllMainMissionProgGui()
	for k, v in pairs(self.allMainMission) do
		v:InitProgGui()
	end
end

function MainMissionGui:InitExploreCoin()
	self:RefrshExploreCoinRes(tostring(C_MainMission:GetExploreCoin()))
end

--- 增加探索点数动画
function MainMissionGui:OnExplorePointChanged(_addingVal)
	local hint = world:CreateInstance('HintExploreCoin','HintExploreCoin',self.mainMissionGui)
	GuiUtil.OnResAddedTween(hint,_addingVal,Vector2(0.1,0.1),Vector2(0.7, 0.7))
end

---数据埋点 玩家打开成就子界面 一川
---@param _name string 成就Key
function MainMissionGui:EventTrackingForOpenSecondary(_name)
	---数据埋点 一川
	UploadLog("achievement_secondary_{".._name.."}_click","C1004",_name,C_MainMission:GetMissionStage(_name))
end

---数据埋点 玩家完成成就 一川
---@param _name string 成就Key
function MainMissionGui:EventTrackingForCompleteSecondary(_name)
	---数据埋点 一川
	UploadLog("achievement_complete_{".._name.."}_click","C1004",_name,C_MainMission:GetMissionStage(_name))
end

---数据埋点 玩家领取成就奖励 一川
---@param _name string 成就Key
---@param _stage int 子成就Key 
---@param _num int 增加的探索币
function MainMissionGui:EventTrackingForGetRewardSecondary(_name,_stage,_num)
	---数据埋点 一川
	UploadLog("achievement_get_{".._name.."}_click","C1004",_name,_stage,_num)
end
return MainMissionGui