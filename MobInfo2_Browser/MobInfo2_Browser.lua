if not C_Item then return end

--[[
	MI2B: MobInfo2_Browser
	Database Browser for the MobInfo2 AddOn
	copyright 2005 by Chester, continued by Skeeve
	enhanced ClassicAPI version by Drakensangs
]]

BINDING_HEADER_MI2BROWSER = "MobInfo 2 Browser"
BINDING_NAME_MI2BROWSER   = "Open MobInfo 2 Browser"

MI2B_VERSION = " 1.3"
MI2B_TITLE	 = "MobInfo 2 Browser"
MI2B = {}
MI2B["lv"] = {
	[0] = "|cff7f7f7f",
	[1] = "|cff4ccc4c",
	[2] = "|cffffff00",
	[3] = "|cffff7f4c",
	[4] = "|cffff1919",
}

-- mobType constants (match MobInfo2.lua)
local MI2B_TYPE_NORMAL	  = 1
local MI2B_TYPE_ELITE	  = 2
local MI2B_TYPE_WORLDBOSS = 3
local MI2B_TYPE_RARE	  = 4

-- Boss level sentinel used by WoW for skull mobs
local MI2B_BOSS_LEVEL = -1
-- Sorting weight for boss level: higher than any real level
local MI2B_BOSS_SORT_LEVEL = 99999

-- Item quality filter constants.
-- qualityFilter[i] = true means that rarity IS shown/enabled.
-- Indices: 1=Poor 2=Common 3=Uncommon 4=Rare 5=Epic 6=Legendary
-- Default: all enabled except Poor (1).
local MI2B_QUALITY_COLORS = {
	"|cff9d9d9d",  -- 1 Poor
	"|cffffffff",  -- 2 Common
	"|cff1eff00",  -- 3 Uncommon
	"|cff0070dd",  -- 4 Rare
	"|cffa335ee",  -- 5 Epic
	"|cffff8000",  -- 6 Legendary
}
local MI2B_QUALITY_NAMES = { "Poor", "Common", "Uncommon", "Rare", "Epic", "Legendary" }

-- Returns the localized quality name, falling back to the hardcoded default
-- if the locale string is not yet defined (e.g. during early load).
local function MI2B_GetQualityName(i)
	local names = {
		MI2B_QUALITY_POOR, MI2B_QUALITY_COMMON, MI2B_QUALITY_UNCOMMON,
		MI2B_QUALITY_RARE, MI2B_QUALITY_EPIC,   MI2B_QUALITY_LEGENDARY,
	}
	return (names[i] and names[i] ~= "") and names[i] or MI2B_QUALITY_NAMES[i]
end

local function MI2B_QualityDefault()
	return { [1]=false, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true }
end

-- Returns true if this entry has any item of an enabled rarity.
-- If all rarities are disabled the filter is considered inactive and all pass.



-----------------------------------------------------------------------------
-- MI2B_GetMobName()
-- Resolve the display name for a "creatureID:level" mob index via the
-- creature cache (C_CreatureInfo, populated at login by MI2_PreloadCreatureNames).
-- Legacy "name:level" keys are handled transparently.
-----------------------------------------------------------------------------
local function MI2B_GetMobName(mobIndex)
	local idStr = string.match(mobIndex, "^(%d+):")
	if idStr then
		local cid  = tonumber(idStr)
		local info = cid and C_CreatureInfo.GetCreatureInfoByID(cid)
		if info and info.name and info.name ~= "" then return info.name end
		return idStr  -- fallback until cache warms up
	end
	local name = MI2_GetIndexComponents(mobIndex)
	return name or mobIndex
end


-----------------------------------------------------------------------------
-- MI2B_GetZoneName()
-- Resolve all zone names from a decoded location table.
-- Modern format: location.zones = { [areaID] = true, ... }
-- Returns all resolved names joined by ", " (up to 4), or UNKNOWN.
-----------------------------------------------------------------------------
local function MI2B_GetZoneName(location)
	if not location or not location.zones then return UNKNOWN end
	local names = {}
	for id in pairs(location.zones) do
		local name = C_Map.GetAreaInfo(id)
		if name and name ~= "" then
			table.insert(names, name)
		end
	end
	if table.getn(names) == 0 then return UNKNOWN end
	table.sort(names)
	return table.concat(names, ", ")
end


-----------------------------------------------------------------------------
-- MI2B_FormatLevel()
-- True world bosses (rank 3) are stored with level -1 and displayed as "".
-- Skull mobs of any other rank also have level -1 but should display "-1"
-- so the caller can append the appropriate rank suffix (+, (R), or nothing).
-- Pass mobType so we can distinguish the two cases.
-----------------------------------------------------------------------------
local function MI2B_FormatLevel(level, mobType)
	if level == MI2B_BOSS_LEVEL and mobType == MI2B_TYPE_WORLDBOSS then return "" end
	return tostring(level)
end


-----------------------------------------------------------------------------
-- MI2B_MobTypeSuffix()
-- Returns the display suffix for a mob entry.
--   3 (worldboss) -> "++"
--   2 (elite)	   -> "+"
--   4 (rare)	   -> "(R)"
--   1 (normal)    -> ""
-----------------------------------------------------------------------------
local function MI2B_MobTypeSuffix(mobType)
	if	   mobType == MI2B_TYPE_WORLDBOSS then return "++"
	elseif mobType == MI2B_TYPE_ELITE	  then return "+"
	elseif mobType == MI2B_TYPE_RARE	  then return "(R)"
	else									   return ""
	end
end


-----------------------------------------------------------------------------
-- MI2B_SortLevel()
-- Level value used for sorting.  True world bosses (rank 3, level -1) sort
-- above all real levels.  Skull mobs of other ranks (also level -1 until
-- re-encountered at higher player level) sort below level-1 worldbosses but
-- above level 0, treated as level -1 numerically.
-----------------------------------------------------------------------------
local function MI2B_SortLevel(level, mobType)
	if level == MI2B_BOSS_LEVEL and mobType == MI2B_TYPE_WORLDBOSS then
		return MI2B_BOSS_SORT_LEVEL
	end
	return level or 0
end


function MobInfo2_Browser_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")
	SLASH_MI2BROWSER1 = "/mi2b"
	SlashCmdList["MI2BROWSER"] = function(msg) MI2B_SlashCommand(msg) end
	tinsert(UISpecialFrames, "MI2B_BrowseFrame")
end


function MobInfo2_Browser_OnEvent()
	if event == "VARIABLES_LOADED" then
		if not MI2B_BrowseFrame.orgHide then
			MI2B_BrowseFrame.orgHide = MI2B_BrowseFrame.Hide
			MI2B_BrowseFrame.Hide	 = MobInfo2_Browser_Hide
		end
		if not MI2BSave then MI2BSave = {} end
		if MI2BSave.qualityFilter == nil then MI2BSave.qualityFilter = MI2B_QualityDefault() end

		-- Hook the MobInfo2 minimap button to support Ctrl+left-click → open Browser
		local orgMouseUp = MI2_MinimapButton_OnMouseUp
		MI2_MinimapButton_OnMouseUp = function( button )
			if button == "LeftButton" and IsControlKeyDown() then
				if MI2B_BrowseFrame:IsVisible() then
					MI2B_BrowseFrame:Hide()
				else
					MI2B_RefreshBrowseList()
				end
			else
				orgMouseUp( button )
			end
		end

		-- Hook the minimap button tooltip to add the Browser hint line
		local orgEnter = MI2_MinimapButton_OnEnter
		MI2_MinimapButton_OnEnter = function()
			orgEnter()
			-- Insert Browser tip between tip1 and tip2 by rebuilding the tooltip
			GameTooltip:SetOwner( MI2_MinimapButton, "ANCHOR_LEFT" )
			GameTooltip:SetText( "MobInfo2" )
			GameTooltip:AddLine( MI2_TXT_MINIMAP_TIP1, 1, 1, 1 )
			GameTooltip:AddLine( MI2B_MINIMAP_TIP_BROWSER, 1, 1, 1 )
			GameTooltip:AddLine( MI2_TXT_MINIMAP_TIP2, 1, 1, 1 )
			GameTooltip:Show()
		end
	end
end


function MI2B_Main_OnShow()
	if MI2BSave and MI2BSave.framepos_L and MI2BSave.framepos_T then
		this:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", MI2BSave.framepos_L, MI2BSave.framepos_T)
	end
end

function MI2B_Main_OnMouseDown(arg1)
	if arg1 == "LeftButton" then this:StartMoving() end
end

function MI2B_Main_OnMouseUp(arg1)
	if arg1 == "LeftButton" then
		this:StopMovingOrSizing()
		MI2BSave.framepos_L = this:GetLeft()
		MI2BSave.framepos_T = this:GetTop()
	end
end


function MI2B_SlashCommand(msg)
	if not msg or msg == "" then
		if MI2B_BrowseFrame:IsVisible() then
			MI2B_BrowseFrame:Hide()
		else
			MI2B_RefreshBrowseList()
		end
	end
end


function MI2B_GetTimeOffset(t, format)
	format = format or "m"
	if	   format == "m" then return t/60
	elseif format == "h" then return t/3600
	elseif format == "d" then return t/86400 end
end


--/script MI2B_RefreshBrowseList()
function MI2B_RefreshBrowseList()
	if not MI2_DB_VERSION or not MobInfoDB then
		DEFAULT_CHAT_FRAME:AddMessage(RED_FONT_COLOR_CODE..MI2B_TITLE.." needs MobInfo2 data to run.")
		UIErrorsFrame:AddMessage(MI2B_LOADERROR, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME)
		PlaySound("igQuestCancel")
		return
	end

	ShowUIPanel(MI2B_BrowseFrame, 1)
	MI2BrowseTable = {}
	local iNew		= 1
	local mobDbSize = 0

	for mobIndex, mobInfo in pairs(MobInfoDB) do
		-- skip meta-entries that are not mob records
		if not string.find(mobIndex, "Database.+") and not string.find(mobIndex, "Locations.+") then
			local _, mobLevel = MI2_GetIndexComponents(mobIndex)
			if mobLevel then
				mobDbSize = mobDbSize + 1

				-- Decode via MI2_FetchMobData exactly as the base addon does.
				-- MI2_FetchMobData returns a reference into the cache; shallow-copy
				-- it so we can safely add browser-only fields without corrupting it.
				local cached = MI2_FetchMobData(mobIndex)
				local entry  = {}
				for k, v in pairs(cached) do entry[k] = v end

				-- Resolve healthMax from MobHealth PPP (same as MI2_GetUnitBasedMobData)
				local ppp = MobHealth_PPP(mobIndex)
				entry.healthMax = (ppp and ppp > 0) and floor(ppp * 100 + 0.5) or nil

				-- Compute quality counts from itemList using C_Item.GetItemQualityByID,
				-- mirroring MI2_BuildQualityString in MobInfo2.lua. r1=grey .. r6=legendary.
				entry.r1, entry.r2, entry.r3, entry.r4, entry.r5, entry.r6 = 0, 0, 0, 0, 0, 0
				if entry.itemList then
					for itemID, amount in pairs(entry.itemList) do
						local q = C_Item.GetItemQualityByID(itemID)
						if q then
							local idx = q + 1
							entry["r"..idx] = (entry["r"..idx] or 0) + amount
						end
					end
				end

				-- Browser display/sort fields
				entry.nm	   = MI2B_GetMobName(mobIndex)
				entry.lv	   = mobLevel
				entry.mobIndex = mobIndex
				-- Pre-compute zone name once for display and sorting
				entry.zoneName = MI2B_GetZoneName(entry.location)

				if MI2B_ListFilter_Search(mobIndex, entry) then
					MI2BrowseTable[iNew] = entry
					iNew = iNew + 1
				end
			end
		end
	end

	if MobInfoConfig and MobInfoConfig.CombinedMode == 1 then
		local byID	  = {}
		local idOrder = {}

		for i = 1, iNew - 1 do
			local e = MI2BrowseTable[i]
			-- Extract the creature ID portion from the mob index.
			-- Keys are "creatureID:level" for modern entries.
			local creatureID = string.match(e.mobIndex, "^(%d+):")
			if not creatureID then
				-- Legacy name:level key - use the name as the combine key.
				creatureID = string.match(e.mobIndex, "^(.+):%d+$") or e.mobIndex
			end

			local eLevel = e.lv

			if byID[creatureID] then
				local combined = byID[creatureID]

				-- Merge statistical data into the combined entry.
				MI2_AddTwoMobs(combined, e)

				-- Re-compute quality counts from the merged itemList.
				combined.r1, combined.r2, combined.r3, combined.r4, combined.r5, combined.r6 = 0, 0, 0, 0, 0, 0
				if combined.itemList then
					for itemID, amount in pairs(combined.itemList) do
						local q = C_Item.GetItemQualityByID(itemID)
						if q then
							local ridx = q + 1
							combined["r"..ridx] = (combined["r"..ridx] or 0) + amount
						end
					end
				end

				-- Expand the level range.
				-- Only treat level -1 as a true boss if the mob is rank 3 (worldboss).
				-- Other ranks at level -1 are skull mobs of unknown level; use 0 as
				-- their sortable level so they fall below normal known-level mobs.
				local eTrueWorldBoss = (eLevel == MI2B_BOSS_LEVEL and (e.mobType or MI2B_TYPE_NORMAL) == MI2B_TYPE_WORLDBOSS)
				if eTrueWorldBoss then
					combined.hasBoss = true
				else
					local sortableLevel = (eLevel == MI2B_BOSS_LEVEL) and 0 or eLevel
					if sortableLevel < combined.minLevel then combined.minLevel = sortableLevel end
					if sortableLevel > combined.maxLevel then combined.maxLevel = sortableLevel end
				end

				-- Keep the highest mobType (worldboss > elite > rare > normal).
				if (e.mobType or MI2B_TYPE_NORMAL) > (combined.mobType or MI2B_TYPE_NORMAL) then
					combined.mobType = e.mobType
				end
			else
				-- First time seeing this creature ID - seed the combined entry.
				local combined = {}
				for k, v in pairs(e) do combined[k] = v end
				local isTrueWorldBoss = (eLevel == MI2B_BOSS_LEVEL and (e.mobType or MI2B_TYPE_NORMAL) == MI2B_TYPE_WORLDBOSS)
				combined.hasBoss  = isTrueWorldBoss
				combined.minLevel = isTrueWorldBoss and 99999 or ((eLevel == MI2B_BOSS_LEVEL) and 0 or eLevel)
				combined.maxLevel = isTrueWorldBoss and 0     or ((eLevel == MI2B_BOSS_LEVEL) and 0 or eLevel)
				byID[creatureID]  = combined
				table.insert(idOrder, creatureID)
			end
		end

		-- Rebuild MI2BrowseTable from the merged entries.
		iNew = 1
		for _, creatureID in ipairs(idOrder) do
			local combined = byID[creatureID]

			-- Build the level display string and the sort-level value.
			-- hasBoss is only set for true rank-3 worldboss entries (level -1).
			-- Skull mobs (level -1, non-worldboss rank) feed into minLevel/maxLevel
			-- as level 0, so their display falls out of the normal range logic.
			if combined.hasBoss then
				combined.lvDisplay = "++"
				combined.lv		   = MI2B_BOSS_LEVEL
				combined.mobType   = MI2B_TYPE_WORLDBOSS
			else
				local lo = combined.minLevel
				local hi = combined.maxLevel
				-- If the range collapsed to 0 it means all entries were skull mobs;
				-- surface that as -1 so the rank suffix still renders correctly.
				if lo == 0 and hi == 0 then
					combined.lv        = MI2B_BOSS_LEVEL
					combined.lvDisplay = tostring(MI2B_BOSS_LEVEL)
				elseif lo == hi then
					combined.lv        = hi
					combined.lvDisplay = tostring(hi)
				else
					-- Drop the 0 sentinel from the display when real levels are present.
					local displayLo = (lo == 0) and MI2B_BOSS_LEVEL or lo
					combined.lv        = hi
					combined.lvDisplay = tostring(displayLo).."-"..tostring(hi)
				end
			end

			-- Re-derive the zone name from the merged location.
			combined.zoneName = MI2B_GetZoneName(combined.location)

			-- Re-check filter against the combined entry.
			if MI2B_ListFilter_Search(combined.mobIndex, combined) then
				MI2BrowseTable[iNew] = combined
				iNew = iNew + 1
			end
		end
	end

	local itemDbSize = 0
	local seenItems = {}
	for _, mobInfo in pairs(MobInfoDB) do
		local mobData = {}
		MI2_DecodeItemList( mobInfo, mobData )
		if mobData.itemList then
			for itemID in pairs(mobData.itemList) do
				if not seenItems[itemID] then
					seenItems[itemID] = true
					itemDbSize = itemDbSize + 1
				end
			end
		end
	end
	MI2B_TotalMobsTextValue:SetText(mobDbSize)
	MI2B_TotalMobTextValue:SetText(itemDbSize)

	MI2BrowseTable.onePastEnd = iNew
	-- Restore saved sort on the very first open (all sort fns are defined by now).
	if MI2BSave and MI2BSave.lastSortKey and not MI2B_ActiveSortFn then
		MI2B["sort"] = MI2B["sort"] or {}
		MI2B["sort"][MI2BSave.lastSortKey] = MI2BSave.lastSortDir
		MI2B_RestoreSavedSort()
	end
	if MI2B_ActiveSortFn then
		MI2B_ReapplySort()
		MI2B_ScrollBar_Update()
	else
		MI2B_SortByLevel(1)
	end
end


function MI2B_ScrollBar_Update()
	if not MI2B_BrowseFrame:IsVisible() then return end
	MI2BrowseTable = MI2BrowseTable or {}
	MI2BrowseTable.onePastEnd = MI2BrowseTable.onePastEnd or 1
	FauxScrollFrame_Update(MI2B_ListScrollFrame, MI2BrowseTable.onePastEnd, 15, 12)

	for line = 1, 20 do
		local idx = line + FauxScrollFrame_GetOffset(MI2B_ListScrollFrame)
		if idx < MI2BrowseTable.onePastEnd then
			local e		= MI2BrowseTable[idx]
			local loots = e.loots or 0

			-- Level + mob type suffix.
			-- Combined entries store a pre-built display string in lvDisplay
			-- (e.g. "42-44" or "++"); individual entries derive it from lv.
			local suffix
			local lvDisp
			if e.lvDisplay then
				-- Combined entry: lvDisplay already encodes the full level range.
				-- For boss-combined entries mobType is forced to WORLDBOSS so the
				-- suffix would be "++", but lvDisplay is already "++", so we only
				-- append a non-boss suffix (elite "+", rare "(R)") when present.
				local mt = e.mobType or MI2B_TYPE_NORMAL
				if mt == MI2B_TYPE_WORLDBOSS then
					suffix  = ""
					lvDisp  = e.lvDisplay
				else
					suffix  = MI2B_MobTypeSuffix(mt)
					lvDisp  = e.lvDisplay..suffix
				end
			else
				suffix = MI2B_MobTypeSuffix(e.mobType or MI2B_TYPE_NORMAL)
				lvDisp = MI2B_FormatLevel(e.lv, e.mobType)..suffix
			end

			-- XP
			local xpStr = (e.xp and e.xp > 0) and tostring(e.xp) or "??"

			-- Kills
			local killsStr = (e.kills and e.kills > 0) and tostring(e.kills) or "--"

			-- HP max
			local hpStr = (e.healthMax and e.healthMax > 0) and tostring(e.healthMax) or "???"

			-- Max damage
			local maxDStr = (e.maxDamage and e.maxDamage > 0) and tostring(e.maxDamage) or "?"

			-- DPS
			local color, dpsStr
			if e.dps and e.dps > 0 then
				dpsStr = tostring(e.dps)
				color  = ""
			else
				dpsStr = "??"
				color  = "|cff7f6600"
			end

			-- Cloth %
			local clothStr = ""
			if e.clothCount and e.clothCount > 0 and loots > 0 then
				clothStr = ceil((e.clothCount / loots) * 100).."%"
			end

			-- Total value column
			local totalVal    = MI2B_GetMobTotalValue(e)
			local totalValStr = (totalVal ~= 0) and (mifontWhite..copper2text(totalVal)) or (mifontWhite.."0")

			-- Mob type column: always derive from mobType directly so that
			-- combined boss entries (which set suffix="" to avoid doubling "++"
			-- in the level column) still show "++" in the rank column.
			local mtStr = MI2B_MobTypeSuffix(e.mobType or MI2B_TYPE_NORMAL)

			-- Rarity column: show enabled rarities only.
			-- Format mirrors MI2_BuildQualityString:
			--   showItemCount=true  -> "count(chance%)"
			--   showItemCount=false -> "chance%"
			local qf = MI2BSave and MI2BSave.qualityFilter
			local rarityParts = {}
			for idx = 1, 6 do
				local enabled = not qf or qf[idx]  -- nil filter = all enabled
				if enabled then
					local count = e["r"..idx] or 0
					if count > 0 and loots > 0 then
						local chance = ceil((count / loots) * 100)
						if chance > 100 then chance = 100 end
						if MI2BSave and MI2BSave.showItemCount then
							table.insert(rarityParts, MI2B_QUALITY_COLORS[idx]..count.."("..chance.."%) ")
						else
							table.insert(rarityParts, MI2B_QUALITY_COLORS[idx]..chance.."%")
						end
					end
				end
			end
			local rarityStr = table.concat(rarityParts, " ")

			getglobal("MI2B_List"..line.."Text")	:SetText(color..e.nm)
			getglobal("MI2B_List"..line.."TextLV")	:SetText(lvDisp)
			getglobal("MI2B_List"..line.."TextXP")	:SetText(xpStr)
			getglobal("MI2B_List"..line.."TextKL")	:SetText(killsStr)
			getglobal("MI2B_List"..line.."TextHP")	:SetText(hpStr)
			getglobal("MI2B_List"..line.."TextMaxD"):SetText(maxDStr)
			getglobal("MI2B_List"..line.."TextDPS") :SetText(dpsStr)
			getglobal("MI2B_List"..line.."TextLT")	:SetText(loots > 0 and tostring(loots) or "")
			getglobal("MI2B_List"..line.."TextCTH") :SetText(clothStr)
			getglobal("MI2B_List"..line.."TextMV")	:SetText(totalValStr)
			getglobal("MI2B_List"..line.."TextMT")	:SetText(mtStr)
			getglobal("MI2B_List"..line.."TextRARE"):SetText(rarityStr)
			getglobal("MI2B_List"..line.."TextLoc") :SetText(e.zoneName or UNKNOWN)

			getglobal("MI2B_List"..line):Show()
		else
			getglobal("MI2B_List"..line):Hide()
		end
	end

	local found = table.getn(MI2BrowseTable)
	local mobWord = (found == 1) and (MI2B_MOB_SINGULAR or "  Mob ") or (MI2B_MOB_PLURAL or "  Mobs ")
	MI2B_TotalPlayersText:SetText(found..mobWord..MI2B_FOUND)
end


function MI2B_GetMobTotalValue(e)
	local loots = e.loots or 0
	if loots == 0 then return 0 end
	local ca = (e.copper and e.copper > 0) and ceil(e.copper / loots) or 0
	local computedIV = MI2_ComputeItemValue(e, e.mobIndex) or 0
	local ia = computedIV > 0 and ceil(computedIV / loots) or 0
	return ca + ia
end


function MI2B_ListButton_OnClick(arg1)
end

function MI2B_MetaMapCheckLoc(index) return nil end


-- -----------------------------------------------------------------------
-- Filters
-- -----------------------------------------------------------------------

function MI2B_ListFilter_Search(mobIndex, entry)
	if not MI2B_ListFilter_PerCharacterCheck(entry)    then return end
	if not MI2B_ListFilter_SearchName(entry.nm)		   then return end
	if not MI2B_ListFilter_SearchLevel(mobIndex)	   then return end
	if not MI2B_ListFilter_SearchXP(entry)			   then return end
	if not MI2B_ListFilter_SearchKills(entry)		   then return end
	if not MI2B_ListFilter_SearchMobValue(entry)	   then return end
	if not MI2B_ListFilter_SearchItemName(entry)	   then return end
	if not MI2B_ListFilter_SearchLocation(entry)	   then return end
	return 1
end

function MI2B_ListFilter_PerCharacterCheck(entry)
	if not MI2BSave.perchar or MI2BSave.perchar == 0 then return 1 end
	if not entry or not tonumber(entry.dps) or tonumber(entry.dps) <= 0 then return end
	return 1
end

function MI2B_ListFilter_SearchName(displayName)
	if not MI2B_BrowseName or not MI2B_BrowseName:IsVisible() or MI2B_BrowseName:GetText() == "" then return 1 end
	local carrot = string.find(MI2B_BrowseName:GetText(), "^%u") and "^" or ""
	if string.find(strupper(displayName or ""), carrot..strupper(MI2B_BrowseName:GetText())) then return 1 end
end

function MI2B_ListFilter_SearchLevel(mobIndex)
	local min = MI2B_BrowseMinLevel:GetText()
	local max = MI2B_BrowseMaxLevel:GetText()
	if (not MI2B_BrowseMinLevel or not MI2B_BrowseMinLevel:IsVisible() or min == "") and
	   (not MI2B_BrowseMaxLevel or not MI2B_BrowseMaxLevel:IsVisible() or max == "") then
		return 1
	end
	local _, mobLevel = MI2_GetIndexComponents(mobIndex)
	if not mobLevel then return end
	if min and min ~= "" and mobLevel < tonumber(min) then return end
	if max and max ~= "" and mobLevel > tonumber(max) then return end
	return 1
end

function MI2B_ListFilter_SearchXP(entry)
	local xP = MI2B_BrowseXP:GetText()
	if not MI2B_BrowseXP or not MI2B_BrowseXP:IsVisible() or xP == "" then return 1 end
	if not tonumber(entry.xp) or tonumber(entry.xp) < tonumber(xP) then return end
	return 1
end

function MI2B_ListFilter_SearchKills(entry)
	local kill = MI2B_BrowseKills:GetText()
	if not MI2B_BrowseKills or not MI2B_BrowseKills:IsVisible() or kill == "" then return 1 end
	if not tonumber(entry.kills) or tonumber(entry.kills) < tonumber(kill) then return end
	return 1
end

function MI2B_ListFilter_SearchMobValue(entry)
	local gl = MI2B_BrowseMobValueG:GetText()
	local sv = MI2B_BrowseMobValueS:GetText()
	local cp = MI2B_BrowseMobValueC:GetText()
	gl = (gl and gl ~= "") and 10000 * tonumber(gl) or 0
	sv = (sv and sv ~= "") and 100   * tonumber(sv) or 0
	cp = (cp and cp ~= "") and tonumber(cp)			or 0
	local searchLoot = gl + sv + cp
	if searchLoot == 0 then return 1 end
	if MI2B_GetMobTotalValue(entry) < searchLoot then return end
	return 1
end

function MI2B_ListFilter_SearchItemName(entry)
	if not MI2B_BrowseItemName or not MI2B_BrowseItemName:IsVisible() or MI2B_BrowseItemName:GetText() == "" then return 1 end
	if not entry.itemList then return end
	local searchText = string.lower(MI2B_BrowseItemName:GetText())
	for itemID in pairs(entry.itemList) do
		local itemText = MI2_GetLootItemString(itemID)
		if itemText and string.find(string.lower(itemText), searchText, 1, true) then
			return 1
		end
	end
end

function MI2B_ListFilter_SearchLocation(entry)
	local searchText = MI2B_BrowseLocation:GetText()
	if not searchText or searchText == "" then return 1 end
	if string.find(strupper(entry.zoneName or UNKNOWN), strupper(searchText)) then return 1 end
end


-- -----------------------------------------------------------------------
-- Sorting
-- -----------------------------------------------------------------------

function MI2B_SortToggleOperator(v, noflip)
	if noflip then return end
	MI2B["sort"] = MI2B["sort"] or {}
	if MI2B["sort"][v] == nil then
		MI2B["sort"][v] = true
	end
	MI2B["sort"][v] = not MI2B["sort"][v]
end

-- Generic numeric/string comparator. Falls back to name for equal values.
-- Ascending by default (desc flag = nil); descending when flag = 1.
local function cmp(e1, e2, key, xform)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local v1 = e1[key]
	local v2 = e2[key]
	if xform then v1 = xform(v1); v2 = xform(v2) end
	if v1 == nil and v2 == nil then return e1.nm < e2.nm end
	if v1 == nil then return false end
	if v2 == nil then return true  end
	if v1 == v2  then return e1.nm < e2.nm end
	local desc = MI2B["sort"] and MI2B["sort"][key] == true
	if tonumber(v1) and tonumber(v2) then
		if desc then return tonumber(v1) > tonumber(v2)
		else		 return tonumber(v1) < tonumber(v2) end
	end
	if desc then return v1 > v2
	else		 return v1 < v2 end
end

-- mobType display order: normal(1) < rare(4) < elite(2) < worldboss(3)
local MI2B_MobTypeOrder = { [1]=1, [4]=2, [2]=3, [3]=4 }
local function mobTypeOrder(t) return MI2B_MobTypeOrder[t or 1] or 1 end

function MI2B_NameComparison(e1, e2)	return cmp(e1, e2, "nm") end
-- mobType tiebreaker rank within same level: elite(2)=3 > rare(4)=2 > normal(1)=1
local MI2B_LevelTiebreaker = { [2]=3, [4]=2, [1]=1, [3]=3 }
function MI2B_LevelComparison(e1, e2)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local lv1 = MI2B_SortLevel(e1.lv, e1.mobType)
	local lv2 = MI2B_SortLevel(e2.lv, e2.mobType)
	local desc = MI2B["sort"] and MI2B["sort"]["lv"] == true
	if lv1 ~= lv2 then
		if desc then return lv1 > lv2
		else		 return lv1 < lv2 end
	end
	-- Same level: elite on top, then rare, then normal (always, regardless of asc/desc)
	local t1 = MI2B_LevelTiebreaker[e1.mobType or 1] or 1
	local t2 = MI2B_LevelTiebreaker[e2.mobType or 1] or 1
	if t1 ~= t2 then return t1 > t2 end
	return e1.nm < e2.nm
end
function MI2B_XPComparison(e1, e2)		return cmp(e1, e2, "xp") end
function MI2B_KillsComparison(e1, e2)	return cmp(e1, e2, "kills") end
function MI2B_MaxHPComparison(e1, e2)	return cmp(e1, e2, "healthMax") end
function MI2B_MinDComparison(e1, e2)	return cmp(e1, e2, "minDamage") end
function MI2B_MaxDComparison(e1, e2)	return cmp(e1, e2, "maxDamage") end
function MI2B_DPSComparison(e1, e2)		return cmp(e1, e2, "dps") end
function MI2B_LootsComparison(e1, e2)	return cmp(e1, e2, "loots") end
function MI2B_CopperComparison(e1, e2)	return cmp(e1, e2, "copper") end
-- mobType sorted by display order, not raw value
function MI2B_MobTypeComparison(e1, e2) return cmp(e1, e2, "mobType", mobTypeOrder) end
-- location sorted by zone name; toggle key matches the field passed to cmp
function MI2B_LocComparison(e1, e2)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local v1 = (e1.zoneName and e1.zoneName ~= UNKNOWN) and e1.zoneName or nil
	local v2 = (e2.zoneName and e2.zoneName ~= UNKNOWN) and e2.zoneName or nil
	if v1 == nil and v2 == nil then return e1.nm < e2.nm end
	if v1 == nil then return false end
	if v2 == nil then return true  end
	if v1 == v2  then return e1.nm < e2.nm end
	local desc = MI2B["sort"] and MI2B["sort"]["zoneName"] == true
	if desc then return v1 > v2
	else		 return v1 < v2 end
end

function MI2B_ClothComparison(e1, e2)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local function pct(e)
		if not e.clothCount or not e.loots or e.loots == 0 then return nil end
		return ceil((e.clothCount / e.loots) * 100)
	end
	local v1, v2 = pct(e1), pct(e2)
	if v1 == nil and v2 == nil then return e1.nm < e2.nm end
	if v1 == nil then return false end
	if v2 == nil then return true  end
	if v1 == v2  then return e1.nm < e2.nm end
	if MI2B["sort"] and MI2B["sort"]["clothCount"] == true then return v1 > v2
	else														return v1 < v2 end
end

function MI2B_MobValueComparison(e1, e2)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local v1 = MI2B_GetMobTotalValue(e1)
	local v2 = MI2B_GetMobTotalValue(e2)
	if v1 == v2 then return e1.nm < e2.nm end
	if MI2B["sort"] and MI2B["sort"]["totalValue"] == true then return v1 > v2
	else														return v1 < v2 end
end

function MI2B_ItemRarityComparison(e1, e2)
	if not e1 and not e2 then return false end
	if not e1 then return false end
	if not e2 then return true  end
	local qf = MI2BSave and MI2BSave.qualityFilter

	-- Exponential weights per quality tier:
	-- poor=1, common=2, uncommon=5, rare=15, epic=50, legendary=75
	local weights = { 1, 2, 5, 15, 50, 75 }

	-- Score = sum over enabled tiers of (total_drops / loots) * weight.
	-- This gives expected weighted-quality items per loot: a mob that drops
	-- 3 epics per kill scores far higher than one that drops 1 rare per kill,
	-- and both drop count and drop rate are properly factored in.
	local function score(e)
		if not e.loots or e.loots == 0 then return 0 end
		local total = 0
		for idx = 1, 6 do
			local enabled = not qf or qf[idx]
			if enabled then
				local count = e["r"..idx] or 0
				if count > 0 then
					total = total + (count / e.loots) * weights[idx]
				end
			end
		end
		return total
	end

	local v1, v2 = score(e1), score(e2)
	if v1 == v2 then return e1.nm < e2.nm end
	if MI2B["sort"] and MI2B["sort"]["r1"] == true then return v1 > v2
	else											     return v1 < v2 end
end

MI2B_ActiveSortFn = nil

-- Maps sort key → raw comparator function, populated as makeSort is called.
MI2B_ComparatorByKey = {}

local function makeSort(key, fn)
	MI2B_ComparatorByKey[key] = fn
	return function(noflip)
		MI2B_SortToggleOperator(key, noflip)
		if not noflip then
			MI2B_ActiveSortFn = fn
			-- Persist the sort choice across sessions
			if MI2BSave then
				MI2BSave.lastSortKey = key
				MI2BSave.lastSortDir = MI2B["sort"] and MI2B["sort"][key]
			end
		end
		-- Compact: collect only non-nil entries into a fresh indexed array,
		-- sort it, then write back. This eliminates nil holes that WoW's Lua 5.0
		-- table.sort can expose to comparators when the table has string keys
		-- (onePastEnd) or sparse integer keys.
		local tmp = {}
		for i = 1, (MI2BrowseTable.onePastEnd or 1) - 1 do
			if MI2BrowseTable[i] ~= nil then
				tmp[table.getn(tmp) + 1] = MI2BrowseTable[i]
			end
		end
		table.sort(tmp, fn)
		-- Write sorted entries back and reset onePastEnd
		for i = 1, table.getn(tmp) do
			MI2BrowseTable[i] = tmp[i]
		end
		MI2BrowseTable.onePastEnd = table.getn(tmp) + 1
		ShowUIPanel(MI2B_BrowseFrame, 1)
		MI2B_ScrollBar_Update()
	end
end

-- Re-apply the last active sort after a list rebuild, without flipping direction.
function MI2B_ReapplySort()
	if not MI2B_ActiveSortFn then return end
	local tmp = {}
	for i = 1, (MI2BrowseTable.onePastEnd or 1) - 1 do
		if MI2BrowseTable[i] ~= nil then
			tmp[table.getn(tmp) + 1] = MI2BrowseTable[i]
		end
	end
	table.sort(tmp, MI2B_ActiveSortFn)
	for i = 1, table.getn(tmp) do
		MI2BrowseTable[i] = tmp[i]
	end
	MI2BrowseTable.onePastEnd = table.getn(tmp) + 1
end

MI2B_SortByName		   = makeSort("nm",			MI2B_NameComparison)
MI2B_SortByLevel	   = makeSort("lv",			MI2B_LevelComparison)
MI2B_SortByXP		   = makeSort("xp",			MI2B_XPComparison)
MI2B_SortByKills	   = makeSort("kills",		MI2B_KillsComparison)
MI2B_SortByMaxHP	   = makeSort("healthMax",	MI2B_MaxHPComparison)
MI2B_SortByMinD		   = makeSort("minDamage",	MI2B_MinDComparison)
MI2B_SortByMaxD		   = makeSort("maxDamage",	MI2B_MaxDComparison)
MI2B_SortByDPS		   = makeSort("dps",		MI2B_DPSComparison)
MI2B_SortByLoots	   = makeSort("loots",		MI2B_LootsComparison)
MI2B_SortByCloth	   = makeSort("clothCount", MI2B_ClothComparison)
MI2B_SortByCopper	   = makeSort("copper",		MI2B_CopperComparison)
MI2B_SortByMobValue    = makeSort("totalValue", MI2B_MobValueComparison)
MI2B_SortByMobType	   = makeSort("mobType",	MI2B_MobTypeComparison)
MI2B_SortByItemRarity  = makeSort("r1",			MI2B_ItemRarityComparison)
MI2B_SortByLocation    = makeSort("zoneName",	MI2B_LocComparison)

-- Defined here so all sort functions above are already in scope.
function MI2B_RestoreSavedSort()
	if not MI2BSave or not MI2BSave.lastSortKey or MI2B_ActiveSortFn then return end
	-- MI2B_ComparatorByKey holds the raw comparator (not the makeSort wrapper),
	-- which is what MI2B_ReapplySort passes to table.sort.
	local cmp = MI2B_ComparatorByKey[MI2BSave.lastSortKey]
	if cmp then MI2B_ActiveSortFn = cmp end
end


-----------------------------------------------------------------------------
-- MI2B_CreateBrowseTooltip()
-----------------------------------------------------------------------------
function MI2B_CreateBrowseTooltip(mobDataB, tooltip)
	local mobName = mobDataB.nm
	local mobLevel = mobDataB.lv
	local mobType  = mobDataB.mobType or MI2B_TYPE_NORMAL

	-- Determine difficulty colour, mirroring MI2_Search.lua tooltip logic.
	local nameColor
	if mobType == MI2B_TYPE_WORLDBOSS then
		nameColor = "|cffff1a1a"
	elseif mobLevel == -1 then
		nameColor = "|cffff1a1a"
	else
		local playerLevel = UnitLevel("player") or 1
		local diff = playerLevel - (mobLevel or 0)
		if diff >= 6 then
			nameColor = "|cff808080"
		elseif diff >= 3 then
			nameColor = "|cff40bf40"
		elseif diff > -3 then
			nameColor = "|cffffff00"
		elseif diff > -5 then
			nameColor = "|cffff8040"
		else
			nameColor = "|cffff1a1a"
		end
	end

	local caption
	if mobDataB.lvDisplay then
		local mt = mobDataB.mobType or MI2B_TYPE_NORMAL
		if mt == MI2B_TYPE_WORLDBOSS then
			caption = nameColor..mobName.."|r  "..mobDataB.lvDisplay
		else
			caption = nameColor..mobName.."|r  "..mobDataB.lvDisplay..MI2B_MobTypeSuffix(mt)
		end
	else
		local suffix = MI2B_MobTypeSuffix(mobType)
		caption = nameColor..mobName.."|r  "..MI2B_FormatLevel(mobLevel, mobType)..suffix
	end

	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetText(caption)

	-- Pass the creature ID and the stored lv so MI2_BuildMobInfoTooltip
	-- can apply its own combine pass (level ±4 search) when CombinedMode is on.
	local idStr		 = string.match(mobDataB.mobIndex, "^(%d+):")
	local creatureID = tonumber(idStr) or idStr
	local mobLevel	 = mobDataB.lv
	MI2_BuildMobInfoTooltip(creatureID, mobLevel, 1)
	GameTooltip:Show()
end


function MI2B_OpenLocationMap()
	local index   = this:GetID() + FauxScrollFrame_GetOffset(MI2B_ListScrollFrame)
	local mobData = MI2BrowseTable[index]
	if not mobData or not mobData.location or not mobData.location.zones then return end

	-- Resolve the first zone ID to a continent/zone for SetMapZoom
	local zid = next(mobData.location.zones)
	if not zid then return end

	ShowUIPanel(WorldMapFrame)
	-- SetMapZoom with just continent opens the continent map;
	-- we use the area ID directly if supported, otherwise just open world map.
	MI2B_MobLocationIconText:SetText(mobData.nm.."\n"..MI2B_FormatLevel(mobData.lv, mobData.mobType)..MI2B_MobTypeSuffix(mobData.mobType or 1))
	MI2B_MobLocationIcon:Show()
end


function MI2B_MobLocationIcon_OnEvent()
	if event == "WORLD_MAP_UPDATE" then
		if WorldMapFrame:IsVisible() then
			if not (this["info"] and this["info"].cont) then
				this:Hide()
				return
			end
			getglobal(this:GetName().."Text"):SetText(this["info"].nm.."\n"..MI2B_FormatLevel(this["info"].lv, this["info"].mobType))
			this:Show()
		else
			this["info"] = {}
		end
	end
end


function MobInfo2_Browser_Hide()
	if MI2B.browseropen and MI2B.mapclosed then
		MI2B.browseropen = nil
		MI2B.mapclosed   = nil
		return
	end
	MI2B_BrowseFrame:orgHide()
end


local orgMI2_OptionsFrameOnShow = MI2_OptionsFrameOnShow
function MI2_OptionsFrameOnShow()
	orgMI2_OptionsFrameOnShow()
	MI2B_OpenBrowserButton:SetPoint("BOTTOMRIGHT", "MI2_MainOptionsFrame", "BOTTOMRIGHT", -7, -26)
	MI2B_OpenBrowserButton:Show()
end


-----------------------------------------------------------------------------
-- Item Quality dropdown (UIDropDownMenu, vanilla 1.12.1 compatible)
-- keepShownOnClick=1 keeps the menu open after each selection.
-- The frame is created once in XML (MI2B_QualityDropDown) and initialized
-- on demand. It closes automatically via CloseDropDownMenus() on browser hide.
-----------------------------------------------------------------------------

local function MI2B_QualityDropDown_Init(level)
	if level ~= 1 then return end
	if not MI2BSave then MI2BSave = {} end
	if not MI2BSave.qualityFilter then MI2BSave.qualityFilter = MI2B_QualityDefault() end

	local info

	-- "Show Item Count" toggle: shows count(chance%) instead of chance%
	info = {}
	info.text            = MI2B_QUALITY_SHOW_ITEM_COUNT or "Show Item Count"
	info.checked         = MI2BSave.showItemCount and true or false
	info.keepShownOnClick = 1
	info.func = function()
		MI2BSave.showItemCount = not MI2BSave.showItemCount or nil
		MI2B_RefreshBrowseList()
		MI2B_ReapplySort()
		MI2B_ScrollBar_Update()
	end
	UIDropDownMenu_AddButton(info, level)

	-- Separator
	info = {}; info.text = ""; info.notCheckable = true; info.disabled = true
	UIDropDownMenu_AddButton(info, level)

	-- One entry per rarity
	for i = 1, 6 do
		local idx = i
		info = {}
		info.text             = MI2B_QUALITY_COLORS[i]..MI2B_GetQualityName(i).."|r"
		info.checked          = MI2BSave.qualityFilter[i] and true or false
		info.keepShownOnClick  = 1
		info.func = function()
			if not MI2BSave.qualityFilter then MI2BSave.qualityFilter = MI2B_QualityDefault() end
			MI2BSave.qualityFilter[idx] = not MI2BSave.qualityFilter[idx]
			MI2B_RefreshBrowseList()
			MI2B_ReapplySort()
			MI2B_ScrollBar_Update()
		end
		UIDropDownMenu_AddButton(info, level)
	end
end

function MI2B_ToggleQualityDropDown(self)
	if not MI2BSave then MI2BSave = {} end
	if not MI2BSave.qualityFilter then MI2BSave.qualityFilter = MI2B_QualityDefault() end
	UIDropDownMenu_Initialize(MI2B_QualityDropDown, MI2B_QualityDropDown_Init, "MENU")
	ToggleDropDownMenu(1, nil, MI2B_QualityDropDown, self:GetName(), 0, 0)
end

-- Close the dropdown when the browser is hidden
local orgMobInfo2_Browser_Hide = MobInfo2_Browser_Hide
MobInfo2_Browser_Hide = function()
	CloseDropDownMenus()
	orgMobInfo2_Browser_Hide()
end