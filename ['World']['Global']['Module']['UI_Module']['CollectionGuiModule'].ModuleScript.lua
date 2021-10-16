local CollectionGui = {}

function CollectionGui:Init()
    this = self
    ---图鉴ScreenGui
    this.collectionScreenGui = localPlayer.Local.CollectionGui
    ---图鉴主界面在Main的入口
    this.collectionGuiEnterBtn = localPlayer.Local.ControlGui.EnterCollectionGui_Btn
    ---图鉴入口的点击波纹特效
    this.collectionGuiEnterClickEffect = this.collectionGuiEnterBtn.ClickEffect_Ima
    ---相册Gui下的图鉴入口
    this.enterCollectionGuiByCamGui = localPlayer.Local.CamGui.CamBg.OpenCreatureBtn
    ------------------------图鉴主界面的变量命名-----------------------
    ---图鉴卷轴
    this.collectionPanel = this.collectionScreenGui.CollectionPanel
    ---图鉴主页面Gui
    this.collectionGui = this.collectionScreenGui.CollectionPanel.CollectionGui_Rainforest_Ima
    ---生态系统标题
    this.ecosystemName = this.collectionGui.EcosystemName_tex
    ---生态系统副标题
    this.ecosystemSmallTitle = this.collectionGui.EcosystemSmallTitle_tex
    ---图鉴卷轴左滑按钮
    this.collectionPanelLeftBtn = this.collectionScreenGui.Left_CollectionPanel_Btn
    ---图鉴卷轴右滑按钮
    this.collectionPanelRightBtn = this.collectionScreenGui.Right_CollectionPanel_Btn
    ---图鉴卷轴左滑按钮的波纹特效
    this.collectionPanelLeftBtnClickEffect = this.collectionPanelLeftBtn.ClickEffect_Ima
    ---图鉴卷轴右滑按钮的波纹特效
    this.collectionPanelRightBtnClickEffect = this.collectionPanelRightBtn.ClickEffect_Ima
    ---图鉴返回主UI按钮
    this.collectionPanelBackBtn = this.collectionScreenGui.Back_CollectionPanel_Btn

    ------------------------生物子界面的变量命名-----------------------
    ---生物子界面 背景图 节点路径
    this.creatureBackground = this.collectionScreenGui.CreatureBackground_Ima
    ---生物子界面 书本图
    this.creatureBook = this.creatureBackground.BookBackground_Ima
    ---生物子界面 生物名称
    this.creatureTitle = this.creatureBook.CreatureTitle_Tex
    ---生物子界面 身长数据
    this.creatureHeight = this.creatureBook.CreatureHeightTitle_Tex.CreatureHeight_Tex
    ---生物子界面 体重数据
    this.creatureWeight = this.creatureBook.CreatureWeightTitle_Tex.CreatureWeight_Tex
    ---生物子界面 栖息地
    this.creatureHabitat = this.creatureBook.CreatureHabitatTitle_Tex.CreatureHabitat_Tex
    ---生物子界面 习性
    this.creatureHabits = this.creatureBook.CreatureBiologicalHabitsTitle_Tex.CreatureBiologicalHabits_Tex
    ---生物子界面 信息图
    this.creatureInfogram = this.creatureBook.CreatureInfogram_Ima
    ---生物子界面 声音按钮
    this.creatureSound = this.creatureBook.CreatureSound_Btn
    ---生物子界面/特殊行为 返回按钮
    this.creature_Behavior_Back = this.creatureBackground.Back_Creature_Btn
    ---生物子界面 前一个 按钮
    this.creaturePreviousBtn = this.creatureBook.Previous_Btn
    ---生物子界面 后一个 按钮
    this.creatureNextBtn = this.creatureBook.Next_Btn
    ---特殊行为卷轴 背景图
    this.behaviorPanelBackground = this.creatureBackground.BehaviorPanelBackground_Ima
    ---特殊行为卷轴
    this.behaviorPanel = this.behaviorPanelBackground.BehaviorPanel
    ---特殊行为卷轴 左滑按钮
    this.behaviorPanelLeftBtn = this.behaviorPanelBackground.Left_BehaviorPanel_Btn
    ---特殊行为卷轴 右滑按钮
    this.behaviorPanelRightBtn = this.behaviorPanelBackground.Right_BehaviorPanel_Btn

    ---------------------------音效资源------------------------------
    ---通用点击音效
    this.clickSound = localPlayer.Local.Sfx.Click
    ---打开卷轴音效
    this.behaviorPanelOpenSound = localPlayer.Local.Independent.GameCam.Sfx.OpenSub_album
    ---关闭卷轴音效
    this.behaviorPanelCloseSound = localPlayer.Local.Independent.GameCam.Sfx.CloseSub_album
    ---添加照片
    this.addBehaviorPhotoSound = localPlayer.Local.Sfx.AddPhotoSuccessfully
    ---交换照片音效1
    this.changeBehaviorPhotoSound1 = localPlayer.Local.Sfx.ChoosePhoto
    ---交换照片音效2
    this.changeBehaviorPhotoSound2 = localPlayer.Local.Sfx.PutDownPhoto
    ---收集完整音效
    this.collectionCompleteSound = localPlayer.Local.Sfx.CollectionComplete
    -------------------------固定文本前缀/后缀命名--------------------
    ---按钮通用后缀
    this.btnSuffix = "_Btn"
    ---图片通用后缀
    this.imaSuffix = "_Ima"
    ---文本通用后缀
    this.texSuffix = "_Tex"
    ---图鉴主界面未发现按钮中间名
    this.collectionNotFoundWord = "_NotFound"
    ---图鉴主界面已发现按钮中间名
    this.collectionFoundWord = "_Found"
    ---图鉴主界面未发现按钮下 状态图名
    this.collectionNotFoundImaWord = "NotFound"
    ---图鉴主界面 按钮下背景框
    this.collectionAnimalBackgroundWord = "AnimalTitleBackground"
    ---图鉴主界面 按钮下收集状态图片
    this.collectionAnimalStatusWord = "AnimalStatus"
    ---图鉴主界面 按钮下收集进度图片
    this.collectionAniamlProgressWord = "_AnimalProgress"
    ---生物子界面 星级/特殊行为 前缀
    this.creatureBehaviorWord = "_Behavior"
    ---生物子界面 星星图前缀
    this.creatureStarImaWord = "star"
    ---生物子界面 相片图前缀
    this.creaturePhotoImaWord = "photo"
    ---生物子界面 默认未发现文本
    this.creatureNotFoundText = "???"
    ---特殊行为区域 相片点击状态
    this.behaviorPhotoAdd = "add"
    ---特殊行为区域 相片可插入状态
    this.behaviorPhotoAvailable = "available"
    ---特殊行为区域 相片不可点击状态
    this.behaviorPhotoUnavailable = "unavailable"
    ---特殊行为卷轴 Archetype 中间名
    this.behaviorPanelPhotoArchetypeWord = "_Album"
    ---特殊行为卷轴 相片Archetype 名字
    this.behaviorPanelPhotoArchetypeName = this.behaviorPanelPhotoArchetypeWord..this.imaSuffix
    ---提示点击 的波纹特效中间名
    this.clickEffectWord = "ClickEffect"
    ---解锁特效 中间名
    this.unlockEffectWord = "UnlockEffect"
    ---闪光特效 中间名
    this.flashEffectWord = "FlashEffect"
    ---图鉴已发现按钮 动物名字文本中间名
    this.collectionFoundBtnNameWord = "AnimalName"
    ---信息框点击按钮前置名
    this.tipInfoWord = "Tip"

    -------------------------资源市场路径----------------------------
    ---图鉴 资源根路径
    this.collectionResourceRoot = "Texture/CollectionGui/"
    ---图鉴卷轴 资源路径
    this.collectionPanelRoot = this.collectionResourceRoot.."Overview/"
    ---图鉴卷轴 背景图路径
    this.collectionPanelBackgroundRoot = this.collectionPanelRoot.."Background/"
    ---图鉴卷轴 提示点击图路径
    this.collectionPanelClickRoot = this.collectionPanelRoot.."Click/"
    ---图鉴卷轴 提示点击图 Pressed 路径
    this.collectionPanelClickPressedRoot = this.collectionPanelClickRoot.."Pressed/"
    ---图鉴卷轴 已发现图路径
    this.collectionPanelFoundRoot = this.collectionPanelRoot.."Found/"
    ---图鉴卷轴 已发现图 Pressed路径
    this.collectionPanelFoundPressedRoot = this.collectionPanelFoundRoot.."Pressed/"
    ---图鉴卷轴 未发现图路径
    this.collectionPanelNotFoundRoot = this.collectionPanelRoot.."NotFound/"
    ---图鉴卷轴 其他图路径
    this.collectionPanelInfoRoot = this.collectionPanelRoot.."Info/"

    ---生物子页面 资源路径
    this.creatureResourceRoot = this.collectionResourceRoot.."Creature/"
    ---生物子页面 背景图路径
    this.creatureBackgroundRoot = this.creatureResourceRoot.."Background/"
    ---生物子页面 星级/特殊行为区域路径
    this.creatureBehaviorRoot = this.creatureResourceRoot.."Behavior/"
    ---生物子页面 可插入操作时星星图路径
    this.creatureBehaviorAvailableRoot = this.creatureBehaviorRoot.."Available/"
    ---生物子页面 已插入时星星图路径
    this.creatureBehaviorDoneRoot = this.creatureBehaviorRoot.."Done/"
    ---生物子页面 不能操作时星星图路径
    this.creatureBehaviorUnavailableRoot = this.creatureBehaviorRoot.."Unavailable/"
    ---生物子页面 星级/特殊行为区域 状态图路径
    this.creaturePhotoRoot = this.creatureResourceRoot.."Photo/"
    ---生物子页面 生物信息图
    this.creatureInfogramRoot = this.creatureResourceRoot.."Infogram/"
    ---生物子页面 未发现的生物信息图
    this.creatureNotFoundInfogramRoot = this.creatureInfogramRoot.."NotFound/"

    ---特效 路径
    this.effectRoot = this.collectionResourceRoot.."Effect/"
    ---特效 波纹点击特效路径
    this.effectClickRoot = this.effectRoot.."Click/"
    ---特效 解锁特效路径
    this.effectUnlockRoot =  this.effectRoot.."Unlock/"
    ---特效 闪光特效路径
    this.effectFlashRoot = this.effectRoot.."Flash/"
    -------------------------临时数值命名----------------------------
    ---雨林背景图标准分辨率
    this.rainForestSize = Vector2(3840,1242)
    ---特殊行为区域 Archetype 相片背景起始AnchorsX
    this.photoBgdArchetypeAnchorsX = Vector2(0.18,0.18)
    ---特殊行为区域 Archetype 相片背景起始AnchorsY
    this.photoBgdArchetypeAnchorsY = Vector2(0.575,0.575)
    ---特殊行为区域 Archetype 相片AnhcorsX.x间隔
    this.photoBgdArchetypeClapX = 0.2

    ---特殊行为区域 Archetype 相片宽度（?）
    this.photoBgdArchetypeWidth = 0.15
    ---特殊行为区域 Archetype 相片间隔（?）
    this.photoBgdArchetypeClap = 0.05
    ---特殊行为区域 Archetype 初始状态最多显示的相片数量
    this.photoBgdArchetypeMaxNum = 4
    ---生物子界面 书本图上移Offset（?）
    this.creatureBookUpOffset = Vector2(0,0)

    ---特殊行为区域 卷轴背景图左移Offset
    this.behaviorPanelBackgroundLeftOffset = Vector2(0,0)
    ---变暗的Alpha值
    this.darkAlpha = 0.4
    ---波纹特效图片数
    this.clickEffectNum = 12
    ---解锁特效图片数
    this.unlockEffectNum = 24
    ---解锁特效的前置等待数
    this.prepareUnlockNum = 6
    ---解锁特效的前置放大耗时数
    this.UnlockBigNum = 4
    ---原本Size
    this.lockSize = Vector2(60,60)
    ---放大Size
    this.unlockBigSize = Vector2(66,66)
    ---闪光特效图片数
    this.flashEffectNum = 17
    ---特效播放1帧时间
    this.effectFrame = 0.04
    ---波纹特效播放间隔
    this.clickEffectClapNum = 15
    ---闪光特效播放间隔
    this.flashEffectClapNum = 30
    ---Panel滚动单位值
    this.panelMoveUnit = 34
    ---Panel滚动Tween
    this.panelMoveTween = nil
    ---提示点击的原来Size
    this.tipToClickStartSize = Vector2(280,280)
    ---提示点击的Tween表格
    this.tipTweenTable = {}
    for i = 1, Const.SpecialBehaviorNum do
        this.tipTweenTable[i] = {}
        this.tipTweenTable[i].negTween_ = nil
        this.tipTweenTable[i].posTween_ = nil
    end
    ---动物自动音效播放Trigger
    this.isAutoSoundPlay = false
    ---图鉴主界面移动Tween
    this.collectionPanelAutoMoveTween = nil
    ---图鉴生物文本框默认文本LocalizeKey
    this.creatureUnknownTextKey = "ProjectDarwin_IllustratedBook__Unknown"
    ---当前平台
    this.platformName = world:GetDevicePlatform()
    
    -------------------------标志Ui状态-----------------------------
    ---当前打开的图鉴Key
    this.openCreatureKey = 0
    ---当前打开的星级/行为Key
    this.openBehaviorKey = 0
    ---当前Ui层级
    this.openUiLevel = 1
    ---所有Ui层级
    this.allUiLevel = {}
    ---最近识别的生物Key
    this.recentCreatureKey = 0
    ---是否从相机Gui进入
    this.isFromCamGui = false
    ---是否可以触发按钮
    this.isCanTriggerBtn = true
    ---触碰最大滑屏速度
    this.touchSpeed = 0.1

    -------------------------初始化函数------------------------------
    ---图鉴主页面初始化
    C_Collection:InitAllCreature()

    CollectionGui:CreateNewUiLevel(1,CollectionGui.OnEnter_1,CollectionGui.OnClick_1,CollectionGui.OnExit_1)
	CollectionGui:CreateNewUiLevel(2,CollectionGui.OnEnter_2,CollectionGui.OnClick_2,CollectionGui.OnExit_2)
    CollectionGui:CreateNewUiLevel(3,CollectionGui.OnEnter_3,CollectionGui.OnClick_3,CollectionGui.OnExit_3)
	CollectionGui:CreateNewUiLevel(4,CollectionGui.OnEnter_4,CollectionGui.OnClick_4,CollectionGui.OnExit_4)

    CollectionGui:InitGui()


end

---前端Init函数汇总
function CollectionGui:InitGui()
    -----------因主界面背景图Size不确定，子节点Size自动调整
    ---图鉴主界面背景图Size确定
    CollectionGui:InitColectionBackground()
    ---图鉴主界面按钮Size/文本框大小确定
    CollectionGui:InitCreatureBtnSize()
    ---生物子界面 书本图上移Offset确定
    this.creatureBookUpOffset = Vector2(0,490)
    ---特殊行为区域 卷轴背景图左移Offset确定
    this.behaviorPanelBackgroundLeftOffset = Vector2(this.behaviorPanelBackground.FinalSize.x,0)
    this.behaviorPanelBackground.Offset = this.behaviorPanelBackgroundLeftOffset
    -------------按钮点击事件--------------------------
    CollectionGui:InitEnter_1_ClickEvent()
    CollectionGui:InitEnter_2_ClickEvent()
    CollectionGui:InitEnter_3_ClickEvent()
    CollectionGui:InitEnter_4_ClickEvent()
    CollectionGui:Init_PanelMove_ClickEvent()
    CollectionGui:Init_Panel_Event()
    CollectionGui:Init_CreatureChange_ClickEvent()
    CollectionGui:Init_CreatureSound_ClickEvent()
    -------------按钮点击事件结束----------------------
    -------------Tween动画初始化----------------------
    
    -------------红点检测----------------------------
    ---点击特效检查
    CollectionGui:IsShowNotification()
end

---面向过程
local collectionUi = {}

---@param _uiLevel int Ui层级
---@param _onEnterFunc function 进入该层级前执行的函数
---@param _onClickFunc function 进入后执行
---@param _onExitFunc function 退出该层级前执行的函数
function collectionUi:Init(_uiLevel,_onEnterFunc,_onClickFunc,_onExitFunc)
    ---UI层级记录
    self.uiLevel_ = _uiLevel
    self.onEnterFunc_ = _onEnterFunc
    self.onClickFunc_ = _onClickFunc
    self.onExitFunc_ = _onExitFunc
end

---设置Ui层级
function collectionUi:SetUiLevel(_levelNum)
    if _levelNum == this.openUiLevel then
        --print("[warn]层级相同")
        this.allUiLevel[this.openUiLevel].onExitFunc_(CollectionGui,this.allUiLevel[_levelNum].onEnterFunc_,_levelNum)
    elseif _levelNum < Const.CollectionUiLevel.MainUi or _levelNum > Const.CollectionUiLevel.MaxLevel then
        print("[error]层级超出限制")
    else
        --this.allUiLevel[this.openUiLevel].onExitFunc_(this.allUiLevel[_levelNum].onEnterFunc_,this.allUiLevel[_levelNum].onClickFunc_)
        this.allUiLevel[this.openUiLevel].onExitFunc_(CollectionGui,this.allUiLevel[_levelNum].onEnterFunc_,_levelNum)
    end
end


---创建新对象
function CollectionGui:CreateNewUiLevel(_uiLevel,_onEnterFunc,_onClickFunc,_onExitFunc)
    local c = {}
    setmetatable(c,{__index = collectionUi})
    
    c:Init(_uiLevel,_onEnterFunc,_onClickFunc,_onExitFunc)
    this.allUiLevel[_uiLevel] = c

    return c
end

--------------------------------------------------UI层级运行函数-------------------------------------------------
---进入Main层级前运行1次
function CollectionGui:OnEnter_1()
    --print("Enter Main Ui Level 1")
    ---点击特效检查
    CollectionGui:IsShowNotification()

    CollectionGui:OnClick_1()
end

---进入Main层级
function CollectionGui:OnClick_1()
    --print("Click Main Ui Level 1")
    local lastNum = this.openUiLevel
    this.openUiLevel = 1
    ---音效播放
    CollectionGui:PlaySound(this.clickSound)
    ---统一的窗口打开处理
    CollectionGui:OpenUiLevelWindows(lastNum,this.openUiLevel)
end

---退出Main层级
function CollectionGui:OnExit_1(_nextEnterFunc,_levelNum)
    --print("Exit Main Ui Level 1")
    ---波纹特效停止播放
    CollectionGui:StopClickEffect(this.collectionGuiEnterClickEffect)
    _nextEnterFunc()
end
------------------------------------------------------
---进入图鉴主界面层级前运行1次
function CollectionGui:OnEnter_2()
    --print("Enter Collection Ui Level 2")
    ---图鉴卷轴滑动按钮初始化
    CollectionGui:PanelMoveBtnShow(this.collectionPanelLeftBtn,this.collectionPanelRightBtn,this.collectionPanel)
    ---已发现生物的表现处理
    CollectionGui:CollectionSetFound()
    ---图鉴辅助移动
    CollectionGui:CollectionPanelMoveBySon()

    CollectionGui:OnClick_2()
end

---进入图鉴主界面层级
function CollectionGui:OnClick_2()
    --print("Click Collection Ui Level 2")
    local lastNum = this.openUiLevel
    this.openUiLevel = 2
    ---音效播放
    CollectionGui:PlaySound(this.clickSound)
    ---统一的窗口打开处理
    CollectionGui:OpenUiLevelWindows(lastNum,this.openUiLevel)
end

---退出图鉴主界面层级
function CollectionGui:OnExit_2(_nextEnterFunc,_levelNum)
    --print("Exit Collection Ui Level 2")
    ---重置
    CollectionGui:ResetCollectionConfig()
    
    _nextEnterFunc()
end
---------------------------------------------------------
---进入生物子界面层级前运行1次
function CollectionGui:OnEnter_3()
    --print("Enter Creature Ui Level 3")
    local c = C_Collection.allCreature[this.openCreatureKey]
    ---相册同步接口
    c:FreshPhotoNum()
    ---上半部分
    CollectionGui:ChangeInfoByCreature(c)
    ---特殊行为区域更新
    CollectionGui:ChangePhotoByCreature(c)
    ---声音按钮出现
    CollectionGui:InitSoundBtn(c)
    ---切换生物按钮
    CollectionGui:InitChangeCreatureBtn()

    ---region 数据埋点 一川
    if QuestMgr.tutorialComplete then
        UploadLog("collection_animal_{"..tostring(this.openCreatureKey).."}_click","C1004",this.openCreatureKey)
    end
    ---endregion

    CollectionGui:OnClick_3()
end

---进入生物子界面层级
function CollectionGui:OnClick_3()
    --print("Click Creature Ui Level 3")
    local lastNum = this.openUiLevel
    this.openUiLevel = 3
    ---音效播放
    --C_AudioMgr:HandbookSound(C_Collection.allCreature[this.openCreatureKey].bigKeyName_)
    CollectionGui:CreatureSoundAutoPlay(C_Collection.allCreature[this.openCreatureKey])

    ---统一的窗口打开处理
    CollectionGui:OpenUiLevelWindows(lastNum,this.openUiLevel)

end

---退出生物子界面层级
function CollectionGui:OnExit_3(_nextEnterFunc,_levelNum)
    --print("Exit Creature Ui Level 3")
    local c = C_Collection.allCreature[this.openCreatureKey]
    ---此时生物现在打开的生物，根据上一个生物状态重置有BUG
    ---全部重置（到达1、2级）
    CollectionGui:ResetCreatureConfig(c,_levelNum)
    _nextEnterFunc()
end
-------------------------------------------------------
---进入特殊行为/星级层级前运行1次
function CollectionGui:OnEnter_4()
    --print("Enter behavior Ui Level 4")
    local c = C_Collection.allCreature[this.openCreatureKey]
    ---相册同步接口
    c:FreshPhotoNum(this.openBehaviorKey)
    ---更新部分creature界面信息
    CollectionGui:ChangeDownCreatureInBehavior(c)
    ---卷轴相册 更新
    CollectionGui:ChangeBehaviorPanel(c,this.openBehaviorKey)
    ---卷轴滑动按钮初始化
    CollectionGui:PanelMoveBtnShow(this.behaviorPanelLeftBtn,this.behaviorPanelRightBtn,this.behaviorPanel)
    ---播放窗口移动Tween
    CollectionGui:MoveWindowsInBehaviorOpen()

    ---region 数据埋点 一川
    if QuestMgr.tutorialComplete then
        UploadLog("collection_behavior_{"..tostring(this.openCreatureKey).."}_click","C1004",this.openCreatureKey,this.openBehaviorKey) 
    end
    ---endregion

    CollectionGui:OnClick_4()
end

---进入特殊行为/星级层级
function CollectionGui:OnClick_4()
    --print("Click behavior Ui Level 4")
    local lastNum = this.openUiLevel
    this.openUiLevel = 4
    ---音效播放
    CollectionGui:PlaySound(this.behaviorPanelOpenSound)
    
    ---统一的窗口打开处理
    CollectionGui:OpenUiLevelWindows(lastNum,this.openUiLevel)
end

---退出特殊行为/星级层级
function CollectionGui:OnExit_4(_nextEnterFunc,_levelNum)
    --print("Exit behavior Ui Level 4")
    local c = C_Collection.allCreature[this.openCreatureKey]
    CollectionGui:ResetBehaviorConfig(c,_levelNum)
    ---音效播放
    CollectionGui:PlaySound(this.behaviorPanelCloseSound)
    _nextEnterFunc()
end

-------------------------------------------------------UI层级结束------------------------------------------------------------

---按钮点击事件 进入1级界面（MainGui）
function CollectionGui:InitEnter_1_ClickEvent()
    ---从Collection 2级 入口
    this.collectionPanelBackBtn.OnClick:Connect(
        function ()
            this.allUiLevel[2]:SetUiLevel(1)

            ---region 数据埋点 一川
            if not QuestMgr.tutorialComplete then
                UploadLog("tutorial_collection_failBack_click","C1004")
            end
            ---endregion

        end
    )
end

---按钮点击事件 进入2级界面（Collection）
function CollectionGui:InitEnter_2_ClickEvent()
    ---从Main 1级 入口
    this.collectionGuiEnterBtn.OnClick:Connect(
        function ()
            this.allUiLevel[1]:SetUiLevel(2)
			---新手引导时的特殊处理
			if not QuestMgr.tutorialComplete then
				IntroGuiMgr:ShowMask(IntroGuiMgr.maskCollection, IntroGuiMgr.maskAlpha, IntroGuiMgr.fadeDuration)
                
                ---region 数据埋点 一川
                UploadLog("tutorial_collection_click","C1004")
                ---endregion
            else
                ---region 数据埋点 一川
                UploadLog("collection_click","C1004")
                ---endregion
            end
        end
    )

    ---从Creature 3级 入口
    this.creature_Behavior_Back.OnClick:Connect(
        function ()
            --[[
            ---从三级入口
            if this.openUiLevel == 3 and not this.isFromCamGui then
                this.allUiLevel[3]:SetUiLevel(2)
            elseif this.openUiLevel == 3 and this.isFromCamGui then
                ---相机入口的统一处理
                this.allUiLevel[3]:SetUiLevel(1)
            elseif this.openUiLevel == 3 and not QuestMgr.tutorialComplete then
                ---新手引导时的特殊处理
                this.allUiLevel[3]:SetUiLevel(1)
            end
            --]]

            if this.openUiLevel == 3 then
                if this.isFromCamGui or not QuestMgr.tutorialComplete then
                    ---新手引导时的特殊处理/相机入口的统一处理
                    this.allUiLevel[3]:SetUiLevel(1)
                else
                    this.allUiLevel[3]:SetUiLevel(2)
                end
            end

			GuideSystem:DestroyRipple(this.creature_Behavior_Back)

            ---region 数据埋点 一川
            if not QuestMgr.tutorialComplete then
                if CollectionGui:CheckForTutorialComplete() then
                    UploadLog("tutorial_collection_sucessBack_click","C1004")
                else
                    UploadLog("tutorial_collection_failBack_click","C1004")
                end 
            end
            ---endregion
        end
    )

    ---从相机出口的特殊处理
    this.enterCollectionGuiByCamGui.OnClick:Connect(
        function ()
            this.isFromCamGui = true
            if this.recentCreatureKey ~= 0 then
                this.openCreatureKey = this.recentCreatureKey
                this.allUiLevel[1]:SetUiLevel(3)
            else
                this.allUiLevel[1]:SetUiLevel(2)
            end
            
            ---region 数据埋点 一川 
            UploadLog("photograph_collection_click","C1004")
            ---endregion
        end
    )
end

---按钮点击事件 进入3级界面（Creature）
function CollectionGui:InitEnter_3_ClickEvent()
    --[[
    this.collectionGui.OnPanBegin:Connect(
        function ()
            Notice:ShowMessage("Collection start")
        end
    )
    this.collectionGui.OnPanEnd:Connect(
        function (_position,_panDistance,deltaDistance,_panSpeed)
            Notice:ShowMessage("Collection end")
            print(_position,_panDistance,deltaDistance,_panSpeed)
        end
    )
    --]]
    ---从Collection 2级 入口
    for key, value in pairs(C_Collection.allCreature) do
        local notFoundBtn = CollectionGui:ConfirmCollectionBtn(key,false)
        local foundBtn = CollectionGui:ConfirmCollectionBtn(key,true)

        ---处理统一开启函数

        local func = function ()   
            this.openCreatureKey = key
            this.isAutoSoundPlay = true
            this.allUiLevel[2]:SetUiLevel(3)
        end

        if this.platformName == Enum.Platform.Windows then
            ---未发现按钮 事件
            if notFoundBtn then
                notFoundBtn.OnClick:Connect(
                    function ()                    
                        func()                       
                    end
                )

                ---重复事件 
                local notFoundTipBtn = CollectionGui:ConfirmCollectionNotFoundBtnObj(notFoundBtn,Const.CollectionNotFoundBtnKey.TipBtn)
                notFoundTipBtn.OnClick:Connect(
                    function ()       
                        func()
                    end
                )
            end

            ---已发现按钮事件
            if foundBtn then
                foundBtn.OnClick:Connect(
                    function ()
                        func()
                        ---region 数据埋点 一川
                        if not QuestMgr.tutorialComplete then                        
                            UploadLog("tutorial_creature_click","C1004")
                        end
                        ---endregion
                    end
                )
                

                local foundTipBtn = CollectionGui:ConfirmCollectionFoundBtnObj(foundBtn,Const.CollectionFoundBtnKey.TipBtn)
                foundTipBtn.OnClick:Connect(
                    function ()
                        func()
                        if not QuestMgr.tutorialComplete then
                            ---region 数据埋点 一川
                            UploadLog("tutorial_creature_click","C1004")
                            ---endregion
                        end
                    end
                )
            end    

        else
            ---(苹果需要特殊处理？)
            ---未发现按钮 事件
            if notFoundBtn then
                notFoundBtn.OnPanEnd:Connect(
                    function (_position,_panDistance,deltaDistance,_panSpeed)
                        --Notice:ShowMessage("Not Found end")
                        --print(_position,_panDistance,deltaDistance,_panSpeed)
                        if _panSpeed <= this.touchSpeed then
                            func()
                        end
                    end
                )

                ---重复事件 
                local notFoundTipBtn = CollectionGui:ConfirmCollectionNotFoundBtnObj(notFoundBtn,Const.CollectionNotFoundBtnKey.TipBtn)
                notFoundTipBtn.OnPanEnd:Connect(
                    function (_position,_panDistance,deltaDistance,_panSpeed)
                        if _panSpeed <= this.touchSpeed then
                            func()
                        end
                    end
                )
            end

            ---已发现按钮事件
            if foundBtn then
                foundBtn.OnPanEnd:Connect(
                    function (_position,_panDistance,deltaDistance,_panSpeed)
                        if _panSpeed <= this.touchSpeed then

                            func()

                            ---region 数据埋点 一川
                            if not QuestMgr.tutorialComplete then                        
                                UploadLog("tutorial_creature_click","C1004")
                            end
                            ---endregion
                        end
                    end
                )
                

                local foundTipBtn = CollectionGui:ConfirmCollectionFoundBtnObj(foundBtn,Const.CollectionFoundBtnKey.TipBtn)
                foundTipBtn.OnPanEnd:Connect(
                    function (_position,_panDistance,deltaDistance,_panSpeed)
                        if _panSpeed <= this.touchSpeed then

                            func()

                            if not QuestMgr.tutorialComplete then
                                ---region 数据埋点 一川
                                UploadLog("tutorial_creature_click","C1004")
                                ---endregion
                            end
                        end
                    end
                )
            end
        end
    end

    ---从 Behavior 4级 入口
    this.creature_Behavior_Back.OnClick:Connect(
        function ()
            if this.openUiLevel == 4 then
                this.allUiLevel[4]:SetUiLevel(3)
                this.openBehaviorKey = 0

                ---region 数据埋点 一川
                if not QuestMgr.tutorialComplete then    
                    UploadLog("tutorial_behavior_failBack_click","C1004") 
                end
                ---endregion
            end
        end
    )

    ---从 Behavior 滑动区域入口
    ---
end

--按钮点击事件 进入4级界面（Behavior）
function CollectionGui:InitEnter_4_ClickEvent()
    --- 从 creature 3级 入口
    for i = 1, Const.SpecialBehaviorNum do
        local btn = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Btn)
        btn.OnClick:Connect(
            function ()
                local lastNum = this.openBehaviorKey
                this.openBehaviorKey = i
                if lastNum == 0 then
                    ---从上级Ui进入
                    this.allUiLevel[3]:SetUiLevel(4)

                    ---region 数据埋点 一川
                    if not QuestMgr.tutorialComplete then                       
                        UploadLog("tutorial_behavior_click","C1004")                       
                    end
                    ---endregion
                elseif lastNum == this.openBehaviorKey then
                    ---点击相同按钮两次时，第二次返回
                    this.allUiLevel[4]:SetUiLevel(3)
                    this.openBehaviorKey = 0

                    ---region 数据埋点 一川
                    if not QuestMgr.tutorialComplete then
                        UploadLog("tutorial_behavior_failBack_click","C1004")                       
                    end
                    ---endregion
                else
                    ---点击其他区域，不改变层级
                    this.allUiLevel[4]:SetUiLevel(4)
                end
            end
        )
    end
end

---按钮点击事件 卷轴滑动按钮
function CollectionGui:Init_PanelMove_ClickEvent()
    ---图鉴主界面左滑动按钮
    this.collectionPanelLeftBtn.OnClick:Connect(
        function ()
            CollectionGui:DestroyTween(this.collectionPanelAutoMoveTween)
            CollectionGui:PanelMoveByClickBtn(this.collectionPanelLeftBtn,this.collectionPanelRightBtn,this.panelMoveTween,this.collectionPanel,false)
        end
    )

    ---图鉴卷轴右滑按钮
    this.collectionPanelRightBtn.OnClick:Connect(
        function ()
            CollectionGui:DestroyTween(this.collectionPanelAutoMoveTween)
            CollectionGui:PanelMoveByClickBtn(this.collectionPanelLeftBtn,this.collectionPanelRightBtn,this.panelMoveTween,this.collectionPanel,true)
        end
    )

    ---按钮点击事件 特殊行为区域卷轴 左滑动按钮
    this.behaviorPanelLeftBtn.OnClick:Connect(
        function ()
            CollectionGui:PanelMoveByClickBtn(this.behaviorPanelLeftBtn,this.behaviorPanelRightBtn,this.panelMoveTween,this.behaviorPanel,false)
        end
    )

    ---特殊行为区域卷轴 右滑动按钮
    this.behaviorPanelRightBtn.OnClick:Connect(
        function ()
            CollectionGui:PanelMoveByClickBtn(this.behaviorPanelLeftBtn,this.behaviorPanelRightBtn,this.panelMoveTween,this.behaviorPanel,true)
        end
    )
end

--- 卷轴
function CollectionGui:Init_Panel_Event()

    this.collectionPanel.OnScrollBegin:Connect(
        function ()
            CollectionGui:DestroyTween(this.collectionPanelAutoMoveTween)
        end
    )

    this.collectionPanel.OnScrollEnd:Connect(
        function ()

            CollectionGui:CollectionPanelMoveBtnChange()
            
            CollectionGui:LeftAndRightMoveBtnShowTip()
        end
    )

    this.behaviorPanel.OnScrollEnd:Connect(
        function ()
            local Scale = this.behaviorPanel.ScrollScale
            local leftBtn = this.behaviorPanelLeftBtn
            local rightBtn = this.behaviorPanelRightBtn
            if Scale == 0 then
                leftBtn.Alpha = this.darkAlpha
                leftBtn.Clickable = false
                rightBtn.Alpha = 1
                rightBtn.Clickable = true
            elseif Scale == 100 then
                rightBtn.Alpha = this.darkAlpha
                rightBtn.Clickable = false 
                leftBtn.Alpha = 1
                leftBtn.Clickable = true
            else
                leftBtn.Alpha = 1
                leftBtn.Clickable = true
                rightBtn.Alpha = 1
                rightBtn.Clickable = true 
            end
        end
    )
end

---触控设备长按事件(卷轴)

---切换生物种类
function CollectionGui:Init_CreatureChange_ClickEvent()
    ---从creature 三级 入口
    this.creaturePreviousBtn.OnClick:Connect(
        function ()
            local oldIndex = C_Collection.allCreature[this.openCreatureKey].collectionIndex_
            local previous = C_Collection:RetureTypeByCollectionIndex(oldIndex - 1)
            if previous then
                this.openCreatureKey = previous.type_
                this.allUiLevel[3]:SetUiLevel(3)
            end
        end
    )

    this.creatureNextBtn.OnClick:Connect(
        function ()
            local oldIndex = C_Collection.allCreature[this.openCreatureKey].collectionIndex_
            local next = C_Collection:RetureTypeByCollectionIndex(oldIndex + 1)
            if next then
                this.openCreatureKey = next.type_
                this.allUiLevel[3]:SetUiLevel(3)
            end
        end
    )
end

---声音按钮
function CollectionGui:Init_CreatureSound_ClickEvent()
    this.creatureSound.OnClick:Connect(
        function ()
            ---音效播放
            C_AudioMgr:HandbookSound(C_Collection.allCreature[this.openCreatureKey].bigKeyName_)
        end
    )
end
--------------------------------------------以上为逻辑层-------------------------------------------------

--------------------------------------------以下为表现层-------------------------------------------------
---根据图鉴卷轴的FinalSize确定背景图SizeY，根据比例得到SizeX，接着确定偏移量，使图鉴背景图校准卷轴
function CollectionGui:InitColectionBackground()
    local finalSize = this.collectionPanel.FinalSize
    local x = (finalSize.y / this.rainForestSize.y) * this.rainForestSize.x
    ---防止漏图  
    if x <= finalSize.x then
        x = finalSize.x
    end
    this.collectionGui.Size = Vector2(x,finalSize.y)
    --print(this.collectionGui.Size)

    ---偏移
    local offsetX = 0.5 * this.collectionGui.Size.x - 0.5 * finalSize.x
    --print(offsetX)
    this.collectionGui.Offset = Vector2(offsetX,0)

    ---Panel长度确定
    this.collectionPanel.ScrollRange = x
end

---根据生物key，确定图鉴主界面按钮路径
---@param _type int 生物Key
---@param _isFound boolean 是否是已发现按钮
function CollectionGui:ConfirmCollectionBtn(_type,_isFound)
    if _isFound then
        ---返回已发现按钮
        local foundName = tostring(_type)..this.collectionFoundWord..this.btnSuffix
        local foundBtn = this.collectionGui:GetChild(foundName)
        return foundBtn
    else
        ---返回未发现按钮
        local notFoundName = tostring(_type)..this.collectionNotFoundWord..this.btnSuffix
        local notFoundBtn = this.collectionGui:GetChild(notFoundName)
        
        return notFoundBtn
    end
end

---根据特殊行为/星级key，确定生物子界面特殊区域组件
---@param _behaviorKey int 特殊行为/星级Key
---@param _objectKey int 组件数字key 见（Const.SpecialBehaviorObjectKey）
function CollectionGui:ConfirmBehaviorObj(_behaviorKey,_objectKey)

    local name = tostring(_behaviorKey)..this.creatureBehaviorWord..this.imaSuffix
    local obj = this.creatureBook:GetChild(name)

    if _objectKey == Const.SpecialBehaviorObjectKey.Background then
        ---获得背景图
        return obj
    elseif _objectKey == Const.SpecialBehaviorObjectKey.Photo then
        ---获得相片
        local photo = obj:GetChild(this.creaturePhotoImaWord..this.imaSuffix)

        return photo
    elseif _objectKey == Const.SpecialBehaviorObjectKey.Star then
        ---获得星星图
        local star = obj:GetChild(this.creatureStarImaWord..this.imaSuffix)

        return star
    elseif _objectKey == Const.SpecialBehaviorObjectKey.Btn then
        ---获得点击按钮
        local btn = obj:GetChild(tostring(_behaviorKey)..this.creatureBehaviorWord..this.btnSuffix)
        
        return btn
    end
end


---根据图鉴背景图放缩倍数，调整动物图片大小
function CollectionGui:InitCreatureBtnSize()
    ---确认背景图X\Y比例
    local finalSize = this.collectionGui.Size
    local xTimes = finalSize.x / this.rainForestSize.x
    local yTimes = finalSize.y / this.rainForestSize.y

    for key, value in pairs(C_Collection.allCreature) do
        local notFoundBtn = CollectionGui:ConfirmCollectionBtn(key,false)
        local foundBtn = CollectionGui:ConfirmCollectionBtn(key,true)
        if notFoundBtn then
            local notFoundSize = notFoundBtn.Size
            notFoundBtn.Size = Vector2(notFoundSize.x * xTimes,notFoundSize.y * yTimes)
           
        end
        
        if foundBtn then
            local foundSize = foundBtn.Size
            foundBtn.Size = Vector2(foundSize.x * xTimes,foundSize.y * yTimes)
            
        end
    end

    local titleSize = this.ecosystemName.Size
    local smallTitleSize = this.ecosystemSmallTitle.Size
    this.ecosystemName.Size = Vector2(titleSize.x * xTimes,titleSize.y * yTimes)
    this.ecosystemSmallTitle.Size = Vector2(smallTitleSize.x * xTimes,smallTitleSize.y * yTimes)
end

---进入MainGui前，检查是否需要显示红点提示/需要点击的表现
function CollectionGui:IsShowNotification()
    local trigger = C_Collection:IsShowNotification()
    if trigger and not this.isFromCamGui then
        ---播放点击特效
        --print("播放点击特效")
        this.collectionGuiEnterClickEffect:SetActive(true)
        CollectionGui:PlayClickEffect(this.collectionGuiEnterClickEffect)
        --this.collectionRedPoint:SetActive(true)
    else
        --this.collectionRedPoint:SetActive(false)
        this.collectionGuiEnterClickEffect:SetActive(false)
        --print("无点击特效")
    end
end


---进入CollectionGui前，检查是否是已发现生物,对表现方式进行处理
function CollectionGui:CollectionSetFound()
    for key, value in ipairs(C_Collection.allCreature) do
        if value.isFound_ then
            ---按钮配置
            CollectionGui:ConfirmCollectionBtn(key,false):SetActive(false)
            local btn = CollectionGui:ConfirmCollectionBtn(key,true)
            btn:SetActive(true)
            if value:CreatureInCollectionIsShow() then
                ---有可插入的照片
                CollectionGui:ChangeFoundCreaturePeform(btn,key,Const.CreaturePhotoStatus.Click)
            elseif value:GetStickPhotoNum() == 4 then
                ---收集完整
                CollectionGui:ChangeFoundCreaturePeform(btn,key,Const.CreaturePhotoStatus.Done)
            elseif value:GetStickPhotoNum() < 4 and not value:CreatureInCollectionIsShow() then
                ---未收集完整且没有可插入照片
                CollectionGui:ChangeFoundCreaturePeform(btn,key,Const.CreaturePhotoStatus.Known)
            end
        end
    end
end


---进入CollectionGui前，替换需要消息提示的生物按钮图片
---@param _btn Object 已发现生物按钮
---@param _type int 该生物Key
---@param _status int 收集状况 （见Const.CreaturePhotoStatus）
function CollectionGui:ChangeFoundCreaturePeform(_btn,_type,_status)
    if _status == Const.CreaturePhotoStatus.Click then
        ---有可插入的照片
        ---按钮配置
        _btn.Texture = ResourceManager.GetTexture(this.collectionPanelClickRoot..tostring(_type))
        _btn.PressedImage = ResourceManager.GetTexture(this.collectionPanelClickPressedRoot..tostring(_type))
        
        ---播放点击特效
        local ima = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.ClickEffect)
        ima:SetActive(true)
        CollectionGui:PlayClickEffect(ima)
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,true)

    elseif _status == Const.CreaturePhotoStatus.Done then
        ---收集完整
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,true)
        ---中间图
        local bgd = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Background)
        local status = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Status)
        status:SetActive(false)

        ---播放收集完整特效
        local unlock = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.UnlockEffect)
        local flash = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.FlashEffect)
        ---是否可以播放解锁动画
        local c = C_Collection.allCreature[_type]
        if c.isPlayUnlockEffect then
            unlock:SetActive(true)
            flash:SetActive(true)
            CollectionGui:PlayUnlockEffect(_btn)
            c.isPlayUnlockEffect = false
        else
            unlock:SetActive(true)
            unlock.Texture = ResourceManager.GetTexture(this.effectUnlockRoot..tostring(this.unlockEffectNum))
            flash:SetActive(true)
            CollectionGui:PlayFlashEffect(_btn)
        end

    elseif _status == Const.CreaturePhotoStatus.Known then
        ---未收集完整且没有可插入照片
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,true)
    end
end

---进入CollectionGui/退出CollectionGui前,照片插入进度更新
---@param _btn Object 已发现生物按钮
---@param _type int 该生物Key
---@param _trigger boolean 进入CollectionGui = true,退出 = false
function CollectionGui:CollectionAnimalProgress(_btn,_type,_trigger)
    local num = C_Collection.allCreature[_type]:GetStickPhotoNum()
    local status = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Status)
    
    for i = 1, num do
        local ima = status:GetChild(tostring(i)..this.collectionAniamlProgressWord..this.imaSuffix)
        if _trigger then
            ima.Alpha = 1
        else
            ima.Alpha = this.darkAlpha
        end 
    end
end


---退出CollectionGui前，图鉴里生物图片、效果重置
---@param _btn Object 已发现生物按钮
---@param _type int 该生物Key
---@param _status int 收集状况 （见Const.CreaturePhotoStatus）
function CollectionGui:CreatureInCollectionReset(_btn,_type,_status)
    if _status == Const.CreaturePhotoStatus.Click then
        ---有可插入的照片
        ---按钮配置
        _btn.Texture = ResourceManager.GetTexture(this.collectionPanelFoundRoot..tostring(_type))
        _btn.PressedImage = ResourceManager.GetTexture(this.collectionPanelFoundPressedRoot..tostring(_type))
        
        ---停止播放点击特效
        local ima = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.ClickEffect)
        CollectionGui:StopClickEffect(ima)
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,false)

    elseif _status == Const.CreaturePhotoStatus.Done then
        ---收集完整
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,false)
        ---中间图
        local bgd = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Background)
        local status = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Status)
        status:SetActive(true)

        ---停止播放收集完整特效
        
    elseif _status == Const.CreaturePhotoStatus.Known then
        ---未收集完整且没有可插入照片
        ---进度展现
        CollectionGui:CollectionAnimalProgress(_btn,_type,false)
    end  
end

---退出CollectionGui前，图鉴主界面重置操作
function CollectionGui:ResetCollectionConfig()
    for key, value in ipairs(C_Collection.allCreature) do
        if value.isFound_ then
            ---按钮配置
            CollectionGui:ConfirmCollectionBtn(key,false):SetActive(true)
            local btn = CollectionGui:ConfirmCollectionBtn(key,true)
            btn:SetActive(false)
            btn.Texture = ResourceManager.GetTexture(this.collectionPanelFoundRoot..tostring(key))
            btn.PressedImage = ResourceManager.GetTexture(this.collectionPanelFoundPressedRoot..tostring(key))
            CollectionGui:CollectionAnimalProgress(btn,key,false)
            ---停止播放点击特效
            local ima = CollectionGui:ConfirmCollectionFoundBtnObj(btn,Const.CollectionFoundBtnKey.ClickEffect)
            CollectionGui:StopClickEffect(ima)

            ---停止播放收集完整特效
            CollectionGui:StopUnlockEffect(btn)
            CollectionGui:StopFlashEffect(btn)
            --[[
            if value:CreatureInCollectionIsShow() then
                ---有可插入的照片
                CollectionGui:CreatureInCollectionReset(btn,key,Const.CreaturePhotoStatus.Click)
            elseif value:GetStickPhotoNum() == 4 then
                ---收集完整
                CollectionGui:CreatureInCollectionReset(btn,key,Const.CreaturePhotoStatus.Done)
            elseif value:GetStickPhotoNum() < 4 and not value:CreatureInCollectionIsShow() then
                ---未收集完整且没有可插入照片
                CollectionGui:CreatureInCollectionReset(btn,key,Const.CreaturePhotoStatus.Known)
            end
            --]]
        end
    end

    ---图鉴卷轴滑动按钮重置
    this.collectionPanelLeftBtn.Alpha = 1
    this.collectionPanelRightBtn.Alpha = 1
    this.collectionPanelLeftBtn.Clickable = true
    this.collectionPanelRightBtn.Clickable = true
    CollectionGui:StopClickEffect(this.collectionPanelLeftBtnClickEffect)
    CollectionGui:StopClickEffect(this.collectionPanelRightBtnClickEffect)
    ---图鉴卷轴滑动位置重置
    this.collectionPanel.ScrollScale = 0
    CollectionGui:DestroyTween(this.collectionPanelAutoMoveTween)
end

---退出CollectionGui时，根据要打开的层级确定是否关闭CollectionGui
---@param _levelNum int 要打开的UiLevel
function CollectionGui:CloseCollectionGui(_levelNum)
    if _levelNum < 2 then
        ---回到上一级
        C_GuiMgr:BackToMainInterface()
    else
        ---不关闭CollectionGui

    end
end

---打开界面，根据上个UiLevel和要打开的Uilevel决定打开方式
---@param _lastNum int 上一个UiLevel
---@param _nowNum int 准备打开的UiLevel
function CollectionGui:OpenUiLevelWindows(_lastNum,_nowNum)
    if _lastNum == Const.CollectionUiLevel.MainUi then
        ---从MainGui出发
        if _nowNum == Const.CollectionUiLevel.CollectionUi then
            ---到 CollectionGui
            --C_GuiMgr:BackToMainInterface()
            C_GuiMgr:OpenGui("CollectionGui")
        elseif _nowNum == Const.CollectionUiLevel.CreatureUi then
            ---到 CreatureGui
            --C_GuiMgr:BackToMainInterface()
            C_GuiMgr:OpenGui("CollectionGui")
            this.creatureBackground:SetActive(true)
        
        elseif _nowNum == Const.CollectionUiLevel.Behavior then
            print("[error]]不存在这种打开顺序")
        end

    elseif _lastNum == Const.CollectionUiLevel.CollectionUi then
        ---从Collection出发
        if _nowNum == Const.CollectionUiLevel.MainUi then
            ---到 MainUi
            C_GuiMgr:BackToMainInterface()
            ---从相机进入后返回时返回至相机Gui
            if this.isFromCamGui then
                C_GuiMgr:OpenGui("CamGui")
                this.isFromCamGui = false
            end
        elseif _nowNum == Const.CollectionUiLevel.CreatureUi then
            ---到 CreatureGui  
            this.creatureBackground:SetActive(true)
        elseif _nowNum == Const.CollectionUiLevel.Behavior then
            print("[error]]不存在这种打开顺序")
        end

    elseif _lastNum == Const.CollectionUiLevel.CreatureUi then
        ---从Creature出发
        if _nowNum == Const.CollectionUiLevel.MainUi then
            ---到 MainUi
            this.creatureBackground:SetActive(false)
            C_GuiMgr:BackToMainInterface()
            ---从相机进入后返回时返回至相机Gui
            if this.isFromCamGui then
                C_GuiMgr:OpenGui("CamGui")
                this.isFromCamGui = false
            end
        elseif _nowNum == Const.CollectionUiLevel.CollectionUi then
            ---到 CollectionUi  
            this.creatureBackground:SetActive(false)

        elseif _nowNum == Const.CollectionUiLevel.Behavior then
            ---到 Behavior
            ---播放特殊行为区域出现动画
        end

    elseif _lastNum == Const.CollectionUiLevel.Behavior then
        ---从Behavior出发
        if _nowNum == Const.CollectionUiLevel.MainUi then
            ---到 MainUi
            ---播放特殊行为区域重置动画

            this.creatureBackground:SetActive(false)
            C_GuiMgr:BackToMainInterface()
        elseif _nowNum == Const.CollectionUiLevel.CollectionUi then
            ---到 CollectionUi  
            ---播放特殊行为区域重置动画
            
            this.creatureBackground:SetActive(false)
        elseif _nowNum == Const.CollectionUiLevel.CreatureUi then
            ---到 Behavior
            ---播放特殊行为区域重置动画

        end
    end
end

---进入CreatureGui前，根据生物Key更改生物页面上方的具体信息
function CollectionGui:ChangeInfoByCreature(_creatureTable)
    if _creatureTable.isFound_ then
        ---标题本地化
        this.creatureTitle.LocalizeKey = _creatureTable.nameLocalizeKey_
        ---身长
        this.creatureHeight.Text = _creatureTable.height_
        ---体重
        this.creatureWeight.Text = _creatureTable.weight_
        ---栖息地本地化
        this.creatureHabitat.LocalizeKey = _creatureTable.habitatLocalizeKey_
        ---习性本地化
        this.creatureHabits.LocalizeKey = _creatureTable.habitsLocalizeKey_
        ---信息图
        this.creatureInfogram.Texture = ResourceManager.GetTexture(this.creatureInfogramRoot..tostring(_creatureTable.type_))
    else
        ---标题本地化
        this.creatureTitle.LocalizeKey = this.creatureUnknownTextKey
        ---身长
        this.creatureHeight.Text = this.creatureNotFoundText
        ---体重
        this.creatureWeight.Text = this.creatureNotFoundText
        ---栖息地本地化
        this.creatureHabitat.LocalizeKey = _creatureTable.habitatLocalizeKey_
        ---习性
        this.creatureHabits.LocalizeKey = this.creatureUnknownTextKey
        ---信息图
        this.creatureInfogram.Texture = ResourceManager.GetTexture(this.creatureNotFoundInfogramRoot..tostring(_creatureTable.type_))   
    end
end

---进入CreatureGui前，根据后端数据，更改特殊行为区域信息
function CollectionGui:ChangePhotoByCreature(_creatureTable)
    for i = 1, Const.SpecialBehaviorNum do
        local sbB = _creatureTable.specialBehavior_[i]
        ---确定背景
        local bgd = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Background)
        ---确定节点下的相片
        local photo = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Photo)
        ---确定星星图
        local star = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Star)
        ---确定按钮
        local btn = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Btn)
        if _creatureTable:IsStickPhoto(i) then
            ---已贴有照片
            bgd.Alpha = 1
            ---确定texture
            photo.Texture = sbB.stickPhoto_:GetShotSrc()
            star.Texture = ResourceManager.GetTexture(this.creatureBehaviorDoneRoot..tostring(i))
            btn:SetActive(true)
        elseif _creatureTable:IsCanAddPhoto(i) then
            ---可贴照片
            photo.Texture = ResourceManager.GetTexture(this.creaturePhotoRoot..this.behaviorPhotoAvailable)
            star.Texture = ResourceManager.GetTexture(this.creatureBehaviorAvailableRoot..tostring(i))
            btn:SetActive(true)
            ---播放变大变小Tween
            CollectionGui:InitCreatureBehaviorTween(_creatureTable,photo,i)
            star.Alpha = 1
        else
            ---不可贴入照片且没贴过照片
            CollectionGui:DestroyCreatureBehaviorTween(_creatureTable,photo,i)
        end
    end
    
end

---进入CollectionGui前，声音按钮
function CollectionGui:InitSoundBtn(_creatureTable)
    if _creatureTable.isSound_ then
        this.creatureSound:SetActive(true)
    end
end

---退出CreatureGui前，生物子界面重置
function CollectionGui:ResetPhotoByCreature(_creatureTable)
    for i = 1, Const.SpecialBehaviorNum do
        ---确定背景
        local bgd = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Background)
        ---确定节点下的相片
        local photo = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Photo)
        ---确定星星图
        local star = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Star)
        ---确定按钮
        local btn = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Btn)
        
        photo.Texture = ResourceManager.GetTexture(this.creaturePhotoRoot..this.behaviorPhotoUnavailable)
        star.Texture = ResourceManager.GetTexture(this.creatureBehaviorUnavailableRoot..tostring(i))
        btn:SetActive(false)
        star.Alpha = 1
        bgd.Alpha = 0
        this.creatureBook.Alpha = 1
        bgd.Alpha = 0
        CollectionGui:DestroyCreatureBehaviorTween(_creatureTable,photo,i)
        --[[
        if _creatureTable:IsStickPhoto(i) then
            ---已贴有照片
            bgd.Alpha = 0
        elseif _creatureTable:IsCanAddPhoto(i) then
            ---停止播放变大边小Tween并重置回初始大小
            print("🐖🐖")
            CollectionGui:DestroyCreatureBehaviorTween(_creatureTable,photo,i)
        end
        --]]
    end

    ---声音按钮重置
    this.creatureSound:SetActive(false)

    ---切换按钮重置 
	if QuestMgr.tutorialComplete then
		this.creaturePreviousBtn:SetActive(true)
		this.creaturePreviousBtn.Alpha = 1
		this.creaturePreviousBtn.Clickable = true
		this.creatureNextBtn:SetActive(true)
		this.creatureNextBtn.Alpha = 1
		this.creatureNextBtn.Clickable = true
	end
end

---退出CreatureGui前，生物子界面询问重置
---@param _nextNum int 下一个要打开的UiLevel
function CollectionGui:ResetCreatureConfig(_creatureTable,_nextNum)
    if _nextNum == Const.CollectionUiLevel.Behavior then
        ---进入behavior界面 不重置
        this.creaturePreviousBtn:SetActive(false)
        this.creatureNextBtn:SetActive(false)
    elseif _nextNum == Const.CollectionUiLevel.CreatureUi then
        ---进入 同级creature界面
        CollectionGui:ResetPhotoByCreature(_creatureTable)
    else
        ---进入其他界面
        this.openCreatureKey = 0
        CollectionGui:ResetPhotoByCreature(_creatureTable)
    end
end

---进入Behavior 前，生物子界面下方的组件更新
function CollectionGui:ChangeDownCreatureInBehavior(_creatureTable)
    ---书本图 alpha
    this.creatureBook.Alpha = this.darkAlpha
    ---特殊行为 alpha
    for i = 1, Const.SpecialBehaviorNum do
        ---非选择的行为区域表现变化
        local sbB = _creatureTable.specialBehavior_[i]
        ---确定背景
        local bgd = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Background)
        ---确定节点下的相片
        local photo = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Photo)
        ---确定星星图
        local star = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Star)
        if i ~= this.openBehaviorKey then
            ---非选择的行为区域表现变化
            local sbB = _creatureTable.specialBehavior_[i]
            if _creatureTable:IsStickPhoto(i) then
                ---已贴有照片
                bgd.Alpha = this.darkAlpha
                photo.Alpha = this.darkAlpha
                star.Alpha = this.darkAlpha
            elseif _creatureTable:IsCanAddPhoto(i) then
                ---可贴照片
                photo.Texture = ResourceManager.GetTexture(this.creaturePhotoRoot..this.behaviorPhotoAvailable)
                photo.Alpha = this.darkAlpha
                star.Alpha = this.darkAlpha
                ---变大变小Tween
                CollectionGui:InitCreatureBehaviorTween(_creatureTable,photo,i)
            else
                ---不可贴入照片且没贴过照片
                photo.Alpha = this.darkAlpha
                star.Alpha = this.darkAlpha
            end
        else
            ---选择的行为区域表现变化
            if _creatureTable:IsStickPhoto(i) then
                ---已贴有照片
                bgd.Alpha = 1
                photo.Alpha = 1
                star.Alpha = 1
            elseif _creatureTable:IsCanAddPhoto(i) then
                ---可贴照片
                photo.Texture = ResourceManager.GetTexture(this.creaturePhotoRoot..this.behaviorPhotoAdd)
                photo.Alpha = 1
                star.Alpha = 0
            else
                ---不可贴入照片且没贴过照片
            end
        end
    end
    ---动物图 alpha
    this.creatureInfogram.Alpha = 0
end

---进入Behavior 前，特殊行为卷轴更新
function CollectionGui:ChangeBehaviorPanel(_creatureTable,_behaviorKey)
    local behaviorT = _creatureTable.specialBehavior_
    local panelNum = 0
    if behaviorT[_behaviorKey].panelPhoto_ then
        ---清理已有相片
        CollectionGui:DestroyBehaviorPanelPhoto()
        panelNum = #behaviorT[_behaviorKey].panelPhoto_
        for i = 1, panelNum do
            ---创建图片
            local obj = CollectionGui:NewPhotoInBehaviorPanel(i)
            ---相片节点
            local photoObj = CollectionGui:ConfirmBehaviorArchetypeObj(i,Const.BehaviorPanelArchetype.Photo)

            ---确定texture
            local tex = behaviorT[_behaviorKey].panelPhoto_[i]:GetShotSrc()
            photoObj.Texture = tex

            --[[
            if _isInitShow then
                ---初始化动效播放
                CollectionGui:PlayBtnTween(photoObj,info.btnTweenPanelFrontEntry..tostring(i)..info.btnTweenInitKeyBehindEntry)
            end
            --]]
        end
    end

    ---特殊卷轴位置初始化
    --this.behaviorPanel.ScrollScale = 0

    ---特殊行为卷轴 大小确定
    CollectionGui:SetBehaviorPanelScale(this.behaviorPanel,panelNum)

    ---滑动按钮配置
    
end

---进入Behavior 前，窗口移动至指定位置
function CollectionGui:MoveWindowsInBehaviorOpen()
    local bookTween = Tween:TweenProperty(this.creatureBook,{Offset = this.creatureBookUpOffset},0.1,Enum.EaseCurve.Linear)
    local panelTween = Tween:TweenProperty(this.behaviorPanelBackground,{Offset = Vector2(0,0)},0.1,Enum.EaseCurve.Linear)
    bookTween.OnComplete:Connect(
        function ()
            bookTween:Destroy()
            panelTween:Play()
        end
    )
    panelTween.OnComplete:Connect(
        function ()
            panelTween:Destroy()
        end
    )
    bookTween:Play()
end

---退出Behavior 前，询问重置
---@param _nextNum int 准备进入的UiLevel
function CollectionGui:ResetBehaviorConfig(_creatureTable,_nextNum)
    if _nextNum == Const.CollectionUiLevel.Behavior then
        ---进入behavior界面

    elseif _nextNum == Const.CollectionUiLevel.CreatureUi then
        ---进入Creature界面
        ---窗口移动 + 清理Panel
        CollectionGui:MoveWindowsInBehaviorClose()
        ---下方区域修正
        CollectionGui:ResetBehaviorAlpha(_creatureTable)
    else
        ---进入其他界面 重置
        ---窗口移动 + 清理Panel
        CollectionGui:MoveWindowsInBehaviorClose()
        ---两个界面同时重置
        CollectionGui:ResetCreatureAndBehavior(_creatureTable)
    end
end

---在特殊行为卷轴，创建相片对象
---@param _index int 该相片在panelTable的顺序
function CollectionGui:NewPhotoInBehaviorPanel(_index)
    ---创建相片对象
    local obj = world:CreateInstance(
    this.behaviorPanelPhotoArchetypeName,
    tostring(_index)..this.behaviorPanelPhotoArchetypeName,
    this.behaviorPanel
    )

    ---确定相片Anchors位置
    CollectionGui:ConfirmNewPhotoAnchors(obj,_index)


    ---点击事件
    local btn = CollectionGui:ConfirmBehaviorArchetypeObj(_index,Const.BehaviorPanelArchetype.Btn)

    if this.platformName == Enum.Platform.Windows then
        btn.OnClick:Connect(
        function ()
            
            local c = C_Collection.allCreature[this.openCreatureKey]
            local behaviorPhoto = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Photo)
            local bgd = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Background)
            ---确定节点下的相片
            local photo = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Photo)
            ---确定是否是插入或者交换操作
            if not c:IsStickPhoto(this.openBehaviorKey) then
                ---插入照片
                ---更新后端数据
                c:AddBehaviorPhoto(_index,this.openBehaviorKey)

                ---移动动效
                CollectionGui:PhotoAutomaticMove(true,obj,behaviorPhoto,this.openBehaviorKey,c,_index)
                
                
                
                ---清除变大变小Tween
                CollectionGui:DestroyCreatureBehaviorTween(c,photo,this.openBehaviorKey)

                ---清空当前打开行为Key
                this.openBehaviorKey = 0
                
            
            else
                ---交换照片
                ---更新后端数据
                c:ChangeBehaviorPhoto(_index,this.openBehaviorKey)

                ---移动动效
                CollectionGui:PhotoAutomaticMove(false,obj,behaviorPhoto,this.openBehaviorKey,c,_index)
                
                ---移动至上一层
                --this.allUiLevel[4]:SetUiLevel(3)
            end
            
        end
    )
    else
        btn.OnPanEnd:Connect(
        function (_position,_panDistance,deltaDistance,_panSpeed)
            if _panSpeed <= this.touchSpeed then
                local c = C_Collection.allCreature[this.openCreatureKey]
                local behaviorPhoto = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Photo)
                local bgd = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Background)
                ---确定节点下的相片
                local photo = CollectionGui:ConfirmBehaviorObj(this.openBehaviorKey,Const.SpecialBehaviorObjectKey.Photo)
                ---确定是否是插入或者交换操作
                if not c:IsStickPhoto(this.openBehaviorKey) then
                    ---插入照片
                    ---更新后端数据
                    c:AddBehaviorPhoto(_index,this.openBehaviorKey)

                    ---移动动效
                    CollectionGui:PhotoAutomaticMove(true,obj,behaviorPhoto,this.openBehaviorKey,c,_index)
                    
                    
                    
                    ---清除变大变小Tween
                    CollectionGui:DestroyCreatureBehaviorTween(c,photo,this.openBehaviorKey)

                    ---清空当前打开行为Key
                    this.openBehaviorKey = 0
                    
                
                else
                    ---交换照片
                    ---更新后端数据
                    c:ChangeBehaviorPhoto(_index,this.openBehaviorKey)

                    ---移动动效
                    CollectionGui:PhotoAutomaticMove(false,obj,behaviorPhoto,this.openBehaviorKey,c,_index)
                    
                    ---移动至上一层
                    --this.allUiLevel[4]:SetUiLevel(3)
                end
            end
        end
    )
    end
    

    return obj
end

---获取特殊行为卷轴的 相片对象下的组件
---@param _index int 该相片在panelTable的顺序
---@param _objectKey int 相片下组件Key (见Const.BehaviorPanelArchetype)
function CollectionGui:ConfirmBehaviorArchetypeObj(_index,_objectKey)

    local name = tostring(_index)..this.behaviorPanelPhotoArchetypeName
    local obj = this.behaviorPanel:GetChild(name)

    if _objectKey == Const.BehaviorPanelArchetype.Background then
        ---获得背景图
        return obj
    elseif _objectKey == Const.BehaviorPanelArchetype.Photo then
        ---获得相片
        local photo = obj:GetChild(this.creaturePhotoImaWord..this.imaSuffix)

        return photo
    elseif _objectKey == Const.BehaviorPanelArchetype.Btn then
        ---获得按钮
        local btn = obj:GetChild(this.behaviorPanelPhotoArchetypeWord..this.btnSuffix)
        
        return btn
    end
end

---确定新生成的相片Anchors，确定位置
---@param _obj gameObject 相片
---@param _index int 该相片在panelTable的顺序
function CollectionGui:ConfirmNewPhotoAnchors(_obj,_index)
    _obj.AnchorsY = this.photoBgdArchetypeAnchorsY
    local claps = _index - 1
    local x1 = claps * this.photoBgdArchetypeClapX + this.photoBgdArchetypeAnchorsX.x
    _obj.AnchorsX = Vector2(x1,x1)
end

---准备增加/交换照片时，点击的照片自动和对应位置有移动效果
---@param _isAdd boolean 是 增加照片/否 交换照片
---@param _panelphoto gameObject 特殊行为卷轴相片
---@param _behaviorPhoto gameObject  特殊行为区域相片
---@param _behaviorKey int 特殊行为Key
---@param _c table  当前生物表
---@param _index int 特殊行为卷轴相片顺序
function CollectionGui:PhotoAutomaticMove(_isAdd,_panelphoto,_behaviorPhoto,_behaviorKey,_c,_index)
    local bgd = _behaviorPhoto.Parent
    if _isAdd then
        ---增加照片 动画
        ---确定位置
        local t = CollectionGui:GetDestinationAnchors(true,_index,_behaviorKey)
        local tween = Tween:TweenProperty(_panelphoto,{Offset = t},0.2,Enum.EaseCurve.CubicOut)
        tween.OnPlay:Connect(
            function ()
                ---音效播放
                CollectionGui:PlaySound(this.changeBehaviorPhotoSound1)
                ---开始动画后按钮不可点击
                local btn = CollectionGui:ConfirmBehaviorArchetypeObj(_index,Const.BehaviorPanelArchetype.Btn)
                btn.Clickable = false
                ---层级变换，将卷轴层级高于书本
                this.behaviorPanelBackground:Up()
            end
        )
        tween.OnComplete:Connect(
            function ()
                ---音效播放
                CollectionGui:PlaySound(this.addBehaviorPhotoSound)
                tween:Destroy()
                local tex = _c.specialBehavior_[_behaviorKey].stickPhoto_:GetShotSrc()
                _behaviorPhoto.Texture = tex
                ---出现照片框
                bgd.Alpha = 1
                ---层级变换，将卷轴层级低于书本
                this.behaviorPanelBackground:Down()

				---新手引导时的特殊处理
				if not QuestMgr.tutorialComplete then
					if CollectionGui:CheckForTutorialComplete() then
						IntroGuiMgr:ShowMask(IntroGuiMgr.maskCreature, IntroGuiMgr.maskAlpha, IntroGuiMgr.fadeDuration)
						GuideSystem:RippleGuide(this.creature_Behavior_Back, Vector2(0.5,0.5))
						this.creature_Behavior_Back.RippleGuide.CloseBtn:SetActive(false)
                        
                        ---region 数据埋点 一川
                        UploadLog("tutorial_add_click","C1004")
                        ---endregion
                    end
				else
                    ---region 数据埋点 一川
                    UploadLog("collection_add_{"..tostring(_c.type_).."}_click","C1004",_c.type_,_behaviorKey)
                    ---endregion
                end

                ---刷新卷轴内其他照片位置
                CollectionGui:ChangeBehaviorPanel(_c,_behaviorKey)
           
                ---移动至上一层
                this.allUiLevel[4]:SetUiLevel(3)
                
                local photoNum = _c:GetStickPhotoNum()
                if photoNum == Const.SpecialBehaviorNum and QuestMgr.tutorialComplete then
                    ---若收集完整则跳至图鉴界面
                    local showCompleteFunc = function ()
                        this.allUiLevel[this.openUiLevel]:SetUiLevel(2)
                    end
                    ---等待书本图上移的动画时间
                    C_TimeMgr:AddDelayTimeEvent(500,showCompleteFunc) 
                end   
            end
        )
        tween:Play()
    else
        ---交换照片 动画

        ---卷轴→特殊行为
        ---确定位置
        local t = CollectionGui:GetDestinationAnchors(true,_index,_behaviorKey)
        local tween = Tween:TweenProperty(_panelphoto,{Offset = t},0.2,Enum.EaseCurve.CubicOut)
        tween.OnPlay:Connect(
            function ()
                ---音效播放
                CollectionGui:PlaySound(this.changeBehaviorPhotoSound1)
                ---开始动画后按钮不可点击
                local btn = CollectionGui:ConfirmBehaviorArchetypeObj(_index,Const.BehaviorPanelArchetype.Btn)
                btn.Clickable = false

            end
        )
        tween.OnComplete:Connect(
            function ()
                ---音效播放
                CollectionGui:PlaySound(this.changeBehaviorPhotoSound2)
                tween:Destroy()

                local tex = _c.specialBehavior_[_behaviorKey].stickPhoto_:GetShotSrc()
                _behaviorPhoto.Texture = tex

                ---更新后端数据
                _c:FreshPhotoNum(_behaviorKey)
                
                ---刷新卷轴内其他照片位置
                CollectionGui:ChangeBehaviorPanel(_c,_behaviorKey)
            end
        )
        

        ---特殊行为→卷轴
        local t2 = CollectionGui:GetDestinationAnchors(false,_index,_behaviorKey)
       
        local btn = CollectionGui:ConfirmBehaviorObj(_behaviorKey,Const.SpecialBehaviorObjectKey.Btn)
        local star = CollectionGui:ConfirmBehaviorObj(_behaviorKey,Const.SpecialBehaviorObjectKey.Star)

        local tween02 = Tween:TweenProperty(_behaviorPhoto.Parent,{Offset = t2},0.2,Enum.EaseCurve.CubicOut)
        tween02.OnPlay:Connect(
            function ()
                ---开始动画后不可点击
                btn.Clickable = false
                ---星星图隐藏
                star:SetActive(false)
                ---卷轴Panel停止移动
                this.behaviorPanel.ScrollScale = math.floor(this.behaviorPanel.ScrollScale + 0.5)
            end
        )
        tween02.OnComplete:Connect(
            function ()
                ---结束动画后恢复
                btn.Clickable = true
                bgd.Offset = Vector2(0,0)
                ---星星图显示
                star:SetActive(true)
                tween02:Destroy()

                ---region 数据埋点 一川
				if QuestMgr.tutorialComplete then
                    UploadLog("collection_change_{"..tostring(_c.type_).."}_click","C1004",_c.type_,_behaviorKey)                 
                end
                ---region 数据埋点 一川
            end
        )

        tween:Play()
        tween02:Play()
    end
end

---计算移动Tween移动目的地的Anchors
---@param _isPanelToBehavior boolean 是=特殊行为卷轴相片 → 特殊行为区域 / 否特殊行为区域 ← 特殊行为卷轴相片
---@param _index int 特殊行为卷轴相片顺序
---@param _behaviorKey int 特殊行为Key
function CollectionGui:GetDestinationAnchors(_isPanelToBehavior,_index,_behaviorKey)
    ---获取书本图（特殊行为区域的父节点）的X宽度
    local bookX = this.creatureBook.AnchorsX.y - this.creatureBook.AnchorsX.x
    ---获取书本图左边留白距离
    local bookBrank = this.creatureBook.AnchorsX.x
    ---获取书本图Size
    local bookSize = this.creatureBook.Size
    ---获取全局分辨率
    local final = this.creatureBackground.FinalSize
    ---获取特殊行为卷轴背景图的Size
    local behaviorPanelSize = Vector2(final.x,this.behaviorPanelBackground.Size.y)

    ---特殊行为区域
    local destinationObj = CollectionGui:ConfirmBehaviorObj(_behaviorKey,Const.SpecialBehaviorObjectKey.Background)
    ---计算区域的绝对像素坐标
    local Ox = (destinationObj.AnchorsX.x - 0.5) * bookSize.x
    local Oy = (destinationObj.AnchorsY.y - 0.5) * bookSize.y
    local coordinateD = Vector2(0.5 * final.x + Ox , 0.5 * final.y + Oy + this.creatureBookUpOffset.y)
    --print("特殊行为区域"..tostring(_behaviorKey)..":",coordinateD)

    ---计算卷轴相片的绝对像素坐标
    local startObj = CollectionGui:ConfirmBehaviorArchetypeObj(_index,Const.BehaviorPanelArchetype.Background)
    local SOx
    if this.behaviorPanel.ScrollRange == final.x then
        SOx = startObj.AnchorsX.x * final.x
    else
        ---卷轴平移的像素修正（屏幕不是一个点而是面,移动至尽头时是右边缘至终点而是不是左边缘）
        ---计算移动至尽头时的平移量
        local bigSizeX = this.behaviorPanel.ScrollRange - final.x
        ---计算当前的移动修正量
        local newSizeX = (this.behaviorPanel.ScrollScale / 100) * bigSizeX
        SOx = startObj.AnchorsX.x * final.x - newSizeX
    end
    local y1 = (startObj.AnchorsY.y - 0.5) * behaviorPanelSize.y
    local SOy = this.behaviorPanelBackground.AnchorsY.y * final.y + y1
    local coordinateS = Vector2(SOx,SOy)
    --print("特殊行为卷轴"..tostring(_index)..":",coordinateS)

    if _isPanelToBehavior then
        ---特殊行为卷轴相片 → 特殊行为区域
        local delta = coordinateD - coordinateS
        --print("特殊行为卷轴相片 → 特殊行为区域，平移量：",delta)
        
        return delta
    else
        ---特殊行为区域 → 特殊行为卷轴相片
        local delta = coordinateS - coordinateD
        --print("特殊行为区域 → 特殊行为卷轴相片，平移量：",delta)

        return delta
    end
end

---Behavior退出时/刷新时，清除BehaviorPanel下的相片
---@param _nextNum int 准备进入的UiLevel
function CollectionGui:DestroyBehaviorPanelPhoto()
    ---清理已有相片
    local old = this.behaviorPanel:GetChildren()
    for key, value in pairs(old or {}) do
        value:Destroy()
    end
end

---退出Behavior 前，窗口移动至指定位置
---@param _func function 指定运行的重置函数
function CollectionGui:MoveWindowsInBehaviorClose()
    local bookTween = Tween:TweenProperty(this.creatureBook,{Offset = Vector2(0,0)},0.05,Enum.EaseCurve.Linear)
    local panelTween = Tween:TweenProperty(this.behaviorPanelBackground,{Offset = this.behaviorPanelBackgroundLeftOffset},0.05,Enum.EaseCurve.Linear)
    bookTween.OnComplete:Connect(
        function ()
            bookTween:Destroy()
            CollectionGui:DestroyBehaviorPanelPhoto()
        end
    )
    panelTween.OnComplete:Connect(
        function ()
            panelTween:Destroy()
            bookTween:Play()
        end
    )
    panelTween:Play()
end

---退出Behavior前（不回到Creature）,重置Creature、Behavior
function CollectionGui:ResetCreatureAndBehavior(_creatureTable)
    ---Creature重置
    CollectionGui:ResetPhotoByCreature(_creatureTable)
    ---卷轴重置
    this.behaviorPanel.ScrollScale = 0
    this.behaviorPanelLeftBtn.Alpha = 1
    this.behaviorPanelLeftBtn.Clickable = true
    this.behaviorPanelRightBtn.Alpha = 1
    this.behaviorPanelRightBtn.Clickable = true

    ---动物图 alpha
    this.creatureInfogram.Alpha = 1
end

---退出Behavior前（回到Creature）,重置Creature下方特殊行为区域的改动
function CollectionGui:ResetBehaviorAlpha(_creatureTable)
    ---书本图 alpha
    this.creatureBook.Alpha = 1
    ---特殊行为 alpha
    for i = 1, Const.SpecialBehaviorNum do
         ---非选择的行为区域表现变化
         local sbB = _creatureTable.specialBehavior_[i]
         ---确定背景
         local bgd = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Background)
         ---确定节点下的相片
         local photo = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Photo)
         ---确定星星图
         local star = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Star)
        if i ~= this.openBehaviorKey then
            if _creatureTable:IsStickPhoto(i) then
                ---已贴有照片
                bgd.Alpha = 1
                photo.Alpha = 1
                star.Alpha = 1
            elseif _creatureTable:IsCanAddPhoto(i) then
                ---可贴照片
                photo.Alpha = 1
                
            else
                ---不可贴入照片且没贴过照片
                photo.Alpha = 1
                star.Alpha = 1
            end
        else
            if _creatureTable:IsStickPhoto(i) then
                ---已贴有照片
                bgd.Alpha = 1
                photo.Alpha = 1
                star.Alpha = 1
            elseif _creatureTable:IsCanAddPhoto(i) then
                ---可贴照片
                photo.Texture = ResourceManager.GetTexture(this.creaturePhotoRoot..this.behaviorPhotoAvailable)
                star.Alpha = 1
            else
                ---不可贴入照片且没贴过照片
                photo.Alpha = 1
                star.Alpha = 1
            end
        end
    end

    ---卷轴重置
    this.behaviorPanel.ScrollScale = 0
    this.behaviorPanelLeftBtn.Alpha = 1
    this.behaviorPanelLeftBtn.Clickable = true
    this.behaviorPanelRightBtn.Alpha = 1
    this.behaviorPanelRightBtn.Clickable = true

    ---动物图 alpha
    this.creatureInfogram.Alpha = 1
end

---进入CollectionGui前，给需要点击的按钮播放波纹特效
function CollectionGui:CollectionPlayClickEffect()
    ---动物按钮
    for key, value in ipairs(C_Collection.allCreature) do
        if value.isFound_ then   
            if value:CreatureInCollectionIsShow() then
                ---有可插入的照片
                local ima = CollectionGui:ConfirmCollectionBtn(key,true)
            else

            end
        end
    end
end

---播放 波纹特效
---@param _ima gameObject 特效图片
function CollectionGui:PlayClickEffect(_ima)
    if _ima.ActiveSelf then
        ---当前该组件已激活
        for i = 1, this.clickEffectNum do
            local root = this.effectClickRoot..tostring(i)
            local func = function ()
                if _ima.ActiveSelf then
                    _ima.Texture = ResourceManager.GetTexture(root)
                    if i == this.clickEffectNum then
                        ---一次循环结束
                        _ima.Alpha = 0
                        C_TimeMgr:AddDelayTimeEvent(this.clickEffectClapNum * this.effectFrame * 1000,CollectionGui.PlayClickEffect,CollectionGui,_ima)
                    elseif i == 1 then
                        ---开始
                        _ima.Alpha = 1
                    end
                end
            end

            C_TimeMgr:AddDelayTimeEvent(this.effectFrame * 1000 * i,func)
        end
    end
end

---停止播放 波纹点击特效
---@param _ima gameObject 特效图片
function CollectionGui:StopClickEffect(_ima)
    _ima:SetActive(false)
end

---确认图鉴 已发现按钮下的组件
---@param _btn gameObject 图鉴界面的已发现按钮
---@param _objectKey int 组件编号 （见Const.CollectionFoundBtnKey）
function CollectionGui:ConfirmCollectionFoundBtnObj(_btn,_objectKey)

    ---图鉴已发现按钮 信息框背景图
    local bgd = _btn:GetChild(this.collectionAnimalBackgroundWord..this.imaSuffix)
    
    if _objectKey == Const.CollectionFoundBtnKey.Background then
        ---获取信息框背景图
        return bgd
    elseif _objectKey == Const.CollectionFoundBtnKey.Name then
        ---获取动物名字的文本框
        local name = bgd:GetChild(this.collectionFoundBtnNameWord..this.texSuffix)
        return name
    elseif _objectKey == Const.CollectionFoundBtnKey.ClickEffect then
        ---获取波纹点击特效的图片
        local click = bgd:GetChild(this.clickEffectWord..this.imaSuffix)
        return click
    elseif _objectKey == Const.CollectionFoundBtnKey.Status then
        ---获取收集进度的背景图
        local status = bgd:GetChild(this.collectionAnimalStatusWord..this.imaSuffix)
        return status
    elseif _objectKey == Const.CollectionFoundBtnKey.UnlockEffect then
        ---获取解锁特效 图片
        local unlock = bgd:GetChild(this.unlockEffectWord..this.imaSuffix)
        return unlock
    elseif _objectKey == Const.CollectionFoundBtnKey.FlashEffect then
        ---获取闪光特效 图片
        local flash = bgd:GetChild(this.flashEffectWord..this.imaSuffix)
        return flash
    elseif _objectKey == Const.CollectionFoundBtnKey.TipBtn then
        local tip = bgd:GetChild(this.tipInfoWord..this.btnSuffix)
        return tip
    end
end

---Panel移动的通用方法
---@param _leftbtn UiButtonObject 左滑Btn
---@param _rightBtn UiButtonObject 右滑Btn
---@param _tween tweenObject 临时存储的Tween
---@param _panel UiPanelObject 要移动的Panel
---@param _isAdd boolean 是否是增加当前ScrollScale
function CollectionGui:PanelMoveByClickBtn(_leftbtn,_rightBtn,_tween,_panel,_isAdd)
    if _tween then
        _tween:Complete()
    end
    
    
    local Scale = _panel.ScrollScale
    if _isAdd and Scale ~= 100 then
        Scale = Scale + this.panelMoveUnit

        Scale = math.Clamp(Scale,0,100)
        _tween = Tween:TweenProperty(_panel,{ScrollScale = Scale},0.15,Enum.EaseCurve.CubicOut)
        _tween.OnComplete:Connect(
            function ()
                _tween:Destroy()
                local new = _panel.ScrollScale
                if new == 0 then
                    _leftbtn.Alpha = this.darkAlpha
                    _leftbtn.Clickable = false
                    --this.collectionPanelLeftBtnClickEffect:SetActive(false)
                    --CollectionGui:StopClickEffect(this.collectionPanelLeftBtnClickEffect)
                elseif new == 100 then
                    _rightBtn.Alpha = this.darkAlpha
                    _rightBtn.Clickable = false 
                    --this.collectionPanelRightBtnClickEffect:SetActive(false)
                    --CollectionGui:StopClickEffect(this.collectionPanelRightBtnClickEffect)
                else
                    _leftbtn.Alpha = 1
                    _leftbtn.Clickable = true
                    _rightBtn.Alpha = 1
                    _rightBtn.Clickable = true 
                end

                if _leftbtn == this.collectionPanelLeftBtn then
                    CollectionGui:LeftAndRightMoveBtnShowTip()
                end
            end
        )
        _tween:Play()

    elseif not _isAdd and Scale ~= 0 then
        Scale = Scale - this.panelMoveUnit
        Scale = math.Clamp(Scale,0,100)

        _tween = Tween:TweenProperty(_panel,{ScrollScale = Scale},0.15,Enum.EaseCurve.CubicOut)
        _tween.OnComplete:Connect(
            function ()
                _tween:Destroy()
                local new = _panel.ScrollScale
                if new == 0 then
                    _leftbtn.Alpha = this.darkAlpha
                    _leftbtn.Clickable = false
                elseif new == 100 then
                    _rightBtn.Alpha = this.darkAlpha
                    _rightBtn.Clickable = false 
                else
                    _leftbtn.Alpha = 1
                    _leftbtn.Clickable = true
                    _rightBtn.Alpha = 1
                    _rightBtn.Clickable = true 
                end

                if _rightBtn == this.collectionPanelRightBtn then
                    CollectionGui:LeftAndRightMoveBtnShowTip()
                end
            end
        )
        _tween:Play()
    end
    
end

---Panel滚动按钮初始化
function CollectionGui:PanelMoveBtnShow(_leftBtn,_rightBtn,_panel)
    local Scale = _panel.ScrollScale
    if _panel.ScrollRange <= _panel.FinalSize.x then
        _leftBtn.Alpha = this.darkAlpha
        _leftBtn.Clickable = false
        _rightBtn.Alpha = this.darkAlpha
        _rightBtn.Clickable = false
    else
        if Scale == 0 then
            _leftBtn.Alpha = this.darkAlpha
            _leftBtn.Clickable = false
            _rightBtn.Alpha = 1
            _rightBtn.Clickable = true
        elseif Scale == 100 then
            _rightBtn.Alpha = this.darkAlpha
            _rightBtn.Clickable = false
            _leftBtn.Alpha = 1
            _leftBtn.Clickable = true
        end
    end
end

---进入CreatureGui 前，生物子界面 生物切换按钮初始化
function CollectionGui:InitChangeCreatureBtn()
    local c = C_Collection.allCreature[this.openCreatureKey]
    local oldIndex = c.collectionIndex_
    local previous = C_Collection:RetureTypeByCollectionIndex(oldIndex - 1)
    local next = C_Collection:RetureTypeByCollectionIndex(oldIndex + 1)
	if QuestMgr.tutorialComplete then
		this.creaturePreviousBtn:SetActive(true)
		this.creatureNextBtn:SetActive(true)
	end
    if not previous then
        this.creaturePreviousBtn.Alpha = this.darkAlpha
        this.creaturePreviousBtn.Clickable = false
    end
    if not next then
        this.creatureNextBtn.Alpha = this.darkAlpha
        this.creatureNextBtn.Clickable = false
    end
end

---播放 前置的 解锁动效
---@param _btn UiButtonObject 当前播放动效的已发现按钮
function CollectionGui:PlayUnlockEffect(_btn)
    
    local start = function ()
        ---音效播放
        CollectionGui:PlaySound(this.collectionCompleteSound)

        local status = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Status)
        local deltaX = (this.unlockBigSize.x - status.Size.x) / this.UnlockBigNum
        local deltaY = (this.unlockBigSize.y - status.Size.y) / this.UnlockBigNum
        
        ---换图
        local changeTexture = function ()
            --local delay = this.effectFrame * 1000 * (this.UnlockBigNum - 1)
            local unlock = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.UnlockEffect)
            for i = 1, this.unlockEffectNum do
                local texture = function ()
                    unlock.Texture = ResourceManager.GetTexture(this.effectUnlockRoot..tostring(i))
                    if i == this.unlockEffectNum then
                        C_TimeMgr:AddDelayTimeEvent(this.flashEffectClapNum * this.effectFrame * 1000,CollectionGui.PlayFlashEffect,CollectionGui,_btn)
                    end
                end
                C_TimeMgr:AddDelayTimeEvent(this.effectFrame * 1000 * (i - 1),texture)
            end
        end

        ---放大
        for i = 1, this.UnlockBigNum do
            local bigFunc = function ()
                
                local newSize = Vector2(status.Size.x + i * deltaX,status.Size.y + i * deltaY)
                status.Size = newSize
                local progress = status:GetChildren()
                for index, value in ipairs(progress) do
                    value.Size = newSize
                end
                if i == this.UnlockBigNum then
                    status:SetActive(false)
                    C_TimeMgr:AddDelayTimeEvent(0,changeTexture)
                end
            end 
            C_TimeMgr:AddDelayTimeEvent(this.effectFrame * 1000 * (i - 1),bigFunc)
        end
    end

    C_TimeMgr:AddDelayTimeEvent(this.effectFrame * 1000 * this.prepareUnlockNum,start)
    
end

---播放闪光动效 
---@param _btn UiButtonObject 当前播放动效的已发现按钮
function CollectionGui:PlayFlashEffect(_btn)
    local flash = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.FlashEffect)
    if flash.ActiveSelf then
        for i = 1, this.flashEffectNum do
            local func = function ()
                if flash.ActiveSelf then
                    flash.Texture = ResourceManager.GetTexture(this.effectFlashRoot..tostring(i))
                    if i == this.flashEffectNum then
                        ---一次循环结束
                        flash.Alpha = 0
                        C_TimeMgr:AddDelayTimeEvent(this.flashEffectClapNum * this.effectFrame * 1000,CollectionGui.PlayFlashEffect,CollectionGui,_btn)
                    elseif i == 1 then
                        ---开始
                        flash.Alpha = 1
                    end
                end
                
            end
            C_TimeMgr:AddDelayTimeEvent(this.effectFrame * 1000 * (i - 1),func)
        end
    end
end 

function CollectionGui:StopUnlockEffect(_btn)
    local unlock = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.UnlockEffect)
    unlock:SetActive(false)
    local status = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.Status)
    status.Size = this.lockSize
    for index, value in ipairs(status:GetChildren()) do
        value.Size = this.lockSize
    end
    unlock.Alpha = 1
end

function CollectionGui:StopFlashEffect(_btn)
    local flash = CollectionGui:ConfirmCollectionFoundBtnObj(_btn,Const.CollectionFoundBtnKey.FlashEffect)
    flash:SetActive(false)    
end

---指定音效播放
---@param _sound AudioSource 音效文件
function CollectionGui:PlaySound(_sound)
    if _sound then
        _sound:Play()
    else
        print("音效文件不存在")
    end
end

---按钮的统一动效
---@param _btnObj gameObject 按钮
---@param _firstValue float 第一步变化倍数
---@param _secondValue float 第二步变化倍数
---@param _firstTime float 第一步变化时间
---@param _secondTime float 第二步变化时间
---@param _key string 主键
---@param _func function 动效播放后执行的函数
---@param _isFromSmallToBig boolean 是否是播放时从最小大小（0）开始
function CollectionGui:InitBtnTween(_ImaObj,_firstValue,_secondValue,_firstTime,_secondTime,_key,_func,_isFromSmallToBig)
    local oldSize = _ImaObj.Size

    this.activeBtnTweenTable[_key] = {}
    local root = this.activeBtnTweenTable[_key]
    
    if _firstValue < _secondValue then
        ---先变小后变大
        root.firstTween_ = Tween:TweenProperty(_ImaObj,{Size = _firstValue * oldSize},_firstTime,Enum.EaseCurve.Linear)
        root.secondTween_ = Tween:TweenProperty(_ImaObj,{Size = _secondValue * oldSize},_secondTime,Enum.EaseCurve.CubicOut)
    else
        ---先变大后变小
        root.firstTween_ = Tween:TweenProperty(_ImaObj,{Size = _firstValue * oldSize},_firstTime,Enum.EaseCurve.CubicOut)
        root.secondTween_ = Tween:TweenProperty(_ImaObj,{Size = _secondValue * oldSize},_secondTime,Enum.EaseCurve.Linear)
    end
    
    
    root.firstTween_.OnPlay:Connect(
        function ()
           
        end
    )
    root.firstTween_.OnComplete:Connect(
        function ()
            root.secondTween_:Play()
        end
    )
    root.secondTween_.OnComplete:Connect(
        function ()
            if _func then
                _func()
            end
        end
    )
end

---特殊行为区域生成点击提示
---@param _creatureTable table 生物表
---@param _obj UiObject 变化的组件
---@param _behaviorKey int 生成行为区域
---@param _uiLevel int 当前Ui层级
function CollectionGui:InitCreatureBehaviorTween(_creatureTable,_obj,_behaviorKey)
    --[[
    for index, value in ipairs(C_Collection.allCreature) do
        for i = 1, Const.SpecialBehaviorNum do
            local obj = CollectionGui:ConfirmBehaviorObj(i,Const.SpecialBehaviorObjectKey.Background)
            local btt = value.behaviorTipTween_[i]
            btt.negTween_ = Tween:TweenProperty(obj,{Size = Vector2(- 1 * this.tipToClickSize.x,- 1 * this.tipToClickSize.y)},1,Enum.EaseCurve.Linear)
            btt.posTween_ = Tween:TweenProperty(obj,{Size = this.tipToClickSize},1,Enum.EaseCurve.Linear)
            btt.negTween_.OnComplete:Connect(
                function ()
                    btt.status_ = btt.posTween_
                    btt.posTween_:Play()
                end
            )
            btt.posTween_.OnComplete:Connect(
                function ()
                    btt.status_ = btt.negTween_
                    btt.negTween_:Play()
                end
            )
        end
    end
    --]]

    local btt = this.tipTweenTable[_behaviorKey]
    local trigger = btt.status_
    local startSize = _obj.Size
    btt.negTween_ = Tween:TweenProperty(_obj,{Size = 0.9 * this.tipToClickStartSize},1,Enum.EaseCurve.Linear)
    btt.posTween_ = Tween:TweenProperty(_obj,{Size = 1.1 * this.tipToClickStartSize},1,Enum.EaseCurve.Linear)
    btt.negTween_.OnComplete:Connect(
        function ()
            btt.status_ = btt.posTween_
            if btt.posTween_ then
                btt.posTween_:Play()
            end
        end
    )
    btt.posTween_.OnComplete:Connect(
        function ()
            btt.status_ = btt.negTween_
            if btt.negTween_ then
                btt.negTween_:Play()
            end
        end
    )

    if not btt.status_ then
        btt.negTween_:Play()
    end
end

---特殊行为区域点击提示销毁
---@param _creatureTable table 生物表
---@param _obj UiObject 变化的组件
---@param _behaviorKey int 生成行为区域
function CollectionGui:DestroyCreatureBehaviorTween(_creatureTable,_obj,_behaviorKey)
    local btt = this.tipTweenTable[_behaviorKey]
    if btt.negTween_ then
        btt.negTween_:Destroy()
    end
    if btt.posTween_ then
        btt.posTween_:Destroy()
    end
    _obj.Size = this.tipToClickStartSize
end

---图鉴主界面卷轴，根据当前Panel进度得出屏幕范围
---@param _scale float panel的ScrollScale
function CollectionGui:ReturnScreenScaleByCollectionPanel(_scale)
    local scale = math.Clamp(_scale,0,100)
    ---Panel长度确定
    local x = this.collectionPanel.ScrollRange
    local finalSize = this.collectionPanel.FinalSize
    ---屏幕在图鉴背景图的相对长度
    local relatively = finalSize.x / x
    --print(finalSize.x / x,relatively)
    ---卷轴滑至100%时
    local maxX = (x - finalSize.x) / x
    --print(maxX)
    ---根据当前Panel进度确定屏幕范围
    local deltaX = (maxX - 0) / 100 * scale
    local deltaY = deltaX + relatively

    return Vector2(deltaX,deltaY)
end

---进入CollectionGui后，每次Panel移动，判断是否需要左滑、右滑按钮消息提示
function CollectionGui:LeftAndRightMoveBtnShowTip()
    local leftClick = this.collectionPanelLeftBtnClickEffect
    local rightClick = this.collectionPanelRightBtnClickEffect
    ---记录屏幕友方的可插入照片的动物数量
    local leftNum = 0
    ---记录屏幕左方的可插入照片的动物数量
    local rightNum = 0
    ---屏幕分布
    for key, value in ipairs(C_Collection.allCreature) do
        if value.isFound_ and value:CreatureInCollectionIsShow() then
            local btn = CollectionGui:ConfirmCollectionBtn(key,true)
            local bgd = CollectionGui:ConfirmCollectionFoundBtnObj(btn,Const.CollectionFoundBtnKey.Background)
            local obj = CollectionGui:ConfirmCollectionFoundBtnObj(btn,Const.CollectionFoundBtnKey.ClickEffect)
            
            local v1 = CollectionGui:TransformAnchorsXByRelation(obj.AnchorsX.x,bgd,btn)
            local newV = CollectionGui:TransformAnchorsXByRelation(v1,btn,this.collectionGui)
            local screenV = CollectionGui:ReturnScreenScaleByCollectionPanel(this.collectionPanel.ScrollScale)
            

            if newV <= screenV.y and newV >= screenV.x then
                ---该组件在屏幕内
                --print(value.name_.."在屏幕内")
                --[[
                this.collectionPanelLeftBtnClickEffect:SetActive(false)
                CollectionGui:StopClickEffect(this.collectionPanelLeftBtnClickEffect)
                this.collectionPanelRightBtnClickEffect:SetActive(false)
                CollectionGui:StopClickEffect(this.collectionPanelRightBtnClickEffect)
                --]]
            elseif newV < screenV.x then
                ---该组件不在屏幕内,在屏幕左方
                --print(value.name_.."在屏幕左方")
                leftNum = leftNum + 1
            else
                ---该组件不在屏幕内,在屏幕友方
                --print(value.name_.."在屏幕友方")
                rightNum = rightNum + 1
            end
        end
    end
    --print(leftNum,rightNum)
    if leftNum > 0 then
        if not leftClick.ActiveSelf and leftClick.Parent.Clickable then
            leftClick:SetActive(true)
            CollectionGui:PlayClickEffect(leftClick)
        elseif not leftClick.Parent.Clickable then
            leftClick:SetActive(false)
            CollectionGui:StopClickEffect(leftClick)
        end
    else
        leftClick:SetActive(false)
        CollectionGui:StopClickEffect(leftClick)
    end

    if rightNum > 0 then
        if not rightClick.ActiveSelf and rightClick.Parent.Clickable then
            rightClick:SetActive(true)
            CollectionGui:PlayClickEffect(rightClick)
        elseif not rightClick.Parent.Clickable then
            rightClick:SetActive(false)
            CollectionGui:StopClickEffect(rightClick)
        end
    else
        rightClick:SetActive(false)
        CollectionGui:StopClickEffect(rightClick)
    end
end

---将子对象的AnchorsX转换成父对象anchors(中心锚点)
function CollectionGui:TransformAnchorsXByRelation(_sonAnchorsX,_dad,_grandpa)
    ---确认子对象与父对象的像素差
    local deltaX = (_sonAnchorsX - 0.5) * _dad.Size.x
    ---像素差转换成祖父对象坐标系
    local aX = deltaX / _grandpa.Size.x
    local x = aX + _dad.AnchorsX.x
    return x
end

---动物自动音效播放
function CollectionGui:CreatureSoundAutoPlay(_creatureTable)
    if this.isAutoSoundPlay then
        ---音效播放
        C_AudioMgr:HandbookSound(_creatureTable.bigKeyName_)
        this.isAutoSoundPlay = false
    end
end

---卷轴从零开始时，子节点相对于屏幕的x坐标（0~1） 关系 panel-bgd-son
function CollectionGui:GetStartScreenAnhcorsX(_bgd,_panel,_sonAnchorsX)
    ---屏幕长度
    local screenPixel = this.collectionPanel.FinalSize.x
    ---子节点绝对位置
    local sonPixel = _bgd.Size.x * _sonAnchorsX
    ---子节点现在AnchorsX
    local ax = sonPixel / screenPixel
    
    return ax
end

---卷轴移动时，返回某个子节点的相对屏幕的x坐标（0~1）
function CollectionGui:GetSonScreenAnchorsX(_bgd,_panel,_sonAnchorsX)
    local scale = _panel.ScrollScale / 100
    local start = CollectionGui:GetStartScreenAnhcorsX(_bgd,_panel,_sonAnchorsX)
    local new = start - scale

    return new
end

---若使子节点处于屏幕中心，返回此时的ScrollScale
function CollectionGui:GetPanelSrollScaleBySon(_bgd,_panel,_sonAnchorsX)
    local oldx = CollectionGui:GetSonScreenAnchorsX(_bgd,_panel,_sonAnchorsX)
    ---与屏幕中心的差值
    local cha = math.abs((oldx - 0.5) * 100)
    if oldx > 0.5 then
        ---子节点在当前屏幕右方
        cha = _panel.ScrollScale + cha

    elseif oldx < 0.5 then
        ---子节点在当前屏幕左方
        cha = _panel.ScrollScale - cha

    else
        cha = _panel.ScrollScale
    end
    cha = math.Clamp(cha,0,100)
    return cha
end

---进入CollectionGui前，图鉴卷轴移动至可点击的按钮为屏幕中心的位置
function CollectionGui:CollectionPanelMoveBySon()
    ---按卷轴排列顺序，位置靠后优先移动
    local minIndex = 0
    local moveKey = 0
    
    ---遍历生物表，找出移动的中心节点
    for key, value in ipairs(C_Collection.allCreature) do
        if value.isFound_ and value:CreatureInCollectionIsShow() then
            if value.collectionIndex_ > minIndex then
                moveKey = key
                minIndex = value.collectionIndex_
            end
        end
    end
    
    ---若有移动中心节点，则开始移动
    if moveKey ~= 0 then
        local foundBtn = CollectionGui:ConfirmCollectionBtn(moveKey,true)
        local scale = CollectionGui:GetPanelSrollScaleBySon(this.collectionGui,this.collectionPanel,foundBtn.AnchorsX.x)
        local tween = this.collectionPanelAutoMoveTween
        tween = Tween:TweenProperty(this.collectionPanel,{ScrollScale = scale},0.5,Enum.EaseCurve.CubicOut)
        tween.OnComplete:Connect(
            function ()
                tween:Destroy()

                CollectionGui:CollectionPanelMoveBtnChange()

                CollectionGui:LeftAndRightMoveBtnShowTip()
                
            end
        )
        tween:Play()
    end
end

---销毁tween
function CollectionGui:DestroyTween(_tween)
    if _tween then
        _tween:Destroy()
    end
end

---获取未发现按钮下组件
function CollectionGui:ConfirmCollectionNotFoundBtnObj(_btn,_objectKey)
    local notFoundIma = _btn:GetChild(this.collectionNotFoundImaWord..this.imaSuffix)
    if _objectKey == Const.CollectionNotFoundBtnKey.NotFoundIma then
        ---未发现按钮下的 问号图
        return notFoundIma
    elseif _objectKey == Const.CollectionNotFoundBtnKey.TipBtn then
        ---未发现按钮下的 提示点击按钮
        local tip = notFoundIma:GetChild(this.tipInfoWord..this.btnSuffix)
        return tip
    end
end

---进入Behavior前，根据特殊卷轴照片数量决定特殊卷轴ScrollScale
---@param _panelNum int 要显示的特殊卷轴照片数量
---@param _behaviorPanel UiPanelObject 特殊卷轴组件
function CollectionGui:SetBehaviorPanelScale(_behaviorPanel,_panelNum)
 
    if _panelNum > this.photoBgdArchetypeMaxNum then
        local x = _behaviorPanel.FinalSize.x
        local claps = _panelNum - this.photoBgdArchetypeMaxNum
        local x1 = claps * this.photoBgdArchetypeClapX
        x1 = x1 * x
        _behaviorPanel.ScrollRange = x1 + x
    else
        _behaviorPanel.ScrollRange = _behaviorPanel.FinalSize.x
    end
end

---图鉴卷轴下滑动按钮自动变化
function CollectionGui:CollectionPanelMoveBtnChange()
    
    local Scale = this.collectionPanel.ScrollScale
    local leftBtn = this.collectionPanelLeftBtn
    local rightBtn = this.collectionPanelRightBtn

    local finalSize = this.collectionPanel.FinalSize
    local x = (finalSize.y / this.rainForestSize.y) * this.rainForestSize.x

    if x <= finalSize.x then
        leftBtn.Alpha = 0
        leftBtn.Clickable = false
        rightBtn.Alpha = 0
        rightBtn.Clickable = false
    elseif Scale == 0 then 
        leftBtn.Alpha = this.darkAlpha
        leftBtn.Clickable = false
        rightBtn.Alpha = 1
        rightBtn.Clickable = true 
        this.collectionPanelLeftBtnClickEffect:SetActive(false)
        CollectionGui:StopClickEffect(this.collectionPanelLeftBtnClickEffect)
    elseif Scale == 100 then
        rightBtn.Alpha = this.darkAlpha
        rightBtn.Clickable = false 
        leftBtn.Alpha = 1
        leftBtn.Clickable = true
        this.collectionPanelRightBtnClickEffect:SetActive(false)
        CollectionGui:StopClickEffect(this.collectionPanelRightBtnClickEffect)
    else
        leftBtn.Alpha = 1
        leftBtn.Clickable = true
        rightBtn.Alpha = 1
        rightBtn.Clickable = true 
    end
end

---检测新手引导是否完成插入照片操作
function CollectionGui:CheckForTutorialComplete()
    ---杰克代码
    local tutorialPhotoInserted = false
    for k,v in pairs(C_Collection.allCreature[Config.Quest[20002].ObjectiveID].specialBehavior_) do
        if v.stickPhoto_ ~= nil then tutorialPhotoInserted = true end
    end
    return tutorialPhotoInserted
end
return CollectionGui