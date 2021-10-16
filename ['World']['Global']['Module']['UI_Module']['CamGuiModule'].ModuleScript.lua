---相机ui
---author Chen Muru
local CamGui, this = ModuleUtil.New('CamGui', ClientBase)

local minSliderPosVal = 0.35
local minZoompointPutputVal = 2
local constDefAnimalCollisionGroup = 1
local constDefStatueCollisionGroup = 6
function CamGui:Init()
    self.camGui = localPlayer.Local.CamGui
    self.camBg = self.camGui.CamBg
    self.takePicBtn = self.camBg.TakePicBtn     ---快门
    self.quit = self.camBg.Quit     ---退出相机视角
    self.photoSizeFrame = self.camBg.PhotoSizeFrame
    self.openAlbumBtn = self.camBg.OpenAlbumBtn ---打开相册按钮
    self.zoomPoint = self.camBg.ZoomPoint   ---视觉上的放大缩小按钮
    self.pressedZoomPoint = self.zoomPoint.PressedBtn   ---实际的放大缩小按钮
    self.zoomOutput = self.pressedZoomPoint.Output  ---放大缩小输出值
    self.flashWhite = self.camBg.FlashWhite     ---闪光灯白色图片
    self.flashWhiteTween = self:InitFlashTween()    ---闪光灯tween动画
    self.switchSelfieCam = self.camBg.SwitchCam     ---转换自拍他拍模式按钮
    self.recognitionFrame = self.camBg.RecognitionFrame     ---识别动物框
    self.selfieFrame = self.camBg.SelfieFrame   ---自拍
    self.bPlayingRecognitionFrame = false   ---当前是否在播放识别框动画
    self.creatureNameImg = self.camBg.CreatureNameImg   ---生物名称图
    self.filter = self.camBg.Filter     --- 滤镜选择轮
    self.showPhotoBg = self.camBg.ShowPhotoBg   --- 显示照片的背景
    self.animalNameBgd = self.camBg.AnimalNameBgd   --- 动物名字后面的背景图
    self.nameTxt = self.animalNameBgd.NameTxt   --- 动物名Text
    self.photo = self.showPhotoBg.Photo --- 拍照后显示的照片
    self.photoFrame = self.showPhotoBg.PhotoFrame   --- 相框
    self.findNewCreatureAfterScan = self.showPhotoBg.FindNewCreatureAfterScan   ---发现新物种！的图片
    self.creatureNameAfterScan = self.showPhotoBg.CreatureNameAfterScan ---扫描后生物的名字
    self.openCreatureBtn = self.camBg.OpenCreatureBtn   --- 打开图鉴按钮
    self.saveImgBtn = self.showPhotoBg.SaveImgBtn   --- 保存照片按钮
    self.deleteImgBtn = self.showPhotoBg.DeleteImgBtn   --- 删除照片按钮
    self.allStar = self.showPhotoBg.Stars:GetChildren() --- 所有星星
    self.photoEstimationBgd = self.showPhotoBg.PhotoEstimationBgd   --- 评价生物的背景
    self.photoEstimationTxt = self.photoEstimationBgd.PhotoEstimationTxt   --- 照片分析txt
    self.touchFigure = self.camBg.TouchFigure   --- 触屏
    self.camAim = self.camBg.CamAim     --- 准心
    self.scanImg = self.showPhotoBg.ScanImg
    self.oldRecognitionFrameSize = CamGui.recognitionFrame.Size
    self.oldCamAimSize = self.camAim.Size
    self.inSightObjName = nil   ---在视野中的生物名称
    self.inSightObj = nil ---视野中的生物
    self.camRotDeltaVal = Vector2(0,0)  --- 手指点击触屏使相机旋转的差值
    --self:ModifyPhotoAndFrameSize()
    self:BindBtnEventCallback()
    self:InitRecognitionFrame()
    self:IntOpenCamGuiTween()
    self:InitPhotoFramePopUpTweener()
    GuiUtil.CreateSlider(Const.SliderTypeNum.Vertical,minSliderPosVal,0.85,minZoompointPutputVal,45,self.pressedZoomPoint,self.zoomPoint)
    self.camBg.PoseBgImg:SetActive(false)
    self.tmpPhoto = nil
end

--- Update函数
-- @param dt delta time 每帧时间
function CamGui:Update(dt)
    self:DetectObjInCamSight()
end

function CamGui:CamGuiSetActive(_val)
    self.camGui:SetActive(_val)
    if _val then
        CamMgr:ChangeCamera('CamCam')
        CamMgr:SetCamLookAtTarget(localPlayer)
    else
        CamMgr:ChangeCamera('GameCam')
    end
end

function CamGui:BindBtnEventCallback()
    --- 退出相机
    self.quit.OnClick:Connect(function()
		self:QuitCamGui()
    end)
    --- 按下快门
    self.takePicBtn.OnClick:Connect(function()
        AudioUtil:Play(localPlayer.Sfx.Shoot)
        self.flashWhite:SetActive(true)
        self:GetPhotoTexture()
        if self.inSightObj and self.inSightObj.CollisionGroup == constDefStatueCollisionGroup then
            Filter:CheckStatue(self.inSightObjName) 
        end
        C_TimeMgr:AddDelayTimeEvent(100,function(self) self.flashWhiteTween:Play() end,self)

        -- Modified By Chao 
        -- 自拍成就
        if CamMgr.bSelfie then 
            C_MainMission:AddCurProgress('Selfie')
        end

        ---region 数据埋点 一川
        if not QuestMgr.tutorialComplete then  
            UploadLog("tutorial_takePic_click","C1004")
        end
        ---endregion
    end)
    --- 打开相册
    self.openAlbumBtn.OnClick:Connect(function()
        AudioUtil:Play(localPlayer.Local.Sfx.Album)
        AlbumGui:SetAlbumGuiActivity(true)
        ---region 数据埋点 一川
        UploadLog("photograph_album_click","C1004")
        ---endregion
    end)
    --- 转换自拍他拍按钮
    self.switchSelfieCam.OnClick:Connect(function()
		--举起、放下相机动作	关兆辉
		if not CamMgr.bSelfie then
			MainGui:PutCamera()
		else
			MainGui:TakeCamera()
		end
	
        AudioUtil:Play(localPlayer.Local.Sfx.ChangeCamera)
        CamMgr:SwitchSelfie()
        local bSelfie = CamMgr:GetbSelfie()
        self:SetSelfiCameraGui(bSelfie)
    end)
    --- 储存照片
    self.saveImgBtn.OnClick:Connect(function()
		AudioUtil:Play(localPlayer.Local.Sfx.SavePhoto)
        self:SaveTmpPhoto()
    end)
    --- 删除照片
    self.deleteImgBtn.OnClick:Connect(function()
        AlbumGui:DeletePhoto(self.tmpPhoto)
        self:SetPhotoInterfaceActivity(false)
    end)
    self.touchFigure.OnPanEnd:Connect(function(_pos,_dist,_deltaDist,_spd)
		self.camRotDeltaVal = Vector2(0,0)
	end)
    self.touchFigure.OnPanStay:Connect(function(_pos,_dist,_deltaDist,_spd)
        self.camRotDeltaVal = _deltaDist
    end)
end

local function GetDistBetweenObj(srcPos, dstPos)
    return (srcPos - dstPos).Magnitude
end

local constDefSightRadius = 0.3
local camMinRaycastLen = 30
local originCamMinRaycast = 30
local bDetectCreature = false
function CamGui:SetCamMinDist()
    camMinRaycastLen = originCamMinRaycast * self.zoomOutput.Value * 0.8
end

function CamGui:SaveTmpPhoto()
    self:SetPhotoInterfaceActivity(false)
    local star = self.tmpPhoto.star
    if star then
        C_Collection:FindNewCreature(self.tmpPhoto.name, star)
        -- 新手教程行为
        if not QuestMgr.tutorialComplete and C_Collection.allCreature[Config.Quest[20001].ObjectiveID].isFound_ == true then
            IntroGuiMgr:ShowMask(IntroGuiMgr.maskPhoto, IntroGuiMgr.maskAlpha, IntroGuiMgr.fadeDuration)
			GuideSystem:RippleGuide(self.quit, Vector2(0.5,0.5))
			self.quit.RippleGuide.CloseBtn:SetActive(false)
            
            ---region 数据埋点 一川
            UploadLog("tutorial_save_click","C1004")
            ---endregion 
           
        end
    else
        ---region 数据埋点 一川
        if QuestMgr.tutorialComplete then
            ---其他照片埋点
            UploadLog("photograph_scenery_click","C1004",C_PlayerDataMgr:GetSkyPeriod(),C_PlayerDataMgr:GetPlayerPos())
        end
        ---endregion
    end
    self.tmpPhoto:UploadTexture()
    self.tmpPhoto = nil
end

function CamGui:QuitCamGui()
	PlayerCtrl:DisableMovementInput(false)
	---播放放下相机动作 关兆辉
	if not CamMgr.bSelfie then
		MainGui:PutCamera()
	end

	---红点提示 一川
	CollectionGui:IsShowNotification()

	AudioUtil:Play(localPlayer.Local.Sfx.CloseCamera)
	if CutsceneMgr.cutsceneActive and not QuestMgr.tutorialComplete then
		CamMgr:ChangeCamera('CutsceneCam')
	else
		CamMgr:ChangeCamera('GameCam')
	end
	C_GuiMgr:BackToMainInterface()
	GuideSystem:DestroyRipple(self.quit)
	self:ResetCamGui()
	---region 数据埋点 一川
	if not QuestMgr.tutorialComplete then
		if C_Collection.allCreature[Config.Quest[20001].ObjectiveID].isFound_ == true then
			UploadLog("tutorial_camera_successBack_click","C1004")
		else
			UploadLog("tutorial_camera_failBack_click","C1004")
		end
	end
	---endregion
	self.showPhotoBg:SetActive(false)
end

function CamGui:ResetInSightObj()
    self.inSightObjName = nil
    self.inSightObj = nil
end

function CamGui:RestoreCamGuiWhenNotFindCreature()
    local oldAimSize = self.oldCamAimSize
    self.camAim.Size = Vector2(oldAimSize.x,oldAimSize.y)
    self.camAim.Color = Color(255,255,255)
    self.nameTxt.Text = " "
    self.photoEstimationTxt.Text = " "
    self.animalNameBgd:SetActive(false)
    --self.inSightObjName = nil
    --self.inSightObj = nil
    bDetectCreature = false
    self:PlayRecognitionFrameShrinkTween()
end

local maxSpd = 25
--- 检测视野中的生物
function CamGui:DetectObjInCamSight()
    if not self.camGui.ActiveSelf then
        return
    end
    if self.showPhotoBg.ActiveSelf or self.flashWhite.ActiveSelf then
        return
    end
    if CamMgr:GetbSelfie() then
        self:RestoreCamGuiWhenNotFindCreature()
        self:ResetInSightObj()
        return
    end
    self:SetCamMinDist()
    local deviceFormat = world:GetDevicePlatform()
    if deviceFormat == Enum.Platform.Windows then
        local dMouseClickValX,dMouseClickValY = CamMgr:GetMouseClickDifVal()
        if math.abs(dMouseClickValX) > maxSpd or math.abs(dMouseClickValY) > maxSpd then
            self:RestoreCamGuiWhenNotFindCreature()
            return
        end
    else
        if math.abs(self.camRotDeltaVal.x) > maxSpd or math.abs(self.camRotDeltaVal.y) > maxSpd then
            self:RestoreCamGuiWhenNotFindCreature()
            return
        end
    end
    local curCam = world.CurrentCamera
    local curCamPos = curCam.Position
    local hitResult = Physics:RaycastByGroup(curCamPos, curCamPos + curCam.Forward * camMinRaycastLen, {constDefAnimalCollisionGroup,constDefStatueCollisionGroup}, false)
    local hitObj
    self:ResetInSightObj()
    if #hitResult.HitObjectAll < 1 then
        self:RestoreCamGuiWhenNotFindCreature()
        return
    else
        hitObj = hitResult.HitObjectAll[1]
        if hitObj.CollisionGroup == constDefAnimalCollisionGroup and not isAnimalModel(hitObj) then
            self:RestoreCamGuiWhenNotFindCreature()
            return
        end
    end
    --if not bDetectCreature then
    --    C_TimeMgr:AddDelayTimeEvent(500,
    --    function() 
    --        if not bDetectCreature then 
    --            self:ResetInSightObj()
    --        end 
    --    end)
    --end
    bDetectCreature = true
    self.animalNameBgd:SetActive(true)
    if not self.bPlayingRecognitionFrame then
        self.recognitionFrameEnlargeTween:Play()
    end
    local name = hitObj.Name
    self.inSightObj = hitObj
    if name == "animatedMesh" then
        local parent = hitObj.Parent
        name = parent.Name
        self.inSightObj = parent
    end
    self.inSightObjName = name
    if self:CheckIfIsStatue(name) then
        self.nameTxt.LocalizeKey = Config.StatueLocalize[name].LocalizeKey
    else
        self.nameTxt.LocalizeKey = self:GetAnimalLocalizeKey(name)
    end
end

function isAnimalModel(_model)
    if _model.ClsName or _model.Name == "animatedMesh" then
        return true
    end
    return false
end

--- 获得放大缩小的输出值
function CamGui:GetZoomOutput()
    return self.zoomOutput.Value
end

--- 初始化闪光灯tween动画
function CamGui:InitFlashTween()
    local tweener = Tween:TweenProperty(self.flashWhite, {Alpha = 1}, 0.3, Enum.EaseCurve.CubicOut)
    tweener.OnPlay:Connect(function()
        self:HideCameraGuiContent(true)
    end)
    tweener.OnComplete:Connect(function()
        self.flashWhite.Alpha = 0 
        self.flashWhite:SetActive(false)
        self:PlayPhotoFramePopUpTweener()
    end)
    return tweener
end

--- 初始化生物识别框tween动画
function CamGui:InitRecognitionFrame()
    local recognitionFrame = self.recognitionFrame
    local oldRecognitionFrameSize = self.oldRecognitionFrameSize
    local camAim = self.camAim
    self.recognitionFrameEnlargeTween = Tween:TweenProperty(recognitionFrame, {Size = 1.2 * oldRecognitionFrameSize}, 0.3, Enum.EaseCurve.Linear)
    self.camAimEnlargeTween = Tween:TweenProperty(camAim,{Size = 2 * self.oldCamAimSize},0.3, Enum.EaseCurve.Linear)
    self.recognitionFrameEnlargeTween.OnPlay:Connect(function()
        self.bPlayingRecognitionFrame = true
        if not self.inSightObjName then
            return
        end
        local result = C_Collection:CheckIfCreatureFound(self.inSightObjName)
        self.camAimEnlargeTween:Play()
        --if not result then
            recognitionFrame.Color = Color(246,254,150)
            camAim.Color = Color(246,254,150)
        --end
    end)
    self.recognitionFrameEnlargeTween.OnComplete:Connect(function()
        self.bPlayingRecognitionFrame = false
        if not self.inSightObjName then
            return
        end
        --local result = C_Collection:CheckIfCreatureFound(self.inSightObjName)
        --self.creatureNameImg.Alpha = 1
        --self.creatureNameImg.Texture = ResourceManager.GetTexture("UI/Camera/Recognition/"..self.inSightObjName)
        --if result then
        --    self.creatureNameImg.Texture = ResourceManager.GetTexture("UI/Camera/Recognition/"..self.inSightObjName)
        --else
        --    self.creatureNameImg.Texture = ResourceManager.GetTexture("UI/Camera/Recognition/NewCreature")
        --end
    end)
    self.recognitionFrameShrinkTween = Tween:TweenProperty(recognitionFrame, {Size = oldRecognitionFrameSize}, 0.1, Enum.EaseCurve.Linear)
    self.camAimShrinkTween = Tween:TweenProperty(camAim, {Size = self.oldCamAimSize},0.1,Enum.EaseCurve.Linear)
    self.recognitionFrameShrinkTween.OnPlay:Connect(function()
        self.bPlayingRecognitionFrame = true
        self.camAimShrinkTween:Play()
        recognitionFrame.Color = Color(255,255,255)
        camAim.Color = Color(255,255,255)
        self.creatureNameImg.Alpha = 0
    end)
    self.recognitionFrameShrinkTween.OnComplete:Connect(function()
        self.bPlayingRecognitionFrame = false
    end)
end

--- 还原相机页面
function CamGui:ResetCamGui()
    self.recognitionFrameEnlargeTween:Complete()
    self.recognitionFrameShrinkTween:Complete()
    self.recognitionFrame.Size = self.oldRecognitionFrameSize
    self.recognitionFrame.Color = Color(255,255,255)
    self.creatureNameImg.Alpha = 0
    self.bPlayingRecognitionFrame = false
    self:SetSelfiCameraGui(false)
end

--- 播放识别框缩小动画
function CamGui:PlayRecognitionFrameShrinkTween()
    if not self.bPlayingRecognitionFrame and self.oldRecognitionFrameSize ~= self.recognitionFrame.Size then
        self.recognitionFrameShrinkTween:Play()
    end
end

--- 初设打开相机动画
function CamGui:IntOpenCamGuiTween()
    local time = 0.8
    local animType = Enum.EaseCurve.CubicOut
    local oldFilterAnchorsX = Vector2(self.filter.AnchorsX.x,self.filter.AnchorsX.y)
    local oldTakePicBtnAnchorsY = Vector2(self.takePicBtn.AnchorsY.x,self.takePicBtn.AnchorsY.y)
    local oldSelfiAnchorsY = Vector2(self.switchSelfieCam.AnchorsY.x,self.switchSelfieCam.AnchorsY.y)
    local oldOpenAlbumAnchorsX = Vector2(self.openAlbumBtn.AnchorsX.x,self.openAlbumBtn.AnchorsX.y)
    local oldOpenCreatureAnchorsX = Vector2(self.openCreatureBtn.AnchorsX.x,self.openCreatureBtn.AnchorsX.y)
    self.filterTweener = Tween:TweenProperty(self.filter,{AnchorsX = oldFilterAnchorsX}, time, animType)
    self.openAlbumBtnTweener = Tween:TweenProperty(self.openAlbumBtn,{AnchorsX = oldOpenAlbumAnchorsX}, time, animType)
    self.takePicBtnTweener = Tween:TweenProperty(self.takePicBtn,{AnchorsY = oldTakePicBtnAnchorsY}, time, animType)
    self.switchSelfieTweener = Tween:TweenProperty(self.switchSelfieCam,{AnchorsY = oldSelfiAnchorsY}, time, animType)
    self.openCreatureTweener = Tween:TweenProperty(self.openCreatureBtn,{AnchorsX = oldOpenCreatureAnchorsX}, time, animType)
    self.filterTweener.OnComplete:Connect(function()
        self.quit:SetActive(true)
    end)
end

--- 播放打开相机动画
function CamGui:PlayOpenCamGuiTween()
    self:ResetCamera()
    self.quit:SetActive(false)
    self.filter.AnchorsX = Vector2(-0.2,-0.2)
    self.openAlbumBtn.AnchorsX = Vector2(1.3,1.3)
    self.takePicBtn.AnchorsY = Vector2(-0.3,-0.3)
    self.switchSelfieCam.AnchorsY = Vector2(-0.4,-0.4)
    self.openCreatureBtn.AnchorsX = Vector2(1.3,1.3)
    self.filterTweener:Play()
    self.openAlbumBtnTweener:Play()
    self.takePicBtnTweener:Play()
    self.switchSelfieTweener:Play()
    self.openCreatureTweener:Play()
end

local oldFrameSize = nil
local oldPhotoSize = nil
--- 初始化照片弹出动画
function CamGui:InitPhotoFramePopUpTweener()
    local frameObj = self.showPhotoBg.PhotoFrame
    local photoObj = self.showPhotoBg.Photo
    oldFrameSize = Vector2(frameObj.Size.x, frameObj.Size.y)
    oldPhotoSize = Vector2(photoObj.Size.x, photoObj.Size.y)
    self.photoFrameTweener = Tween:TweenProperty(frameObj,{Size = oldFrameSize},0.8, Enum.EaseCurve.BackInOut)
    self.photoTweener = Tween:TweenProperty(photoObj,{Size = oldPhotoSize},0.8, Enum.EaseCurve.BackInOut)
    self.photoFrameTweener.OnComplete:Connect(function()
        self:PlayScanPhotoTweener()
    end)
end

function CamGui:PlayPhotoFramePopUpTweener()
    self:ResetStar()
    self.photoEstimationBgd:SetActive(false)
    local showPhotoBg = self.showPhotoBg
    showPhotoBg.PhotoFrame.Size = 0.2 * oldFrameSize
    showPhotoBg.Photo.Size = 0.2 * oldPhotoSize
    self:SetPhotoInterfaceActivity(true)
    self.photoFrameTweener:Play()
    self.photoTweener:Play()
end

local up = 0.85
local down = 0.18
local scanResult = false
--- 播放识别照片的动画
function CamGui:PlayScanPhotoTweener()
    local txt = " "
	if self.tmpPhoto then
    local name = self.tmpPhoto.name
    if self:CheckIfNotNormalPhoto() then
        txt = self.inSightObjName
        if not self:CheckIfIsStatue(name) then
            for ii = self.tmpPhoto.star, 1, -1 do
                self.allStar[ii]:SetActive(true)
            end
        end
    end
    local star = self.tmpPhoto.star
    if star and star > 1 then
        self.photoEstimationBgd:SetActive(true)
        self.photoEstimationTxt.Text = self.tmpPhoto:GetPhotoAssess()
    else
        --self.photoEstimationTxt.Text = txt
    end
	end
    self.saveImgBtn:SetActive(true)
    self.deleteImgBtn:SetActive(true)
end

--- 显示相片界面
function CamGui:SetPhotoInterfaceActivity(_val)
    local photoGui = {
        self.saveImgBtn,self.deleteImgBtn,self.creatureNameAfterScan,self.findNewCreatureAfterScan,self.scanImg
    }
    self.showPhotoBg:SetActive(_val)
    for _, v in pairs(photoGui) do
        v:SetActive(false)
    end
    self:HideCameraGuiContent(_val)
end

function CamGui:HideCameraGuiContent(_val)
    local cameraGui = {self.openCreatureBtn,self.quit,self.filter,self.takePicBtn,self.openAlbumBtn}
    local cameraGui02 = {self.recognitionFrame,self.camAim,self.creatureNameImg,}
    for _, v in pairs(cameraGui) do
        if v == self.openCreatureBtn or v == self.openAlbumBtn then
			if QuestMgr:CheckTableForValue(IntroGuiMgr.unlockedGui, 'collection') then
				v:SetActive(not _val)
			end
		else
			v:SetActive(not _val)
		end
    end
    for _, v in pairs(cameraGui02) do
        if _val == false and not CamMgr:GetbSelfie() then
            v:SetActive(true)
        else
            v:SetActive(false)
        end
    end
end

function CamGui:GetCamRotDeltaVal()
    return self.camRotDeltaVal.x, self.camRotDeltaVal.y
end

--- 获得生物的信息
function CamGui:RequestCreatureInfo(_photoId,_creature)
    local creatureName = _creature.ClsName.Value
    local id = _creature.id.Value
    NetUtil.Fire_S("GetCreatureInfoEvent",localPlayer.UserId,creatureName,id,_photoId)
end

--- 获得照片Texture回调事件
function CamGui.GetPhotoTextureCallback(_scrShot)
    local star
    local inSightObj = CamGui.inSightObj
    if inSightObj and CamGui.inSightObj.Star then
        star = inSightObj.Star.Value
    end
    CamGui.photoTexture = _scrShot
    CamGui.photo.Texture = CamGui.photoTexture
    local o = AlbumGui:CreateNewPhoto(CamGui.inSightObjName,star,_scrShot)
    CamGui.tmpPhoto = o
    if star then
        local rairty = 1
        if inSightObj.Rarity then
            rairty = inSightObj.Rarity.Value
        end
        o:GenPhotoAssess(inSightObj.ClsName.Value,rairty)
    end
end

local path = "./ScreenCapture"

--- 获得照片Texture
function CamGui:GetPhotoTexture()
    local tmp = {self.recognitionFrame,self.camAim,self.camBg,self.creatureNameImg}
    for _, v in pairs(tmp) do
        v:SetActive(false)
    end
    Notice:SetRootUiActivity(false)
    ScreenCapture.Screenshot(path, self.photoSizeFrame, CamGui.GetPhotoTextureCallback)
    C_TimeMgr:AddDelayTimeEvent(100,
    function() 
        self.camBg:SetActive(true)
        Notice:SetRootUiActivity(true)
    end)
end

--- 调整照片和相框Size
function CamGui:ModifyPhotoAndFrameSize()
    local photoFinalSize = self.photoSizeFrame.FinalSize
    local proportion = photoFinalSize.x/photoFinalSize.y
    GuiUtil.ResetGuiSizeByProportion(self.photo,proportion)
    GuiUtil.ResetSizeYByCoe(self.photoFrame,1/proportion)
    AlbumGui:SetPhotoSizeProportion(proportion)
end

function CamGui:ResetCamera()
    self.zoomPoint.AnchorsY = Vector2(minSliderPosVal,minSliderPosVal)
    self.zoomOutput.Value = minZoompointPutputVal
    CamMgr:SetbSelfie(false)
end

--- @param val boolean 是否处于自拍
function CamGui:SetSelfiCameraGui(val)
    local tmp = {self.camAim,self.recognitionFrame,self.creatureNameImg}
    for _, v in pairs(tmp) do
        v:SetActive(not val)
    end
    self.selfieFrame:SetActive(val)
    -- Added By Chao 自拍动作面板的显示
    self.camBg.PoseBgImg:SetActive(val)

    ---region 数据埋点 一川
    CamGui:CheckForSelfPhotoClick(val)
    ---endregion
end

function CamGui:ResetStar()
    for _, v in pairs(self.allStar) do
        v:SetActive(false)
    end
end

--- 检测是否为雕像
function CamGui:CheckIfIsStatue(name)
    if self.inSightObj and self.inSightObj.CollisionGroup == constDefStatueCollisionGroup then
        return true
    end
    if Config.StatueLocalize[name] then
        return true
    end
    return false
end

--- 检测是否不为风景照片
function CamGui:CheckIfNotNormalPhoto()
    local tmpPhoto = self.tmpPhoto
    if tmpPhoto then
        if tmpPhoto.name ~= "none" then
            return true
        end
    end
    return false
end

--- 获得动物localizeKey
function CamGui:GetAnimalLocalizeKey(name)
    local collectionConfig = Config.CollectionProperty
    for _, v in pairs(collectionConfig) do
        if v.keyName2 == name then
            return v.nameLocalizeKey
        end
    end
    print("[warn!!!!!]不存在该动物的localizeKey: ", name)
end

---自拍按钮 数据埋点 一川
---@param _trigger boolean 是否处于自拍状态
function CamGui:CheckForSelfPhotoClick(_trigger)
    if _trigger then
        local id = C_PlayerDataMgr:GetSkyPeriod()
        UploadLog("photograph_self_{"..tostring(id).."}_click","C1004",id)
    end
end

function CamGui:CheckIfSaveTmpPhoto()
    if self.tmpPhoto then
        self:SaveTmpPhoto()
    end
end

return CamGui