if not C_Item then return end

--
-- MI2_Events.lua
--
-- Handlers for all WoW events that MobInfo subscribes to. This includes
-- the main MobInfo OnEvent handler called "MI2_OnEvent()". Event handling
-- is based on a global table of event handlers called "MI2_EventHandlers[]".
-- For each event that MobInfo supports the corresponding handler function
-- is available in the table.
--
-- (this is code restructering work in progress, it has not yet been completed ... )
--

-- global variables initialisation
MI2_Target = {}
MI2_CurZone = 0

-- miscellaneous other event related global vairables 
MI2_IsNonMobLoot = nil

-- local variables declaration and initialisation
local MI2_EventHandlers = { }
local MI2_GT_OnShow_Orig
local MI2_Scan_SelfBuff
local MI2_LootFrameOpen = false

-----------------------------------------------------------------------------
-- MI2_VariablesLoaded()
--
-- main global initialization function, this is called as the handler
-- for the "VARIABLES_LOADED" event
-----------------------------------------------------------------------------
local function MI2_VariablesLoaded()
	-- initialize "MobInfoConfig" data structure (main MobInfo config options)
	MI2_InitOptions()
	MI2_UpdateMinimapButton()

	-- register with all AddOn managers that MobInfo attempts to support
	-- currently that is: myAddons, KHAOS (mainly for Cosmos), EARTH (originally for Cosmos)
	MI2_RegisterWithAddonManagers()

	-- ensure that MobHealthFrame get set correctly (if we have to set it for compatibility)
	if  MobHealthFrame == "MI2"  then
		MobHealthFrame = MI2_MobHealthFrame
	end

	-- setup a confirmation dialog for critical configuration options
	StaticPopupDialogs["MOBINFO_CONFIRMATION"] = {
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		showAlert = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
	}
	StaticPopupDialogs["MOBINFO_SHOWMESSAGE"] = {
		button1 = TEXT(OKAY),
		showAlert = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
	}

	-- cleanup for all databases
	MI2_CleanupDatabases()

	-- obtain player name and realm name
	MI2_SetPlayerName()
	-- setup event handling for the entire AddOn (MobInfo and MobHealth)
	MI2_UpdateMobInfoState()
	-- initialize slash commands processing
	MI2_SlashInit()
	-- build cross reference table for fast item tooltips
	MI2_BuildXRefItemTable()

	-- from this point onward process events
	MI2_InitializeEventTable()
	
	-- extend the spell school table to list both schools and schortcuts
	local newSchools = {}
	local school, schortcut
	for school, schortcut in pairs(MI2_SpellSchools) do
		newSchools[school] = schortcut
		newSchools[schortcut] = school
	end
	MI2_SpellSchools = newSchools

	-- hook into OnShow for main game tooltip (needed to add info to tooltip)
	MI2_GT_OnShow_Orig = GameTooltip:GetScript("OnShow")
	GameTooltip:SetScript( "OnShow", MI2_GameTooltip_OnShow )

	-- MODIFIER_STATE_CHANGED: when KeypressMode is active, dynamically show/hide
	-- MobInfo data as the ALT key is pressed or released while a mob is hovered.
	local MI2_AltFrame = CreateFrame("Frame")
	MI2_AltFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
	MI2_AltFrame:SetScript("OnEvent", function()
		-- arg1 = key name (e.g. "LALT"/"RALT"), arg2 = 1 (down) or 0 (up)
		if arg1 ~= "LALT" and arg1 ~= "RALT" then return end
		if MobInfoConfig.DisableMobInfo == 1 or MobInfoConfig.KeypressMode == 0 then return end
		if not GameTooltip:IsVisible() then return end

		-- Only act when a hostile/neutral creature is currently moused over
		if not (UnitCreatureType("mouseover") and UnitIsFriend("player","mouseover") == nil) then
			return
		end

		if arg2 == 1 then
			-- ALT pressed: inject MobInfo data directly, bypassing the
			-- IsAltKeyDown() gate inside MI2_GameTooltip_OnShow which may
			-- not yet reflect the new key state at event-fire time.
			local mouseoverID = UnitCreatureID("mouseover")
			local mouseoverLevel = UnitLevel("mouseover")
			if mouseoverID then
				MI2_MigrateMobEntry( mouseoverID, UnitName("mouseover"), mouseoverLevel )
			end
			MI2_BuildMobInfoTooltip( mouseoverID or UnitName("mouseover"), mouseoverLevel, nil )
			GameTooltip:Show()
		else
			-- ALT released: restore the vanilla tooltip via SetUnit, then
			-- re-apply the correct reaction colour to the mob name on line 1.
			GameTooltip:SetUnit("mouseover")
			local nameText = getglobal("GameTooltipTextLeft1")
			if nameText then
				local reaction = UnitReaction("player", "mouseover")
				local color = FACTION_BAR_COLORS and reaction and FACTION_BAR_COLORS[reaction]
				if color then
					nameText:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

-----------------------------------------------------------------------------
-- MI2_EventLootOpened()
--
-- WoW event notification that loot frame has been opened
-----------------------------------------------------------------------------
local function MI2_EventLootOpened( )
	local index = MI2_Target.mobIndex or MI2_LastTargetIdx
	local numItems = GetNumLootItems()

	MI2_CurrentCorpseIndex = nil
	MI2_LootFrameOpen = true

	-- if there is a target it must be a dead one, the loot must be mob loot
	-- reject non empty loots without target (empty loots opened by "QuickLoot" have no target)
	if (not MI2_Target.mobIndex and numItems > 0)
			or (MI2_Target.mobIndex and not UnitIsDead("target")) or MI2_IsNonMobLoot then
		MI2_IsNonMobLoot = false
		return
	end

	-- check if this is a known corpse being reopened, reopened corpses
	-- can (and must) be ignored because they have already been fully processed
	if MI2_CheckForCorpseReopen(index) then
		return
	end	

	-- record all loot found on the corpse (called each time to catch skinning))
	MI2_RecordAllLootItems( index, numItems )
end

-----------------------------------------------------------------------------
-- MI2_EventLootSlotCleared()
--
-- WoW event notification that one loot item has been looted.
-- This results in a new corpse ID which must be stored for corpse reopen
-- detection
-----------------------------------------------------------------------------
local function MI2_EventLootSlotCleared( )
	MI2_StoreCorpseId( MI2_GetCorpseId(MI2_Target.mobIndex) )
end

-----------------------------------------------------------------------------
-- MI2_EventLootClosed()
--
-- Event handler for WoW event that the loot window has been closed.
-- This is used to catch empty loots when using auto-loot (Shift+RightClick)
-- In this case "LOOT_CLOSED" is the only loot event that fires
-----------------------------------------------------------------------------
local function MI2_EventLootClosed( )
	local mobIndex = MI2_Target.mobIndex
	if mobIndex and not MI2_LootFrameOpen then
		MI2_RecordAllLootItems( mobIndex, 0 )
	end
	MI2_LootFrameOpen = false
end

-----------------------------------------------------------------------------
-- MI2_EventUnitCombat()
--
-- Event handler for the "UNIT_COMBAT" event. This handler will
-- accumulate all damage done to the current target, and will record all
-- damage done to the player by the current target.
-----------------------------------------------------------------------------
local function MI2_EventUnitCombat()
	if arg1 == "target" then
		if MI2_Target.index and arg4 > 0 then
--*****
MI2_RecordTargetCombat( arg4, arg2 == "HEAL" )
--*****
		end
	elseif arg1 == "player" then
		if arg3 ~= "CRITICAL" and arg2 ~= "HEAL" and MI2_Target.mobIndex then 
			MI2_RecordDamage( MI2_Target.mobIndex, tonumber(arg4) )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_EventUnitHealth()
--
-- Event handler for the "UNIT_HEALTH" event. This handler will
-- process health number that WoW gives us for the current target. Combining
-- the health value with the damage done to the current target and with the
-- current health percentage of the target allows us to calculate the PPP
-- value (Point Per Percent) for the current target. The PPP value can then
-- be used to calculate a health value from a given health percentage.
--
-- if health value has changed update game tooltip
-----------------------------------------------------------------------------
local function MI2_EventUnitHealth()
	if arg1 == "target" then
--*****
MI2_RecordTargetHealth( UnitHealth("target") )
--*****
	end

	-- update health in MobInfo tooltip when target health changes and tooltip is visible
	if arg1 == "target" and MI2_HealthLine and GameTooltip:IsShown() then
		local mobIndex = MI2_Target.mobIndex
		if mobIndex then
			local mobPPP = MobHealth_PPP(mobIndex)
			if mobPPP <= 0 then mobPPP = 1 end
			local healthMax = floor(mobPPP * 100 + 0.5)
			local healthCur
			if UnitHealthMax("target") == 100 then
				healthCur = floor(mobPPP * UnitHealth("target") + 0.5)
			else
				healthCur = UnitHealth("target")
				healthMax = UnitHealthMax("target")
			end
			MI2_UpdateTooltipHealthMana( healthCur, healthMax )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_EventUnitMana()
--
-- Event handler for the "UNIT_MANA" event.
-- This handler will update the mana shown in the target frame and also
-- update mana shown in the game tooltip.
-----------------------------------------------------------------------------
local function MI2_EventUnitMana()
	if arg1 == "target" then
		MobHealth_Display( )
	end

	-- update health and mana shown in MobInfo tooltip
	if GameTooltip:IsShown() then
		MI2_UpdateTooltipHealthMana()
	end
end

-----------------------------------------------------------------------------
-- MI2_OnTargetChanged()
--
-- Event handler for the "PLAYER_TARGET_CHANGED" event. This handler will
-- fill the global variable "MI2_Target" with all the data that MobInfo2
-- needs to know about the current target.
-----------------------------------------------------------------------------
function MI2_OnTargetChanged()
	local name = UnitName("target")
	local level = UnitLevel("target")

	MI2_IsNonMobLoot = false -- to reset non Mob loot detection

	-- previous target post processing: update targets HP in database,
	-- remember last targets mob index, update DPS if recorded
	if  MI2_Target.mobIndex then
		MI2_SaveTargetHealthData()
		MI2_LastTargetIdx = MI2_Target.mobIndex
		if MI2_Target.FightStartTime then
			MI2_RecordDps( MI2_LastTargetIdx, MI2_Target.FightEndTime - MI2_Target.FightStartTime, MI2_Target.FightDamage )
		end
		if MobInfoConfig.SaveResist == 1 then
			MI2_StoreResistData( MI2_LastTargetIdx )
		end
	end

	if name and level and (UnitCanAttack("player","target") or UnitIsPlayer("target")) then
		MI2_Target = { name=name, level=level }
		MI2_Target.class = UnitClass("target")

		-- set index to either player or mob and store matching health database
		if  UnitIsPlayer("target")  then
			-- Use GUID as the key for player health data so it persists through
			-- name changes and is unique per realm. Migrate old name-keyed entries.
			local guid = UnitGUID("target")
			if guid and MobHealthPlayerDB then
				if MobHealthPlayerDB[name] and not MobHealthPlayerDB[guid] then
					MobHealthPlayerDB[guid] = MobHealthPlayerDB[name]
					MobHealthPlayerDB[name] = nil
				end
			end
			MI2_Target.index = guid or name
			MI2_Target.healthDB = MobHealthPlayerDB
		else
			MI2_Target.creatureID = UnitCreatureID("target")
			if MI2_Target.creatureID then
				-- skip transient mob summons whose ID has no permanent creature
				-- template (e.g. voidwalkers summoned by warlock NPCs): they
				-- produce unresolvable numeric DB keys like "98164:N".
				local info = C_CreatureInfo.GetCreatureInfoByID( MI2_Target.creatureID )
				if not info then
					MI2_Target = {}
				else
					MI2_Target.mobIndex = MI2_MigrateMobEntry( MI2_Target.creatureID, name, level ) or (MI2_Target.creatureID..":"..level)
				end
			else
				MI2_Target.mobIndex = name..":"..level
			end
			-- health index and DB now use the ID-based mobIndex, backed by MobInfoDB[key].mh
			if MI2_Target.mobIndex then
				MI2_Target.index = MI2_Target.mobIndex
				MI2_Target.healthDB = MI2_MobHpDB
				MI2_RecordLocationAndType( MI2_Target.mobIndex )
				if level < (UnitLevel("player") + 5) then MI2_Target.ResOk = true end
				local mobData = MI2_FetchMobData( MI2_Target.mobIndex )
				if mobData then mobData.killed = nil end
			end
		end
	else
		MI2_Target = {}
	end

--***************************
-- update mob health display with health for new target
MI2_HpSetNewTarget()
--***************************

	-- update options dialog if shown
	if  frmMIConfig:IsVisible()  then
		MI2_DbOptionsFrameOnShow()
	end

end

-----------------------------------------------------------------------------
-- MI2_EventSelfMelee()
--
-- handler for event CHAT_MSG_COMBAT_SELF_HITS
-- handles normal and critical melee damage
-----------------------------------------------------------------------------
local function MI2_EventSelfMelee( )
	-- process event only for Mobs
	if not MI2_Target.mobIndex then return end

	local s,e, mob, damage = string.find(arg1, MI2_ChatScanStrings[4])
--if damage then chattext( "DBG: COMBATHITSELFOTHER: dmg="..damage ) end
	if not damage then
		s,e, mob, damage = string.find(arg1, MI2_ChatScanStrings[5])
--if damage then chattext( "DBG: COMBATHITCRITSELFOTHER: dmg="..damage ) end
	end

	if damage then
		MI2_RecordHit( tonumber(damage) )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventSelfSpell()
--
-- handler for event "CHAT_MSG_SPELL_SELF_DAMAGE"
-- handles normal and critical spell damage and damage done by bows/guns
-----------------------------------------------------------------------------
local function MI2_EventSelfSpell( )
	local isResist = false

	-- process event only for Mobs
	if not MI2_Target.mobIndex then return end

	local s,e, spell, mob, damage, school = string.find(arg1, MI2_ChatScanStrings[17])
--if damage then chattext( "DBG: SPELLLOGCRITSCHOOLSELFOTHER: dmg="..damage..", spell="..spell..", school="..school ) end
	if not damage then
		s,e, spell, mob, damage, school = string.find(arg1, MI2_ChatScanStrings[7])
--if damage then chattext( "DBG: SPELLLOGSCHOOLSELFOTHER: dmg="..damage..", spell="..spell..", school="..school ) end
		if not damage then
			s,e, spell, mob, damage = string.find(arg1, MI2_ChatScanStrings[6])
--if damage then chattext( "DBG: SPELLLOGSELFOTHER: dmg="..damage..", spell="..spell ) end
			if not damage then
				s,e, spell, mob, damage = string.find(arg1, MI2_ChatScanStrings[8])
--if damage then chattext( "DBG: SPELLLOGCRITSELFOTHER: dmg="..damage..", spell="..spell ) end
				if not damage then
					s,e, mob, spell = string.find(arg1, MI2_ChatScanStrings[14])
--if spell then chattext( "DBG: IMMUNESPELLSELFOTHER: spell="..spell ) end
					if not spell then
						s,e, spell, mob = string.find(arg1, MI2_ChatScanStrings[15])
--if mob then chattext( "DBG: SPELLIMMUNESELFOTHER: spell="..(spell or "nil")..", mob="..(mob or "nil") ) end
						if not mob then
							s,e, spell, mob = string.find(arg1, MI2_ChatScanStrings[16])
							isResist = true
--if mob then chattext( "DBG: SPELLRESISTSELFOTHER: spell="..(spell or "nil")..", mob="..(mob or "nil") ) end
	end end end end end end

	if damage then
		MI2_RecordHit( tonumber(damage), spell, school )
	elseif mob and spell then
		MI2_RecordImmunResist( mob, spell, isResist )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventPetMelee()
--
-- handler for event "CHAT_MSG_COMBAT_PET_HITS" and "CHAT_MSG_SPELL_PET_DAMAGE"
-- handles normal and critical melee/spell damage done by players pet
-----------------------------------------------------------------------------
local function MI2_EventPetMelee( )
	-- process event only for Mobs
	if not MI2_Target.mobIndex then return end

	local s,e, pet, mob, damage = string.find(arg1, MI2_ChatScanStrings[10])
--if damage then chattext( "DBG: pet COMBATHITOTHEROTHER: dmg="..damage ) end
	if not damage then
		s,e, pet, mob, damage = string.find(arg1, MI2_ChatScanStrings[11])
--if damage then chattext( "DBG: pet COMBATHITCRITOTHEROTHER: dmg="..damage ) end
	end

	if damage then
		MI2_RecordHit( tonumber(damage) )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventPetSpell()
--
-- handler for event "CHAT_MSG_COMBAT_PET_HITS" and "CHAT_MSG_SPELL_PET_DAMAGE"
-- handles normal and critical melee/spell damage done by players pet
-----------------------------------------------------------------------------
local function MI2_EventPetSpell( )
	-- process event only for Mobs
	if not MI2_Target.mobIndex then return end

	local s,e, pet, spell, mob, damage = string.find(arg1, MI2_ChatScanStrings[12])
--if damage then chattext( "DBG: pet SPELLLOGOTHEROTHER: dmg="..damage ) end
	if not damage then
		s,e, pet, spell, mob, damage = string.find(arg1, MI2_ChatScanStrings[13])
--if damage then chattext( "DBG: pet SPELLLOGCRITOTHEROTHER: dmg="..damage ) end
	end

	if damage then
		MI2_RecordHit( tonumber(damage) )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventSpellPeriodic()
--
-- handler for event "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"
-- handles periodic damage done by spells
-----------------------------------------------------------------------------
local function MI2_EventSpellPeriodic()
	-- process event only for Mobs
	if not MI2_Target.mobIndex then return end

	local s,e, mob, damage, school, spell = string.find(arg1, MI2_ChatScanStrings[9])
--if damage then chattext( "DBG: PERIODICAURADAMAGESELFOTHER: dmg="..damage..", spell="..spell..", school="..school ) end
	if not damage then
		s,e, mob, spell = string.find(arg1, MI2_ChatScanStrings[18])
--if spell then chattext( "DBG: AURAADDEDOTHERHARMFUL: mob="..mob..", spell="..spell ) end
	end

	if damage then
		MI2_RecordHit( damage, spell, school, true )
	else
		MI2_RecordHit( 0, spell, school )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventSpellPeriodic_ZHTW()
--
-- Special processing of periodic events for the Chinese localisation.
-- This function was kindly submitted by Andyca Chiou.
-----------------------------------------------------------------------------
local function MI2_EventSpellPeriodic_ZHTW()
	-- process event only for Mobs
	--*** 2006/10/4 Modified by zhTW DOT message parsing
	if not MI2_Target.mobIndex then return end
	
	--local s,e, mob, damage, school, spell = string.find(arg1, MI2_ChatScanStrings[9])
	local s,e, spell, mob, damage, school = string.find(arg1, MI2_ChatScanStrings[9])
--if damage then chattext( "DBG: PERIODICAURADAMAGESELFOTHER: dmg="..damage..", spell="..spell..", school="..school ) end

  if not damage then
		s,e, mob, spell = string.find(arg1, MI2_ChatScanStrings[18])
--if spell then chattext( "DBG: AURAADDEDOTHERHARMFUL: mob="..mob..", spell="..spell ) end
	end

	--if damage then
	--	MI2_RecordHit( tonumber(damage) )
	--end
	if damage then
		MI2_RecordHit( damage, spell, school, true )
	else
		MI2_RecordHit( 0, spell, school )
	end
  --*** End Modification
end

-----------------------------------------------------------------------------
-- MI2_EventSelfBuff()
--
-- event handler for the WoW "CHAT_MSG_SPELL_SELF_BUFF" event
-- This event is called for lots of miscellaneous reasons. The reason I
-- subscribe to it is to detect the opening of chest loot or collecting
-- loot (chests, barrels, mining, herbs)
-----------------------------------------------------------------------------
local function MI2_EventSelfBuff()
	local s,e, lootAction, lootType = string.find( arg1, MI2_ChatScanStrings[1] )

	-- set global flag that a non Mob loot window is being opened
	if lootAction and lootType then
		MI2_IsNonMobLoot = true
	end
end

-----------------------------------------------------------------------------
-- MI2_EventSelfBuff_ZHTW()
--
-- zhTW Chinese version parsing function for MI2_EventSelfBuff()
-- This function was kindly submitted by Andyca Chiou.
-----------------------------------------------------------------------------
local function MI2_EventSelfBuff_ZHTW()
	local s,e, lootType, lootAction  = string.find( arg1, MI2_ChatScanStrings[1] )

	-- set global flag that a non Mob loot window is being opened
	if lootAction and lootType then
		MI2_IsNonMobLoot = true
	end
end

-----------------------------------------------------------------------------
-- MI2_EventHostileDeath()
--
-- Event handler for chat message telling me that a hostile mob has
-- died.
-----------------------------------------------------------------------------
local function MI2_EventHostileDeath()
	local s,e, creatureName = string.find( arg1, MI2_ChatScanStrings[2] )
	if creatureName then
		MI2_RecordKill( creatureName )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventCreatureDiesXP()
--
-- event handler for the chat message telling us that a mob died
-- and gave us XP points
-----------------------------------------------------------------------------
function MI2_EventCreatureDiesXP()
	local s,e, creature, xp = string.find( arg1, MI2_ChatScanStrings[3] )
	if creature and xp then
		MI2_RecordKill( creature, tonumber(xp) )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventMonsterEmote()
--
-- event handler for the WoW "CHAT_MSG_MONSTER_EMOTE" event
-----------------------------------------------------------------------------
local function MI2_EventMonsterEmote()
	local s,e = string.find( arg1, MI2_CHATMSG_MONSTEREMOTE )
	if s then
		MI2_RecordLowHpAction( arg2, 1 )
	end
end

-----------------------------------------------------------------------------
-- MI2_EventZoneChanged()
--
-- event handler for "ZONE_CHANGED_NEW_AREA" and "ZONE_CHANGED_INDOORS"
-- this is processed for mob location tracking so that we know the zone
-----------------------------------------------------------------------------
local function MI2_EventZoneChanged()
	MI2_SetNewZone()
end

-----------------------------------------------------------------------------
-- MI2_Player_Login()
--
-- register the GameTooltip:OnShow event at player login time. This ensures
-- that MobInfo is the (hopefully) last AddOn to hook into this event.
-----------------------------------------------------------------------------
local function MI2_Player_Login()
	-- set current zone
	MI2_EventZoneChanged()

	-- scan spellbook to fill spell to school conversion table
	MI2_ScanSpellbook()

	-- pre-load creature names for all mob IDs in the database
	MI2_PreloadCreatureNames()

	-- kick off fast item cache warming for uncached pending items
	MI2_PreloadItems()

	if not (myAddOnsFrame_Register or EarthFeature_AddButton or Khaos) then
	end
end

-----------------------------------------------------------------------------
-- MI2_GameTooltip_OnShow
--
-- OnShow event handler for the GameTooltip frame
-- This handler will :
--   * call the original handler which it replaces
--   * if a valid Mob is hovered display the corresponding MobInfo data
--   * if a known item is hovered add the corresponding item data
-----------------------------------------------------------------------------
function MI2_GameTooltip_OnShow( )
	MI2_HealthLine, MI2_ManaLine = nil, nil
	MI2_CurrentItemTooltip = nil
	MI2_CurrentItemID = nil

	-- check if mobinfo tooltip extensions are enabled and check for keypress mode
	if MobInfoConfig.DisableMobInfo == 0 and (MobInfoConfig.KeypressMode == 0
			or MobInfoConfig.KeypressMode == 1 and IsAltKeyDown())  then
		local firstline = getglobal("GameTooltipTextLeft1");

		if  UnitCreatureType("mouseover") and UnitIsFriend("player","mouseover") == nil then
			-- add mob data to mob tooltip (show abbreviated location)
			local mouseoverID = UnitCreatureID("mouseover")
			local mouseoverLevel = UnitLevel("mouseover")
			-- skip transient NPC summons whose creature ID has no permanent
			-- template in the cache (e.g. voidwalkers summoned by warlock NPCs)
			local skipMob = mouseoverID and not C_CreatureInfo.GetCreatureInfoByID( mouseoverID )
			if not skipMob then
				if mouseoverID then
					MI2_MigrateMobEntry( mouseoverID, UnitName("mouseover"), mouseoverLevel )
				end
				MI2_BuildMobInfoTooltip( mouseoverID or UnitName("mouseover"), mouseoverLevel, nil )
				GameTooltip:Show()
			end
		elseif firstline and UnitClass("mouseover") == nil then
			-- add item loot info to item tooltip
			-- use GetItem() to retrieve base itemID, then resolve to base name
			-- so random-suffix items (e.g. "of the Tiger") match the XRef table
			local _, _, tooltipItemID = GameTooltip:GetItem()
			local lookupName
			if tooltipItemID then
				lookupName = C_Item.GetItemNameByID(tooltipItemID)
			end
			if not lookupName then
				lookupName = firstline:GetText()
			end
			MI2_CurrentItemTooltip = lookupName
			MI2_CurrentItemID = tooltipItemID
			if MI2_BuildItemDataTooltip( lookupName ) then
				GameTooltip:Show()
			end
		end
	end

	-- call original WoW event for GameTooltip:OnShow()
	if MI2_GT_OnShow_Orig then
		MI2_GT_OnShow_Orig(event)
	end
end

-----------------------------------------------------------------------------
-- MI2_InitializeEventTable()
--
-- This function enables (ie. registers) only those events that are
-- needed for the current MobInfo recording options. The general rule is
-- that we only register events if we want to record the data of the event.
-----------------------------------------------------------------------------
function MI2_InitializeEventTable()
	-- reset all events to their always on flag state
	for eventName, eventInfo in pairs(MI2_EventHandlers) do
		local eventEnabled = eventInfo.always
								or MobInfoConfig.SaveBasicInfo == 1 and eventInfo.basic
								or MobInfoConfig.SaveCharData == 1 and eventInfo.char
								or MobInfoConfig.SaveItems == 1 and eventInfo.items
								or MobInfoConfig.SaveLocation == 1 and eventInfo.loc
		if eventEnabled then
			this:RegisterEvent( eventName )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_OnEvent()
--
-- MobInfo main event handler function, gets called for all registered events
-- uses table with event handler info
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- MI2_EventCreatureDataLoaded()
--
-- Called when CREATURE_DATA_LOAD_RESULT fires (arg1=creatureID, arg2=success).
-- Flushes cached mob data for the loaded creature so subsequent tooltip
-- renders use the real name instead of a numeric fallback.
-----------------------------------------------------------------------------
function MI2_EventCreatureDataLoaded()
	if not arg2 then
		-- load failed: still advance the preload queue
		if MI2_CreaturePreloadPending and MI2_CreaturePreloadPending > 0 then
			MI2_CreaturePreloadPending = MI2_CreaturePreloadPending - 1
		end
		MI2_CreaturePreload_Next()
		return
	end
	local creatureID = arg1
	if not creatureID then return end

	-- advance the creature preload queue
	if MI2_CreaturePreloadPending and MI2_CreaturePreloadPending > 0 then
		MI2_CreaturePreloadPending = MI2_CreaturePreloadPending - 1
	end
	MI2_CreaturePreload_Next()

	-- service rank migration set
	if MI2_RankMigrationSet and MI2_RankMigrationSet[creatureID] then
		MI2_RankMigrationSet[creatureID] = nil
		MI2_RankMigrationDone = MI2_RankMigrationDone + 1
		local info = C_CreatureInfo.GetCreatureInfoByID(creatureID)
		if info and MobInfoConfig.SaveBasicInfo == 1 then
			local rank = info.rank
			local mobType
			if	   rank == 0 then mobType = 1
			elseif rank == 4 then mobType = 4
			elseif rank == 3 then mobType = 3
			else				  mobType = 2
			end
			local idStr = tostring(creatureID)
			for mobIndex, mobInfo in pairs(MobInfoDB) do
				if type(mobInfo) == "table" then
					local cid = MI2_GetIndexComponents(mobIndex)
					if cid == idStr then
						local mobData = MI2_FetchMobData(mobIndex)
						mobData.mobType = mobType
						MI2_StoreBasicInfo(mobIndex, mobData)
						if MI2_MobCache then MI2_MobCache[mobIndex] = nil end
					end
				end
			end
		end
		if MI2_RankMigrationDone >= MI2_RankMigrationTotal then
			DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffMobInfo2:|r Database migration complete.")
			MI2_RankMigrationSet = nil
		end
	end

	-- flush mob cache for this creature
	if MI2_MobCache then
		for mobIndex in pairs(MI2_MobCache) do
			if type(mobIndex) == "string" then
				local cid = MI2_GetIndexComponents(mobIndex)
				if tonumber(cid) == creatureID then
					MI2_MobCache[mobIndex] = nil
				end
			end
		end
	end

	-- if current target is this creature, record rank
	if MI2_Target.creatureID and MI2_Target.creatureID == creatureID and MI2_Target.mobIndex then
		local info = C_CreatureInfo.GetCreatureInfoByID(creatureID)
		if info and MobInfoConfig.SaveBasicInfo == 1 then
			local mobData = MI2_FetchMobData(MI2_Target.mobIndex)
			local rank = info.rank
			if	   rank == 0 then mobData.mobType = 1
			elseif rank == 4 then mobData.mobType = 4
			elseif rank == 3 then mobData.mobType = 3
			else				  mobData.mobType = 2
			end
			MI2_StoreBasicInfo(MI2_Target.mobIndex, mobData)
			MI2_MobCache[MI2_Target.mobIndex] = nil
		end
		MI2_OnTargetChanged()
	end

	-- if an item tooltip is showing, rebuild it so #ID names update to real names
	if MI2_CurrentItemTooltip and MI2_CurrentItemID and GameTooltip:IsVisible() then
		GameTooltip:SetItemByID(MI2_CurrentItemID)
	end
end

-----------------------------------------------------------------------------
-- MI2_EventItemInfoReceived()
--
-- Called when GET_ITEM_INFO_RECEIVED fires (arg1=itemID).
-- Rebuilds the XRef item table to include items that were not cached
-- when the table was first built (e.g. after a WDB clear).
-- Also refreshes any currently open item tooltip.
-----------------------------------------------------------------------------
function MI2_EventItemInfoReceived()
	local itemID = arg1
	if not itemID or not MI2_PendingItemIDs then return end

	local pending = MI2_PendingItemIDs[itemID]
	if not pending then return end

	local itemText = C_Item.GetItemNameByID(itemID)
	if not itemText then return end

	-- add to XRef table using the pre-built pending lookup
	for mobIndex, amount in pairs(pending) do
		MI2_AddItemToXRefTable( mobIndex, itemText, amount )
	end
	MI2_PendingItemIDs[itemID] = nil

	-- if an item tooltip is open and it is for this item, rebuild it
	if MI2_CurrentItemID and MI2_CurrentItemID == itemID and GameTooltip:IsVisible() then
		GameTooltip:SetItemByID( MI2_CurrentItemID )
	end
end

function MI2_OnEvent( event )	
	MI2_EventHandlers[event].f()
end

-----------------------------------------------------------------------------
-- MI2_OnLoad()
--
-- Set up main event handler table and do stuff that must be done before
-- "VARIABLES_LOADED" is called.
-----------------------------------------------------------------------------
function MI2_OnLoad()
	-- main MobInfo event handler table
	-- "f"=function to call, "always"=event always on flag, "basic"=mob basic info event, 
	-- "items"=item tracking event, "loc"=mob location event, "char"=char specific event
	MI2_EventHandlers = {
		VARIABLES_LOADED = {f=MI2_VariablesLoaded, on=1},
		UNIT_COMBAT = {f=MI2_EventUnitCombat, always=1},
		UNIT_HEALTH = {f=MI2_EventUnitHealth, always=1},
		UNIT_MANA = {f=MI2_EventUnitMana, always=1},
		PLAYER_TARGET_CHANGED = {f=MI2_OnTargetChanged, always=1},
		PLAYER_LOGIN = {f=MI2_Player_Login, always=1},

		LOOT_OPENED = {f=MI2_EventLootOpened, basic=1, items=1},
		LOOT_CLOSED = {f=MI2_EventLootClosed, basic=1, items=1},
		LOOT_SLOT_CLEARED = {f=MI2_EventLootSlotCleared, basic=1, items=1},
		CHAT_MSG_SPELL_SELF_BUFF = {f=MI2_EventSelfBuff, basic=1, items=1},
		CHAT_MSG_COMBAT_XP_GAIN = {f=MI2_EventCreatureDiesXP, basic=1},
		ZONE_CHANGED_NEW_AREA = {f=MI2_EventZoneChanged, loc=1},
		ZONE_CHANGED_INDOORS = {f=MI2_EventZoneChanged, loc=1},

		CHAT_MSG_COMBAT_HOSTILE_DEATH = {f=MI2_EventHostileDeath, char=1},
		CHAT_MSG_COMBAT_SELF_HITS = {f=MI2_EventSelfMelee, char=1},
		CHAT_MSG_SPELL_SELF_DAMAGE = {f=MI2_EventSelfSpell, char=1},
		CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = {f=MI2_EventSpellPeriodic, char=1},
		CHAT_MSG_COMBAT_PET_HITS = {f=MI2_EventPetMelee, char=1},
		CHAT_MSG_SPELL_PET_DAMAGE = {f=MI2_EventPetSpell, char=1},
		CHAT_MSG_MONSTER_EMOTE = {f=MI2_EventMonsterEmote, basic=1},
		CREATURE_DATA_LOAD_RESULT = {f=MI2_EventCreatureDataLoaded, always=1},
		GET_ITEM_INFO_RECEIVED = {f=MI2_EventItemInfoReceived, always=1}, }

	-- event table modification required for chinese localisation
	if ( GetLocale() == "zhTW" ) then
		MI2_EventHandlers.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE.f = MI2_EventSpellPeriodic_ZHTW
		MI2_EventHandlers.CHAT_MSG_SPELL_SELF_BUFF.f = MI2_EventSelfBuff_ZHTW

	end

	MI2_ChatScanStrings = {
		[1] = OPEN_LOCK_SELF,
		[2] = SELFKILLOTHER,
		[3] = COMBATLOG_XPGAIN_FIRSTPERSON,
		[4] = COMBATHITSELFOTHER,
		[5] = COMBATHITCRITSELFOTHER,
		[6] = SPELLLOGSELFOTHER,
		[7] = SPELLLOGSCHOOLSELFOTHER,
		[8] = SPELLLOGCRITSELFOTHER,
		[9] = PERIODICAURADAMAGESELFOTHER,
		[10] = COMBATHITOTHEROTHER,
		[11] = COMBATHITCRITOTHEROTHER,
		[12] = SPELLLOGOTHEROTHER,
		[13] = SPELLLOGCRITOTHEROTHER,
		[14] = IMMUNESPELLSELFOTHER,
		[15] = SPELLIMMUNESELFOTHER,
		[16] = SPELLRESISTSELFOTHER,
		[17] = SPELLLOGCRITSCHOOLSELFOTHER,
		[18] = AURAADDEDOTHERHARMFUL, }

	for idx, scanString in pairs(MI2_ChatScanStrings) do
		scanString = string.gsub(scanString, "%(", "%%%(")
		scanString = string.gsub(scanString, "%)", "%%%)")
		scanString = string.gsub(scanString, "(%%s)", "%(%.%+%)")
		scanString = string.gsub(scanString, "(%%%d$s)", "%(%.%+%)")
		scanString = string.gsub(scanString, "(%%d)", "%(%%%d%+%)")
		scanString = string.gsub(scanString, "(%%%d$d)", "%(%%%d%+%)")
		MI2_ChatScanStrings[idx] = scanString
	end

	-- process no other events until "VARIABLES_LOADED"
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("CREATURE_DATA_LOAD_RESULT")
	this:RegisterEvent("GET_ITEM_INFO_RECEIVED")

	-- prepare for importing external database data
	-- this must be done before "VARIABLES_LOADED" overwrites import data
	MI2_PrepareForImport()
	MI2_DeleteAllMobData()
	MobHealthPlayerDB = {}

	-- set some stuff that is needed (only) for improved compatibility
	-- to other AddOns wanting to use MobHealth info
	if  not MobHealth_OnEvent  then
		MobHealthFrame = "MI2"
		MobHealth_OnEvent = MI2_OnEvent
	end
end
