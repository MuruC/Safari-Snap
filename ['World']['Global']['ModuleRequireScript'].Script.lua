--- 将Global.Module目录下每一个用到模块提前require,定义为全局变量
-- @script Module Defines
-- @copyright Lilith Games, Avatar Team
-- Utilities
ModuleUtil = require(Utility.ModuleUtilModule)
LuaJsonUtil = require(Utility.LuaJsonUtilModule)
NetUtil = require(Utility.NetUtilModule)
CsvUtil = require(Utility.CsvUtilModule)
XlsUtil = require(Utility.XlsUtilModule)
EventUtil = require(Utility.EventUtilModule)
UUID = require(Utility.UuidModule)
TweenController = require(Utility.TweenControllerModule)
GlobalFunc = require(Utility.GlobalFuncModule)
LinkedList = Utility.LinkedListModule
ValueChangeUtil = require(Utility.ValueChangeUtilModule)
TimeUtil = require(Utility.TimeUtilModule)
CloudLogUtil = require(Utility.CloudLogUtilModule)
BTNode = require(Utility.BTNodeModule)
BTObj = require(Utility.BTObjModule)
BTMgr = require(Utility.BTMgrModule)
GuiUtil = require(Utility.GuiUtilModule)
FSMUtil = require(Utility.FSMUtilModule)
SkillUtil = require(Utility.SkillUtilModule)
AnimUtil = require(Utility.AnimUtilModule)
AudioUtil = require(Utility.AudioUtilModule)
-- Game Defines
GAME_ID = 'X0000'

-- Utility Initilization
--TimeUtil.Init()
CloudLogUtil.Init(GAME_ID)

-- Framework
ModuleUtil.LoadModules(Framework)

-- Globle Defines
ModuleUtil.LoadModules(Define)
ModuleUtil.LoadXlsModules(Xls, Config)

-- Cls
ModuleUtil.LoadCls(Module.Cls_Module)
ModuleUtil.LoadCls(Module.Creature_Module)
--FSMBase = require(Module.Cls_Module.FSMBaseCls)
--CreatureBase = require(Module.Cls_Module.CreatureBaseCls)
--Reindeer = require(Module.Creature_Cls.DeerCls)
--Wolf = require(Module.Creature_Module.WolfCls)
--Brownbear = require(Module.Creature_Module.BrownbearCls)
--Butterfly = require(Module.Creature_Module.ButterflyCls)
ModuleUtil.LoadModules(Module.ItemClass)

-- Server and Client Modules
ModuleUtil.LoadModules(Module.S_Module)
ModuleUtil.LoadModules(Module.UI_Module)
ModuleUtil.LoadModules(Module.C_Module)

-- Fsm
ModuleUtil.LoadModules(Module.Fsm_Module)
ModuleUtil.LoadModules(Module.Fsm_Module.PlayerActFsm)

-- Plugin Modules
GuideSystem = require(world.Global.Plugin.FUNC_Guide.GuideSystemModule)
