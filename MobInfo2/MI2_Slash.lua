if not C_Item then return end

--
-- MI2_Slash.lua
--
-- Handle all slash commands and the actions performed by slash commands.
-- All option dialog settings use slash commands for performing their
-- actions.
--
-- Note: version history now located in ReadMe.txt
--

local MI2_DeleteMode = ""

-- Configs
function MI2_SlashAction_Default()

MI2_ScanSpellbook()

	MobInfoConfig.ShowClass = 1
	MobInfoConfig.ShowHealth = 1
	MobInfoConfig.ShowMana = 0
	MobInfoConfig.ShowDamage = 1
	MobInfoConfig.ShowKills = 0
	MobInfoConfig.ShowLoots = 1
	MobInfoConfig.ShowEmpty = 0
	MobInfoConfig.ShowXp = 1
	MobInfoConfig.ShowNo2lev = 1
	MobInfoConfig.ShowQuality = 1
	MobInfoConfig.ShowCloth = 1
	MobInfoConfig.ShowCoin = 0
	MobInfoConfig.ShowIV = 0
	MobInfoConfig.ShowTotal = 1
	MobInfoConfig.ShowItems = 1
	MobInfoConfig.ShowLocation = 1
	MobInfoConfig.ShowClothSkin = 1
	MobInfoConfig.ShowQuestLoot = 1
	MobInfoConfig.ShowResists = 1
end

function MI2_SlashAction_AllOn()
	MobInfoConfig.ShowClass = 1
	MobInfoConfig.ShowHealth = 1
	MobInfoConfig.ShowMana = 1
	MobInfoConfig.ShowKills = 1
	MobInfoConfig.ShowDamage = 1
	MobInfoConfig.ShowXp = 1
	MobInfoConfig.ShowNo2lev = 1
	MobInfoConfig.ShowLoots = 1
	MobInfoConfig.ShowEmpty = 1
	MobInfoConfig.ShowCoin = 1
	MobInfoConfig.ShowIV = 1
	MobInfoConfig.ShowTotal = 1
	MobInfoConfig.ShowQuality = 1
	MobInfoConfig.ShowCloth = 1
	MobInfoConfig.ShowItems = 1
	MobInfoConfig.ShowLocation = 1
	MobInfoConfig.ShowClothSkin = 1
	MobInfoConfig.ShowQuestLoot = 1
	MobInfoConfig.ShowResists = 1
	MobInfoConfig.AbbrevHP = 1
	MobInfoConfig.ShowQualPoor = 1
	MobInfoConfig.ShowQualCommon = 1
	MobInfoConfig.ShowQualUncommon = 1
	MobInfoConfig.ShowQualRare = 1
	MobInfoConfig.ShowQualEpic = 1
	MobInfoConfig.ShowQualLegendary = 1
end

function MI2_SlashAction_AllOff()
	MobInfoConfig.ShowClass = 0
	MobInfoConfig.ShowHealth = 0
	MobInfoConfig.ShowMana = 0
	MobInfoConfig.ShowKills = 0
	MobInfoConfig.ShowDamage = 0
	MobInfoConfig.ShowXp = 0
	MobInfoConfig.ShowNo2lev = 0
	MobInfoConfig.ShowLoots = 0
	MobInfoConfig.ShowEmpty = 0
	MobInfoConfig.ShowCoin = 0
	MobInfoConfig.ShowIV = 0
	MobInfoConfig.ShowTotal = 0
	MobInfoConfig.ShowQuality = 0
	MobInfoConfig.ShowCloth = 0
	MobInfoConfig.ShowItems = 0
	MobInfoConfig.ShowLocation = 0
	MobInfoConfig.ShowClothSkin = 0
	MobInfoConfig.ShowQuestLoot = 0
	MobInfoConfig.ShowResists = 0
	MobInfoConfig.AbbrevHP = 0
	MobInfoConfig.ShowQualPoor = 0
	MobInfoConfig.ShowQualCommon = 0
	MobInfoConfig.ShowQualUncommon = 0
	MobInfoConfig.ShowQualRare = 0
	MobInfoConfig.ShowQualEpic = 0
	MobInfoConfig.ShowQualLegendary = 0
end

function MI2_SlashAction_Minimal()
	MobInfoConfig.ShowClass = 1
	MobInfoConfig.ShowHealth = 1
	MobInfoConfig.ShowMana = 0
	MobInfoConfig.ShowKills = 0
	MobInfoConfig.ShowDamage = 0
	MobInfoConfig.ShowXp = 0
	MobInfoConfig.ShowNo2lev = 1
	MobInfoConfig.ShowLoots = 0
	MobInfoConfig.ShowEmpty = 0
	MobInfoConfig.ShowCoin = 0
	MobInfoConfig.ShowIV = 0
	MobInfoConfig.ShowTotal = 1
	MobInfoConfig.ShowQuality = 0
	MobInfoConfig.ShowCloth = 0
	MobInfoConfig.ShowItems = 0
	MobInfoConfig.ShowLocation = 0
	MobInfoConfig.ShowClothSkin = 0
	MobInfoConfig.ShowQuestLoot = 0
	MobInfoConfig.ShowResists = 0
end


-----------------------------------------------------------------------------
-- MI2_RegisterWithAddonManagers()
--
-- Register MobInfo with the KHAOS AddOn manager. This is a very simple
-- registration that merely creates a button to open the MobInfo options
-- dialog.
--
-- Register MobInfo with the myAddons manager.
--
-- Register with the EARTH AddOn manager.
-----------------------------------------------------------------------------
function MI2_RegisterWithAddonManagers()

	-- register with myAddons manager
	if ( myAddOnsFrame_Register ) then
		local mobInfo2Details = {
		name = "MobInfo2",
		author = "Skeeve & Dizzarian",
		category = MYADDONS_CATEGORY_OTHERS,
		optionsframe = "frmMIConfig"
		}
		myAddOnsFrame_Register( mobInfo2Details )
	end

	-- register with EARTH manager (mainly for Cosmos support)
	if EarthFeature_AddButton then
		EarthFeature_AddButton(
			{
				id = "MobInfo2",
				name = "MobInfo2",
				subtext = "v"..miVersionNo,
				tooltip = MI_DESCRIPTION,
				icon = "Interface\\AddOns\\MobInfo2\\MobInfoIcon",
				callback = function(state) MI2_SlashParse( "", false ) end,
				test = nil
			}
		)
	
	-- register with KHAOS (only if EARTH not found)
	elseif Khaos then
		Khaos.registerOptionSet(
			"tooltip",
			{
				id = "MobInfo2OptionSet",
				text = "MobInfo 2",
				helptext = MI_DESCRIPTION,
				difficulty = 1,
				callback = function(state) end,
				default = true,
				options = {
					{
						id = "MobInfo2OptionsHeader",
						type = K_HEADER,
						difficulty = 1,
						text = MI_TXT_WELCOME,
						helptext = MI_DESCRIPTION
					},
					{
						id = "MobInfo2OptionsButton",
						type = K_BUTTON,
						difficulty = 1,
						text = MI_TXT_CONFIG_TITLE,
						helptext = "",
						callback = function(state) MI2_SlashParse( "", false ) end,
						feedback = function(state) end,
						setup = { buttonText = MI_TXT_OPEN }
					}
				}
			}
		)
	end
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearTarget()
--
-- Clear MobInfo and MobHealth data for current target.
-----------------------------------------------------------------------------
function MI2_SlashAction_ClearTarget()
	local index = MI2_Target.mobIndex
	if index then
		MI2_MobHealth_ClearTargetData()
		MI2_DeleteMobData( index )
		MI2_Target = {}
		MI2_OnTargetChanged()
		MI2_DbOptionsFrameOnShow()
		chattext( "data for target "..mifontGreen..index..mifontWhite.." has been deleted" )
	end
end

-----------------------------------------------------------------------------
-- MI2_Slash_ClearAllConfirmed()
--
-- Clear-All-Confirmation-Handler : Clear entire contents of MobInfo and
-- MobHealth databases.
-----------------------------------------------------------------------------
function MI2_Slash_ClearAllConfirmed()
	if MI2_DeleteMode == "MobDb" then
		MI2_DeleteAllMobData()
		MobInfoConfig.ImportSignature = ""
	elseif MI2_DeleteMode == "HealthDb" then
		MI2_MobHealth_Reset()
	elseif MI2_DeleteMode == "PlayerDb" then
		MobHealthPlayerDB = {}
	end
	chattext( "database deleted: "..MI2_DeleteMode )
	MI2_Target = {}
	MI2_OnTargetChanged()
	MI2_DbOptionsFrameOnShow()
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearHealthDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
-----------------------------------------------------------------------------
function MI2_SlashAction_ClearHealthDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearAllConfirmed
	MI2_DeleteMode = "HealthDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearPlayerDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
-----------------------------------------------------------------------------
function MI2_SlashAction_ClearPlayerDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearAllConfirmed
	MI2_DeleteMode = "PlayerDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearMobDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
-----------------------------------------------------------------------------
function MI2_SlashAction_ClearMobDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearAllConfirmed
	MI2_DeleteMode = "MobDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end

-----------------------------------------------------------------------------
-- MI2_Slash_TrimDownConfirmed()
--
-- Trim down the contents of the mob info database by removing all data
-- that is not set as being recorded. This function is called when the
-- user confirms the delete confirmation.
-----------------------------------------------------------------------------
function MI2_Slash_TrimDownConfirmed()
	-- loop through database and check each record
	-- remove all fields within the record where recording of the field is disabled
	for idx, mobInfo in pairs(MobInfoDB) do
		if  MobInfoConfig.SaveBasicInfo == 0 then
			mobInfo.bi = nil
		end
		if  MobInfoConfig.SaveLocation == 0 then
			mobInfo.ml = nil
		end
		if  MobInfoConfig.SaveItems == 0 then
			mobInfo.il = nil
		elseif mobInfo.il then
			-- Remove items below the current quality recording threshold.
			-- ItemsQuality: 1=Grey+, 2=White+, 3=Green+  (maps to min quality 0, 1, 2)
			local minQuality = (MobInfoConfig.ItemsQuality or 1) - 1
			if minQuality > 0 then
				local mobData = {}
				MI2_DecodeItemList( mobInfo, mobData )
				if mobData.itemList then
					local changed = false
					for itemID in pairs(mobData.itemList) do
						local q = C_Item.GetItemQualityByID(itemID)
						if q and q < minQuality then
							mobData.itemList[itemID] = nil
							changed = true
						end
					end
					if changed then
						MI2_StoreLootItems( idx, mobData )
					end
				end
			end
		end
		if  MobInfoConfig.SaveResist == 0 then
			mobInfo.re = nil
		end
		if  MobInfoConfig.SaveCharData == 0 then
			MI2_RemoveCharData( mobInfo )
		end
	end

	-- char table can be deleted when not saving char specific data
	if  MobInfoConfig.SaveCharData == 0 then
		MI2_CharTable = { charCount = 0 }
	end

	-- force a cleanup after trimming down
	MI2_ClearMobCache()
	MI2_CleanupDatabases()

	MI2_DbOptionsFrameOnShow()
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_TrimDownMobData()
--
-- Trim down the contents of the mob info database by removing all data
-- that is not set as being recorded. Ask for a confirmation before
-- actually deleting anything.
-----------------------------------------------------------------------------
function MI2_SlashAction_TrimDownMobData()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_TRIM_DOWN_CONFIRM
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_TrimDownConfirmed
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end

-----------------------------------------------------------------------------
-- MI2_UpdateMob()
--
-- Update a specific existing mob by adding to it the given new Mob data.
-----------------------------------------------------------------------------
local function MI2_UpdateMob( mobIndex, newMobInfo )
	local existingMobInfo = MobInfoDB[mobIndex]
	local existingMobData, newMobData = {}, {}
	MI2_GetMobDataFromMobInfo( existingMobInfo, existingMobData )
	MI2_GetMobDataFromMobInfo( newMobInfo, newMobData )
	MI2_AddTwoMobs( existingMobData, newMobData )
	MI2_StoreAllMobData( existingMobData, nil, nil, MI2_PlayerName, mobIndex )
	-- merge mh health data: prefer the higher quality (higher pct) entry
	if newMobInfo.mh then
		if not existingMobInfo.mh then
			existingMobInfo.mh = newMobInfo.mh
		else
			local _, oldPct = MI2_HpDecode( existingMobInfo.mh )
			local _, newPct = MI2_HpDecode( newMobInfo.mh )
			if newPct and oldPct and newPct > 90 and newPct > oldPct then
				existingMobInfo.mh = newMobInfo.mh
			end
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_AdaptImportLocation()
--
-- Adapt the location info of an imported Mob. This is only necessary for
-- Mobs in instances, because instances are not available in the WoW
-- zone tables.
-----------------------------------------------------------------------------
local function MI2_AdaptImportLocation( mobInfo, importZoneTable )
	-- zone IDs are now real AreaTable area IDs (via C_Map.GetBestMapForUnit),
	-- so imported zone IDs are already correct and need no remapping
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_ImportMobData()
--
-- Import externally supplied MobInfo database into own database.
-----------------------------------------------------------------------------
function MI2_SlashAction_ImportMobData()
	local newMobs, updatedMobs, newHealth, newItems = 0, 0, 0, 0
	local mobIndex, mobInfo, healthInfo

	chattext( " starting external database import ...." )

	-- import health data: mh fields are embedded in MobInfoDB entries
	-- and are handled during the mob import loop below

	-- import Mobs into main Mob database
	for mobIndex, mobInfo in pairs(MobInfoDB_Import) do
		MI2_RemoveCharData( mobInfo )
		if MobInfoDB[mobIndex] then
			updatedMobs = updatedMobs + 1
			if MobInfoConfig.ImportOnlyNew == 0 then
				-- import Mob that already exists
				MI2_UpdateMob( mobIndex, mobInfo )
			end
		else
			-- import unknown Mob
			MobInfoDB[mobIndex] = mobInfo
			newMobs = newMobs + 1
		end
	end

	-- update item cross reference table after import
	if MobInfoConfig.ImportOnlyNew == 0 then
		MI2_BuildXRefItemTable()
	end

	chattext( " imported "..newMobs.." new Mobs" )
	chattext( " imported "..newHealth.." new health values" )
	chattext( " imported "..newItems.." new loot items" )
	if MobInfoConfig.ImportOnlyNew == 0 then
		chattext( " updated data for "..updatedMobs.." existing Mobs" )
	else
		chattext( " did NOT update data for "..updatedMobs.." existing Mobs" )
	end

	-- update database options frame
	MobInfoConfig.ImportSignature = MI2_Import_Signature
	MI2_DbOptionsFrameOnShow()
	MI2_PreloadCreatureNames()
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_DeleteSearch()
--
-- Delete all Mobs in the search result list from the MobInfo database.
-- This function will ask for confirmation before deleting.
-----------------------------------------------------------------------------
function MI2_SlashAction_DeleteSearch()
	local confirmationText = string.format( MI_TXT_DEL_SEARCH_CONFIRM, MI2_NumMobsFound )
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = confirmationText
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_DeleteSearchResultMobs
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end

-----------------------------------------------------------------------------
-- MI2_SlashInit()
--
-- Add all Slash Commands
-----------------------------------------------------------------------------
function MI2_SlashInit()
	SlashCmdList["MOBINFO"] = MI2_SlashParse
	SLASH_MOBINFO1 = "/mobinfo2" 
	SLASH_MOBINFO2 = "/mi2" 
end

-----------------------------------------------------------------------------
-- MI2_SlashParse()
--
-- Parses the msg entered as a slash command. This function is also used
-- for the internal purpose of setting all options in the options dialog.
-- When used by the options dialog there is no need to actually update the
-- dialog, which is indicated by the "updateOptions" parameter.
-----------------------------------------------------------------------------
function MI2_SlashParse( msg, updateOptions )
	-- extract option name and option argument from message string
	local _, _, cmd, param = string.find( string.lower(msg), "([%w_]*)[ ]*([-%w]*)") 
	
	-- handle show/hide of options dialog first of all
	-- handle all simple commands that dont require parsing right here
	if  not cmd  or  cmd == ""  or  cmd == "config"  then
		if  frmMIConfig:IsVisible()  then
			frmMIConfig:Hide()
		else
			frmMIConfig:Show()
		end
		return
	elseif  cmd == 'version'  then
		chattext( ' MobInfo-2 Version '..miVersionNo )
		return
	elseif  cmd == 'update' and MI2_UpdatePrices  then
		MI2_UpdatePrices()
		return
	elseif  cmd == 'help'  then
		chattext( MI_TXT_USAGE )
		return
	end

	-- search for the option data structure matching the command
	local optionName, optionData
	for idx, val in pairs(MI2_OPTIONS) do
		local lower_opt = string.lower( idx )
		local optionCommand = string.sub(lower_opt, 8)
		if cmd == lower_opt or cmd == optionCommand then
			optionName = string.sub(idx, 8)
			optionData = val
			break
		end
	end

	-- now call the option handler for the more complex commands
	if  optionData  then
		MI2_OptionParse( optionName, optionData, param, updateOptions )
	end
end

-----------------------------------------------------------------------------
-- MI2_OptionParse()
--
-- Parses the more complex option toggle/set commands. There are 4
-- categories of options:
--   * options that can toggle between an on and off state
--   * options that represent a numeric value
--   * options that represent a text
--   * options that activate a special functionality represented by a
--	   handler function that must correspond to a specific naming convention
-----------------------------------------------------------------------------
function MI2_OptionParse( optionName, optionData, param, updateOptions )
	-- handle the option according to its option type: its either a
	-- switch being toggleg, a value being set, or a special action
	if optionData.val then
		-- it is a slider setting a value
		-- get new option value from parameter and set it
		local optValue = tonumber( param ) or 0
		MobInfoConfig[optionName] = optValue
		if  updateOptions  then
			chattext( optionData.text.." : "..mifontGreen..optValue )
		end

	elseif optionData.txt then
		-- it is a text based option
		MobInfoConfig[optionName] = param
		if  updateOptions  then
			chattext( optionData.text.." : "..mifontGreen..param )
		end

	elseif  MobInfoConfig[optionName]  then
		-- it is a switch toggle option:
		-- get current option value and toggle it to the opposite state (On<->Off)
		local valTxt = { val0 = "-OFF-",  val1 = "-ON-" }
		local optValue = MobInfoConfig[ optionName ]
		optValue = 1 - optValue  -- toggle option
		MobInfoConfig[optionName] = optValue
		chattext( optionData.text.." : "..mifontGreen..valTxt["val"..optValue] )

		-- special case: disabling MobInfo requires extra processing
		if optionName == "DisableMobInfo" then MI2_UpdateMobInfoState() end
		-- special case: toggling minimap button shows/hides it immediately
		if optionName == "ShowMinimapButton" then MI2_UpdateMinimapButton() end
		-- some toggle switches control recording options which in turn controls events
		MI2_InitializeEventTable()
	else
		-- special action commands have a corresponding handler function
		local actionHandlerName = "MI2_SlashAction_"..optionName
		local actionHandler = getglobal( actionHandlerName )
		if  actionHandler  then
			actionHandler()
			updateOptions = true -- for AllOn, AllOff, etc.
		end
	end

	-- update font and position of health / mana texts
	MI2_MobHealth_SetPos()

	-- update options dialog if shown and if requested
	if  frmMIConfig:IsVisible()  and  updateOptions  then
		MI2_UpdateOptions()
	end

end
