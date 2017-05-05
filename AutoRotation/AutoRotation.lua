-----------------------------------
--自动输出,治疗
--by 水月

local buttonflag = 1
local r, g, b  =	1.00,	1.00,	1.00
local class, englishClass, classarg1 = UnitClass("player");	
local following = ""
local ct = 0
local SpellOverlayed = 0
local factionGroup = ""
local tooltipText = "左键移动,右键菜单"
HpList = {}
local AddTracker = {}
local nodespelskill = ""
local cast = UnitCastingInfo('player')--玩家正在读条
local chan = UnitChannelInfo('player')--玩家正在引导
--_, mycurrentSpecName, _, _, role = GetSpecializationInfo(GetSpecialization())

if classarg1 == 0 then r, g, b  =	1.00,	1.00,	1.00	--NPC
	elseif classarg1 == 1 then r, g, b  =	0.78,	0.61,	0.43	--Warrior	（不读条）
	elseif classarg1 == 2 then r, g, b  =	0.96,	0.55,	0.73	--Paladin
	elseif classarg1 == 3 then r, g, b  =	0.67,	0.83,	0.45	--Hunter （不读条）
	elseif classarg1 == 4 then r, g, b  =	1.00,	0.96,	0.41	--Rogue （不读条）
	elseif classarg1 == 5 then r, g, b  =	1.00,	1.00,	1.00	--Priest （读条职业）
	elseif classarg1 == 6 then r, g, b  =	0.77,	0.12,	0.23	--DeathKnight （不读条）
	elseif classarg1 == 7 then r, g, b  =	0.00,	0.44,	0.87	--Shaman
	elseif classarg1 == 8 then r, g, b  =	0.41,	0.80,	0.94	--Mage （读条职业）
	elseif classarg1 == 9 then r, g, b  =	0.58,	0.51,	0.79	--Warlock （读条职业）
	elseif classarg1 == 10 then r, g, b  =	0.00,	1.00,	0.59	--Monk
	elseif classarg1 == 11 then r, g, b  =	1.00,	0.49,	0.04	--Druid
	elseif classarg1 == 12 then r, g, b  =	0.64,	0.19,	0.79	--DH （不读条）
	elseif classarg1 == nil then r, g, b  =	0,	1,	0
end	
--渐隐规则 frame, timeToFade, startAlpha, endAlpha
--Interface\\AddOns\\AutoRotation\\image\\

---技能数据库
local noCastcalss = {
	"战士",
	"潜行者",
	"死亡骑士",
	"恶魔猎手",
	"猎人"
}
local noCastcalss = {
	"增强",
	"野性守护",
	"踏风",
	"酒仙",
	"猎人"
}

local interruptTable = {--打断技能
	"法术反制",
	"拳击",
	"责难",
	"反制射击",
	"脚踢",
	"法术封锁",
	"切喉手",
	"迎头痛击",
	"心灵冰冻",
	"吞噬魔法",
	"风剪"
}
 local nomalhealTable = {--恢复萨满技能
--萨满	
	"治疗之泉图腾",
	--"激流",
	"治疗波",
--牧师
	"苦修",
	"快速治疗"
}

local ShortrangeAoeHealTabel = { --9.9码以内群治疗
	"治疗之雨",
	"女王的恩赐"
}
local LongrangeAoeHealTabel = {	--9.9码以上群治疗
	"治疗之泉图腾"
	--"治疗链"
}
 local ShortrangeAoeHealBurstTabel = { --9.9码以内群治疗爆发技能
	"灵魂链接图腾"
}
 local LongrangeAoeHealBurstTabel = { --9.9码以上群治疗爆发技能
	"升腾",
	"治疗之潮图腾",
	"暴雨图腾"
}
local bigdamageTable = { --对目标爆发技能列表
--DH	
	"混乱之刃",
	"涅墨西斯",
--FS
	"镜像",
	"冰冷血脉",
	"燃烧",
--LR
	"狂野怒火",
	"野性守护",
	"夺命黑鸦",
--SM	
	"升腾",
	"野性狼魂",
	"毁灭之风",
	"风暴元素",
	"土元素"
	--"142117"--延时之力
}
local ShortrangnotargetbigdamageTable = { --本体爆发技能列表	
	"恶魔变形"
}
local debuffremoveTable = { --用来驱散的法术技能列表
	"净化灵魂"
}

local ShortrangeAoeNonTargetTable = { --不需要目标的aoe 如暴风雪 9.9yard 短距离
--法师
	"暴风雪",
	"冰锥术",
	"寒冰宝珠",
	"龙息术",
	"流星",
	--"烈焰风暴",
	
	"魔爆术",
--萨满	
	"毁灭闪电",
	"!空气之怒",
	"闪电奔涌图腾",
	"馅地图腾",
	"巫毒图腾",
--猎人
	"爆炸陷阱",
--DH
	"伊利达雷之怒"
}
local LongrangeAoeNonTargetTable = { --需要目标AOE 如活动炸弹 长距离
--法师
	"活动炸弹",
--萨满	
	"闪电链",
--猎人
	"凶暴野兽",
	"多重射击"	
}

local mageTable = { --通常技能列表
	"凤凰烈焰",
	"黑冰箭"
}
local shamanTable = {--增强萨满技能
	"狂野扑击",
	"风暴守护者",
	"闪电箭",
	"风暴打击",
	"熔岩猛击",
	"石化"
	--"升腾",
}
local zhanshiTable = {--战士技能
	"冲锋",
	"毁灭打击",
	"盾牌猛击",
	"猛击"
}
local yuansushamanTable = {--元素萨满技能
	"风暴守护者",
	"雷霆风暴",
	"闪电箭"
}

local jielvTable = {--戒律牧技能
	"苦修",
	"惩击"
}

local lierenTable = {--兽王猎人技能
	"杀戮命令",
	"凶暴野兽"
}

local haojieTable = {--浩劫技能
	"吞噬魔法",
	"投掷利刃",
	"邪能之刃",
	"刀舞",
	"伊利达雷之怒",
	"混乱新星",
	"混乱打击"
}
 

 local MagicDebuff = {--可以驱散魔法
	"圣骑士",
	"萨满祭司",
	"牧师",
	"武僧",
	"德鲁伊"
}
 local CurseDebuff = {--可以驱散诅咒
	"萨满祭司",
	"德鲁伊"
}
 local DiseaseDebuff = {--可以驱散疾病
	"圣骑士",
	"牧师"
}
 local PoisonDebuff = {--可以驱散毒药
	"圣骑士",
	"武僧",
	"德鲁伊"
}


 local JumpNeedDebuffs = {--需要移动debuff
	"极度冰寒",--魔枢最后boss 跳动需要 极度冰寒48095
	"无尽寒冬"--新卡拉赞 麦迪文场景 无尽寒冬227806
}	

function playerMPpercent()--玩家能量百分比
	return UnitPower("player")/UnitPowerMax("player")*100;
end
function playerHPpercent()--玩家血百分比
	return UnitHealth("player")/UnitHealthMax("player")*100;
end

local function playerMP()--玩家真实能量
	return UnitPower("player")
end

function canInterrupt()--目标法术可以打断
	local spell, _, _, _, _, endTime, _, _, notinterrupt= UnitCastingInfo("Target");
	if spell and not notinterrupt then
		return true
	else
		return false
	end	
end
local function Interrupt()--打断
	for k, v in pairs(interruptTable) do
		local start, duration, enabled = GetSpellCooldown(v);
		if duration == 0 then
			SpellStopCasting()--停止施法
			CastSpellByName(v)
		end
	end
end

local function cooldowntime(spellID)--指定技能冷却剩余时间
	local start, duration, enable = GetSpellCooldown(spellID)
	local t = start + duration - GetTime();
	if t ~= nil then
		return t 
	else
		return 0 
	end	
end	
local function isGCD()--卡GCD是true --161691 要塞技能 bug技能 可以获取GCD
	local start, duration, enable = GetSpellCooldown(161691)
	if duration ~= 0 then
		--print(t)
		return true;
	else
		--print("bukagcd")
		return false;
	end
end
local function numGUIDs()--GUID
	  local count = 0
	  for k,v in pairs(AddTracker) do
		count = count+1
	  end
	  return count
 end 
local function removeTracker()--移除GUID
	for k in pairs (AddTracker) do
		AddTracker [k] = nil
	end
end
local function addIntoNoDISPEL()--加入不被驱散列表
	if not tContains(NoDISPEL, nodespelskill) then	
		table.insert(NoDISPEL,NoDISPELNum,nodespelskill)	
		NoDISPELNum = NoDISPELNum + 1
		print(nodespelskill..">>已被加入不被驱散列表")
	end
end	
local function NoDISPELtableremove() --几乎不使用 清空驱散列表
	for k, v in pairs(NoDISPEL) do
		NoDISPEL [k] = nil
	end
	NoDISPELNum = 1
	print("不驱散列表已被清除")
end
local function NoDISPELtableshow() --展示 清空驱散列表
	for k, v in pairs(NoDISPEL) do
		print(k, v)
	end
end
local function DebuffJump() --移动buff 秒清
	for j = 1, 40 do
		local debuff, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitDebuff("player", j)
		if not debuff then break end
		desc = GetSpellDescription(spellID)
		if string.find(desc, "跳") then
			JumpOrAscendStart()
			JumpOrAscendStop()
		end
		
		if tContains(JumpNeedDebuffs, debuff) and count >= 3 then--在需要移动列表 层数大于3
			MoveForwardStart()
			MoveForwardStop()
		end
	end
end


---------------------------------
BackroundColor = UIParent:CreateTexture("HIGHLIGHT");
BackroundColor:SetAllPoints();
BackroundColor:SetColorTexture(0, 0, 0, 0.8);
BackroundColor:Hide()
FullScreenTexture = UIParent:CreateTexture("HIGHLIGHT");
FullScreenTexture:SetAllPoints();
--FullScreenTexture:SetTexture("Interface\\FullScreenTextures\\LowHealth.blp")
FullScreenTexture:SetAlpha(0.3)
FullScreenTexture:Hide()

local MainFrame = CreateFrame("Frame", "mainframe", UIParent,"MyFrameTemplate")
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:SetResizable(true)
MainFrame:EnableMouseWheel(true)
MainFrame:SetSize(120,40);
MainFrame:Show()
MainFrame:SetPoint("CENTER",UIParent,"CENTER",-90,0);
MainFrame:SetFrameStrata("HIGH")
MainFrame.Status = MainFrame:CreateFontString(nil,"OVERLAY");
MainFrame.Status:SetFontObject(Game13Font_o1) 
MainFrame.Status:SetAllPoints()
MainFrame.doing = MainFrame:CreateFontString(nil,"OVERLAY");--施法状态
MainFrame.doing:SetFontObject(Game13Font_o1) 
MainFrame.doing:SetPoint("CENTER",MainFrame,"CENTER",0,30);
MainFrame.doing:SetText("")
MainFrame.following = MainFrame:CreateFontString(nil,"OVERLAY");--跟随目标
MainFrame.following:SetFontObject(Game13Font_o1) 
MainFrame.following:SetPoint("CENTER",MainFrame.Status,"CENTER",0,45);
MainFrame.react = MainFrame:CreateTexture("HIGHLIGHT");
MainFrame.react:SetAllPoints();
MainFrame.icon = MainFrame:CreateTexture("HIGHLIGHT");
MainFrame.icon:SetTexture("")
MainFrame.icon:SetPoint("CENTER",MainFrame,"CENTER",80,0);
MainFrame.icon:SetSize(40,40);
MainFrame.icon:Hide()
MainFrame.Slidebar = CreateFrame("Slider",nil,MainFrame,"OptionsSliderTemplate");
MainFrame.Slidebar:SetPoint("CENTER",MainFrame.Status,"CENTER",0,-60);
MainFrame.Slidebar:SetWidth(100)
MainFrame.Slidebar:SetHeight(10)
MainFrame.Slidebar:SetMinMaxValues(0,4)
MainFrame.Slidebar:SetValue(0)
MainFrame.Slidebar:Hide()
MainFrame.Slidebar:SetValueStep(1)
MainFrame.Slidebar:SetObeyStepOnDrag(true) 
MainFrame.Slidebar:SetOrientation('HORIZONTAL')
MainFrame.Slidebar:SetScript("OnValueChanged", function(self, value) 
  	ct = math.floor(MainFrame.Slidebar:GetValue())
	
	if ct == 0 then
		following = ""
		MainFrame.following:SetText("无跟随目标")
	elseif 	ct == 1 then
		following = "party1"
	elseif 	ct == 2 then
		following = "party2"
	elseif 	ct == 3 then
		following = "party3"
	elseif 	ct == 4 then
		following = "party4"
	elseif 	ct == 5 then	
		MainFrame.following:SetText("跟随最近队友")
	end	
end)

local Healer = CreateFrame("Frame", "Healer", MainFrame,"MyFrameTemplate")
--Healer:SetScale(1/scale)
Healer:SetMovable(true)
Healer:EnableMouse(true)
Healer:SetResizable(true)
Healer:EnableMouseWheel(true)
Healer:SetSize(120,40);
Healer:Hide()
Healer:SetPoint("RIGHT",MainFrame,"RIGHT",160,0);
Healer.Status = Healer:CreateFontString(nil,"OVERLAY");
Healer.Status:SetFontObject(ChatFontNormal) 
Healer.Status:SetPoint("CENTER", 0, 0);
Healer.Status:SetText(string.format("平均HP：%s%%\n>%s<\n目标血量：%s%%","无","无","无"))
Healer.auto = Healer:CreateTexture("HIGHLIGHT");
Healer.auto:SetAllPoints();
Healer.auto:SetColorTexture(r, g, b, 0.8);
local options = CreateFrame("Frame", "options", MainFrame,"MyFrameTemplate")
--options:SetScale(1/scale)
options:SetMovable(true)
options:EnableMouse(true)
options:SetResizable(true)
options:EnableMouseWheel(true)
options:SetSize(120,135);
options:Hide()
options:SetPoint("LEFT",MainFrame,"LEFT",0,-100);
options.auto = options:CreateTexture("HIGHLIGHT");
options.auto:SetAllPoints();
options.auto:SetColorTexture(168/255, 153/255, 120/255, 0.8);
options.AOEStatus = options:CreateFontString(nil,"OVERLAY");
options.AOEStatus:SetFontObject(ChatFontNormal) 
options.AOEStatus:SetPoint("TOPLEFT", 3, -110);
options.AOEStatus:SetText("怪数量超过")
options.AOE = CreateFrame("EditBox",nil,options,"InputBoxTemplate");
options.AOE:SetPoint("TOPLEFT", 85, -110);
options.AOE:SetSize(30,20);
options.AOE:SetText(3)
options.AOE:SetNumeric(true)
options.AOE:SetMaxLetters(2) 
options.AOE:IsToplevel(enabled) 
options.AOE:Disable()
options.AOE:SetScript("OnMouseDown",function(self,LeftButton,down) 
	options.AOE:Enable()
end);
options.AOE:SetScript("OnEnterPressed",function(self,LeftButton,down) 
	options.AOE:SetText(options.AOE:GetNumber() or "1")
	options.AOE:Disable()
end);
CheckButton0 = CreateFrame("CheckButton", "CheckButton0_GlobalName", options, "ChatConfigCheckButtonTemplate");
CheckButton0:SetPoint("TOPLEFT", 3, -5);
--CheckButton1:SetChecked();
CheckButton0_GlobalNameText:SetText("强制DPS模式");
CheckButton0.tooltip = "不论是不是DPS天赋 强制进行DPS";
CheckButton0:SetScript("OnClick", 
  function()
    --do stuff
  end
);
CheckButton1 = CreateFrame("CheckButton", "CheckButton1_GlobalName", options, "ChatConfigCheckButtonTemplate");
CheckButton1:SetPoint("TOPLEFT", 3, -25);
--CheckButton1:SetChecked();
CheckButton1_GlobalNameText:SetText("与目标交互");
CheckButton1.tooltip = "与鼠标指向互动";
CheckButton1:SetScript("OnClick", 
  function()
    --do stuff
  end
);
CheckButton2 = CreateFrame("CheckButton", "CheckButton2_GlobalName", options, "ChatConfigCheckButtonTemplate");
CheckButton2:SetPoint("TOPLEFT", 3, -45);
CheckButton2:SetChecked(true)
CheckButton2_GlobalNameText:SetText("自动秒驱");
CheckButton2.tooltip = "治疗模式下自动驱散队伍人DEBUFF";
CheckButton2:SetScript("OnClick", 
  function()
    --do stuff
  end
);
CheckButton3 = CreateFrame("CheckButton", "CheckButton3_GlobalName", options, "ChatConfigCheckButtonTemplate");
CheckButton3:SetPoint("TOPLEFT", 3, -65);
CheckButton3:SetChecked(true)
CheckButton3_GlobalNameText:SetText("自动打断");
CheckButton3.tooltip = "所有模式下，只要目标可以打断进行打断";
CheckButton3:SetScript("OnClick", 
  function()
    --do stuff
  end
);

CheckButton4 = CreateFrame("CheckButton", "CheckButton4_GlobalName", options, "ChatConfigCheckButtonTemplate");
CheckButton4:SetPoint("TOPLEFT", 3, -85);
CheckButton4:SetChecked(true)
CheckButton4_GlobalNameText:SetText("使用AOE");
CheckButton4.tooltip = "使用AOE类法术，如果是范围法术在自身周围释放，如暴风雪";
CheckButton4:SetScript("OnClick", 
  function()
    --do stuff
  end
);

MainFrame:RegisterEvent("ADDON_LOADED")
MainFrame:RegisterEvent("SPELL_DAMAGE")
MainFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
MainFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
MainFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
MainFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
MainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
MainFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
MainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
MainFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
MainFrame:RegisterEvent("CURSOR_UPDATE")
MainFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
MainFrame:RegisterEvent("NAME_PLATE_CREATED");
MainFrame:RegisterEvent("PLAYER_DEAD");
MainFrame:RegisterEvent("PLAYER_ALIVE");
MainFrame:RegisterEvent("PLAYER_UNGHOST");
MainFrame:RegisterEvent("RESURRECT_REQUEST");
MainFrame:RegisterEvent("UI_ERROR_MESSAGE");
MainFrame:RegisterEvent("ZONE_CHANGED")--地图位置变化
MainFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED");--脱离战斗
MainFrame:RegisterEvent("RAID_ROSTER_UPDATE");
MainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");--战斗记录
MainFrame:RegisterEvent("PLAYER_FLAGS_CHANGED")--玩家flag
MainFrame:RegisterEvent("PARTY_MEMBER_DISABLE");--队友死了
MainFrame:RegisterEvent("PARTY_MEMBER_ENABLE");--队友上线？
MainFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16,...)
	--timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 =
	if event == "ADDON_LOADED" then
		NoDISPEL = NoDISPEL or {} --创建或者继承 不被驱散列表
		NoDISPELNum = NoDISPELNum or 1--不被驱散列表数量
		 _, mycurrentSpecName, _, _, role = GetSpecializationInfo(GetSpecialization())
		MainFrame.Status:SetText(role)
		MainFrame.react:SetColorTexture(1, 1, 1, 0);
	elseif	event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "ZONE_CHANGED" then
		 _, mycurrentSpecName, _, _, role = GetSpecializationInfo(GetSpecialization())
		MainFrame.Status:SetText(role)
		MainFrame.react:SetColorTexture(1, 1, 1, 0);
	elseif event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBER_DISABLE" or event == "PARTY_MEMBER_ENABLE" then
		 
	elseif event == "PLAYER_REGEN_ENABLED"  then --脱战
		if classarg1 == 7 and buttonflag == 0 then --萨满 
			if not UnitAura("player","幽魂之狼") then
				CastSpellByName("!幽魂之狼")
			end	
		end
		if playerMPpercent() < 100 or playerHPpercent() < 100 then --脱战吃面包
			UseItemByName("魔法汉堡")
		end
		removeTracker()--移除GUID
	elseif event == "PLAYER_FLAGS_CHANGED" then --afk时候
		MoveForwardStart()
		MoveForwardStop()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED"  then --战斗记录检查
		local sGUID = arg4
		local sFlag = arg7
		local GUID = arg8
		if arg2 == "PARTY_KILL" then
			--print("击杀目标")
			if tContains(AddTracker, GUID) then
				for i=#AddTracker,1,-1 do
					if AddTracker[i] == GUID then
						table.remove(AddTracker,i)
						--print("移除: "..GUID)
						--print("add: "..numGUIDs())
					end	
				end
			end
		elseif arg2 == "SPELL_DAMAGE" and sGUID == UnitGUID("player")  then ---判断进站
			if not tContains(AddTracker, GUID) then
				table.insert(AddTracker, GUID)
				--print("进战斗怪数量: "..numGUIDs())
			end
		elseif (arg2 == "SPELL_DAMAGE" or arg2 == "SPELL_HEAL" or arg2 == "SPELL_CAST_SUCCESS") and arg5 == UnitName("player") and arg9 ~= nil and buttonflag == 0 then --释放成功 + 伤害来源玩家本体 	
			local _, _, icon = GetSpellInfo(arg12)
			MainFrame.doing:SetText(arg13.."|T"..icon..":0|t"..">>"..arg9)
			MainFrame.icon:SetTexture(icon)
		elseif arg2 == "SPELL_INTERRUPT" and arg5 == UnitName("player") then --打断喊话
			FullScreenTexture:SetTexture("Interface\\AddOns\\AutoRotation\\image\\pink.tga")
			UIFrameFadeIn(FullScreenTexture, 0.8, 0.5, 0)
			SendChatMessage("我已打断<"..arg9..">的-"..arg16,"yell")
		elseif arg2 == "SPELL_DISPEL" and arg5 == UnitName("player") then	--驱散成功喊话
			SendChatMessage("我已驱散<"..arg9..">的-"..arg16,"yell") 
		elseif arg2 == "SPELL_DISPEL_FAILED" and arg5 == UnitName("player") then	--驱散失败
			SendChatMessage("驱散失败<"..arg9..">的-"..arg16,"yell") 
			nodespelskill = arg16
			addIntoNoDISPEL()--加入不被驱散列表
		end
	elseif event == "UI_ERROR_MESSAGE" and buttonflag == 0 then
		if arg2 == "距离太远。" then
			MainFrame.Status:SetText("距离太远")
		elseif arg2 == "你必须面对目标。" then
			MainFrame.Status:SetText("方向错误")
		else
			MainFrame.Status:SetText("RUNNING")
		end
	--[[elseif event == "NAME_PLATE_CREATED" then			
	   --Set the tag based on UnitClassification, can return "worldboss", "rare", "rareelite", "elite", "normal", "minus"
		
		local function frame()
		local tag 
		local level = UnitLevel(frame.unit)
		local inInstance, instanceType = IsInInstance()
		if not inInstance then
		local tex = frame.FactionIcon or frame:CreateTexture(nil, "OVERLAY")
		frame.FactionIcon = tex
		tex:SetSize(50, 50)
		tex:SetPoint("LEFT",frame, -40, 0)
		local factionGroup = UnitFactionGroup(frame.unit) or " "
		if factionGroup == "Alliance" then
			frame.TexturePath = "Interface\\Timer\\Alliance-Logo"
		elseif factionGroup == "Horde" then
			frame.TexturePath = "Interface\\Timer\\Horde-Logo"
		elseif factionGroup == "Neutral" then
			frame.TexturePath = "Interface\\AddOns\\AutoRotation\\image\\image1.tga"
		else
			frame.TexturePath = nil
		end
		tex:SetTexture(frame.TexturePath)
		if UnitClassification(frame.unit) == "worldboss" or UnitLevel(frame.unit) == -1 then
		  tag = "Boss"
		  level = "??"
		elseif UnitClassification(frame.unit) == "rare" or UnitClassification(frame.unit) =="rareelite" then
		  tag = "稀有"
		elseif UnitClassification(frame.unit) == "elite" then
		  tag = "精英"
		else 
		  tag = ""
		end
	   --Set the nameplate name to include tag(if any), name and level
	   frame.name:SetText(level.." "..UnitName(frame.unit))
		end	
		end
	]]
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" and buttonflag == 0 then	
		local SpellOverlayed, _, icon  = GetSpellInfo(arg1)
		MainFrame.doing:SetText("高亮："..SpellOverlayed.."|T"..icon..":0|t")
		MainFrame.icon:SetTexture(icon)
		--print("高亮："..SpellOverlayed.."|T"..icon..":0|t")
	elseif event == "PLAYER_TARGET_CHANGED" and buttonflag == 0 then	
		if UnitIsDead("target") then 
			UseToy(60854)--使用远程拾取器
		end	
		MainFrame.Status:SetText("需要一个目标")
	elseif  event == "CURSOR_UPDATE"  and CheckButton1:GetChecked()  then --第一个选项then 
		local cast = UnitCastingInfo("player")--玩家正在读条
		local chan = UnitChannelInfo("player")--玩家正在引导
		--print(UnitName("mouseover"),UnitGUID("mouseover"),UnitCastingInfo('player'))
		if not chan and not cast then
			TurnOrActionStart() 
			TurnOrActionStop()
		end	
		if UnitIsDead("mouseover") then
			UseToy(60854)--使用远程拾取器
		end
	elseif event == "SPELL_DAMAGE" then --受到伤害的目标加入列表
		print(GUID) -- works
		print(sFlag) -- works
		if not tContains(AddTracker,GUID) then
			table.insert(AddTracker, GUID)
			print(#AddTracker)
		end
	elseif event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE" then 	
		if buttonflag == 0 then
			MainFrame.Status:SetText("RUNNING")
		elseif buttonflag == 1 then
			MainFrame.Status:SetText(role)
		end
		--print("复活")
		MainFrame.auto:SetColorTexture(r, g, b, 0.8);
	elseif event == "PLAYER_DEAD" then 	
		MainFrame.Status:SetText("你死了")
		MainFrame.auto:SetColorTexture(1, 0, 0, 0.5);
	elseif event == "RESURRECT_REQUEST" then 
		AcceptResurrect();--接受复活
		--print("接受复活")
	end
	
end)

MainFrame:SetScript("OnMouseDown", function(self,button,...) 
	if button == "LeftButton" then 
		MainFrame:StartMoving()
		UIFrameFadeOut(BackroundColor, 0.3, 0, 1)--拖动的背景变暗
	elseif button == "RightButton" then 
		if options:IsVisible() then
			options:Hide()
		else 
			options:Show()
	end		
  end 
end)

MainFrame:SetScript("OnMouseUp", function(self,button,...) 
	if button == "LeftButton" then 
		UIFrameFadeOut(BackroundColor, 0.3, 0.6, 0)--拖动的背景变暗
		MainFrame:StopMovingOrSizing() 
		MainFrame:SetUserPlaced(true)
	end	
 end)
 
MainFrame:SetScript("OnEnter", function() 
	MainFrame.react:SetColorTexture(1, 1, 1, 0.8);
	UIFrameFadeOut(MainFrame.react, 0.1, 0, 0.6)
	GameTooltip:SetOwner(MainFrame, "ANCHOR_TOPLEFT",0,0)
	GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
	GameTooltip:Show()
 end)
 
 MainFrame:SetScript("OnLeave", function() 
	MainFrame.react:SetColorTexture(1, 1, 1, 0.8);
	UIFrameFadeOut(MainFrame.react, 0.1, 0.6, 0)
	GameTooltip_Hide()
 end)
 
 local function bigdamage()--爆发
	--SpellStopCasting()--停止施法
	FullScreenTexture:SetTexture("Interface\\AddOns\\AutoRotation\\image\\orange.tga")
	for k, v in pairs(bigdamageTable) do
			local start, duration, enabled = GetSpellCooldown(v);
			if duration == 0 then	
				SpellStopCasting()--停止施法
				CastSpellByName(v)
				UIFrameFadeOut(FullScreenTexture, 0.8, 0.5, 0)
			end
	end
	for k, v in pairs(ShortrangnotargetbigdamageTable) do
			local start, duration, enabled = GetSpellCooldown(v);
			local shortRange = CheckInteractDistance("target",3);--9.9yard
			if duration == 0 and shortRange then
				SpellStopCasting()--停止施法
				CastSpellByName(v,"player")
				UIFrameFadeOut(FullScreenTexture, 0.8, 0.5, 0)
			end
	end
end

 local function HealBurst()--治疗爆发
	FullScreenTexture:SetTexture("Interface\\AddOns\\AutoRotation\\image\\qinglan.tga")
	local healtarget = healtarget or "player"
	local shortRange = CheckInteractDistance(healtarget,3) ;--9.9yard
	if shortRange then
		for k, v in pairs(ShortrangeAoeHealBurstTabel) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
					--SpellStopCasting()--停止施法
					CastSpellByName(v,"player")
					UIFrameFadeOut(FullScreenTexture, 0.8, 0.5, 0)
				end
		end
	end	
	for k, v in pairs(LongrangeAoeHealBurstTabel) do
			local start, duration, enabled = GetSpellCooldown(v);
			if duration == 0 then	
				--SpellStopCasting()--停止施法
				CastSpellByName(v,"player")
				UIFrameFadeOut(FullScreenTexture, 0.8, 0.5, 0)
			end
	end
end

local function debuff()--移除debuff 
--[[dispelType - Type of aura (relevant for dispelling and certain other mechanics); nil if not one of the following values: (string)
Curse
Disease
Magic
Poison
	if debuffType == "Disease" or debuffType == "Magic" or debuffType == "Curse" or debuffType == "Poison" then
]]
	for k, v in pairs(debuffremoveTable) do
		local start, duration, enabled = GetSpellCooldown(v);
		if duration ~= 0 then return end
	end

	for j = 1, 40 do
		local debuff, _, _, _, debuffType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitDebuff("player", j)
		if not debuff then break end
		if debuffType == "Magic"  and tContains(MagicDebuff,class) then
				for k, v in pairs(debuffremoveTable) do
					local start, duration, enabled = GetSpellCooldown(v);
						if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
							SpellStopCasting()--停止施法
							CastSpellByName(v,"player")
					
						end
				end
				return true
		elseif debuffType == "Disease" and tContains(DiseaseDebuff,class)  then
			for k, v in pairs(debuffremoveTable) do
				local start, duration, enabled = GetSpellCooldown(v);
					if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
						SpellStopCasting()--停止施法
						CastSpellByName(v,"player")
					end
			end
			return true	
		elseif debuffType == "Curse" and tContains(CurseDebuff,class) then
			for k, v in pairs(debuffremoveTable) do
				local start, duration, enabled = GetSpellCooldown(v);
					if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
						SpellStopCasting()--停止施法
						CastSpellByName(v,"player")
						
					end
			end
			return true	
		elseif debuffType == "Poison" and tContains(PoisonDebuff,class) then
			for k, v in pairs(debuffremoveTable) do
				local start, duration, enabled = GetSpellCooldown(v);
					if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
						SpellStopCasting()--停止施法
						CastSpellByName(v,"player")
						
					end
			end
			return true			
		end
	end

	local ubase = IsInRaid() and "raid" or "party"
	for i = 1, GetNumGroupMembers() do
		local unit = ubase..i
		for j = 1, 40 do
			local debuff, _, _, _, debuffType = UnitDebuff(unit, j)
			if not debuff then break end
			if debuffType == "Magic"  and tContains(MagicDebuff,class) then
				for k, v in pairs(debuffremoveTable) do
					local start, duration, enabled = GetSpellCooldown(v);
						if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
							SpellStopCasting()--停止施法
							CastSpellByName(v,unit)
							
						end
				end
				return true
			elseif debuffType == "Disease" and tContains(DiseaseDebuff,class)  then
				for k, v in pairs(debuffremoveTable) do
					local start, duration, enabled = GetSpellCooldown(v);
						if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
							SpellStopCasting()--停止施法
							CastSpellByName(v,unit)
						
						end
				end
				return true	
			elseif debuffType == "Curse" and tContains(CurseDebuff,class) then
				for k, v in pairs(debuffremoveTable) do
					local start, duration, enabled = GetSpellCooldown(v);
						if duration == 0 and not tContains(NoDISPEL, debuff) then	---不驱散列表没有该技能才使用
							SpellStopCasting()--停止施法
							CastSpellByName(v,unit)
							
						end
				end
				return true	
			elseif debuffType == "Poison" and tContains(PoisonDebuff,class) then
				for k, v in pairs(debuffremoveTable) do
					local start, duration, enabled = GetSpellCooldown(v);
						if duration == 0 and not tContains(NoDISPEL, debuff)  then	---不驱散列表没有该技能才使用
							SpellStopCasting()--停止施法
							CastSpellByName(v,unit)
						
						end
				end
				return true			
			end
		end
	end
end
 local function AOE()--aoe 技能
	if  numGUIDs() >= options.AOE:GetNumber() then
		for k, v in pairs(LongrangeAoeNonTargetTable) do
			local start, duration, enabled = GetSpellCooldown(v);
			if duration == 0 then
				CastSpellByName(v)
			end
		end
		local shortRange = CheckInteractDistance("target",3);--9.9yard
		if shortRange then
			for k, v in pairs(ShortrangeAoeNonTargetTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then
					CastSpellByName(v,"player")
				end
			end
		end	
	end	
end

local function buffnow()--buff检测
	if classarg1 == 8 then --法师 
		local _, _, _, _, _, _, xiaokuohao, _, _, _, _ = UnitAura("player", "热力迸发")--火法小括号
		local _, _, _, _, _, _, dakuohao, _, _, _, _ = UnitAura("player", "炽热连击！")--火法大括号
		local _, _, _, _, _, _, bingfengbao, _, _, _, _ = UnitAura("player", "冰冷智慧")--顺发冰风暴
		local _, _, _, _, _, _, hanbingzhi, _, _, _, _ = UnitAura("player", "寒冰指")--寒冰指
		local _, _, _, count, _, _, bingci, _, _, _, _ = UnitAura("player", "冰刺")--冰刺
		local _, _, _, _, _, _, liansuofanying, _, _, _, _ = UnitAura("player", "连锁反应")--连锁反应，冰枪伤害加成
		if xiaokuohao ~= nil then
			CastSpellByName("火焰冲击")--释放火冲
		elseif dakuohao ~= nil then 
			--SpellStopCasting()--停止施法
			CastSpellByName("炎爆术")--释放炎爆
		elseif bingfengbao ~= nil then 
			--SpellStopCasting()--停止施法
			CastSpellByName("冰风暴")--释放冰风暴
		elseif hanbingzhi ~= nil then 
			--SpellStopCasting()--停止施法
			CastSpellByName("冰枪术")--释放冰枪
		elseif count ~= nil and count == 5 then 
			--SpellStopCasting()--停止施法
			CastSpellByName("冰枪术")--释放冰枪		
		end
	elseif classarg1 == 7  then --萨满 
		if  mycurrentSpecName == "增强" then
			local _, _, _, _, _, _, huoshe, _, _, _, _ = UnitAura("player", "火舌")--火舌时间
			local _, _, _, _, _, _, kongqizhinu, _, _, _, _ = UnitAura("player", "空气之怒")--空气之怒
			local _, shandianjian, _ = GetSpellCooldown("闪电箭");
			local _, huimiezhifeng, _ = GetSpellCooldown("毁灭之风");	
			CastSpellByName(SpellOverlayed,"target")--使用高亮法术
			if huoshe == nil or huoshe-GetTime() <= 4 or huimiezhifeng-GetTime()  <= 6 then --当火舌Buff将断或者毁灭之风cd还差6秒且火舌持续小于4秒
				CastSpellByName("火舌")
			elseif playerMPpercent() >= 40 and kongqizhinu == nil then
				CastSpellByName("空气之怒")
			elseif playerMPpercent() >= 46 and shandianjian == 0 then
				CastSpellByName("闪电箭")
			end
		elseif mycurrentSpecName == "元素" then
			local _, _, _, _, _, _, situteng, _, _, _, _ = UnitAura("player", "风暴图腾")--四图腾
			local _, _, _, _, _, _, huozhen, _, _, _, _ = UnitDebuff("target", "烈焰震击")--火震时间
			local _, _, _, _, _, _, rongyanbenteng, _, _, _, _ = UnitAura("player", "熔岩奔腾")--顺发熔岩爆裂
			CastSpellByName(SpellOverlayed,"target")--使用高亮法术
			if situteng == nil then
				CastSpellByName("图腾掌握")
			elseif  huozhen == nil then
				CastSpellByName("烈焰震击")
			elseif rongyanbenteng ~= nil then
				CastSpellByName("熔岩爆裂")--释放熔岩爆裂	
			elseif playerMPpercent() == 100 then-- 满旋涡
				CastSpellByName("大地震击")--大地震
			end	
		end		
	elseif classarg1 == 12  then --DH		
		CastSpellByName(SpellOverlayed,"target")--使用高亮法术
	elseif classarg1 == 3  then --猎人		
		CastSpellByName(SpellOverlayed,"target")--使用高亮法术
	elseif classarg1 == 1  then --战士	
		CastSpellByName(SpellOverlayed,"target")--使用高亮法术
	else	
		
	end	
end

local function heal()--------治疗模块
	local isMoving = GetUnitSpeed("player")
	totalhp = 0
	HpList = {
		["player"] = UnitHealth("player") / UnitHealthMax("player")* 100 or 0
	}	
	if GetNumGroupMembers() > 1 and GetNumGroupMembers() <=5 then
		for n= 1, GetNumGroupMembers()-1 do
			if not tContains(HpList, "party"..n) then	
				table.insert(HpList,n,(UnitHealth("party"..n) / UnitHealthMax("party"..n)* 100)	)
			end	
		end		
	elseif GetNumGroupMembers() > 5 then
		for n= 1, GetNumGroupMembers()-1 do
			if not tContains(HpList, "raid"..n) then	
				table.insert(HpList,n,(UnitHealth("raid"..n) / UnitHealthMax("raid"..n)* 100)	)
			end	
		end		
	end
	
	mk = nil;
	mv = nil;
	
	for k,v in pairs(HpList) do 
		if not mv or v<mv then
			mv = v 
			mk = k 
		end 
	end

	for k,v in pairs(HpList) do 
		totalhp = totalhp + v
	end	
	
	if GetNumGroupMembers() == 0 then
		nums = 1
	else
		nums = GetNumGroupMembers()
	end	
	
	averagehp = totalhp / nums
	healtargethp = mv
	
	if mk == "player" then
		healtarget = mk
	elseif nums > 1 and nums <=5 then
		healtarget = "party"..mk
	elseif nums > 5 then
		healtarget = "raid"..mk	
	end	

	--[[
	for k, v in pairs(HpList) do
		print(k, v, healtarget, healtargethp, totalhp,averagehp)
	end
	]]
	foucusexists = UnitExists("focus")
	foucushp = UnitHealth("focus") / UnitHealthMax("focus") * 100	

	if foucusexists and foucushp < 40 and healtargethp > 35 and not UnitIsDead("focus") then
		healtarget = "focus"	
	elseif healtargethp < 90 and not UnitIsDead(healtarget) then
		healtarget = healtarget
	elseif healtargethp == 100 then
		SpellStopCasting()--停止施法
	else
		healtarget = "player"
	end
	--Healer.Status:SetText(string.format("平均HP：%s\n>%s<\n目标血量：%s", math.floor(averagehp), UnitName(healtarget), math.floor(healtargethp)))
	Healer.Status:SetText(string.format("平均HP：%s%%\n>%s<\n目标血量：%s%%",tostring(math.floor(averagehp)), tostring(UnitName(healtarget)), tostring(math.floor(healtargethp))))
	------------------------------------------------------
	

	if classarg1 == 7  then --萨满 
		local _, _, _, _, _, _, huozhen, _, _, _, _ = UnitDebuff("target", "烈焰震击")--火震时间
		local _, _, _, _, _, _, rongyanbenteng, _, _, _, _ = UnitAura("player", "熔岩奔腾")--顺发熔岩爆裂
		local _, _, _, _, _, _, chaoxibenyong, _, _, _, _ = UnitAura("player", "潮汐奔涌")--潮汐奔涌 治疗暴击buff
		local _, _, _, count, _, _, yuenatedejujiao, _, _, _, _ = UnitAura("player", "约纳特的聚焦")--萨满橙戒指 5层
		if isMoving ~= 0 then --如果移动时候
			if not UnitAura("player","幽魂之狼") and not UnitAffectingCombat("player") and not IsMounted() then
				CastSpellByName("!幽魂之狼")
			elseif UnitAffectingCombat("player") and averagehp < 90 then
				CastSpellByName("灵魂行者的恩赐")
			end	
		end
		if not chaoxibenyong and healtargethp <= 90 then --没有潮汐汹涌buff用激流
			CastSpellByName("激流",healtarget)
		elseif chaoxibenyong and healtargethp <= 50 then--半血以下用治疗之涌
			CastSpellByName("治疗之涌",healtarget)
			if averagehp < 50 or healtargethp <= 30 then--平均血量太低爆发
				HealBurst()--治疗爆发	
			end
		elseif healtargethp <= 10 and cooldowntime(61295) <= 0 then --极低血量激流
			CastSpellByName("激流",healtarget)		
		elseif playerMPpercent() > 5 and healtargethp <= 90 and chaoxibenyong then --正常加
			for k, v in pairs(nomalhealTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
					CastSpellByName(v,healtarget)
				end
			end	
		elseif  playerMPpercent() > 5 and averagehp <= 80 and averagehp >= 50 and GetNumGroupMembers() >= 3 then --加团 超过3个人
			local shortRange = CheckInteractDistance(healtarget,3);--9.9yard
			if shortRange then
				for k, v in pairs(ShortrangeAoeHealTabel) do--近距离
					local start, duration, enabled = GetSpellCooldown(v);
					if duration == 0 then	
						CastSpellByName(v,"player")
					end
				end
			end	
			for k, v in pairs(LongrangeAoeHealTabel) do--远距离
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
					CastSpellByName(v,healtarget)
				end
			end
			if yuenatedejujiao and count >= 5 then
				CastSpellByName("治疗链",healtarget)
			end
		elseif playerMPpercent() > 50 and not huozhen and cooldowntime(188835) <= 0  then -- 有蓝装逼输出火震
			if UnitExists("target") and UnitAffectingCombat("player")  then
				CastSpellByName("烈焰震击","target")
			elseif UnitExists("focus") and UnitAffectingCombat("focus") then
				AssistUnit("focus");
				CastSpellByName("烈焰震击","target")
			end	
		elseif 	playerMPpercent() > 50 and rongyanbenteng then--熔岩爆裂
			if UnitExists("target") and UnitAffectingCombat("player") then
				CastSpellByName("熔岩爆裂","target")
			elseif UnitExists("focus") and UnitAffectingCombat("focus") then
				AssistUnit("focus");
				CastSpellByName("熔岩爆裂","target")
			end	
		end	
	end	
	MainFrame.Status:SetText("RUNNING")
end

local function rotation()-------输出模块
	local isMoving = GetUnitSpeed("player")
	--------测 试 用 区 域---------------------------------------------
	
	------------------------------------------------------------------------	
	if classarg1 == 1  then --战士 	
		for k, v in pairs(zhanshiTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
				CastSpellByName(v)
				--SendChatMessage(v,"party")---队伍喊话
				end
			end	
	elseif classarg1 == 2  then --圣骑士
		
	elseif classarg1 == 3  then --猎人
		if mycurrentSpecName == "野兽控制" then
			haspet = HasPetUI()
			petisDead = UnitIsDead("pet")
			petHP = UnitHealth("pet")/UnitHealthMax("pet")*100
			if not haspet then
				CastSpellByID(883 , "player")--召唤第一个宝宝
			elseif petisDead then
				CastSpellByID(982 , "player")--复活治疗宠物
			end	
			if UnitCanAttack("player", "target") then --普攻
				StartAttack();
				PetAttack();
			end	
			if UnitAura("player","狂野怒火") and cooldowntime(207068) <= 0 and cooldowntime(120679) >= 7 and (cooldowntime(120679) <= 0)== false then
				CastSpellByName("泰坦之雷");
			elseif playerMP() < 30 and cooldowntime(120679) <= 0 then
				CastSpellByName("凶暴野兽");
				CastSpellByName("误导","pet");
			elseif UnitAura("player","狂野怒火") and not isGCD() then
				CastSpellByName("眼镜蛇射击");
			elseif playerMPpercent()>= 80 then --重要 控集中值！！！！
				CastSpellByName("眼镜蛇射击");
			elseif petHP < 10 then 
				CastSpellByName("治疗宠物");
			end
		end	
	elseif classarg1 == 4  then --盗贼
		
	elseif classarg1 == 5  then --牧师	
		if mycurrentSpecName == "戒律" then
			if not UnitDebuff("target","暗言术：痛") then
				CastSpellByName("暗言术：痛","target")
			end		
			if not UnitAura("player","真言术：盾") then
				CastSpellByName("真言术：盾")
			end	
			if playerHPpercent() <= 50 then 
				for k, v in pairs(nomalhealTable) do
				local start, duration, enabled = GetSpellCooldown(v);
					if duration == 0 then	
						CastSpellByName(v,"player")
					end
				end	
			end
			for k, v in pairs(jielvTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
					CastSpellByName(v,"target")
				end
			end
		end
	elseif classarg1 == 6  then --DK	
	
	elseif classarg1 == 7  then --萨满 
		if mycurrentSpecName == "增强" then
			local shortRange = CheckInteractDistance("target",3);--9.9yard
			local isMoving = GetUnitSpeed("player")
			if not shortRange and not UnitAura("player","幽魂之狼") and isMoving ~= 0 then
				CastSpellByName("!幽魂之狼")
			end		
			for k, v in pairs(shamanTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
					CastSpellByName(v,"target")
				end
			end
		elseif mycurrentSpecName == "元素" then
			for k, v in pairs(yuansushamanTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
				
				CastSpellByName(v)
				end
			end	
		elseif mycurrentSpecName == "恢复" then
			for k, v in pairs(yuansushamanTable) do
				local start, duration, enabled = GetSpellCooldown(v);
				if duration == 0 then	
				
				CastSpellByName(v)
				end
			end		
		end			
	elseif classarg1 == 8 then --法师
		for k, v in pairs(mageTable) do
			local start, duration, enabled = GetSpellCooldown(v);
			if duration == 0 then
			CastSpellByName(v)
			end
		end
		if isMoving ~= 0 then --如果移动时候
			CastSpellByName("灼烧")
			CastSpellByName("冰枪术")
		else --站立的时候
			CastSpellByName("火球术")
			CastSpellByName("寒冰箭")
		end
	elseif classarg1 == 9  then --术士

	elseif classarg1 == 10  then --武僧

	elseif classarg1 == 11  then --德鲁伊		
	
	elseif classarg1 == 12  then --DH
		if mycurrentSpecName == "浩劫" then
			if UnitAffectingCombat("player") and playerMPpercent() < 30 then --捡球
				MoveForwardStart()
				MoveForwardStop()
			end
			if UnitCanAttack("player", "target") then --普攻
				StartAttack();
			end	
			if cooldowntime(232893) <= 0 and playerMPpercent() <= 77 then
				CastSpellByName("邪能之刃");
			end
			if canInterrupt() and cooldowntime(138752) <= 0 and playerMPpercent() <= 57 then 
				CastSpellByName("吞噬魔法");
			end	
			if cooldowntime(185123) <= 0 and playerMPpercent() <= 57 then 
				CastSpellByName("投掷利刃");	
			end	
			if UnitAura("player","恶魔变形") and playerMPpercent() >= 8 then 
				CastSpellByName("死亡横扫");
			end	
			if cooldowntime(232893) > 0 and playerMPpercent() < 30 then 
				CastSpellByName("刃舞");	
			end	
			if playerMPpercent() < 24 then 
				CastSpellByName("刃舞");		
			end	
			if playerMPpercent() > 30.7 then 
				CastSpellByName("混乱打击");	
			end
		end

	else
		
	end	
	
end
local function survive()--保命技能
	_, _, _, _, _, _, shanxian, _, _, _, _ = UnitAura("player", "火疗闪烁")--闪现回血
	playerhealpercentage = UnitHealth("player") / UnitHealthMax("player") * 100
	if playerhealpercentage <= 35 then
		CastSpellByName("!寒冰屏障")
		CastSpellByName("!星界转移")
	elseif shanxian == nil and playerhealpercentage <= 50 then
		--CastSpellByName("闪光术")
		--CastSpellByName("闪现术")
	end	
	
end
local function autotarget()
	if role == "DAMAGER" then
		local foucusexists = UnitExists("focus")
		local foucusaffectingCombat = UnitAffectingCombat("focus");
		local exists = UnitExists("target")
		if not exists then		
			--TargetLastTarget();
		end	
		--print(foucusexists,foucusaffectingCombat)
		if foucusexists and foucusaffectingCombat then 
			AssistUnit("focus");
		end	
	end	
end
local function clearcurrenttaget()
	targetisDead = UnitIsDead("target")
	foucusaffectingCombat = UnitAffectingCombat("focus"); 
	if not foucusaffectingCombat and targetisDead then
		ClearTarget();--清除当前目标
	elseif targetisDead then
		ClearTarget();--清除当前目标
	end
end
 local function movementstop()--移动停止
	MoveForwardStop()
	MoveBackwardStop()
	StrafeLeftStop()
	StrafeRightStop()
	TurnLeftStop()
	TurnRightStop()
end
local function camerastop()--镜头停止
	MoveViewUpStop()
	MoveViewOutStop()
	MoveViewLeftStop()
	MoveViewInStop()
	MoveViewDownStop()
end
local function followfunc()--跟随功能
	followingspeed = math.floor(GetUnitSpeed(following) / 7 * 100)--跟随目标的速度
	shortRange = CheckInteractDistance(following, 3);--检测码数
		--[[
		1 = Inspect, 28 yards
		2 = Trade, 11.11 yards
		3 = Duel, 9.9 yards
		4 = Follow, 28 yards
		]]
	if followingspeed >= 100 then -- 自动上坐骑
		--print(followingspeed)
		TargetUnit(following);
		RunMacroText("/run RunBinding(\"INTERACTTARGET\")")--与目标互动
	end		
	if not shortRange then	
		if ct ~= 0 and ct ~= 5  then
			followingclass = UnitClass(following);	
			followingname = UnitName(following)
			if followingname ~= nil and not UnitInVehicle("player") then
				FollowUnit(following)
			elseif UnitName("target") == followingname then
				ClearTarget()
			end
			
		elseif ct == 5 then
			TargetNearestRaidMember() 
			TargetNearestPartyMember() 
			FollowUnit("target") 
			--print("跟随最近")
		end	
	elseif shortRange then
	
	end	
end



---------------------------------------------------------------------------
--*****************核心*************************
-----------------------------------------------------------------------------
 local total = 0
 local function onUpdate(self,elapsed)
    total = total + elapsed
	local cast = UnitCastingInfo('player')--玩家正在读条
	local chan = UnitChannelInfo('player')--玩家正在引导
	local exists = UnitExists("target")
	clearcurrenttaget()--当前目标死亡清除目标,或者焦点脱战清除目标
    if total >= 0.1 and not UnitIsDead("target") and not UnitIsDead("player") and UnitCreatureType("target") ~= "野生宠物" then --频率 	
		---------------------------------------------
		DebuffJump() --需要移动debuff时跳跃	
		survive()--保命
		followfunc()--跟随
		autotarget()--协助焦点 如果有焦点autotarget()--协助焦点 如果有焦点
		---------------------------------------------
		
		if CheckButton3:GetChecked() and canInterrupt() then -- 勾选时生效
			Interrupt()--打断
		end	
		if CheckButton2:GetChecked() then -- 勾选时生效
			debuff()--驱散debuff
		end	
		if UnitExists("target") and UnitCanAttack("player", "target") and not cast and not chan then --读条时候 暂停
			if role == "DAMAGER" or CheckButton0:GetChecked() then --DPS 天赋 以及勾选强制DPS时生效
				buffnow()--buff检测
				if  CheckButton4:GetChecked() then -- 勾选时生效
					AOE()--aoe攻击
				end	
				rotation()--输出循环
				UIFrameFadeIn(MainFrame.auto, 0.1, 0.3, 1)
			end	
		elseif not cast and not chan and role == "HEALER" and not CheckButton0:GetChecked() then		---治疗模式
			heal()--治疗
			UIFrameFadeIn(MainFrame.auto, 0.1, 0.3, 1)
		end
	
	total = 0
	end
end
local f = CreateFrame("frame")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

---------------------------------------
MainFrame.Status = MainFrame:CreateFontString(nil,"OVERLAY");
MainFrame.Status:SetFontObject(Game13Font_o1) 
MainFrame.Status:SetAllPoints()
MainFrame.auto = MainFrame:CreateTexture("HIGHLIGHT");
MainFrame.auto:SetAllPoints();
MainFrame.auto:SetColorTexture(r, g, b, 0.8);
MainFrame.button = CreateFrame("Button", nil, MainFrame)
MainFrame.button:SetPoint("CENTER",MainFrame,"CENTER",0,0)
MainFrame.button:SetWidth(110)
MainFrame.button:SetHeight(30)
MainFrame.button:SetScript("OnMouseDown", function(self,button,...) 
	if button == "RightButton" then
		MainFrame.doing:SetText("爆发")	
		if role == "DAMAGER"  or CheckButton0:GetChecked() then
			bigdamage()--伤害爆发
			MainFrame.react:SetColorTexture(1, 185/255, 15/255, 1);
		elseif role == "HEALER"	then
			HealBurst()--治疗爆发
			MainFrame.react:SetColorTexture(144/255, 254/255, 1, 1);
		end	
		UIFrameFadeOut(MainFrame.auto, 0.8, 0, 1)
		UIFrameFadeOut(MainFrame.react, 0.8, 1, 0)
	elseif button == "MiddleButton" then
		FocusUnit();
	elseif buttonflag == 1 and button == "LeftButton" then
		buttonflag = 0
		--MainFrame.doing:SetText("开")
		MainFrame.react:SetColorTexture(0, 1, 0, 1);
		UIFrameFadeOut(MainFrame.auto, 0.5, 0, 1)
		UIFrameFadeOut(MainFrame.doing, 0.5, 0, 1)
		UIFrameFadeOut(MainFrame.icon, 0.5, 0, 1)
		if role == "HEALER"  then 
			UIFrameFadeOut(Healer, 0.5, 0, 1)
		end	
		UIFrameFadeOut(MainFrame.react, 0.5, 1, 0)
		MainFrame.Status:SetText("RUNNING")
		--MainFrame.icon:Show()
		f:SetScript("OnUpdate", onUpdate)
	elseif buttonflag == 0 and button == "LeftButton" then
		buttonflag = 1
		--MainFrame.doing:SetText("关")
		local currentSpec = GetSpecialization()
		local mycurrentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or ""
		MainFrame.react:SetColorTexture(1, 0, 0, 1);
		UIFrameFadeOut(MainFrame.auto, 0.5, 0, 1)
		UIFrameFadeOut(MainFrame.react, 0.5, 1, 0)
		UIFrameFadeOut(MainFrame.doing, 0.5, 1, 0)
		UIFrameFadeOut(MainFrame.icon, 0.5, 1, 0)
		if role == "HEALER" then
			UIFrameFadeOut(Healer, 0.5, 1, 0)
		end	
		MainFrame.Status:SetText(role)
		--MainFrame.icon:Hide()
		f:SetScript("OnUpdate", nil)
	end
end)
MainFrame.button:SetScript("OnMouseWheel", function(self,delta,...) 
	if delta == 1 and ct > 0 then
		ct = ct - 1
		--print(ct,"上")
	elseif delta == -1 and ct < 5 then
		ct = ct + 1
		--print(ct,"下")
	end
	if ct == 0 then
		following = ""
		MainFrame.following:SetText("不进行跟随")
		UIFrameFadeOut(MainFrame.following, 1, 1, 0)
		movementstop()
	elseif 	ct == 1 then
		following = "party1"
		if	UnitName("party1") ~= nil then
			MainFrame.following:SetText("跟随："..UnitClass("party1").."-"..UnitName("party1"))
		else
			MainFrame.following:SetText("P1无跟随目标")			
		end	
		ClearTarget()
		UIFrameFadeOut(MainFrame.following, 0.1, 0, 1)
	elseif 	ct == 2 then
		following = "party2"
		if	UnitName("party2") ~= nil then
			MainFrame.following:SetText("跟随："..UnitClass("party2").."-"..UnitName("party2"))
		else
			MainFrame.following:SetText("P2无跟随目标")	
		end
		UIFrameFadeOut(MainFrame.following, 0.1, 0, 1)
	elseif 	ct == 3 then
		following = "party3"
		if	UnitName("party3") ~= nil then
			MainFrame.following:SetText("跟随："..UnitClass("party3").."-"..UnitName("party3"))
		else
			MainFrame.following:SetText("P3无跟随目标")	
		end
		UIFrameFadeOut(MainFrame.following, 0.1, 0, 1)
	elseif 	ct == 4 then
		following = "party4"
		if	UnitName("party4") ~= nil then
			MainFrame.following:SetText("跟随："..UnitClass("party4").."-"..UnitName("party4"))
		else
			MainFrame.following:SetText("P4无跟随目标")
		end
		UIFrameFadeOut(MainFrame.following, 0.1, 0, 1)
	elseif 	ct == 5 then	
		TargetNearestPartyMember() 
		TargetNearestRaidMember() 
		FollowUnit("target") 
		MainFrame.following:SetText("跟随最近队友")
		UIFrameFadeOut(MainFrame.following, 0.1, 0, 1)
	end	
		
end)
MainFrame.button:SetScript("OnEnter", function() 
	--SetCursor("ATTACK_CURSOR")
 end)
 
 MainFrame.button:SetScript("OnLeave", function() 
	--SetCursor("NORMAL_CURSOR")
 end)

local function wordChatFilter(self, event, msg, author, ...)
	hour, minute = GetGameTime()
	psword = hour+minute
	if buttonflag == 0 then
		if msg:find("嗜血") or msg:find("英勇") then
			CastSpellByName("时间扭曲", "player")--时光嗜血
		elseif msg:find("爆发") then
			bigdamage()
		--[[	
		elseif msg:find("闪现") then
			SpellStopCasting()--停止施法
			CastSpellByName("闪光术", "player")--闪光
		elseif msg:find("冰箱") then
			SpellStopCasting()--停止施法
			CastSpellByName("!寒冰屏障", "player")--寒冰障壁
		
		]]
		elseif msg:find("反制") or msg:find("dd") then
			Interrupt()--打断
		elseif msg:find("跳") then
			JumpOrAscendStart()
		elseif msg:find("marco") and author ~= UnitName("player")then
			parta, partb = strsplit(" ",msg,2)
			print("拾取到宏->"..partb)
			RunMacroText(partb)
		elseif msg:find("上马") and not IsMounted()then	
			C_MountJournal.SummonByID(0)
		elseif msg:find("下马") then	
			Dismount();
		elseif msg:find("cast") then
			parta, partb = strsplit(" ",msg,2)
			CastSpellByName(partb,"target" or nil)--判断施法
		elseif msg:find("使用") then	
			parta, partb = strsplit(" ",msg,2)--判断使用物品
			UseItemByName(partb)
		elseif msg:find("stop") then
			buttonflag = 1
			--MainFrame.doing:SetText("关")
			local currentSpec = GetSpecialization()
			local mycurrentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or ""
			MainFrame.react:SetColorTexture(1, 0, 0, 1);
			UIFrameFadeOut(MainFrame.auto, 0.5, 0, 1)
			UIFrameFadeOut(MainFrame.react, 0.5, 1, 0)
			UIFrameFadeOut(MainFrame.doing, 0.5, 1, 0)
			UIFrameFadeOut(MainFrame.icon, 0.5, 1, 0)
			MainFrame.Status:SetText(role)
			--MainFrame.icon:Hide()
			f:SetScript("OnUpdate", nil)
		elseif msg:find("清空列表") then		
			 NoDISPELtableremove()
		elseif msg:find("展示列表") then		
			 NoDISPELtableshow() 	
		end
	else
		if msg:find("start") then
			buttonflag = 0
			--MainFrame.doing:SetText("开")
			MainFrame.react:SetColorTexture(0, 1, 0, 1);
			UIFrameFadeOut(MainFrame.auto, 0.5, 0, 1)
			UIFrameFadeOut(MainFrame.doing, 0.5, 0, 1)
			UIFrameFadeOut(MainFrame.icon, 0.5, 0, 1)
			UIFrameFadeOut(MainFrame.react, 0.5, 1, 0)
			MainFrame.Status:SetText("RUNNING")
			--MainFrame.icon:Show()
			f:SetScript("OnUpdate", onUpdate)
		end	
	end
end
--------------------------------
--语言检测

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", wordChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", wordChatFilter)
--------------------------------


--removed stuff with no purpose
 ---姓名版——[[
--[[
hooksecurefunc("CompactUnitFrame_UpdateName", function (frame)
   --Set the tag based on UnitClassification, can return "worldboss", "rare", "rareelite", "elite", "normal", "minus"
	local tag 
	local level = UnitLevel(frame.unit)
	local class, englishClass, classarg1 = UnitClass(frame.unit);
	if classarg1 == 0 then r, g, b  =	1.00,	1.00,	1.00	--NPC
		elseif classarg1 == 1 then r, g, b  =	0.78,	0.61,	0.43	--Warrior	
		elseif classarg1 == 2 then r, g, b  =	0.96,	0.55,	0.73	--Paladin
		elseif classarg1 == 3 then r, g, b  =	0.67,	0.83,	0.45	--Hunter
		elseif classarg1 == 4 then r, g, b  =	1.00,	0.96,	0.41	--Rogue
		elseif classarg1 == 5 then r, g, b  =	1.00,	1.00,	1.00	--Priest 
		elseif classarg1 == 6 then r, g, b  =	0.77,	0.12,	0.23	--DeathKnight
		elseif classarg1 == 7 then r, g, b  =	0.00,	0.44,	0.87	--Shaman
		elseif classarg1 == 8 then r, g, b  =	0.41,	0.80,	0.94	--Mage
		elseif classarg1 == 9 then r, g, b  =	0.58,	0.51,	0.79	--Warlock
		elseif classarg1 == 10 then r, g, b  =	0.00,	1.00,	0.59	--Monk
		elseif classarg1 == 11 then r, g, b  =	1.00,	0.49,	0.04	--Druid
		elseif classarg1 == 12 then r, g, b  =	0.64,	0.19,	0.79	--DH
		elseif classarg1 == nil then r, g, b  =	0,	1,	0
	end	

	local inInstance, instanceType = IsInInstance()
	
	if not inInstance then---不在副本生效，副本里报错
		local tex = frame.FactionIcon or frame:CreateTexture(nil, "OVERLAY")
		frame.FactionIcon = tex
		tex:SetSize(50, 50)
		tex:SetPoint("LEFT",frame, -40, 0)
		frame.healthBar:SetStatusBarColor(r, g, b)
		local factionGroup = UnitFactionGroup(frame.unit) or " "
		if factionGroup == "Alliance" then
			frame.TexturePath = "Interface\\Timer\\Alliance-Logo"
		elseif factionGroup == "Horde" then
			frame.TexturePath = "Interface\\Timer\\Horde-Logo"
		elseif factionGroup == "Neutral" then
			frame.TexturePath = "Interface\\AddOns\\AutoRotation\\image\\image1.tga"
		else
			frame.TexturePath = nil
		end
		tex:SetTexture(frame.TexturePath)
		if UnitClassification(frame.unit) == "worldboss" or UnitLevel(frame.unit) == -1 then
		  tag = "Boss"
		  level = "??"
		elseif UnitClassification(frame.unit) == "rare" or UnitClassification(frame.unit) =="rareelite" then
		  tag = "稀有"
		elseif UnitClassification(frame.unit) == "elite" then
		  tag = "精英"
		else 
		  tag = ""
		end
	   --Set the nameplate name to include tag(if any), name and level
		----frame.name:SetText(level.." "..UnitName(frame.unit))
		--frame.name:SetTextColor(r, g, b, 1)
	end	
end)
--]]

------秒拾取
local loot = CreateFrame("Frame")
local epoch = 0 -- time of the last auto loot

local LOOT_DELAY = 0.3 -- constant interval that prevents rapid looting

-- loots items if auto loot is turned on xor toggle key is pressed
local function LootContents()
  -- slows method calls to once a LOOT_DELAY interval since LOOT_READY event fires twice
  if (GetTime() - epoch >= LOOT_DELAY) then
    epoch = GetTime()
    
    if (GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE")) then -- xor
      for i = GetNumLootItems(), 1, -1 do
        LootSlot(i)
      end
      
      epoch = GetTime() -- update time
    end
  end
end

-- triggering events and actions to fire
loot:RegisterEvent("LOOT_READY")
loot:SetScript("OnEvent", LootContents)


---------调节限容
local AutoLagTolerance = CreateFrame( "Frame", "AutoLagTolerance" )
 
local currentTolerance = GetCVar( "SpellQueueWindow" )
local lastUpdateTime   = 0
 
local function AutoLagTolerance_OnUpdate ( self, elapsed )
    lastUpdateTime = lastUpdateTime + elapsed
 
    -- Update once per second.
    if lastUpdateTime < 1.0 then
        return
    else
        lastUpdateTime = 0
    end
 
    -- Retrieve the world latency.
    local newTolerance = select( 4, GetNetStats() )
 
    -- Ignore an empty value.
    if newTolerance == 0 then
        return
    end
 
    -- Prevent update spam.
    if newTolerance == currentTolerance then
        return
    else
        currentTolerance = newTolerance
    end
 
    -- Adjust the "Lag Tolerance" slider.
    SetCVar( "SpellQueueWindow", newTolerance )
end
 
local function AutoLagTolerance_OnEvent ( self, event, arg1, arg2, ... )
    if event == "PLAYER_ENTERING_WORLD" then
        SetCVar( "SpellQueueWindow", 1 )
    end
end
 
AutoLagTolerance:SetScript( "OnUpdate", AutoLagTolerance_OnUpdate )
AutoLagTolerance:SetScript( "OnEvent",  AutoLagTolerance_OnEvent  )
 
AutoLagTolerance:RegisterEvent( "PLAYER_ENTERING_WORLD" )

-- deleted whatever was here
--[[
local counter = 0
local function hook_JumpOrAscendStart(...)
  counter = counter + 1
  ChatFrame1:AddMessage("Boing! Boing! - " .. counter .. " jumps.")
end
hooksecurefunc("JumpOrAscendStart", hook_JumpOrAscendStart)



]]






