---相册
---Author Chen Muru

local AlbumGui, this = ModuleUtil.New('AlbumGui', ClientBase)

local Photo = {}
function Photo:Initialize(_name, _star, _scrShot)
    self.name = _name or 'none'
    self.srcShot = _scrShot
    self.id = UUID()
    self.thumbnail = AlbumGui:CreatePhotoObj(_scrShot)
    self.date = tostring(os.date('%Y-%m-%d %H:%M:%S'))
    self.bChecked = false
    self.star = _star
    self.url = nil
    self.frameColor = 'White'
    self:BindThumbnailCallBack()
end

function Photo:BindThumbnailCallBack()
    local thumbnail = self.thumbnail
    thumbnail.NormalFrame.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self:OpenSinglePhoto()
        end
    )
    thumbnail.NewFrame.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self:OpenSinglePhoto()
            self:HideNewFrame()
        end
    )
end

function Photo:OpenSinglePhoto()
    AlbumGui:SetSelectedPhoto(self)
    AlbumGui:RefrshSinglePhotoInfo()
    AlbumGui.singlePhotoBg:SetActive(true)
end

function Photo:GetId()
    return self.id
end

function Photo:GetInfo(infoKey)
    return self[infoKey]
end

function Photo:SetInfo(infoKey, val)
    self[infoKey] = val
end

function Photo:DetroyThumbnail()
    self.thumbnail:Destroy()
end

function Photo:SetState(state)
    self.state = state
end

function Photo:HideNewFrame()
    self.thumbnail.NewFrame:SetActive(false)
end

function Photo:CheckIfHideNewFrame()
    if self.bChecked then
        self:HideNewFrame()
    end
end

local uploadMsg = -1
local url
local upLoadCallback = function(_msg, _url)
    uploadMsg = _msg
    url = _url
end

function Photo:UploadTexture()
    ScreenCapture.UploadScreenshot(self.srcShot, upLoadCallback)
    C_TimeMgr:AddRTEvent(
        100,
        function(self)
            if uploadMsg == 0 then
                self:SetPhotoUrl(url)
                uploadMsg = -1
                return true
            end
            return false
        end,
        0,
        self
    )
end

function Photo:SetPhotoUrl(url)
    self.url = url
end

function Photo:GetPhotoUrl(url)
    return self.url
end

function Photo:GetShotSrc()
    return self.srcShot
end

local smallFrameResoure = 'UI/Album/SmallFrame/'
local bigFrameResoure = 'UI/Album/BigFrame/'
function Photo:SetFrameColor(colorVal)
    self.frameColor = colorVal
    local thumbnail = self.thumbnail
    local smallFramePath = smallFrameResoure .. colorVal
    print('smallFramePath: ', smallFramePath)
    thumbnail.NormalFrame.Texture = ResourceManager.GetTexture(smallFramePath)
end

function Photo:CheckIfChangeFrameColor()
    if self.frameColor ~= 'White' then
        self:SetFrameColor(self.frameColor)
    end
end

function Photo:GetFrameColor()
    return self.frameColor
end

local rarityWord_cn = {
    '嗯，是常见的${var}，在野外比较容易遇到。',
    '哇！是比较少见的${var}，不是随处可见的动物呢。',
    '呀！是极其罕见的${var}，真的是很难见到的动物呀'
}
local describeWord_cn = {
    '它在${var1}呢！拍到这样的${var2}还算普通啦。',
    '它在${var1}呢！拍到这样的${var2}需要运气呢~',
    '它在${var1}呢！拍到这样的${var2}太难得了！',
    '它在${var1}呢！拍到这样的${var2}十分幸运呢！'
}

local rarityWord_en = {
    'Yep, it’s an ordinary ${var} commonly encountered in the wild.',
    'Wow, it’s a rare ${var}. You don’t see these every day.',
    'Incredible, ${var}! I thought these were extinct!'
}
local describeWord_en = {
    'Hey, look, it’s a ${var1} ${var2}. Cool.',
    'Wow, it’s a ${var1} ${var2}. Luck was definitely on your side.',
    'Amazing, a ${var1} ${var2}! This is incredibly rare!',
    'Would you look at that? A ${var1} ${var2}! That’s so lucky of you!'
}

local rarityWord_key = {
    'ProjectDarwin_Camera_1',
    'ProjectDarwin_Camera_2',
    'ProjectDarwin_Camera_3'
}
local describeWord_key = {
    'ProjectDarwin_Camera_4',
    'ProjectDarwin_Camera_5',
    'ProjectDarwin_Camera_6',
    'ProjectDarwin_Camera_7'
}

local GetRandomStringInTable = function(table)
    return table[math.random(#table)]
end

local dummyTextForAnimalName
local dummyTextForState

function Photo:GenPhotoAssess(clsName, rarity)
    local rarity = rarity or 1
    local name = self.name
    if self.star == 1 then
        self.assess = ' '
        return
    end
    dummyTextForAnimalName.LocalizeKey = CamGui:GetAnimalLocalizeKey(self.name)
    dummyTextForState.LocalizeKey = Config.CreatureBehavior[clsName][self.star].LocalizeKey
    local animalName = dummyTextForAnimalName.Text
    local state = dummyTextForState.Text
    dummyTextForState.LocalizeKey = rarityWord_key[rarity]
    dummyTextForState.Variable1 = animalName
    local rarityWord = dummyTextForState.Text
    dummyTextForState.LocalizeKey = describeWord_key[self.star]
    dummyTextForState.Variable1 = state
    dummyTextForState.Variable2 = animalName
    local describeWord = dummyTextForState.Text
    self.assess = rarityWord .. describeWord
end

function Photo:GetPhotoAssess()
    return self.assess
end

local Sticker = {}
function Sticker:Initialize(_name)
    self.name = _name
    local stickerOnPhotoBg = AlbumGui.stickerOnPhotoBg
    local obj = world:CreateInstance(_name, _name, stickerOnPhotoBg)
    obj.Offset = Vector2(0, 0)
    local dragUi = GuiUtil.CreateDragUi(obj.TouchBtn, obj, stickerOnPhotoBg)
    dragUi.OnDragBegin = function()
        obj:ToTop()
    end
    self.obj = obj
    self.id = UUID()
    self:BindBtnEventCallback()
    self.fliped = false
    self:SelectSticker()
end

function Sticker:CancelSelectStatus()
    local obj = self.obj
    if not self.fliped then
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/' .. self.name)
    else
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/Fliped' .. self.name)
    end
    obj.TouchBtn:SetActive(false)
end

function Sticker:SelectSticker()
    self:SetSelectStatus()
    AlbumGui:SetCurOperatedSticker(self)
    AlbumGui:SetEditToolActivity(true)
end

function Sticker:SetSelectStatus()
    local obj = self.obj
    if not self.fliped then
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/Sel' .. self.name)
    else
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/SelFliped' .. self.name)
    end
    obj.TouchBtn:SetActive(true)
end

function Sticker:BindBtnEventCallback()
    local obj = self.obj
    local touchBtn = obj.TouchBtn
    --obj.OnDown:Connect(function()
    --    touchBtn:SetActive(true)
    --end)
    obj.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self:SelectSticker()
        end
    )
    touchBtn.OnRotateStay:Connect(
        function(pos1, pos2, signedAngle, signedAnglespeed)
            local angle = obj.Angle - signedAngle
            obj.Angle = angle
            touchBtn.Angle = angle
        end
    )
    touchBtn.OnPinchStay:Connect(
        function(pos1, pos2, deltaSize, pinchSpeed)
            obj.Size = obj.Size + Vector2.One * deltaSize
            touchBtn.Size = touchBtn.Size + Vector2.One * deltaSize
        end
    )
end

function Sticker:DestroyStickerObj()
    self.obj:Destroy()
end

function Sticker:DeleteSticker()
    self:DestroyStickerObj()
    AlbumGui:DeleteSingleSticker(self.id)
end

function Sticker:Rotate()
    local obj = self.obj
    obj.Angle = obj.Angle + 30
end

function Sticker:ChangeStickerSize(coe)
    local obj = self.obj
    local touchBtn = obj.TouchBtn
    obj.Size = obj.Size * coe
    touchBtn.Size = touchBtn.Size * coe
end

function Sticker:FlipSticker()
    local obj = self.obj
    if self.fliped then
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/Sel' .. self.name)
    else
        obj.Texture = ResourceManager.GetTexture('UI/Album/Sticker/SelFliped' .. self.name)
    end
    self.fliped = not self.fliped
end

local StickerPrefab = {}
function StickerPrefab:Initialize(_obj)
    self.obj = _obj
    self.name = _obj.Name
    self:BindBtnEventCallback()
end

function StickerPrefab:BindBtnEventCallback()
    self.obj.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            AlbumGui:CtreateSticker(self.name)
        end
    )
end

local FrameColorBtn = {}
function FrameColorBtn:Initialize(_obj)
    self.obj = _obj
    self.color = _obj.Name
    self:BindBtnEventCallback()
end

function FrameColorBtn:BindBtnEventCallback()
    self.obj.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            AlbumGui:SetFrameColor(self.color)
        end
    )
end

function AlbumGui:Init()
    self.albumGui = localPlayer.Local.AllbumGui
    dummyTextForAnimalName = self.albumGui.dummyTextForAnimalName
    dummyTextForState = self.albumGui.dummyTextForState
    self.allPhotoBg = self.albumGui.AllPhotoBg
    self.allPhotoPnl = self.allPhotoBg.AllPhotoPnl
    self.quit = self.allPhotoBg.Quit
    self.singlePhotoBg = self.albumGui.SinglePhotoBg
    local singlePhotoBg = self.singlePhotoBg
    self.singlePhotoImg = singlePhotoBg.SinglePhotoImg
    self.singlePhotoNewFrame = self.singlePhotoImg.NewFrame
    self.leftSinglePhoto = singlePhotoBg.LeftPage
    self.rightSinglePhoto = singlePhotoBg.RightPage
    self.openDeleteHint = singlePhotoBg.OpenDeleteHint
    self.deleteHint = singlePhotoBg.DeleteHint
    self.deletePhoto = self.deleteHint.DeletePhoto
    self.keepPhoto = self.deleteHint.KeepPhoto
    local infoBg = singlePhotoBg.InfoBg
    self.takePhotoTimeTxt = infoBg.TakePhotoTime
    self.animalNameTxt = infoBg.AnimalName
    self.bInCollectionHintTxt = singlePhotoBg.bInCollectionHintTxt
    self.backToAllPhotoBtn = singlePhotoBg.BackToAllPhotoBtn
    self.openEditBg = singlePhotoBg.EditBtn
    self.editPhotoBg = self.albumGui.EditPhotoBg
    local editPhotoBg = self.editPhotoBg
    self.editedPhoto = editPhotoBg.Photo
    self.editedFrame = self.editedPhoto.Frame
    self.stickerOnPhotoBg = self.editedPhoto.StickerOnPhotoBg
    self.operationHint = editPhotoBg.OperationHint
    self.saveEditedPhoto = editPhotoBg.SavePhoto
    self.backToSinglePhoto = editPhotoBg.BackToSinglePhotoBtn
    self.rotateSticker = editPhotoBg.RotateSticker
    self.flipSticker = editPhotoBg.FlipSticker
    self.enlargeSticker = editPhotoBg.EnlargeSticker
    self.shrinkSticker = editPhotoBg.ShrinkSticker
    self.deleteSticker = editPhotoBg.DeleteSticker

    self.allPhoto = {}
    self.photoArrangedByStar = {}
    self.photoInCollection = {}
    self.selectedPhoto = nil
    self.allSticker = {}
    self.curSinglePhotoIndex = 0
    self.curFrameColor = 'White'
    self:BindBtnEventCallback()
    self:InitAllStickerTool()
    self:SetEditToolActivity(false)
    self:DownloadDataStorge()
end

function AlbumGui:BindBtnEventCallback()
    self.quit.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            ---region 红点提示 一川
            CollectionGui:IsShowNotification()
            ---endregion
            self:SetAlbumGuiActivity(false)
        end
    )
    self.backToAllPhotoBtn.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self.singlePhotoBg:SetActive(false)
            self.deleteHint:SetActive(false)
            --self:OpenSinglePhotoGui(false)
        end
    )
    self.openDeleteHint.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self.deleteHint:SetActive(true)
        end
    )
    self.keepPhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self.deleteHint:SetActive(false)
        end
    )
    self.deletePhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.DeletePhoto)
            self:DeleteSelectedPhoto()
        end
    )
    self.leftSinglePhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self:TurnOverPhoto(-1)
        end
    )
    self.rightSinglePhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self:TurnOverPhoto(1)
        end
    )
    self.openEditBg.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self.deleteHint:SetActive(false)
            self.editPhotoBg:SetActive(true)
            local selectedPhoto = self.selectedPhoto
            self.editedPhoto.Texture = selectedPhoto:GetShotSrc()
            self.editedFrame.Texture = ResourceManager.GetTexture(bigFrameResoure .. selectedPhoto:GetFrameColor())
        end
    )
    self.backToSinglePhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            self.editPhotoBg:SetActive(false)
            self:ClearAllSticker()
            self:SetEditToolActivity(false)
            self:SetFrameColor('White')
        end
    )
    self.rotateSticker.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            if self.curOperatedSticker then
                self.curOperatedSticker:Rotate()
            end
        end
    )
    self.deleteSticker.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.DeletePhoto)
            if self.curOperatedSticker then
                self.curOperatedSticker:DeleteSticker()
            end
        end
    )
    self.enlargeSticker.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            if self.curOperatedSticker then
                self.curOperatedSticker:ChangeStickerSize(1.1)
            end
        end
    )
    self.shrinkSticker.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            if self.curOperatedSticker then
                self.curOperatedSticker:ChangeStickerSize(0.9)
            end
        end
    )
    self.flipSticker.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.Click)
            if self.curOperatedSticker then
                self.curOperatedSticker:FlipSticker()
            end
        end
    )
    self.saveEditedPhoto.OnClick:Connect(
        function()
            AudioUtil:Play(localPlayer.Local.Sfx.SavePhoto)
            self:SaveEditedPhoto()
        end
    )
    local cancelSelectStatus = function()
        self:ResetStickerStatus()
    end
    self.stickerOnPhotoBg.OnTouched:Connect(cancelSelectStatus)
    self.editedFrame.OnTouched:Connect(cancelSelectStatus)
    self.editPhotoBg.EditPhotoBg2.OnTouched:Connect(cancelSelectStatus)
end

local constDefPhotoNumOnEachRow = 4

function AlbumGui:ArrangePhoto()
    GuiUtil.ArrangeGui(self.allPhoto, 500, 450, 200, -700, constDefPhotoNumOnEachRow, 'thumbnail')
end

function AlbumGui:CreatePhotoObj(_scrShot)
    local newPhoto = world:CreateInstance('AlbumPhotoThumbnail', 'AlbumPhotoThumbnail', self.allPhotoPnl)
    newPhoto.Texture = _scrShot
    return newPhoto
end

function AlbumGui:CreateNewPhoto(...)
    local p = CreateNewObject(Photo, ...)
    table.insert(self.allPhoto, 1, p)
    self:ArrangePhoto()
    self:InsertPhotoInStarList(p)
    self:ResetAllPhotoPnlScrollRange()
    return p
end

--- 获得照片信息
function AlbumGui:GetPhotoData(id)
    local allPhoto = self.allPhoto
    for ii = #allPhoto, 1, -1 do
        if allPhoto[ii].id == id then
            return allPhoto[ii]
        end
    end
end

function AlbumGui:InsertPhotoInStarList(p)
    local star = p.star
    if not p.star then
        return
    end
    local name = p.name
    if not self.photoArrangedByStar[name] then
        self.photoArrangedByStar[name] = {}
    end
    local creatureTbl = self.photoArrangedByStar[name]
    if not creatureTbl[star] then
        creatureTbl[star] = {}
    end
    local starTable = creatureTbl[star]
    table.insert(starTable, 1, p)
    self:CheckIfNoticeFirstStarPhoto(name, star)
end

function AlbumGui:DeletePhoto(photo)
    if not photo then
        return
    end
    AudioUtil:Play(localPlayer.Local.Sfx.DeletePhoto)
    photo:DetroyThumbnail()
    local id = photo:GetId()
    for ii = #self.allPhoto, 1, -1 do
        if self.allPhoto[ii]:GetId() == id then
            table.remove(self.allPhoto, ii)
            break
        end
    end
    if photo.star then
        local starTbl = self.photoArrangedByStar[photo.name][photo.star]
        for ii = #starTbl, 1, -1 do
            if starTbl[ii]:GetId() == id then
                table.remove(starTbl, ii)
                break
            end
        end
        C_Collection:DeleteCreaturePhotoEvent(photo.name, photo.star)
    end
    photo = nil
    self:ArrangePhoto()
end

function AlbumGui:DeleteSelectedPhoto()
    self:OpenSinglePhotoGui(false)
    self.deleteHint:SetActive(false)
    self:DeletePhoto(self.selectedPhoto)
end

function AlbumGui:SetSelectedPhoto(_photo)
    self.selectedPhoto = _photo
end

function AlbumGui:RefrshSinglePhotoInfo()
    local selectedPhoto = self.selectedPhoto
    self.takePhotoTimeTxt.Text = selectedPhoto:GetInfo('date')
    self.animalNameTxt.Text = selectedPhoto:GetInfo('name')
    self.singlePhotoNewFrame:SetActive(not selectedPhoto:GetInfo('bChecked'))
    selectedPhoto:SetInfo('bChecked', true)
    selectedPhoto:HideNewFrame()
    self.singlePhotoImg.Texture = selectedPhoto:GetShotSrc()
    local frameColorVal = selectedPhoto:GetFrameColor()
    self.singlePhotoImg.NormalFrame.Texture = ResourceManager.GetTexture(bigFrameResoure .. frameColorVal)
end

function AlbumGui:SetAlbumGuiActivity(_val)
    self.albumGui:SetActive(_val)
    if _val then
        self:OpenSinglePhotoGui(false)
    end
end

function AlbumGui:OpenSinglePhotoGui(_val)
    self.allPhotoBg:SetActive(not _val)
    self.singlePhotoBg:SetActive(_val)
end

function AlbumGui:SetCreatureInfoEventHandler(photoId, state)
    for ii = #self.allPhoto, 1, -1 do
        local photo = self.allPhoto[ii]
        if photo.id == photoId then
            photo:SetState(state)
            break
        end
    end
end

function AlbumGui:CtreateSticker(...)
    local newSticker = CreateNewObject(Sticker, ...)
    self.allSticker[newSticker.id] = newSticker
end

--- 设置当前正在操作的贴纸
function AlbumGui:SetCurOperatedSticker(sticker)
    if self.curOperatedSticker and self.curOperatedSticker.id ~= sticker.id then
        self.curOperatedSticker:CancelSelectStatus()
    end
    self.curOperatedSticker = sticker
end

function AlbumGui:DeleteSingleSticker(stickerId)
    self.curOperatedSticker = nil
    self.allSticker[stickerId] = nil
    if GetTableLength(self.allSticker) < 1 then
        self:SetEditToolActivity(false)
    end
end

function AlbumGui:ClearAllSticker()
    for k, v in pairs(self.allSticker) do
        v:DestroyStickerObj()
        self.allSticker[k] = nil
    end
    self.curOperatedSticker = nil
end

function AlbumGui:RestoreFrameColor()
    self.curFrameColor = 'White'
    self.editedFrame.Texture = ResourceManager.GetTexture(bigFrameResoure .. 'White')
end

function AlbumGui:SetFrameColor(val)
    self.curFrameColor = val
    self.editedFrame.Texture = ResourceManager.GetTexture(bigFrameResoure .. self.curFrameColor)
end

--- @param val int 点击左侧-1，点击右侧为1
function AlbumGui:TurnOverPhoto(val)
    local nextPage = self.curSinglePhotoIndex + val
    local allPhoto = self.allPhoto
    local allPhotoNum = #allPhoto
    if nextPage < 1 then
        nextPage = 1
    end
    if nextPage > allPhotoNum then
        nextPage = allPhotoNum
    end
    self.curSinglePhotoIndex = nextPage
    local photo = allPhoto[nextPage]
    self.selectedPhoto = photo
    self:RefrshSinglePhotoInfo()
end

function AlbumGui:InitAllStickerTool()
    for _, v in pairs(self.editPhotoBg.StickerPrefab:GetChildren()) do
        CreateNewObject(StickerPrefab, v)
    end
    for _, v in pairs(self.editPhotoBg.PaletteBg:GetChildren()) do
        CreateNewObject(FrameColorBtn, v)
    end
end

function AlbumGui:SetEditToolActivity(val)
    self.rotateSticker:SetActive(val)
    self.flipSticker:SetActive(val)
    self.enlargeSticker:SetActive(val)
    self.shrinkSticker:SetActive(val)
    self.deleteSticker:SetActive(val)
end

function AlbumGui:SetPhotoSizeProportion(proportion)
    self.photoSizeproportion = proportion
    local albumGui = localPlayer.Local.AllbumGui
    local singlePhotoImg = albumGui.SinglePhotoBg.SinglePhotoImg
    local editedPhotoImg = albumGui.EditPhotoBg.Photo
    local tmp = {singlePhotoImg, editedPhotoImg, editedPhotoImg.StickerOnPhotoBg}

    local tmp02 = {editedPhotoImg.Frame, singlePhotoImg.NormalFrame}

    for _, v in ipairs(tmp) do
        GuiUtil.ResetGuiSizeByProportion(v, proportion)
    end
    for _, v in ipairs(tmp02) do
        GuiUtil.ResetSizeYByCoe(v, 1 / proportion)
    end
end

local path = './ScreenCapture'

--- 保存p图后的截图
function AlbumGui:SaveEditedPhoto()
    AudioUtil:Play(localPlayer.Local.Sfx.SavePhoto)
    self:ResetStickerStatus()
    self.editedFrame:SetActive(false)
    ScreenCapture.Screenshot(
        path,
        self.stickerOnPhotoBg,
        function(_scrShot)
            local photoData = self.selectedPhoto
            local o = self:CreateNewPhoto(photoData.name, nil, _scrShot)
            o:SetFrameColor(self.curFrameColor)
            o:UploadTexture()
        end
    )
    C_TimeMgr:AddDelayTimeEvent(
        100,
        function()
            self.editedFrame:SetActive(true)
        end
    )

    ---region 数据埋点 一川
    UploadLog('photograph_edit_click', 'C1004')
    ---endregion
end

--- 检测是否提示该插入星级照片
function AlbumGui:CheckIfNoticeFirstStarPhoto(creatureName, star)
    if not self.photoInCollection[creatureName] or not self.photoInCollection[creatureName][star] then
        return true
    end
    return false
end

--- 获得所有该生物该星级的照片
function AlbumGui:GetStarPhoto(creatureName, star)
    local creatureTbl = self.photoArrangedByStar[creatureName]
    if creatureTbl then
        if creatureTbl[star] then
            local starTbl = creatureTbl[star]
            local creatureInCollection = self.photoInCollection[creatureName]
            if creatureInCollection and creatureInCollection[star] then
                local curPicId = creatureInCollection[star].id
                for ii = #starTbl, 1, -1 do
                    if starTbl[ii].id == curPicId then
                        table.remove(starTbl, ii)
                        break
                    end
                    if not table.exists(self.allPhoto, starTbl[ii]) then
                        table.remove(starTbl, ii)
                        break
                    end
                end
            end
        end
        return creatureTbl[star]
    end
end

function AlbumGui:RemovePhotoFromPhotoArrangedByStar(id, creatureName, star)
    if not self.photoArrangedByStar[creatureName] then
        return
    end
    local starTbl = self.photoArrangedByStar[creatureName][star]
    if not starTbl then
        return
    end
    for ii = #starTbl, 1, -1 do
        if starTbl[ii].id == id then
            table.remove(starTbl, ii)
            break
        end
        if not table.exists(self.allPhoto, starTbl[ii]) then
            table.remove(starTbl, ii)
            break
        end
    end
end

local PhotoInCollection = {}

function PhotoInCollection:Initialize(id)
    local photo = AlbumGui:GetPhotoData(id)
    self.name = photo.name
    self.srcShot = photo.srcShot
    self.id = photo.id
    self.star = photo.star
    self.url = photo.url
end

function PhotoInCollection:GetShotSrc()
    return self.srcShot
end

--- 将照片插入图鉴
function AlbumGui:InsertPhotoInCollection(id)
    local p = CreateNewObject(PhotoInCollection, id)
    if not self.photoInCollection[p.name] then
        self.photoInCollection[p.name] = {}
    end
    local creatureTbl = self.photoInCollection[p.name]
    local prePhoto = creatureTbl[p.star]
    if prePhoto then
        local preId = prePhoto.id
        for ii = #self.allPhoto, 1, -1 do
            local photo = self.allPhoto[ii]
            local photoDataTbl = self.photoArrangedByStar[p.name][p.star]
            if photo.id == preId and not table.exists(photoDataTbl, photo) then
                table.insert(self.photoArrangedByStar[p.name][p.star], photo)
                break
            end
        end
    end
    creatureTbl[p.star] = p
end

--- 获得图鉴照片的id
function AlbumGui:GetPhotoInCollection(creatureName, star)
    if not self:CheckIfNoticeFirstStarPhoto(creatureName, star) then
        return self.photoInCollection[creatureName][star]
    end
    return nil
end

function AlbumGui:ResetStickerStatus()
    if self.curOperatedSticker then
        self.curOperatedSticker:CancelSelectStatus()
    end
    self.curOperatedSticker = nil
    self:SetEditToolActivity(false)
end

function AlbumGui:ResetAllPhotoPnlScrollRange()
    local allPhotoNum = #self.allPhoto
    local remain = allPhotoNum % constDefPhotoNumOnEachRow
    local row = (allPhotoNum - remain) / constDefPhotoNumOnEachRow
    if remain > 0 then
        row = row + 1
    end
    local newRowNum = row - 2
    if newRowNum > 0 then
        self.allPhotoPnl.ScrollRange = 1076 + 498 * newRowNum
    end
end

---生成长期存储所需的数据表格
function AlbumGui:NewDataStorgeTable()
    local albumPhoto = {}
    local photoData = {
        'name',
        'id',
        'date',
        'star',
        'url',
        'frameColor',
        'bChecked'
    }
    for photoIndex, photo in pairs(AlbumGui.allPhoto) do
        local thisPhoto = {}
        for _, v in pairs(photoData) do
            thisPhoto[v] = photo[v]
        end
        albumPhoto[photoIndex] = thisPhoto
    end
    local photoInCollection = {}
    local photoData02 = {
        'name',
        'id',
        'star',
        'url'
    }
    for name, creatureTbl in pairs(AlbumGui.photoInCollection) do
        photoInCollection[name] = {}
        for star, creature in pairs(creatureTbl) do
            local thisPhoto = {}
            for _, v in pairs(photoData02) do
                thisPhoto[v] = creature[v]
            end
            photoInCollection[name][star] = thisPhoto
        end
    end
    C_PlayerDataMgr.playerData.photoAlbum = albumPhoto
    C_PlayerDataMgr.playerData.photoInCollection = photoInCollection
    --print("相册长期存储数据整合完毕")
end

local allAlbumRes = {}
local allCollectionRes = {}
---从长期存储同步数据
function AlbumGui:DownloadDataStorge()
    local localData = C_PlayerDataMgr.playerData
    local allPhoto = AlbumGui.allPhoto
    if localData.photoAlbum then
        for photoIndex, photo in pairs(localData.photoAlbum) do
            if photo.url then
                local i = photoIndex
                allAlbumRes[i] = {
                    tempResRef = nil,
                    msg = -1,
                    checkNum = 0
                }
                local DownloadCallback = function(_tempResRef, _msg)
                    allAlbumRes[i].tempResRef = _tempResRef
                    allAlbumRes[i].msg = _msg
                end
                local realURL = 'photoid://' .. photo.url
                ResourceManager.GetRemoteResource(realURL, DownloadCallback)
                local photoData = photo
                C_TimeMgr:AddRTEvent(
                    1000,
                    function(photoIndex, photoData)
                        local resData = allAlbumRes[photoIndex]
                        local resRef = resData.tempResRef
                        local msg = resData.msg
                        local checkNum = resData.checkNum
                        if checkNum > 10 * photoIndex then
                            return true
                        end
                        if resRef and msg == 0 and resRef:GetCompletion() >= 0.99 then
                            local p = AlbumGui:CreateNewPhoto(photoData.name, photoData.star, resRef)
                            for k, val in pairs(photoData) do
                                p[k] = val
                            end
                            p:CheckIfHideNewFrame()
                            p:CheckIfChangeFrameColor()
                            return true
                        end
                        resData.checkNum = checkNum + 1
                        return false
                    end,
                    0,
                    i,
                    photoData
                )
            end
        end
        print('相册长期存储数据衔接完毕')
    else
        print('本地无长期存储数据')
    end
    --[[
    local allPhotoInCollection = AlbumGui.photoInCollection
    if localData.photoInCollection then
        for name, creatureTbl in pairs(localData.photoInCollection) do
            allPhotoInCollection[name] = {}
            for star, data in pairs(creatureTbl) do
                local name_ = name
                local star_ = star
                if allCollectionRes[name_] == nil then
                    allCollectionRes[name_] = {}
                end
                allCollectionRes[name_][star_] = {
                    tempResRef = nil,
                    msg = -1,
                    checkNum = 0
                }
                local DownloadCallback = function(_tempResRef,_msg)
                    local allCollectionData = allCollectionRes[name_][star_]
                    allCollectionData.tempResRef = _tempResRef
                    allCollectionData.msg = _msg
                end
                local realURL = "photoid://"..data.url
                ResourceManager.GetRemoteResource(realURL,DownloadCallback)
                local photoData = data
                C_TimeMgr:AddRTEvent(1000, function(name,star,photoData)
                    local resData = allCollectionRes[name][star]
                    local resRef = resData.tempResRef
                    local msg = resData.msg
                    local checkNum = resData.checkNum
                    if checkNum > 20 then
                        return true
                    end
                    if resRef and msg == 0 and resRef:GetCompletion() >= 0.99 then
                        local photo = {}
                        for k, v in pairs(photoData) do
                            photo[k] = v
                        end
                        allPhotoInCollection[name][star] = photo
                        photo.GetShotSrc = PhotoInCollection.GetShotSrc
                        photo.srcShot = resRef
                        self:RemovePhotoFromPhotoArrangedByStar(photo.id,name,star)
                        return true
                    end
                    return false
                end,0,name_,star_,photoData)
            end
        end
        print("图鉴照片长期存储数据衔接完毕")
    else
        print("本地无长期存储数据")
    end
    --]]
end

return AlbumGui
