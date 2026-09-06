miVersionNo = ' 3.3'

if not C_Item then
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_LOGIN")
	f:SetScript("OnEvent", function()
		local locale = GetLocale()
		local msg
		if locale == "deDE" then
			msg = "|cffff2020MobInfo2:|r ClassicAPI ist nicht installiert. Das Addon funktioniert ohne es nicht. Bitte installiere ClassicAPI und starte das Spiel neu."
		elseif locale == "frFR" then
			msg = "|cffff2020MobInfo2:|r ClassicAPI n'est pas installe. L'addon ne peut pas fonctionner sans lui. Veuillez installer ClassicAPI et redemarrer le jeu."
		elseif locale == "zhTW" then
			msg = "|cffff2020MobInfo2:|r 未安裝 ClassicAPI。若無此附加元件，本插件將無法運作。請安裝 ClassicAPI 並重新啟動遊戲。"
		elseif locale == "zhCN" then
			msg = "|cffff2020MobInfo2:|r 未安装 ClassicAPI。没有它插件将无法运行。请安装 ClassicAPI 并重新启动游戏。"
		elseif locale == "esES" or locale == "esMX" then
			msg = "|cffff2020MobInfo2:|r ClassicAPI no esta instalado. El addon no funcionara sin el. Por favor instala ClassicAPI y reinicia el juego."
		elseif locale == "koKR" then
			msg = "|cffff2020MobInfo2:|r ClassicAPI가 설치되지 않았습니다. 이 애드온은 ClassicAPI 없이는 작동하지 않습니다. ClassicAPI를 설치하고 게임을 다시 시작하십시오."
		else
			msg = "|cffff2020MobInfo2:|r ClassicAPI is not installed. The addon will not function without it. Please install ClassicAPI and restart the game."
		end
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end)
	return
end

--
-- MobInfo-2 is a World of Warcraft AddOn that provides you with useful
-- additional information about Mobs (ie. opponents/monsters). It adds
-- new information to the game's Tooltip when you hover with your mouse
-- over a mob. It also adds a numeric display of the Mobs health
-- and mana (current and max) to the Mob target frame.
--
-- MobInfo-2 is the continuation of the original "MobInfo" by Dizzarian,
-- combined with the original "MobHealth2" by Wyv. Both Dizzarian and
-- Wyv sadly no longer play WoW and stopped maintaining their AddOns.
-- I have "inhereted" MobInfo from Dizzarian and MobHealth-2 from Wyv
-- and now continue to update and improve the united result.
-- MobInfo-2 Enhanced version by Drakensangs.
--

MI2_DB_VERSION = 15
MI2_DB_SV = 1

-----------------------------------------------------------------------------
-- MI2_MobHpDB
--
-- Proxy table that backs mob health data into MobInfoDB[key].mh.
-- This allows MI2_Health.lua to read/write health as if it were a flat
-- table, while the data is actually stored inside the main mob record.
-----------------------------------------------------------------------------
MI2_MobHpDB = {}
setmetatable(MI2_MobHpDB, {
	__index = function(t, key)
		local mobInfo = MobInfoDB and MobInfoDB[key]
		if mobInfo then return mobInfo.mh end
		return nil
	end,
	__newindex = function(t, key, value)
		if not MobInfoDB then return end
		local mobInfo = MobInfoDB[key]
		if not mobInfo then
			mobInfo = {}
			MobInfoDB[key] = mobInfo
		end
		mobInfo.mh = value
	end,
})
MI2_IMPORT_DB_VERSION = 6

local MI2_RecentLoots, MI2_MobCache, MI2_MobCacheIdx, MI2_XRefItemTable
local MI2_NewCorpseIdx = 0
local MI2_CurrentCorpseIndex = nil
local MI2_RecentLoots = {}
local MI2_SpellToSchool = {}
local MI2_CACHE_SIZE = 30

-- skinning loot table using localization independant item IDs:
--	Ruined Leather Scraps, Light Leather, Medium Leather, Heavy Leather, Thick Leather, Rugged Leather
--	Chimera Leather, Devilsaur Leather, Frostsaber Leather, Warbear Leather, Core Leather, Thin Kodo Leather, Crystal Infused Leather
--	Knothide Leather Scraps, Knothide Leather, Broken Silithid Chitin, Silithid Chitin, Fel Scales, Fel Hide
--	Light Hide, Medium Hide, Heavy Hide, Thick Hide, Rugged Hide, Shadowcat Hide, Thick Wolfhide
--	Scorpid Scale, Red Whelp Scales, Turtle Scales, Black Whelp Scales, Brilliant Chromatic Scale
--	Black Dragonscale, Blue Dragonscale, Red Dragonscale, Green Dragonscale, Worn Dragonscale, Heavy Scorpid Scale
--	deviate scale, perfect deviate scale, green whelp scale, worn dragonscale
--	Shadow Draenite, Crystalline Fragments, Flame Spessarite
--
-- removed "Shiny Fish Scales" ([17057]=1,) because its also normal loot
--
local miSkinLoot = { [2934]=1, [2318]=1, [2319]=1, [4234]=1, [4304]=1, [8170]=1,
					[15423]=1,[15417]=1,[15422]=1,[15419]=1,[17012]=1, [5082]=1, [25699]=1,
					[21887]=1,[25649]=1,[20499]=1,[20498]=1,[25700]=1,[25707]=1,
					  [783]=1, [4232]=1, [4235]=1, [8169]=1, [8171]=1, [7428]=1, [8368]=1,
					 [8154]=1,[7287]=1, [8167]=1, [7286]=1,[12607]=1,
					[15416]=1,[15415]=1,[15414]=1,[15412]=1, [8165]=1,[15408]=1,
					 [6470]=1, [6471]=1, [7392]=1, [8165]=1,
					 [23107]=1, [24189]=1, [21929]=1,  }

-- cloth loot table using localization independant item IDs
-- Linen Cloth, Wool Cloth, Silk Cloth, Mageweave Cloth, Felcloth, Runecloth, Mooncloth, Netherweave
local miClothLoot = { [2589]=1, [2592]=1, [4306]=1, [4338]=1, [14256]=1, [14047]=1, [14342]=1, [21877 ]=1 };

local MI2_ItemCollapseList = { [2725]=0, [2728]=0, [2730]=0, [2732]=0,
							   [2734]=0, [2735]=0, [2738]=0, [2740]=0, [2742]=0,
							   [2745]=0, [2748]=0, [2749]=0, [2750]=0, [2751]=0 }

-- global MobInfo color constansts
mifontBlue = "|cff0000ff"
mifontItemBlue = "|cff2060ff"
mifontLightBlue = "|cff00e0ff"
mifontLightGreen = "|cff60ff60"
mifontGreen = "|cff00ff00"
mifontRed = "|cffff0000"
mifontLightRed = "|cffff8080"
mifontGold = "|cffffcc00"
mifontGray = "|cff888888"
mifontDiffGray   = "|cff808080"
mifontDiffGreen  = "|cff40bf40"
mifontDiffOrange = "|cffff8040"
mifontDiffRed	 = "|cffff1a1a"
mifontWhite = "|cffffffff"
mifontSubWhite = "|cffbbbbbb"
mifontMageta = "|cffe040ff" -- old magenta: "|cffff00ff"
mifontYellow  = "|cffffff00"
mifontCyan   = "|cff00ffff"
mifontOrange = "|cffff7000"
MI2_QualityColor = { [1]=mifontGray, [2]=mifontWhite, [3]=mifontGreen, [4]=mifontItemBlue, [5]=mifontMageta, [6]=mifontOrange, [7]=mifontRed }

-- Element-specific colors for resistance display
mifontArcane = "|cffff80ff"		-- Light purple/pink for Arcane
mifontFire = "|cffff4000"		-- Orange-red for Fire
mifontFrost = "|cff4080ff"		-- Light blue for Frost
mifontHoly = "|cffffcc00"		-- Yellow/gold for Holy
mifontNature = "|cff40ff40"		-- Green for Nature
mifontShadow = "|cff8040ff"		-- Purple for Shadow

-- Color mapping for spell schools
MI2_SpellSchoolColors = {
	ar = mifontArcane,
	fi = mifontFire,
	fr = mifontFrost,
	ho = mifontHoly,
	na = mifontNature,
	sh = mifontShadow
}

-----------------------------------------------------------------------------
-- MI2_GetMobName( creatureID )
--
-- Resolves a creature ID to a localized name using the ClassicAPI creature
-- cache. Returns the cached name, or "#<id>" as a fallback if not cached.
-----------------------------------------------------------------------------
function MI2_GetMobName( creatureID )
	if not creatureID then return "?" end
	local info = C_CreatureInfo.GetCreatureInfoByID( creatureID )
	if info then
		return info.name
	end
	return nil
end

-----------------------------------------------------------------------------
-- MI2_MigrateMobEntry( creatureID, mobName, mobLevel )
--
-- Lazy migration: when a mob is targeted we know both its name and its
-- creatureID. If MobInfoDB still has the old "name:level" key for this mob
-- (written by a previous version of the addon), rename it to "id:level".
-- This runs at most once per mob per session.
--
-- When mobLevel is -1 (player too low level to see the mob's level), also
-- checks whether a resolved entry already exists for this creature at a real
-- level. Does so via 63 direct key lookups (vanilla max level) rather than
-- a full DB scan. Returns the resolved key if found, creatureID..":-1" if not.
-----------------------------------------------------------------------------
function MI2_MigrateMobEntry( creatureID, mobName, mobLevel )
	local oldKey = mobName..":"..mobLevel
	local newKey = creatureID..":"..mobLevel
	if oldKey ~= newKey and MobInfoDB[oldKey] and not MobInfoDB[newKey] then
		MobInfoDB[newKey] = MobInfoDB[oldKey]
		MobInfoDB[oldKey] = nil
		if MI2_MobCache[oldKey] then
			MI2_MobCache[newKey] = MI2_MobCache[oldKey]
			MI2_MobCache[oldKey] = nil
		end
	end

	if mobLevel == -1 then
		local prefix = tostring(creatureID)..":"
		local bestKey   = nil
		local bestLevel = 0
		for lv = 1, 63 do
			local key = prefix..lv
			if MobInfoDB[key] and lv > bestLevel then
				bestLevel = lv
				bestKey   = key
			end
		end
		return bestKey or (tostring(creatureID)..":-1")
	end
end

-----------------------------------------------------------------------------
-- MI2_UpgradeBossLevelEntry( creatureID, mobLevel )
--
-- When we encounter a mob at a known level (not -1) and the database has an
-- existing entry for that same creatureID at level -1 that is NOT a world
-- boss (rank 3), it means we previously recorded the mob when it was too
-- high-level to display. Now that we know the real level, merge the -1
-- entry into the correctly-keyed entry and delete the stale -1 key.
-- Called from MI2_BuildMobInfoTooltip on every real mouseover.
-----------------------------------------------------------------------------
function MI2_UpgradeBossLevelEntry( creatureID, mobLevel )
	if mobLevel == -1 then return end
	local oldKey = creatureID..":"..-1
	if not MobInfoDB[oldKey] then return end
	-- Don't touch world-boss entries.
	local oldData = MI2_FetchMobData( oldKey )
	if oldData.mobType == 3 then return end
	local newKey = creatureID..":"..mobLevel
	if MobInfoDB[newKey] then
		-- An entry at the real level already exists; merge the -1 data into it.
		local newData = MI2_FetchMobData( newKey )
		MI2_AddTwoMobs( newData, oldData )
		MI2_StoreBasicInfo( newKey, newData )
		if newData.location then
			MI2_StoreLocation( newKey, newData.location )
		end
	else
		-- No entry at the real level yet; simply re-key the -1 entry.
		MobInfoDB[newKey] = MobInfoDB[oldKey]
		if MI2_MobCache[oldKey] then
			MI2_MobCache[newKey] = MI2_MobCache[oldKey]
			MI2_MobCache[oldKey] = nil
		end
	end
	MobInfoDB[oldKey] = nil
	MI2_MobCache[oldKey] = nil
end

-----------------------------------------------------------------------------
-- MI2_GetMobDataFromMobInfo()
--
-- Extract all data describing a specific mob from a given mob database
-- record (called "mobInfo"). The mobInfo data is in a compressed format
-- that requires decoding to make it usable.
-----------------------------------------------------------------------------
function MI2_GetMobDataFromMobInfo( mobInfo, mobData )
	MI2_DecodeBasicMobData( mobInfo, mobData )
	MI2_DecodePlayerSpecificData( mobInfo, mobData, MI2_PlayerName )
	MI2_DecodeMobLocation( mobInfo, mobData )
	MI2_DecodeItemList( mobInfo, mobData )
	MI2_DecodeResists( mobInfo, mobData )
end

-----------------------------------------------------------------------------
-- MI2_GetUnitBasedMobData()
--
-- Obtain and store all unit specific mob data.
-----------------------------------------------------------------------------
function MI2_GetUnitBasedMobData( mobIndex, mobData, unitId, mobLevel )
	-- get mobs PPP and calculate max health
	local mobPPP = MobHealth_PPP(mobIndex)
	if mobPPP <= 0 then mobPPP = 1 end
	mobData.healthMax = floor(mobPPP * 100 + 0.5)

	-- obtain unit specific values if unitId is given
	if unitId then
		mobData.class = UnitClass(unitId)
		if UnitHealthMax(unitId) == 100 then
			mobData.healthCur = floor(mobPPP * UnitHealth(unitId) + 0.5)
		else
			mobData.healthCur = UnitHealth(unitId)
		end
		mobData.manaCur = UnitMana( unitId )
		mobData.manaMax = UnitManaMax( unitId )
	end

	mobData.color = GetDifficultyColor( mobLevel )
end

-----------------------------------------------------------------------------
-- MI2_FetchMobData()
--
-- Internal function for accessing a mobData record
-- This function implements a caching mechanism for faster access
-- to database records. The cache stores the last 30 Mob records.
-- Data returned by "MI2_FetchMobData()" should NOT be modified because
-- modifications are written back into the main database file.
-----------------------------------------------------------------------------
function MI2_FetchMobData( mobIndex )
	local mobData = MI2_MobCache[mobIndex]
	if mobIndex and not mobData then
		local mobInfo = MobInfoDB[mobIndex]
		mobData = { mobType=1, resists={} }
		if mobInfo then
			MI2_GetMobDataFromMobInfo( mobInfo, mobData )
		end
		MI2_MobCache[mobIndex] = mobData

		local oldMob = MI2_MobCache[MI2_MobCacheIdx]
		if oldMob then
			MI2_MobCache[oldMob] = nil
		end

		MI2_MobCache[MI2_MobCacheIdx] = mobIndex
		MI2_MobCacheIdx = MI2_MobCacheIdx + 1
		if MI2_MobCacheIdx > MI2_CACHE_SIZE then
			MI2_MobCacheIdx = 1
		end
	end
	return mobData
end

-----------------------------------------------------------------------------
-- MI2_DecodeBasicMobData()
--
-- Decode the basic mob data. This function is used by the public
-- "MI2_GetMobData()" and also by the Mob search routines.
-----------------------------------------------------------------------------
function MI2_DecodeBasicMobData( mobInfo, mobData, mobIndex )
	if mobIndex then
		mobInfo = MobInfoDB[mobIndex]
		if not mobInfo then
			-- unknown mob is being looted
			mobData.loots = 1
			return
		end
	end

	-- decode mob basic info: loots, empty loots, experience, cloth count, money looted, item value looted, mob type
	mobData.mobType = 1
	if mobInfo.bi then
		local a,b,lt,el,cp,iv,cc,mt,sc = string.find( mobInfo.bi, "(%d*)/(%d*)/(%d*)/(%d*)/(%d*)/(%d*)/(%d*)")
		mobData.loots		= tonumber(lt)
		mobData.emptyLoots	= tonumber(el)
		mobData.copper		= tonumber(cp)
		mobData.itemValue	= tonumber(iv)
		mobData.clothCount	= tonumber(cc)
		mobData.mobType		= tonumber(mt) or 1
		mobData.skinCount	= tonumber(sc)
	end

	if mobData.mobType > 10 then
		mobData.lowHpAction = floor(mobData.mobType / 10)
		mobData.mobType = mobData.mobType - mobData.lowHpAction * 10
	end
end

-----------------------------------------------------------------------------
-- MI2_DecodeMobLocation()
--
-- Decode mob location info, skip invalid location data
-- The location is encoded in the mob record entry "ml" as a
-- slash-separated list of zone IDs, e.g. "12/14/16".
-- The decoded data is stored in the given "mobData" structure.
-----------------------------------------------------------------------------
function MI2_DecodeMobLocation( mobInfo, mobData, mobIndex )
	if mobIndex then
		mobInfo = MobInfoDB[mobIndex]
	end

	if mobInfo.ml then
		local zones = {}
		for id in string.gmatch( mobInfo.ml, "%d+" ) do
			local zid = tonumber(id)
			if zid and zid > 0 then
				zones[zid] = true
			end
		end
		if next(zones) then
			mobData.location = { zones = zones }
		end
	end
end -- MI2_DecodeMobLocation()

-----------------------------------------------------------------------------
-- MI2_DecodePlayerSpecificData()
--
-- Decode player specific data: number of kills, min damage, max damage, dps
-- Player specific data is encoded in mob record entries starting with
-- the lowercase letter "c" plus a player name index number, eg. "c7",
-- this is called the player ID code. The playerName parameter must give
-- the player ID code for the player data to decode.
-- The decoded data is stored in the given "mobData" structure.
-----------------------------------------------------------------------------
function MI2_DecodePlayerSpecificData( mobInfo, mobData, playerName, mobIndex )
	if mobIndex then
		mobInfo = MobInfoDB[mobIndex]
	end

	if mobInfo[playerName] then
		local a,b,kl,mind,maxd,dps,xp = string.find( mobInfo[playerName], "(%d*)/(%d*)/(%d*)/(%d*)/*(%d*)")
		mobData.kills		= tonumber(kl)
		mobData.minDamage	= tonumber(mind)
		mobData.maxDamage	= tonumber(maxd)
		mobData.dps			= tonumber(dps)
		if xp then
			mobData.xp		= tonumber(xp)
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_DecodeResists()
--
-- Decode mob resistances and immunities info
-- The location is encoded in the mob record entry "re".
-- The decoded data is stored in the given "mobData" structure.
-----------------------------------------------------------------------------
function MI2_DecodeResists( mobInfo, mobData, mobIndex )
	if mobIndex then
		mobInfo = MobInfoDB[mobIndex]
	end

	if mobInfo.re then
		local a,b,ar,arHits,fi,fiHits,fr,frHits,ho,hoHits,na,naHits,sh,shHits = string.find( mobInfo.re, "(%-?%d*),(%-?%d*)/(%-?%d*),(%-?%d*)/(%-?%d*),(%-?%d*)/(%-?%d*),(%-?%d*)/(%-?%d*),(%-?%d*)/(%-?%d*),(%-?%d*)")
		mobData.resists = {}
		mobData.resists.ar	= tonumber(ar)
		mobData.resists.fi	= tonumber(fi)
		mobData.resists.fr	= tonumber(fr)
		mobData.resists.ho	= tonumber(ho)
		mobData.resists.na	= tonumber(na)
		mobData.resists.sh	= tonumber(sh)
		mobData.resists.arHits	= tonumber(arHits)
		mobData.resists.fiHits	= tonumber(fiHits)
		mobData.resists.frHits	= tonumber(frHits)
		mobData.resists.hoHits	= tonumber(hoHits)
		mobData.resists.naHits	= tonumber(naHits)
		mobData.resists.shHits	= tonumber(shHits)
	end
end

-----------------------------------------------------------------------------
-- MI2_DecodeItemList()
--
-- Decode the item list encoded in the "il" string of a mobInfo database
-- record. The result is stored in the given mobData record as a new
-- record field called "itemList".
-----------------------------------------------------------------------------
function MI2_DecodeItemList( mobInfo, mobData, mobIndex )
	if mobIndex then
		mobInfo = MobInfoDB[mobIndex]
	end

	if mobInfo.il then
		local lootItems = mobInfo.il
		local s,e, item, amount = string.find( lootItems, "(%d+)[:]?(%d*)" )
		if e then mobData.itemList = {} end
		while e do
			mobData.itemList[tonumber(item)] = tonumber(amount) or 1
			s,e, item, amount = string.find( lootItems, "/(%d+)[:]?(%d*)", e+1 )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreBasicInfo()
--
-- Store the mob basic info in the mob database. Basic info includes the
-- mob loot quality overview counters.
-----------------------------------------------------------------------------
function MI2_StoreBasicInfo( mobIndex, mobData )
	local mobInfo = MobInfoDB[mobIndex]
	if not mobInfo then
		mobInfo = {}
		MobInfoDB[mobIndex] = mobInfo
	end

	local mobType = mobData.mobType or 1
	if mobData.lowHpAction then
		mobType = mobType + mobData.lowHpAction * 10
	end

	local basicInfo = (mobData.loots or "").."/"..(mobData.emptyLoots or "").."/"..(mobData.copper or "").."/"..(mobData.itemValue or "").."/"..(mobData.clothCount or "").."/"..(mobType or "").."/"..(mobData.skinCount or "")
	if basicInfo ~= "//////" then
		mobInfo.bi = basicInfo
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreLocation()
--
-- Store the mob location data in the mob database.
-----------------------------------------------------------------------------
function MI2_StoreLocation( mobIndex, loc )
	local mobInfo = MobInfoDB[mobIndex]
	if not mobInfo then
		mobInfo = {}
		MobInfoDB[mobIndex] = mobInfo
	end

	-- store all known zone IDs for this mob in mobInfo.ml as "z1/z2/z3"
	if loc.zones and next(loc.zones) then
		local parts = {}
		for id in pairs(loc.zones) do
			table.insert(parts, tostring(id))
		end
		table.sort(parts, function(a,b) return tonumber(a) < tonumber(b) end)
		mobInfo.ml = table.concat(parts, "/")
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreCharData()
--
-- Store the char specific mob data in the mob database.
-----------------------------------------------------------------------------
local function MI2_StoreCharData( mobIndex, mobData, playerName )
	local mobInfo = MobInfoDB[mobIndex]
	if not mobInfo then
		mobInfo = {}
		MobInfoDB[mobIndex] = mobInfo
	end

	local playerInfo = (mobData.kills or "").."/"..(mobData.minDamage or "").."/"..(mobData.maxDamage or "").."/"..(mobData.dps or "").."/"..(mobData.xp or "")
	if playerInfo ~= "////" then
		mobInfo[playerName] = playerInfo
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreLootItems()
--
-- Store a mobs loot items list in mob database.
-----------------------------------------------------------------------------
function MI2_StoreLootItems( mobIndex, mobData )
	local mobInfo = MobInfoDB[mobIndex]
	if not mobInfo then
		mobInfo = {}
		MobInfoDB[mobIndex] = mobInfo
	end

	-- create loot item list string for database
	local itemList = ""
	if mobData.itemList then
		local prefix = ""
		for itemID, amount in pairs(mobData.itemList) do
			itemList = itemList..prefix..itemID
			if amount > 1 then
				itemList = itemList..":"..amount
			end
			prefix = "/"
		end
	end

	if itemList ~= "" then
		mobInfo.il = itemList
	else
		mobInfo.il = nil
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreResistData()
--
-- Store resist data for mob in mob database. Data will only be saved if
-- resistances exist.
-----------------------------------------------------------------------------
function MI2_StoreResistData( mobIndex )
	local mobData = MI2_FetchMobData( mobIndex )
	resData = mobData.resists

	-- store only if resistances exist
	if resData.ar or resData.fi or resData.fr or resData.ho or resData.na or resData.sh then
		local mobInfo = MobInfoDB[mobIndex]
		if not mobInfo then
			mobInfo = {}
			MobInfoDB[mobIndex] = mobInfo
		end
		local resistString = 
				(resData.ar or "")..","..(resData.arHits or "").."/"..
				(resData.fi or "")..","..(resData.fiHits or "").."/"..
				(resData.fr or "")..","..(resData.frHits or "").."/"..
				(resData.ho or "")..","..(resData.hoHits or "").."/"..
				(resData.na or "")..","..(resData.naHits or "").."/"..
				(resData.sh or "")..","..(resData.shHits or "")
		mobInfo.re = resistString
	end
end

-----------------------------------------------------------------------------
-- MI2_StoreAllMobData()
--
-- Store all recorded data for a given mob in the mob database.
-----------------------------------------------------------------------------
function MI2_StoreAllMobData( mobData, mobName, mobLevel, playerName, mobIndex )
	if not mobIndex then
		mobIndex = mobName..":"..mobLevel
	end

	if MobInfoConfig.SaveBasicInfo == 1 then
		MI2_StoreBasicInfo( mobIndex, mobData )
	end

	if MobInfoConfig.SaveLocation == 1 and mobData.location then
		MI2_StoreLocation( mobIndex, mobData.location )
	end

	if MobInfoConfig.SaveCharData == 1 then
		MI2_StoreCharData( mobIndex, mobData, MI2_PlayerName )
	end

	if MobInfoConfig.SaveItems == 1 then
		MI2_StoreLootItems( mobIndex, mobData )
	end

	if MobInfoConfig.SaveResist == 1 then
		MI2_StoreResistData( mobIndex )
	end
end

-----------------------------------------------------------------------------
-- MI2_RemoveCharData()
--
-- Remove all char specific data from the given Mob database record.
-----------------------------------------------------------------------------
function MI2_RemoveCharData( mobInfo )
	for entryName, entryData in pairs(mobInfo) do
		if entryName ~= "bi" and entryName ~= "il" and entryName ~= "ml" and entryName ~= "mh" and entryName ~= "ver" then
			mobInfo[entryName] = nil
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_DeleteMobData()
--
-- Delete data for a specific Mob from database and current target table.
-----------------------------------------------------------------------------
function MI2_DeleteMobData( mobIndex, deleteHealth )
	if mobIndex then
		if deleteHealth and MobInfoDB[mobIndex] then
			MobInfoDB[mobIndex].mh = nil
		end
		MobInfoDB[mobIndex] = nil
		MI2_MobCache[mobIndex] = nil
		if mobIndex == MI2_Target.mobIndex then
			MI2_Target = {}
			MobHealth_Display()
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_SetPlayerName()
--
-- Set the global MobInfo player name. This is the abbreviated player name
-- that is just an index into the MobInfo player name table, where the real
-- name of the player is stored.
-----------------------------------------------------------------------------
function MI2_SetPlayerName()
	local charName = GetCVar( "realmName" )..':'..UnitName("player")
	if not MI2_CharTable[charName] then
		MI2_CharTable.charCount = MI2_CharTable.charCount + 1
		MI2_CharTable[charName] = "c"..MI2_CharTable.charCount
	end
	MI2_PlayerName = MI2_CharTable[charName]
end

-----------------------------------------------------------------------------
-- MI2_ClearMobCache()
--
-- Empty oput the mob data cache
-----------------------------------------------------------------------------
function MI2_ClearMobCache()
	MI2_MobCache = {}
	MI2_MobCacheIdx = 1
end

-----------------------------------------------------------------------------
-- MI2_DeleteAllMobData()
--
-- Delete entire Mob database
-----------------------------------------------------------------------------
function MI2_DeleteAllMobData()
	MobInfoDB = { ["DatabaseVersion:0"] = { ver = MI2_DB_VERSION, sv=MI2_DB_SV } }
	MI2_CharTable = { charCount = 0 }
	MI2_XRefItemTable = {}
	MI2_SetPlayerName()
	MI2_ClearMobCache()
end

-----------------------------------------------------------------------------
-- MI2_DeleteAllMobData()
--
-- Delete entire Mob database
-----------------------------------------------------------------------------
function MI2_InitializeAllMobData()
	if not MobInfoDB then
		MobInfoDB = { ["DatabaseVersion:0"] = { ver = MI2_DB_VERSION, sv=MI2_DB_SV } }
	end
	MI2_CharTable = MI2_CharTable or { charCount = 0 }
	MI2_XRefItemTable = MI2_XRefItemTable or {}
	MobHealthPlayerDB =	MobHealthPlayerDB or {}
	MI2_SetPlayerName()
	MI2_ClearMobCache()
end

-----------------------------------------------------------------------------
-- chattext()
--
-- spits out msg to the chat channel.
-----------------------------------------------------------------------------
function chattext(txt)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( mifontLightBlue.."<MI2> "..txt)
	end
end

-----------------------------------------------------------------------------
-- MI2_InitOptions()
--
-- initialize MobInfo configuration options
-- this takes into account new options that have been added to MobInfo
-- in the course of developement
-----------------------------------------------------------------------------
 function MI2_InitOptions()
	-- initialize MobInfoConfig
	if not MobInfoConfig or not MobInfoConfig.ShowLoots then
		MobInfoConfig = { }
		MI2_SlashAction_Default()
	end

	-- initial defaults for all config options
	if  not MobInfoConfig.ShowBlankLines	then  MobInfoConfig.ShowBlankLines = 1	end
	if  not MobInfoConfig.LimitTooltipLines	then  MobInfoConfig.LimitTooltipLines = 0	end
	if  not MobInfoConfig.TargetFontSize	then  MobInfoConfig.TargetFontSize = 10	end
	if  not MobInfoConfig.DisableMobInfo	then  MobInfoConfig.DisableMobInfo = 0	end
	if  not MobInfoConfig.ShowDamage	then  MobInfoConfig.ShowDamage = 1		end
	if  not MobInfoConfig.ShowMana		then  MobInfoConfig.ShowMana = 1		end
	if  not MobInfoConfig.ShowEmpty		then  MobInfoConfig.ShowEmpty = 0		end
	if  not MobInfoConfig.CombinedMode	then  MobInfoConfig.CombinedMode = 0	end
	if  not MobInfoConfig.KeypressMode	then  MobInfoConfig.KeypressMode = 0	end
	if  not MobInfoConfig.TargetHealth	then  MobInfoConfig.TargetHealth = 1	end
	if  not MobInfoConfig.TargetMana	then  MobInfoConfig.TargetMana = 1		end
	if  not MobInfoConfig.HealthPercent	then  MobInfoConfig.HealthPercent = 1	end
	if  not MobInfoConfig.ManaPercent	then  MobInfoConfig.ManaPercent = 1		end
	if  not MobInfoConfig.HealthPosX	then  MobInfoConfig.HealthPosX = 0		end
	if  not MobInfoConfig.HealthPosY	then  MobInfoConfig.HealthPosY = 11		end
	if  not MobInfoConfig.ManaPosX		then  MobInfoConfig.ManaPosX = 0		end
	if  not MobInfoConfig.ManaPosY		then  MobInfoConfig.ManaPosY = 11		end
	if  not MobInfoConfig.TargetFont	then  MobInfoConfig.TargetFont = 2		end
	if  not MobInfoConfig.SaveMobHp		then  MobInfoConfig.SaveMobHp = 1		end
	if  not MobInfoConfig.RecordPlayerHp	then  MobInfoConfig.RecordPlayerHp = 1	end
	if  not MobInfoConfig.SavePlayerHp	then  MobInfoConfig.SavePlayerHp = 0	end
	if  not MobInfoConfig.CompactMode	then  MobInfoConfig.CompactMode = 1		end
	if  not MobInfoConfig.ShowItems		then  MobInfoConfig.ShowItems = 1		end
	if  not MobInfoConfig.SaveItems		then  MobInfoConfig.SaveItems = 1		end
	if  not MobInfoConfig.SaveCharData	then  MobInfoConfig.SaveCharData = 1	end
	if  not MobInfoConfig.ItemsQuality	then  MobInfoConfig.ItemsQuality = 2	end
	if  not MobInfoConfig.SaveBasicInfo	then  MobInfoConfig.SaveBasicInfo = 1	end
	if  not MobInfoConfig.ItemTooltip	then  MobInfoConfig.ItemTooltip = 1		end
	if  not MobInfoConfig.ItemFilter	then  MobInfoConfig.ItemFilter = ""		end
	if  not MobInfoConfig.ShowLocation	then  MobInfoConfig.ShowLocation = 1	end
	if  not MobInfoConfig.SaveLocation	then  MobInfoConfig.SaveLocation = 1	end
	if  not MobInfoConfig.ShowClothSkin	then  MobInfoConfig.ShowClothSkin = 1	end
	if  not MobInfoConfig.AbbrevHP		then  MobInfoConfig.AbbrevHP = 0		end
	if  not MobInfoConfig.ShowQuestLoot		then  MobInfoConfig.ShowQuestLoot = 1		end
	if  not MobInfoConfig.ShowQualPoor		then  MobInfoConfig.ShowQualPoor = 1		end
	if  not MobInfoConfig.ShowQualCommon	then  MobInfoConfig.ShowQualCommon = 1	end
	if  not MobInfoConfig.ShowQualUncommon	then  MobInfoConfig.ShowQualUncommon = 1	end
	if  not MobInfoConfig.ShowQualRare		then  MobInfoConfig.ShowQualRare = 1		end
	if  not MobInfoConfig.ShowQualEpic		then  MobInfoConfig.ShowQualEpic = 1		end
	if  not MobInfoConfig.ShowQualLegendary	then  MobInfoConfig.ShowQualLegendary = 1	end
	if  not MobInfoConfig.ImportOnlyNew	then  MobInfoConfig.ImportOnlyNew = 0	end
	if  not MobInfoConfig.SaveResist	then  MobInfoConfig.SaveResist = 1		end
	if  not MobInfoConfig.ShowResists	then  MobInfoConfig.ShowResists = 1		end
	if  not MobInfoConfig.ShowLowHpAction	then  MobInfoConfig.ShowLowHpAction = 1	end
	if  MobInfoConfig.ShowMinimapButton == nil  then  MobInfoConfig.ShowMinimapButton = 1  end

	-- former option "HealthOff" has been renamed to "DisableHealth"
	if  not MobInfoConfig.DisableHealth  then  
		MobInfoConfig.DisableHealth = (MobInfoConfig.HealthOff or 0)
	end

	-- config values that no longer exist
	MobInfoConfig.HealthOff = nil
	MobInfoConfig.ManaDistance = nil
	MobInfoConfig.ShowPercent = nil
	MobInfoConfig.CustomTracks = nil
	MobInfoConfig.SaveAllValues = nil
	MobInfoConfig.MobDbVersion = nil
	MobInfoConfig.MobDbVersion = nil
	MobInfoConfig.ClearOnExit = nil
	MobInfoConfig.SaveGoodItems = nil
	MobInfoConfig.SaveQualityData = nil
	MobInfoConfig.OptStableMax = nil
end

-----------------------------------------------------------------------------
-- Minimap button support
-----------------------------------------------------------------------------

local MI2_MINIMAP_DEFAULT_ANGLE = 220
local MI2_MINIMAP_RADIUS = 80

local function MI2_MinimapButtonGetAngle()
	if MobInfoConfig and MobInfoConfig.minimapButtonAngle then
		return MobInfoConfig.minimapButtonAngle
	end
	return MI2_MINIMAP_DEFAULT_ANGLE
end

local function MI2_MinimapButtonSaveAngle( angle )
	if not MobInfoConfig then MobInfoConfig = {} end
	MobInfoConfig.minimapButtonAngle = angle
end

local function MI2_UpdateMinimapButtonPosition()
	local frame = MI2_MinimapButtonFrame
	if not frame then return end
	local angle = MI2_MinimapButtonGetAngle()
	local rad = math.rad( angle )
	local x = math.cos( rad ) * MI2_MINIMAP_RADIUS
	local y = math.sin( rad ) * MI2_MINIMAP_RADIUS
	frame:ClearAllPoints()
	frame:SetPoint( "CENTER", Minimap, "CENTER", x, y )
end

function MI2_UpdateMinimapButton()
	local frame = MI2_MinimapButtonFrame
	if not frame then return end
	if MobInfoConfig and MobInfoConfig.ShowMinimapButton == 1 then
		frame:Show()
		MI2_UpdateMinimapButtonPosition()
	else
		frame:Hide()
	end
end

function MI2_MinimapButton_OnUpdate()
	local mx, my = Minimap:GetCenter()
	local scale  = Minimap:GetEffectiveScale()
	local cx, cy = GetCursorPosition()
	cx = cx / scale
	cy = cy / scale
	local angle  = math.deg( math.atan2( cy - my, cx - mx ) )
	local frame = MI2_MinimapButtonFrame
	frame:ClearAllPoints()
	frame:SetPoint( "CENTER", Minimap, "CENTER",
		math.cos( math.rad( angle ) ) * MI2_MINIMAP_RADIUS,
		math.sin( math.rad( angle ) ) * MI2_MINIMAP_RADIUS )
	MI2_MinimapButtonSaveAngle( angle )
end

function MI2_MinimapButton_OnMouseDown( button )
	if button == "RightButton" then
		MI2_MinimapButton:SetScript( "OnUpdate", MI2_MinimapButton_OnUpdate )
	end
end

function MI2_MinimapButton_OnMouseUp( button )
	if button == "RightButton" then
		MI2_MinimapButton:SetScript( "OnUpdate", nil )
		MI2_UpdateMinimapButtonPosition()
	elseif button == "LeftButton" then
		if frmMIConfig:IsVisible() then
			frmMIConfig:Hide()
		else
			frmMIConfig:Show()
		end
	end
end

function MI2_MinimapButton_OnEnter()
	GameTooltip:SetOwner( MI2_MinimapButton, "ANCHOR_LEFT" )
	GameTooltip:SetText( "MobInfo2" )
	GameTooltip:AddLine( MI2_TXT_MINIMAP_TIP1, 1, 1, 1 )
	GameTooltip:AddLine( MI2_TXT_MINIMAP_TIP2, 1, 1, 1 )
	GameTooltip:Show()
end

function MI2_MinimapButton_OnLeave()
	GameTooltip:Hide()
end

-----------------------------------------------------------------------------
-- MI2_IndexComponents()
--
-- Return the component parts of a mob index: mob name, mob level
-----------------------------------------------------------------------------
function MI2_GetIndexComponents( mobIndex )
	local a, b, mobName, mobLevel = string.find(mobIndex, "(.+):(.+)$")
	mobLevel = tonumber(mobLevel)
	return mobName, mobLevel
end

-----------------------------------------------------------------------------
-- MI2_UpdateDatabaseToV7()
--
-- Update MobInfo database to version V7. This function can handle most of
-- the old versions and variants.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- MI2_MigrateFromLegacy()
--
-- Single consolidated migration function that handles all upgrades from any
-- pre-3.00 database version (1 through 14) to version 15.
--
-- What it does, in order:
--   1. Rebuild bi field from old separate entries; convert
--		char-specific data from table form to string form; remove
--		invalid entries.
--   2. Migrate old coordinate-format ml entries (x/y//z) to
--		zone-ID-only format.
--   3. Fix MobHealthDB health percent values that clash with the
--		special values 100/200.
--   4. Migrate MobHealthDB entries into MobInfoDB as "mh" fields.
--   5. Clear all stored location (ml) data — area IDs from old
--		versions are unreliable.
--   6. Opportunistic name-ID rekeying using pfQuest's unit DB.
--   7. Re-resolve mob ranks (mobType) from the live API.
--   8. Always: strip any remaining name-keyed entries whose name can be
--				resolved to an ID via pfQuest (catches partial migrations).
-----------------------------------------------------------------------------
MI2_RankMigrationSet   = nil
MI2_RankMigrationTotal = 0
MI2_RankMigrationDone  = 0

-----------------------------------------------------------------------------
-- MI2_ResolvePfQuestNames()
--
-- Resolves any name-keyed DB entries to ID-keyed entries using pfQuest's
-- unit database. Safe to call at any time: skips entries already using a
-- numeric ID key and does nothing if pfQuest is not loaded.
-- Called both during migration AND on every login so that mobs recorded
-- before pfQuest was installed are resolved once pfQuest becomes available.
-----------------------------------------------------------------------------
function MI2_ResolvePfQuestNames()
	if type(pfDB) ~= "table" or type(pfDB["units"]) ~= "table" then return end

	-- check if any name-keyed entries exist at all before doing heavy work
	local hasNameKeys = false
	for mobIndex, mobInfo in pairs(MobInfoDB) do
		if type(mobInfo) == "table" then
			local mobName = MI2_GetIndexComponents(mobIndex)
			if mobName and not tonumber(mobName) then
				hasNameKeys = true
				break
			end
		end
	end
	if not hasNameKeys then return end

	-- build name-ID map from pfQuest
	local nameToIDs = {}
	for locale, unitTable in pairs(pfDB["units"]) do
		if type(unitTable) == "table" then
			for creatureID, unitName in pairs(unitTable) do
				if type(creatureID) == "number" and type(unitName) == "string" then
					local entry = nameToIDs[unitName]
					if entry == nil then nameToIDs[unitName] = creatureID
					elseif entry ~= creatureID then nameToIDs[unitName] = false end
				end
			end
		end
	end

	local toRename = {}
	local renamed, ambiguous, notFound = 0, 0, 0
	for mobIndex, mobInfo in pairs(MobInfoDB) do
		if type(mobInfo) == "table" then
			local mobName, mobLevel = MI2_GetIndexComponents(mobIndex)
			if mobName and mobLevel and not tonumber(mobName) then
				local idResult = nameToIDs[mobName]
				if idResult == false then ambiguous = ambiguous + 1
				elseif type(idResult) == "number" then
					local newKey = idResult..":"..mobLevel
					if newKey ~= mobIndex and not MobInfoDB[newKey] then toRename[mobIndex] = newKey end
				else notFound = notFound + 1 end
			end
		end
	end
	for oldKey, newKey in pairs(toRename) do
		MobInfoDB[newKey] = MobInfoDB[oldKey]
		MobInfoDB[oldKey] = nil
		renamed = renamed + 1
	end
	if renamed > 0 or ambiguous > 0 or notFound > 0 then
		local msg = mifontLightBlue.."<MI2> Database:|r "..string.format(MI_TXT_PFQUEST_RESOLVED, renamed)
		if ambiguous > 0 then msg = msg..string.format(MI_TXT_PFQUEST_AMBIGUOUS, ambiguous) end
		if notFound > 0  then msg = msg..string.format(MI_TXT_PFQUEST_NOTFOUND, notFound) end
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
	-- resolve ranks for any entries that were just rekeyed to IDs
	if renamed > 0 then
		MI2_ResolveRanks()
	end
end

-----------------------------------------------------------------------------
-- MI2_ResolveRanks()
--
-- Resolves mob rank (normal/rare/elite/boss) for all ID-keyed DB entries
-- using C_CreatureInfo. Entries not yet in the creature cache are deferred
-- and resolved via GET_ITEM_INFO_RECEIVED-style polling (MI2_RankMigrationSet).
-- Safe to call at any time; called during migration and on every login after
-- pfQuest name resolution so newly rekeyed entries get their rank set.
-----------------------------------------------------------------------------
function MI2_ResolveRanks()
	if not MobInfoConfig.SaveBasicInfo == 1 then return end
	local deferSet = {}
	local deferCount = 0
	local immediateCount = 0
	for mobIndex, mobInfo in pairs(MobInfoDB) do
		if type(mobInfo) == "table" then
			local mobName = MI2_GetIndexComponents(mobIndex)
			local creatureID = tonumber(mobName)
			if creatureID then
				local info = C_CreatureInfo.GetCreatureInfoByID(creatureID)
				if info then
					local rank = info.rank
					local mobType
					if	   rank == 0 then mobType = 1
					elseif rank == 4 then mobType = 4
					elseif rank == 3 then mobType = 3
					else				  mobType = 2
					end
					local mobData = MI2_FetchMobData(mobIndex)
					mobData.mobType = mobType
					MI2_StoreBasicInfo(mobIndex, mobData)
					immediateCount = immediateCount + 1
				else
					if not deferSet[creatureID] then
						deferSet[creatureID] = true
						deferCount = deferCount + 1
					end
				end
			end
		end
	end
	if deferCount > 0 then
		MI2_RankMigrationSet   = deferSet
		MI2_RankMigrationTotal = deferCount
		MI2_RankMigrationDone  = 0
	end
	local total = immediateCount + deferCount
	if total > 0 then
		if deferCount > 0 then
			DEFAULT_CHAT_FRAME:AddMessage(
				mifontLightBlue.."<MI2> Database:|r "..string.format(MI_TXT_RANK_PENDING, total, deferCount))
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				mifontLightBlue.."<MI2> Database:|r "..string.format(MI_TXT_RANK_COMPLETE, total))
		end
	end
end

local function MI2_MigrateFromLegacy( version, subver )
	-- Run all migration steps when upgrading from any version before 15.
	-- All checks against sub-versions lower than 15 are collapsed here.
	if version < 15 then

	-- 1. Rebuild bi and normalise char data
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			if (mobInfo.lt or mobInfo.el or mobInfo.cp or mobInfo.iv or mobInfo.cc) and not mobInfo.bi then
				if mobInfo.lt and mobInfo.lt <= 0 then mobInfo.lt = nil end
				if mobInfo.cp and mobInfo.cp <= 0 then mobInfo.cp = nil end
				if mobInfo.iv and mobInfo.iv <= 0 then mobInfo.iv = nil end
				if mobInfo.el and mobInfo.el <= 0 then mobInfo.el = nil end
				if mobInfo.cc and mobInfo.cc <= 0 then mobInfo.cc = nil end
				mobInfo.bi = (mobInfo.lt or "").."/"..(mobInfo.el or "").."/"..(mobInfo.cp or "").."/"..(mobInfo.iv or "").."/"..(mobInfo.cc or "").."//"..(mobInfo.mt or "").."/"
			end
			local s, slashCount = string.gsub( (mobInfo.bi or ""), "/", "@" )
			if slashCount == 6 then mobInfo.bi = mobInfo.bi.."/"; slashCount = slashCount + 1 end
			if mobInfo.bi == "////////" then mobInfo.bi = nil end
			if mobInfo.bi and slashCount ~= 7 then mobInfo.bi = nil end
			-- Strip the empty slot 6 (old xp placeholder) from 8-slash entries,
			-- collapsing to the new 7-slash format: lt/el/cp/iv/cc/mt/sc
			if mobInfo.bi and slashCount == 7 then
				mobInfo.bi = string.gsub( mobInfo.bi, "^(.-/.-/.-/.-/.-)//(.-)$", "%1/%2" )
				s, slashCount = string.gsub( mobInfo.bi, "/", "@" )
			end
			if mobInfo.bi == "//////" then mobInfo.bi = nil end
			if mobInfo.bi and slashCount ~= 6 then mobInfo.bi = nil end
			
			mobInfo.qi = nil

			for entryName, entryData in pairs(mobInfo) do
				if type(entryData) == "table" then
					local dl = entryData.dl
					local du = entryData.du
					local dd = entryData.dd
					if (dl or du) and not dd then dd = dl.."/"..du.."/"..0 end
					mobInfo[entryName] = (entryData.kl or "").."/"..(dd or "").."/"..(mobInfo.xp or "")
				else
					local isCharEntry = (type(entryData) == "string") and (string.find(entryName,":") ~= nil or MI2_CharTable[entryName]) and string.find(entryData,"/") ~= nil
					isCharEntry = isCharEntry or type(entryData) == "string"
					if isCharEntry then
						if mobInfo[entryName] == "///" then mobInfo[entryName] = nil end
					elseif entryName ~= "bi" and entryName ~= "il" and entryName ~= "ml" and entryName ~= "mh" and entryName ~= "re" then
						mobInfo[entryName] = nil
					end
				end
			end
		end
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			local entryCount = 0
			for entryName, entryData in pairs(mobInfo) do
				entryCount = entryCount + 1
				local isCharEntry = (type(entryData) == "string") and string.find(entryName,":") ~= nil and string.find(entryData,"/") ~= nil
				if isCharEntry then
					if not MI2_CharTable[entryName] then
						MI2_CharTable.charCount = MI2_CharTable.charCount + 1
						MI2_CharTable[entryName] = "c"..MI2_CharTable.charCount
					end
					mobInfo[MI2_CharTable[entryName]] = entryData
					mobInfo[entryName] = nil
				end
			end
			if entryCount == 0 then MobInfoDB[mobIndex] = nil end
		end

	-- 2. Migrate old coordinate ml format to zone-ID only
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			if mobInfo.ml then
				local slashCount = 0
				for _ in string.gmatch(mobInfo.ml, "/") do slashCount = slashCount + 1 end
				if slashCount >= 4 then
					local z = tonumber(string.match(mobInfo.ml, "(%d+)%s*$"))
					if z and z >= 100 then mobInfo.ml = tostring(z) else mobInfo.ml = nil end
				end
			end
		end

	-- 3. Fix MobHealthDB percent values clashing with 100/200
		for idx, hpData in pairs(MobHealthDB) do
			if type(hpData) == "string" then
				local _,_, pts, pct = string.find(hpData, "^(%d+)/(%d+)$")
				pts = tonumber(pts); pct = tonumber(pct)
				if not pct or not pts or pct <= 0 or pts <= 0 then
					MobHealthDB[idx] = nil
				else
					MobHealthDB[idx] = floor((pts/pct)*75.0).."/".."75"
				end
			else
				MobHealthDB[idx] = nil
			end
		end

	-- 4. Migrate MobHealthDB into MobInfoDB as "mh" fields
		local nameIndex = {}
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			if type(mobInfo) == "table" then
				local mobName, mobLevel = MI2_GetIndexComponents(mobIndex)
				if mobName and mobLevel then nameIndex[mobName..":"..mobLevel] = mobIndex end
			end
		end
		for nameKey, hpData in pairs(MobHealthDB) do
			local mobIndex = nameIndex[nameKey]
			if mobIndex and MobInfoDB[mobIndex] and not MobInfoDB[mobIndex].mh then
				MobInfoDB[mobIndex].mh = hpData
			end
		end
		MobHealthDB = nil

	-- 5. Clear all location data (area IDs unreliable)
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			if type(mobInfo) == "table" then mobInfo.ml = nil end
		end

	-- 6. Rekeying name-ID via pfQuest
		-- (handled unconditionally by MI2_CleanupDatabases after migration)

	-- 7. Re-resolve mob ranks from live API
		-- (handled unconditionally by MI2_CleanupDatabases after migration)

	-- 8. Wipe player health DB (name-keyed entries are now
		-- irrelevant since the addon switched to GUID-based player tracking)
		MobHealthPlayerDB = {}
	end
end

function MI2_CleanupDatabases()
	local mobIndex, mobInfo
	local dbVerInfo = MobInfoDB["DatabaseVersion:0"] or { ver=0 }
	local version = dbVerInfo.ver
	local subver  = dbVerInfo.sv or 0

	MI2_InitializeAllMobData()

	MobInfoDB["DatabaseVersion:0"] = nil
	MobInfoDB.DatabaseVersion = nil

	-- delete DB entries with buggy index
	for mobIndex in pairs(MobInfoDB) do
		local mobName, mobLevel = MI2_GetIndexComponents( mobIndex )
		if not mobName or not mobLevel or mobName == "" then
			MobInfoDB[mobIndex] = nil
		end
	end

	-- run consolidated legacy migration if needed
	if version < MI2_DB_VERSION then
		MI2_MigrateFromLegacy( version, subver )
	end

	-- always attempt pfQuest name-ID resolution on login in case pfQuest was
	-- installed after a previous migration left name-keyed entries in the DB.
	-- MI2_ResolveRanks is called from within MI2_ResolvePfQuestNames when
	-- entries are actually rekeyed, so no separate call is needed here.
	MI2_ResolvePfQuestNames()

	MobInfoDB["DatabaseVersion:0"] = { ver = MI2_DB_VERSION, sv=MI2_DB_SV }
end

-----------------------------------------------------------------------------
-- MI2_PrepareForImport()
--
-- Prepare for importing external MobInfo databases into the main database.
-----------------------------------------------------------------------------
function MI2_PrepareForImport()
	local mobDbSize, healthDbSize, itemDbSize = 0, 0, 0

	if not MobInfoDB then return end

	--	external database version number check
	local version = MobInfoDB["DatabaseVersion:0"].ver
	if version and (version < MI2_IMPORT_DB_VERSION or version > MI2_DB_VERSION) then
		MI2_Import_Status = "BADVER"
		return
	end

	-- calculate Mob database size and import signature
	local levelSum, nameSum = 0, 0
	for index in pairs(MobInfoDB) do
		mobDbSize = mobDbSize + 1
		local mobName, mobLevel = MI2_GetIndexComponents( index )
		levelSum = levelSum + mobLevel
		nameSum = nameSum + string.len( mobName )
	end
	for _, mobInfo in pairs(MobInfoDB) do
		if type(mobInfo) == "table" and mobInfo.mh then
			healthDbSize = healthDbSize + 1
		end
	end
	MI2_Import_Signature = mobDbSize.."_"..healthDbSize.."_"..itemDbSize.."_"..levelSum.."_"..nameSum

	-- update the health database to be imported
	if version  < 9 then
		MI2_UpdateDatabaseV8ToV9()
	end

	-- store copy of databases to be imported and calculate import status
	MobInfoDB["DatabaseVersion:0"] = nil
	MobInfoDB_Import = MobInfoDB
	if mobDbSize > 1 then
		MI2_Import_Status = "[V"..version.."] "..(mobDbSize-1).." Mobs"
	end
	if healthDbSize > 0 then
		if MI2_Import_Status then
			MI2_Import_Status = MI2_Import_Status.." & "
		end
		MI2_Import_Status = (MI2_Import_Status or "")..healthDbSize.." HP values"
	end
end

-----------------------------------------------------------------------------
-- MI2_SetNewZone()
--
-- Set a new zone as the MI2 current zone. Add the zone to the MI2 zone
-- name table if zone is unknown.
-----------------------------------------------------------------------------
function MI2_SetNewZone()
	-- use ClassicAPI to get the real AreaTable area ID for the player's zone
	MI2_CurZone = C_Map.GetBestMapForUnit("player") or 0
end

-----------------------------------------------------------------------------
-- MI2_AddItemToXRefTable()
--
-- update the cross reference table for fast item lookup
-- The table is indexed by item name and lists all Mobs that drop the item
-----------------------------------------------------------------------------
function MI2_AddItemToXRefTable( mobIndex, itemName, itemAmount )
	if not MI2_XRefItemTable[itemName] then
		MI2_XRefItemTable[itemName] = {}
	end

	local oldAmount = MI2_XRefItemTable[itemName][mobIndex]
	MI2_XRefItemTable[itemName][mobIndex] = (oldAmount or 0) + itemAmount
end

-----------------------------------------------------------------------------
-- MI2_BuildXRefItemTable()
--
-- build the cross reference table for fast item lookup
-- The table is indexed by item name and lists all Mobs that drop the item.
-- It is needed for quickly generating the "Dropped By" list in item tooltips.
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- MI2_PreloadCreatureNames()
--
-- Queues RequestLoadCreatureByID for every mob ID in MobInfoDB whose name
-- is not yet in the client cache. Uses a sliding window of concurrent
-- requests (MI2_CREATURE_WINDOW) to avoid overflowing the pending set.
-- Each CREATURE_DATA_LOAD_RESULT response triggers MI2_CreaturePreload_Next
-- to send the next request, keeping the pipeline filled safely.
-----------------------------------------------------------------------------
MI2_CreaturePreloadQueue   = nil
MI2_CreaturePreloadPending = 0
local MI2_CREATURE_WINDOW  = 32

function MI2_CreaturePreload_Next()
	if not MI2_CreaturePreloadQueue then return end
	while MI2_CreaturePreloadPending < MI2_CREATURE_WINDOW
			and table.getn(MI2_CreaturePreloadQueue) > 0 do
		local cid = MI2_CreaturePreloadQueue[table.getn(MI2_CreaturePreloadQueue)]
		-- skip if already cached by the time we get to it
		if C_CreatureInfo.GetCreatureInfoByID(cid) then
			MI2_CreaturePreloadQueue[table.getn(MI2_CreaturePreloadQueue)] = nil
		else
			MI2_CreaturePreloadPending = MI2_CreaturePreloadPending + 1
			local ok = C_CreatureInfo.RequestLoadCreatureByID(cid)
			MI2_CreaturePreloadQueue[table.getn(MI2_CreaturePreloadQueue)] = nil
			if not ok then
				-- pending set full; put it back and stop until a slot frees
				MI2_CreaturePreloadPending = MI2_CreaturePreloadPending - 1
				MI2_CreaturePreloadQueue[table.getn(MI2_CreaturePreloadQueue) + 1] = cid
				break
			end
		end
	end
	if table.getn(MI2_CreaturePreloadQueue) == 0 then
		MI2_CreaturePreloadQueue = nil
	end
end

function MI2_PreloadCreatureNames()
	local seen = {}
	local queue = {}
	for mobIndex in pairs(MobInfoDB) do
		local idStr = string.match(mobIndex, "^(%d+):")
		if idStr then
			local cid = tonumber(idStr)
			if cid and not seen[cid] and not C_CreatureInfo.GetCreatureInfoByID(cid) then
				seen[cid] = true
				queue[table.getn(queue) + 1] = cid
			end
		end
	end
	if table.getn(queue) == 0 then return end
	MI2_CreaturePreloadQueue   = queue
	MI2_CreaturePreloadPending = 0
	MI2_CreaturePreload_Next()
end

function MI2_BuildXRefItemTable()
	local mobIndex, mobInfo

	MI2_XRefItemTable = {}
	MI2_PendingItemIDs = {}  -- itemID -> { [mobIndex] = amount } for uncached items
	for mobIndex, mobInfo in pairs(MobInfoDB) do
		local mobData = {}
		MI2_DecodeItemList( mobInfo, mobData )
		if mobData.itemList then
			for itemID, amount in pairs(mobData.itemList) do
				local itemText = C_Item.GetItemNameByID(itemID)
				if itemText then
					MI2_AddItemToXRefTable( mobIndex, itemText, amount )
				else
					-- item not in cache: track it for when ITEM_DATA_LOAD_RESULT fires
					if not MI2_PendingItemIDs[itemID] then
						MI2_PendingItemIDs[itemID] = {}
					end
					MI2_PendingItemIDs[itemID][mobIndex] = amount
				end
			end
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_PreloadItems()
--
-- Warms the client item cache for every uncached item ID in MobInfoDB by
-- calling SetHyperlink on a hidden GameTooltip frame, one item per OnUpdate
-- frame - exactly the technique aux uses in populate_wdb. No interval timer:
-- one call per frame gives maximum throughput without stalling the client.
-- GET_ITEM_INFO_RECEIVED fires for each item and MI2_EventItemInfoReceived
-- populates the XRef table.
-----------------------------------------------------------------------------
function MI2_PreloadItems()
	if not MI2_PendingItemIDs then return end

	local queue = {}
	for itemID in pairs(MI2_PendingItemIDs) do
		if not C_Item.IsItemDataCachedByID(itemID) then
			queue[table.getn(queue) + 1] = itemID
		end
	end

	if table.getn(queue) == 0 then return end

	local idx = 1
	MI2_ItemCacheTooltip:SetOwner(UIParent, "ANCHOR_NONE")

	local preloadFrame = CreateFrame("Frame")
	preloadFrame:SetScript("OnUpdate", function()
		if idx > table.getn(queue) then
			preloadFrame:SetScript("OnUpdate", nil)
			-- queue drained: sweep PendingItemIDs and populate XRef for
			-- everything now cached, regardless of whether GET_ITEM_INFO_RECEIVED
			-- fired (SetHyperlink may not fire that event for all items)
			for itemID, pending in pairs(MI2_PendingItemIDs) do
				local itemText = C_Item.GetItemNameByID(itemID)
				if itemText then
					for mobIndex, amount in pairs(pending) do
						MI2_AddItemToXRefTable(mobIndex, itemText, amount)
					end
					MI2_PendingItemIDs[itemID] = nil
				end
			end
			return
		end
		-- one item per frame: same as aux populate_wdb
		if not C_Item.IsItemDataCachedByID(queue[idx]) then
			MI2_ItemCacheTooltip:SetHyperlink("item:" .. queue[idx])
		end
		idx = idx + 1
	end)
end

-----------------------------------------------------------------------------
-- MI2_CombineLocations()
--
-- Combine the zone sets of a given Mob with a second (new) location.
-- At most MI2_MAX_LOCATIONS distinct zone IDs are kept per mob.
-----------------------------------------------------------------------------
MI2_MAX_LOCATIONS = 4

local function MI2_CombineLocations( mobData, loc2, correctWrongZone )
	if not loc2 or not loc2.zones then return end
	if not mobData.location or not mobData.location.zones then
		mobData.location = { zones = {} }
	end
	local zones = mobData.location.zones
	-- count existing zones
	local count = 0
	for _ in pairs(zones) do count = count + 1 end
	-- add new zones up to the cap
	for id in pairs(loc2.zones) do
		if zones[id] then
			-- already recorded, no slot consumed
		elseif count < MI2_MAX_LOCATIONS then
			zones[id] = true
			count = count + 1
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordLocationAndType()
--
-- Record the current player location as the Mob location, record the type
-- of the mob (normal, elite, boss). This function is intended to be called
-- when targetting a Mob.
-----------------------------------------------------------------------------
function MI2_RecordLocationAndType( mobIndex )
	if MI2_MouseoverIndex == mobIndex then return end

	-- skip transient NPC summons whose creature ID has no permanent template
	local idStr = string.match(mobIndex, "^(%d+):")
	if idStr and not C_CreatureInfo.GetCreatureInfoByID( tonumber(idStr) ) then return end

	local mobData = MI2_FetchMobData( mobIndex )

	if MobInfoConfig.SaveLocation == 1 then
		if MI2_CurZone and MI2_CurZone ~= 0 then
			local newLocation = { zones = { [MI2_CurZone] = true } }
			MI2_CombineLocations( mobData, newLocation, true )
			MI2_StoreLocation( mobIndex, mobData.location )
		end
	end

	if MobInfoConfig.SaveBasicInfo == 1 then
		-- extract creatureID from this mob's index (not from MI2_Target which may be a different mob)
		local idStr = string.match(mobIndex, "^(%d+):")
		if idStr then
			local cid = tonumber(idStr)
			local info = C_CreatureInfo.GetCreatureInfoByID( cid )
			if info then
				local rank = info.rank
				if rank == 0 then
					mobData.mobType = 1		  -- normal
				elseif rank == 4 then
					mobData.mobType = 4		  -- rare
				elseif rank == 3 then
					mobData.mobType = 3		  -- worldboss
				else
					mobData.mobType = 2		  -- elite (rank 1, 2=rareelite)
				end
				MI2_StoreBasicInfo( mobIndex, mobData )
			end
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordLowHpAction()
--
-- Record for a Mob the special action that it performes when low on health.
-- E.g. run away
-----------------------------------------------------------------------------
function MI2_RecordLowHpAction( creature, action )
	if MobInfoConfig.SaveBasicInfo == 1 and MI2_Target.mobIndex and MI2_Target.name == creature then
		local mobData = MI2_FetchMobData( MI2_Target.mobIndex )
		mobData.lowHpAction = action
		MI2_StoreBasicInfo( MI2_Target.mobIndex, mobData )
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordKill()
--
-- record data related to a mob kill
-- attempt to find correct mob DB index based on situation and killed mobs
-- name (kill msg gives only name, not level)
-----------------------------------------------------------------------------
function MI2_RecordKill( creatureName, xp )
	-- try to find DB index for mob that was killed
	local mobIndex
	if MI2_Target.name == creatureName then
		mobIndex = MI2_Target.mobIndex
	elseif MI2_LastTargetIdx then
		local lastID, _ = MI2_GetIndexComponents( MI2_LastTargetIdx )
		local lastName = MI2_GetMobName( tonumber(lastID) ) or ("#"..lastID)
		if string.find(lastName, creatureName) then
			mobIndex = MI2_LastTargetIdx
		end
	end
	if not mobIndex then
		for i=1,MI2_CACHE_SIZE do
			local idx = MI2_MobCache[i]
			if idx then
				local cacheID, _ = MI2_GetIndexComponents( idx )
				local cacheName = MI2_GetMobName( tonumber(cacheID) ) or ("#"..cacheID)
				if string.find(cacheName, creatureName) then
					mobIndex = idx
					break
				end
			end
		end
	end

	if MobInfoConfig.SaveCharData == 1 and mobIndex then
		local mobData = MI2_FetchMobData( mobIndex )
		
		-- Only record kill if not already recorded for this mob
		if not mobData.killed then
			if xp then
				mobData.xp = xp
			end
			mobData.kills = (mobData.kills or 0) + 1
			mobData.killed = 1
			MI2_StoreCharData( mobIndex, mobData, MI2_PlayerName )
		elseif xp and not mobData.xp then
			-- If kill already recorded but we got XP info, update XP only
			mobData.xp = xp
			MI2_StoreCharData( mobIndex, mobData, MI2_PlayerName )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordDamage()
--
-- record min/max damage value for mob
-----------------------------------------------------------------------------
function MI2_RecordDamage( mobIndex, damage )
	if damage > 0 then
		local mobData = MI2_FetchMobData( mobIndex )
		if not mobData.minDamage or mobData.minDamage <= 0 then
			mobData.minDamage, mobData.maxDamage = damage, damage
		elseif damage < mobData.minDamage then
			mobData.minDamage = damage
		elseif damage > mobData.maxDamage then
			mobData.maxDamage = damage
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordDps()
--
-- record a new dps (damage per second) value for a specific mob
-- dps gets calculated from damage done within a given time
-----------------------------------------------------------------------------
function MI2_RecordDps( mobIndex, deltaTime, damage  )
	-- only store dps for fights longer then 4 seconds
	if MobInfoConfig.SaveCharData == 1 and deltaTime > 4 then
		local mobData = MI2_FetchMobData( mobIndex )
		local newDps = damage / deltaTime
		if not mobData.dps then mobData.dps = newDps end
		mobData.dps = floor( ((2.0 * mobData.dps) + newDps) / 3.0 )
		MI2_StoreCharData( mobIndex, mobData, MI2_PlayerName )
	end
end

-----------------------------------------------------------------------------
-- MI2_AddTwoMobs()
--
-- add the data for two mobs,
-- the data of the second mob (mobData2) is added to the data of the first
-- mob (mobData1). The result is returned in "mobData1".
-----------------------------------------------------------------------------
function MI2_AddTwoMobs( mobData1, mobData2 )
	-- add up basic mob data
	mobData1.loots = (mobData1.loots or 0) + (mobData2.loots or 0)
	mobData1.kills = (mobData1.kills or 0) + (mobData2.kills or 0)
	mobData1.emptyLoots = (mobData1.emptyLoots or 0) + (mobData2.emptyLoots or 0)
	mobData1.clothCount = (mobData1.clothCount or 0) + (mobData2.clothCount or 0)
	mobData1.copper = (mobData1.copper or 0) + (mobData2.copper or 0)
	mobData1.itemValue = (mobData1.itemValue or 0) + (mobData2.itemValue or 0)
	mobData1.skinCount = (mobData1.skinCount or 0) + (mobData2.skinCount or 0)
	mobData1.r1 = (mobData1.r1 or 0) + (mobData2.r1 or 0)
	mobData1.r2 = (mobData1.r2 or 0) + (mobData2.r2 or 0)
	mobData1.r3 = (mobData1.r3 or 0) + (mobData2.r3 or 0)
	mobData1.r4 = (mobData1.r4 or 0) + (mobData2.r4 or 0)
	mobData1.r5 = (mobData1.r5 or 0) + (mobData2.r5 or 0)
	mobData1.r6 = (mobData1.r6 or 0) + (mobData2.r6 or 0)
	if mobData2.mobType then mobData1.mobType = mobData2.mobType end
	if not mobData1.xp then mobData1.xp = mobData2.xp end
	if not mobData1.lowHpAction then mobData1.lowHpAction = mobData2.lowHpAction end

	MI2_CombineLocations( mobData1, mobData2.location )

	-- combine DPS
	if not mobData1.dps then
		mobData1.dps = mobData2.dps
	else
		if mobData2.dps then
			mobData1.dps = floor( ((2.0 * mobData1.dps) + mobData2.dps) / 3.0 )
		end
	end

	-- combine resist data
	local resdat1 = mobData1.resists or {}
	local resdat2 = mobData2.resists or {}
	resdat1.ar	= (resdat1.ar or 0) + (resdat2.ar or 0)
	resdat1.fi	= (resdat1.fi or 0) + (resdat2.fi or 0)
	resdat1.fr	= (resdat1.fr or 0) + (resdat2.fr or 0)
	resdat1.ho	= (resdat1.ho or 0) + (resdat2.ho or 0)
	resdat1.na	= (resdat1.na or 0) + (resdat2.na or 0)
	resdat1.sh	= (resdat1.sh or 0) + (resdat2.sh or 0)
	resdat1.arHits	= (resdat1.arHits or 0) + (resdat2.arHits or 0)
	resdat1.fiHits	= (resdat1.fiHits or 0) + (resdat2.fiHits or 0)
	resdat1.frHits	= (resdat1.frHits or 0) + (resdat2.frHits or 0)
	resdat1.hoHits	= (resdat1.hoHits or 0) + (resdat2.hoHits or 0)
	resdat1.naHits	= (resdat1.naHits or 0) + (resdat2.naHits or 0)
	resdat1.shHits	= (resdat1.shHits or 0) + (resdat2.shHits or 0)
	mobData1.resists = resdat1

	-- combine minimum and maximum damage	
	if (mobData2.minDamage or 99999) < (mobData1.minDamage or 99999) then
		mobData1.minDamage = mobData2.minDamage
	end
	if (mobData2.maxDamage or 0) > (mobData1.maxDamage or 0) then
		mobData1.maxDamage = mobData2.maxDamage
	end
	
	-- add loot item tables
	if mobData2.itemList then
		if not mobData1.itemList then mobData1.itemList = {} end
		for itemID, amount in pairs(mobData2.itemList) do
			mobData1.itemList[itemID] = (mobData1.itemList[itemID] or 0) + mobData2.itemList[itemID]
		end
	end

	if mobData1.loots == 0 then mobData1.loots = nil end
	if mobData1.kills == 0 then mobData1.kills = nil end
	if mobData1.emptyLoots == 0 then mobData1.emptyLoots = nil end
	if mobData1.clothCount == 0 then mobData1.clothCount = nil end
	if mobData1.copper == 0 then mobData1.copper = nil end
	if mobData1.itemValue == 0 then mobData1.itemValue = nil end
	if mobData1.skinCount == 0 then mobData1.skinCount = nil end
	if mobData1.dps == 0 then mobData1.dps = nil end
	if mobData1.r1 == 0 then mobData1.r1 = nil end
	if mobData1.r2 == 0 then mobData1.r2 = nil end
	if mobData1.r3 == 0 then mobData1.r3 = nil end
	if mobData1.r4 == 0 then mobData1.r4 = nil end
	if mobData1.r5 == 0 then mobData1.r5 = nil end
	if mobData1.r6 == 0 then mobData1.r6 = nil end
end

-----------------------------------------------------------------------------
-- MI2_GetMobHealthStr()
--
-- Returns the mobhealth in the form of xx/xx from the mobdb formed by
-- MobHealth mod Pulled from Telo's MobHealth
-----------------------------------------------------------------------------
local function MI2_GetMobHealthStr( index, healthPercent )
	local ppp = MobHealth_PPP( index )
	if ppp > 0 and healthPercent then
		return string.format("%d / %d", (healthPercent * ppp) + 0.5, (100 * ppp) + 0.5)
	end
end

-----------------------------------------------------------------------------
-- copper2text()
--
-- Turns a full copper amount to a readable string, eg. 10340 = 1g 3s 40c
-----------------------------------------------------------------------------
function copper2text(copper)
	local g,s,c
		
	g = floor(copper / COPPER_PER_GOLD)
	s = floor(copper / COPPER_PER_SILVER) - g * SILVER_PER_GOLD
	c = copper - g * COPPER_PER_GOLD - s * COPPER_PER_SILVER

	if g > 0 then  
  		return mifontWhite..g..mifontYellow..'g '..mifontWhite..s ..mifontSubWhite..'s '..mifontWhite..c..mifontGold..'c'
	end  

	if s > 0 then  
  		return mifontWhite..s ..mifontSubWhite..'s '..mifontWhite..c..mifontGold..'c'
	end  

	return mifontWhite..c..mifontGold..'c'
end

-----------------------------------------------------------------------------
-- lootName2Copper()
--
-- Turns a lootname like 1 Gold 3 Silver 40 Copper to total copper 10340
-----------------------------------------------------------------------------
function lootName2Copper(item)
	local i = 0
	local g,s,c = 0
	local money = 0
	  
	i = string.find(item, MI_TXT_GOLD )
	if i then
		g = tonumber( string.sub(item,0,i-1) )
		item = string.sub(item,i+5,string.len(item))
		money = money + ((g or 0) * COPPER_PER_GOLD)
	end
	i = string.find(item, MI_TXT_SILVER )
	if i then
		s = tonumber( string.sub(item,0,i-1) )
		item = string.sub(item,i+7,string.len(item))
		money = money + ((s or 0) * COPPER_PER_SILVER)
	end
	i = string.find(item, MI_TXT_COPPER )
	if i then
		c = tonumber( string.sub(item,0,i-1) )
		money = money + (c or 0)
	end

	return money
end

-----------------------------------------------------------------------------
-- MI2_FindItemValue()
--
-- Find the item value in either the Auctioneer database or in out own copy
-- of the Auctioneer item value database or by asking KC_Items
-----------------------------------------------------------------------------
function MI2_FindItemValue( itemID )
	-- use ClassicAPI to get vendor sell price directly from item cache
	local _,_,_,_,_,_,_,_,_,_, sellPrice = C_Item.GetItemInfo( itemID )
	return sellPrice or 0
end

-----------------------------------------------------------------------------
-- MI2_ComputeItemValue()
--
-- Compute total item sell value from itemList at display time.
-- C_Item.GetItemInfo is reliable here since items are already cached.
-- Returns nil if no item list or no sell value.
-----------------------------------------------------------------------------
function MI2_ComputeItemValue( mobData, mobIndex )
	local mobInfo = MobInfoDB[mobIndex or ""]
	if not mobData.itemList and mobInfo then
		MI2_DecodeItemList( mobInfo, mobData )
	end
	if not mobData.itemList then return nil end
	local total = 0
	for itemID, amount in pairs(mobData.itemList) do
		local _,_,_,_,_,_,_,_,_,_, sellPrice = C_Item.GetItemInfo( itemID )
		if sellPrice and sellPrice > 0 then
			total = total + sellPrice * amount
		end
	end
	return total > 0 and total or nil
end

-----------------------------------------------------------------------------
-- GetLootId()
--
-- get loot ID code for given loot slot number, also return link object
-----------------------------------------------------------------------------
local function GetLootId( slot )
	local itemId = 0
	local link = GetLootSlotLink( slot )

	if link then
		local _, _, idCode = string.find(link, "|Hitem:(%d+):(%d+):(%d+):")
		itemId = tonumber( idCode or 0 )
	end

	return itemId
end

-----------------------------------------------------------------------------
-- MI2_RecordLootSlotData()
--
-- Record the data for one loot item. This function is called in turn for
-- each loot item in the loot window.
-- Retiurns 2 values : isSkinningItem, isClamMeat
-----------------------------------------------------------------------------
local function MI2_RecordLootSlotData( mobIndex, mobData, slotID )
	local skinningLoot = false

	-- obtain loot slot data from WoW
	-- abort loot processing upon finding clam meat (ie. a clam was opened)
	local texture, itemName, quantity, quality = GetLootSlotInfo( slotID )
	if string.find(itemName, MI_TXT_CLAM_MEAT) ~= nil then  return false,true  end
	local itemID = GetLootId( slotID )

	-- identify and count money loot, make sure it does not get counted as an item
	if LootSlotIsCoin(slotID) then
		local money = lootName2Copper(itemName)
		mobData.copper = (mobData.copper or 0) + money
		return false,false
	end

	-- GetLootSlotInfo returns quality as 0-based (0=Poor) but can return nil
	-- when the item is not yet in the client cache. C_Item.GetItemInfo also
	-- returns 0-based quality (field 3) and is the authoritative source.
	-- If both are nil the item is not yet cached; skip quality tracking entirely
	-- rather than misrecording it as grey (nil+1 silently becomes 1 in Lua 5.0).
	local itemQuality = nil
	if itemID and itemID > 0 then
		local _, _, iq = C_Item.GetItemInfo( itemID )
		if iq ~= nil then
			itemQuality = iq + 1   -- convert 0-based WoW quality to 1-based r1..r6
		elseif quality ~= nil then
			itemQuality = quality + 1  -- GetLootSlotInfo quality, also 0-based
		end
		-- if both nil: item not cached yet, leave itemQuality nil and skip tracking
	end

	-- record item data within Mob database and update cross reference table
	if MobInfoConfig.SaveItems == 1 and itemQuality and itemQuality >= MobInfoConfig.ItemsQuality then
		if not mobData.itemList then mobData.itemList = {} end
		mobData.itemList[itemID] = (mobData.itemList[itemID] or 0) + quantity
		-- use base item name (no random suffix) so XRef lookup works regardless
		-- of which suffix variant was looted
		local baseName = C_Item.GetItemNameByID(itemID) or itemName
		MI2_AddItemToXRefTable( mobIndex, baseName, quantity )
	end

	-- exit right here if this is a skinning loot window
	if slotID == 1 and miSkinLoot[itemID] then  return true,false  end

	if LootSlotIsItem(slotID) then
		-- use classID 12 to reliably detect quest items
		local _,_,_,_,_, classID = C_Item.GetItemInfoInstant( itemID )
		if classID == 12 then
			-- quest items: exclude from quality tracking and item value
			return false, false
		end
	-- item value is computed lazily at display time from itemList once
	-- C_Item.GetItemInfo is reliably cached; recording it here risks getting
	-- sellPrice=nil for uncached items and permanently storing 0.
	end

	-- cloth detection is handled at the loot-event level in MI2_RecordAllLootItems
	-- to ensure clothCount increments once per loot, not once per cloth slot
	local isCloth = (itemID and miClothLoot[itemID] ~= nil)

	-- quality overview is now computed dynamically from itemList in
	-- MI2_BuildQualityString; no separate r1-r6 tracking needed

	return false, false, isCloth
end

-----------------------------------------------------------------------------
-- MI2_RecordAllLootItems()
--
-- Record the data for all items found in the currently open loot window.
-- Return to the caller whether this loot window represents real mob loot
-- or not. Examples for "not" are: skinning, clam loot
-----------------------------------------------------------------------------
function MI2_RecordAllLootItems( mobIndex, numItems )
	local skinningLoot = false
	local clothThisLoot = false
	local mobData = MI2_FetchMobData( mobIndex )

	-- iterate through all loot slots and record data for each item
	for slotID = 1, numItems, 1 do
		local skin, clam, isCloth = MI2_RecordLootSlotData( mobIndex, mobData, slotID )
		if clam then return end
		skinningLoot = skinningLoot or skin
		if isCloth then clothThisLoot = true end
	end -- for loop

	if skinningLoot then
		mobData.skinCount = (mobData.skinCount or 0) + 1
	else
		-- update loot and empty loot counter
		mobData.loots = (mobData.loots or 0) + 1
		if numItems < 1 then
			mobData.emptyLoots = (mobData.emptyLoots or 0) + 1
		end
		-- increment cloth count once per loot event, not once per cloth slot
		if clothThisLoot then
			mobData.clothCount = (mobData.clothCount or 0) + 1
		end
	end

	if MobInfoConfig.SaveBasicInfo == 1 then
		MI2_StoreBasicInfo( mobIndex, mobData )
	end
	if MobInfoConfig.SaveItems == 1 then
		MI2_StoreLootItems( mobIndex, mobData )
	end
end

-----------------------------------------------------------------------------
-- MI2_GetCorpseId()
--
-- create a (hopefully) unique corpse ID out of the loot items found in 
-- the corpse loot window, return nil if loot is empty
-- WoW Bug: GetNumLootItems() includes emptied loot window slots
-----------------------------------------------------------------------------
function MI2_GetCorpseId( index )
	local corpseId
	local numItems = 0 
	local numSlots = GetNumLootItems()

	if index and numSlots > 0 then
		corpseId = index..(UnitGUID("target") or "")
		for slot = 1, numSlots do
			local texture, item = GetLootSlotInfo( slot )
			if item ~= "" then corpseId = corpseId..item end
		end
	end

	return corpseId
end

-----------------------------------------------------------------------------
-- MI2_StoreCorpseId()
--
-- enter given corpse ID into list of all corpse IDs
-- a list of corpse IDs is maintained to allow detecting corpse reopening
-----------------------------------------------------------------------------
function MI2_StoreCorpseId( corpseId, isNewCorpse )
	-- store a new corpse ID
	if isNewCorpse then
		MI2_NewCorpseIdx = MI2_NewCorpseIdx + 1
		if MI2_NewCorpseIdx > 10 then
			MI2_NewCorpseIdx = 1
		end
		MI2_CurrentCorpseIndex = MI2_NewCorpseIdx
	end

	if MI2_CurrentCorpseIndex then
		MI2_RecentLoots[MI2_CurrentCorpseIndex] = corpseId
		if not corpseId then
			MI2_CurrentCorpseIndex = nil
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_CheckForCorpseReopen()
--
-- Check if the corpse for the given mob index is being reopened.
-- This is done by calculating a (hopefully) unique corpse ID and adding
-- it to the list if it is a new corpse ID. 
-----------------------------------------------------------------------------
function MI2_CheckForCorpseReopen( mobIndex )
	local isReopen = false
	local corpseId = MI2_GetCorpseId( mobIndex )

	-- check if corpse ID is already in the list
	for index, recentCorpseId in pairs(MI2_RecentLoots) do
		if recentCorpseId == corpseId then
			MI2_CurrentCorpseIndex = index
			isReopen = true
			break
		end
	end

	-- add corpse ID the the list if it is a new one
	if corpseId and not isReopen then
		MI2_StoreCorpseId( corpseId, 1 )
	end

	return isReopen
end

-----------------------------------------------------------------------------
-- MI2_GetLootItemString()
--
-- Get and return a string describing a specific loot item.
-- The loot item is identified by its item ID.
-- The color for the string is returned as well
-----------------------------------------------------------------------------
function MI2_GetLootItemString( itemID )
	-- Use ClassicAPI to get item name and quality by ID
	local itemString = C_Item.GetItemNameByID(itemID) or tostring(itemID)
	local quality = C_Item.GetItemQualityByID(itemID)
	-- C_Item.GetItemQualityByID returns 0-based (0=Poor,1=Common,...), add 1 for MI2_QualityColor index
	local color
	if quality then
		color = MI2_QualityColor[quality + 1]
	end

	return itemString, (color or mifontLightRed), quality
end

-----------------------------------------------------------------------------
-- MI2_AddOneItemToTooltip()
--
-- Add one loot item description line to the tooltip. Item description
-- texts can optionally be shortened. Skinning loot uses skinned counter
-- instead of looted counter.
-----------------------------------------------------------------------------
local function MI2_AddOneItemToTooltip( mobData, itemID, amount, useFilter, prefix )
	local itemText, itemColor = MI2_GetLootItemString( itemID )
	
	-- apply item filter is requested
	if useFilter then
		if MobInfoConfig.ItemFilter ~= ""  then
			local itemNotOK = string.find( string.lower(itemText), string.lower(MobInfoConfig.ItemFilter) ) == nil
			if itemNotOK then return end
		end
	else
		itemColor = (prefix or "* ")..itemColor -- prefix for cloth, skinning, and quest loot
	end

	-- shorten item text to keep tooltip reasonably small
	local shortItemNames = true
	if shortItemNames and string.len(itemText) > 35 then
		itemText = string.sub(itemText,1,35).."..."
	end
	itemText = itemText..": "..amount

	local totalAmount = mobData.loots
	if miSkinLoot[itemID] then
		totalAmount = mobData.skinCount
	end
	if totalAmount and totalAmount > 0 then
		itemText = itemText.." ("..ceil(amount/totalAmount*100).."%)"  
	end
	
	if MobInfoConfig.LimitTooltipLines == 1 and GameTooltip:NumLines() >= 30 then return end
	GameTooltip:AddLine( itemColor..itemText )
end

-----------------------------------------------------------------------------
-- MI2_AddItemsToTooltip()
--
-- Add the list of items to the Mob tooltip. This function must be
-- called only for mobs that exist and that have an existing item list.
--
-- Notoriously similar and numerous items that radically increase tooltip
-- size without being of much (if any) interest will be collapsed into
-- just one item (example: "Green Hills of Stranglethorn" pages).
-----------------------------------------------------------------------------
-- Quality index to ShowQual config key mapping (quality 0=Poor .. 5=Legendary, 0-based from C_Item)
local MI2_QualShowConfig = {
	[0] = "ShowQualPoor",
	[1] = "ShowQualCommon",
	[2] = "ShowQualUncommon",
	[3] = "ShowQualRare",
	[4] = "ShowQualEpic",
	[5] = "ShowQualLegendary",
}

local function MI2_AddItemsToTooltip( mobData )
	local normalList = {}
	local collapsedList = {}
	local skinList = {}
	local clothList = {}
	local questList = {}

	-- sort items into 5 separate lists: normal, skin, cloth, quest, collapsed
	for itemID, amount in pairs(mobData.itemList) do
		local _,_,_,_,_, classID = C_Item.GetItemInfoInstant( itemID )
		if classID == 12 then
			questList[itemID] = amount
		elseif miSkinLoot[itemID] then
			skinList[itemID] = amount
		elseif miClothLoot[itemID] then
			clothList[itemID] = amount
		elseif MI2_ItemCollapseList[itemID] then
			-- collapse almost identical items into one item
			if MI2_ItemCollapseList[itemID] == 0 then
				MI2_ItemCollapseList[itemID] = itemID
			end
			local collapsedID = MI2_ItemCollapseList[itemID]
			collapsedList[collapsedID] = (collapsedList[collapsedID] or 0) + amount
		else
			normalList[itemID] = amount
		end
	end

	-- add normal and collapsed items to tooltip
	if MobInfoConfig.ShowItems == 1 then
		-- build a sortable array for normal + collapsed items
		local sortedList = {}
		for itemID, amount in pairs(normalList) do
			local itemText, itemColor, quality = MI2_GetLootItemString( itemID )
			local configKey = MI2_QualShowConfig[quality]
			if not configKey or MobInfoConfig[configKey] == 1 then
				table.insert( sortedList, { id=itemID, amount=amount, quality=(quality or -1) } )
			end
		end
		for itemID, amount in pairs(collapsedList) do
			local itemText, itemColor, quality = MI2_GetLootItemString( itemID )
			local configKey = MI2_QualShowConfig[quality]
			if not configKey or MobInfoConfig[configKey] == 1 then
				table.insert( sortedList, { id=itemID, amount=amount, quality=(quality or -1) } )
			end
		end
		-- sort by quality descending, then by drop chance descending
		local loots = mobData.loots or 0
		table.sort( sortedList, function(a, b)
			if a.quality ~= b.quality then
				return a.quality > b.quality
			end
			local aChance = loots > 0 and (a.amount / loots) or 0
			local bChance = loots > 0 and (b.amount / loots) or 0
			return aChance > bChance
		end)
		for i, entry in ipairs(sortedList) do
			MI2_AddOneItemToTooltip( mobData, entry.id, entry.amount, true )
		end
	end

	-- third: add all cloth and skinning items to tooltip, sorted by quality descending then drop chance descending
	if MobInfoConfig.ShowClothSkin == 1 then
		local loots = mobData.loots or 0
		local function sortByQualityAndChance(list)
			local sorted = {}
			for itemID, amount in pairs(list) do
				local itemText, itemColor, quality = MI2_GetLootItemString( itemID )
				table.insert( sorted, { id=itemID, amount=amount, quality=(quality or -1) } )
			end
			table.sort( sorted, function(a, b)
				if a.quality ~= b.quality then
					return a.quality > b.quality
				end
				local aChance = loots > 0 and (a.amount / loots) or 0
				local bChance = loots > 0 and (b.amount / loots) or 0
				return aChance > bChance
			end)
			return sorted
		end
		for i, entry in ipairs(sortByQualityAndChance(skinList)) do
			MI2_AddOneItemToTooltip( mobData, entry.id, entry.amount, false )
		end
		for i, entry in ipairs(sortByQualityAndChance(clothList)) do
			MI2_AddOneItemToTooltip( mobData, entry.id, entry.amount, false )
		end
	end

	-- fourth: add quest items at the bottom, sorted by quality descending then drop chance descending
	-- items that start a quest get "!! " prefix, others get "! " prefix
	if MobInfoConfig.ShowQuestLoot == 1 then
		local sortedQuestList = {}
		for itemID, amount in pairs(questList) do
			local itemText, itemColor, quality = MI2_GetLootItemString( itemID )
			table.insert( sortedQuestList, { id=itemID, amount=amount, quality=(quality or -1) } )
		end
		local loots = mobData.loots or 0
		table.sort( sortedQuestList, function(a, b)
			if a.quality ~= b.quality then
				return a.quality > b.quality
			end
			local aChance = loots > 0 and (a.amount / loots) or 0
			local bChance = loots > 0 and (b.amount / loots) or 0
			return aChance > bChance
		end)
		for i, entry in ipairs(sortedQuestList) do
			local prefix
			local itemData = C_Item.GetItemDataByID( entry.id )
			if itemData and itemData.startQuest and itemData.startQuest ~= 0 then
				prefix = mifontYellow.."!! "..mifontWhite
			else
				prefix = mifontYellow.."! "..mifontWhite
			end
			MI2_AddOneItemToTooltip( mobData, entry.id, entry.amount, false, prefix )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_AddLocationToTooltip()
--
-- Add the Mob location to the tooltip. Mob location always uses an entire
-- tooltip line.
-----------------------------------------------------------------------------
local function MI2_AddLocationToTooltip( location, showFullLocation )
	if not location.zones then return end
	local zoneNames = {}
	for id in pairs(location.zones) do
		local name = C_Map.GetAreaInfo(id)
		if name then
			table.insert(zoneNames, name)
		end
	end
	if table.getn(zoneNames) > 0 then
		table.sort(zoneNames)
		GameTooltip:AddLine( mifontGold..MI_TXT_LOCATION..mifontWhite..table.concat(zoneNames, ", ") )
	end
end

-----------------------------------------------------------------------------
-- MI2_AddResistToTooltip()
--
-- Add the Mob resistances and immunities data to the tooltip.
-----------------------------------------------------------------------------
local function MI2_AddResistToTooltip( resistData, compact )
	local resistParts = {}
	local immuneParts = {}
	local shortcut, value

	for shortcut, value in pairs(resistData) do
		if string.len(shortcut) < 3 then
			local hits = resistData[shortcut.."Hits"] or 1
			local color = MI2_SpellSchoolColors[shortcut] or mifontWhite
			local schoolName = MI2_SpellSchools[shortcut]
			local schoolAbbrev = string.sub(schoolName, 1, 1)
			
			if value < 0 then
				if hits < 1 then
					table.insert(immuneParts, color..schoolAbbrev)
				else
					table.insert(immuneParts, color..schoolAbbrev.." (partial)")
				end
			elseif value > 0 then
				local resistPercent = ceil((value/hits)*100)
				table.insert(resistParts, color..schoolAbbrev..": "..resistPercent.."%")
			end
		end
	end

	if compact then
		if table.getn(resistParts) > 0 then
			GameTooltip:AddLine( mifontGold.."R       "..mifontWhite..table.concat(resistParts, mifontGold..", ") )
		end
		if table.getn(immuneParts) > 0 then
			GameTooltip:AddLine( mifontGold.."I       "..mifontWhite..table.concat(immuneParts, mifontGold..", ") )
		end
	else
		if table.getn(resistParts) > 0 then
			GameTooltip:AddDoubleLine( mifontGold..MI_TXT_RESIST, table.concat(resistParts, mifontGold..", ") )
		end
		if table.getn(immuneParts) > 0 then
			GameTooltip:AddDoubleLine( mifontGold..MI_TXT_IMMUNE, table.concat(immuneParts, mifontGold..", ") )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_CreateNormalTooltip()
--
-- add all collected mob data to the game tooltip, data is only added if
-- corresponding "Show" flag is set
-----------------------------------------------------------------------------
local function MI2_CreateNormalTooltip( mobData, mobIndex, showFullLocation )
	local copperAvg, itemValueAvg
	local addEmptyLine = 0
	
	if mobData.lowHpAction == 1 and MobInfoConfig.ShowLowHpAction == 1 then
		GameTooltip:AddLine( mifontLightRed..">>  "..MI2_CHATMSG_MONSTEREMOTE.."  <<" )
	end

	if mobData.class and MobInfoConfig.ShowClass == 1 then
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_CLASS, mifontWhite..mobData.class )
	end

	if mobData.healthCur and MobInfoConfig.ShowHealth == 1 then
		local hpMaxStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(mobData.healthMax) or tostring(mobData.healthMax)
		local hpDisplay
		if mobData.healthCur == 0 then
			-- no live unit: show max health only
			hpDisplay = hpMaxStr
		else
			local hpCurStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(mobData.healthCur) or tostring(mobData.healthCur)
			hpDisplay = hpCurStr.." / "..hpMaxStr
		end
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_HEALTH, mifontWhite..hpDisplay )
		MI2_HealthLine = GameTooltip:NumLines()
	end

	if mobData.manaMax and mobData.manaMax > 0 and MobInfoConfig.ShowMana == 1 then
		local manaCurStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(mobData.manaCur) or tostring(mobData.manaCur)
		local manaMaxStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(mobData.manaMax) or tostring(mobData.manaMax)
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_MANA, mifontWhite..manaCurStr.." / "..manaMaxStr )
		MI2_ManaLine = GameTooltip:NumLines()
	end

	local mobGivesXp = not (mobData.color.r == 0.5  and  mobData.color.g == 0.5  and  mobData.color.b == 0.5)
	if mobGivesXp and mobData.xp then
		if MobInfoConfig.ShowXp == 1 then
			GameTooltip:AddDoubleLine( mifontGold..MI_TXT_XP, mifontWhite..mobData.xp )
		end 
		if MobInfoConfig.ShowNo2lev == 1 then
			GameTooltip:AddDoubleLine( mifontGold..MI_TXT_TO_LEVEL, mifontWhite..mobData.mob2Level )
		end 
	end

	if (mobData.minDamage or mobData.dps) and MobInfoConfig.ShowDamage == 1 then 
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_DAMAGE, mifontWhite..(mobData.minDamage or 0).."-"..(mobData.maxDamage or 0).."  ["..(mobData.dps or 0).."]" )
	end

	addEmptyLine = MobInfoConfig.ShowBlankLines

	if mobData.kills and MobInfoConfig.ShowKills == 1 then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_KILLS, mifontWhite..mobData.kills )
	end   

	if  mobData.loots  and  MobInfoConfig.ShowLoots == 1  then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_TIMES_LOOTED, mifontWhite..mobData.loots )
	end

	if  mobData.emptyLoots  and  MobInfoConfig.ShowEmpty == 1  then
		local emptyLootsStr = mifontWhite..mobData.emptyLoots
		if  mobData.loots  then
			emptyLootsStr = emptyLootsStr.." ("..ceil((mobData.emptyLoots/mobData.loots)*100).."%) "
		end
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_EMPTY_LOOTS, emptyLootsStr )
	end

	if mobData.clothCount and MobInfoConfig.ShowCloth == 1 then
		local clothStr = mifontWhite..mobData.clothCount
		if mobData.loots then
			clothStr = clothStr.." ("..ceil((mobData.clothCount/mobData.loots)*100).."%) "
		end
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_CLOTH_DROP, clothStr )
	end

	if mobData.copper and mobData.loots then
		copperAvg = ceil( mobData.copper / mobData.loots )
		if MobInfoConfig.ShowCoin == 1 then
			if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
			GameTooltip:AddDoubleLine(mifontGold..MI_TXT_COIN_DROP,mifontWhite..copper2text(copperAvg))
		end
	end

	local computedItemValue = MI2_ComputeItemValue( mobData, mobIndex )
	if computedItemValue and mobData.loots then
		itemValueAvg = ceil( computedItemValue / mobData.loots )
		if MobInfoConfig.ShowIV == 1 then
			if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
			GameTooltip:AddDoubleLine(mifontGold..MI_TEXT_ITEM_VALUE,mifontWhite..copper2text(itemValueAvg))
		end
	end

	local totalValue = (copperAvg or 0) + (itemValueAvg or 0)
	if totalValue > 0 and MobInfoConfig.ShowTotal == 1 then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine(mifontGold..MI_TXT_MOB_VALUE,mifontWhite..copper2text(totalValue))
	end

	if mobData.qualityStr ~= "" and MobInfoConfig.ShowQuality == 1 then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		GameTooltip:AddDoubleLine(mifontGold..MI_TXT_QUALITY, mobData.qualityStr)
	end

	if mobData.resists and MobInfoConfig.ShowResists == 1 then
		MI2_AddResistToTooltip( mobData.resists )
	end

	if mobData.location and MobInfoConfig.ShowLocation == 1 then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		MI2_AddLocationToTooltip( mobData.location, showFullLocation )
	end

	addEmptyLine = MobInfoConfig.ShowBlankLines

	if mobData.itemList and (MobInfoConfig.ShowItems == 1 or MobInfoConfig.ShowClothSkin == 1 or MobInfoConfig.ShowQuestLoot == 1) then
		if addEmptyLine == 1 then GameTooltip:AddLine("\n") addEmptyLine = 0 end
		MI2_AddItemsToTooltip( mobData )
	end
end

-----------------------------------------------------------------------------
-- MI2_CreateCompactTooltip()
--
-- add all collected mob data to the game tooltip, data is only added if
-- corresponding "Show" flag is set
-----------------------------------------------------------------------------
local function MI2_CreateCompactTooltip( mobData, mobIndex, showFullLocation )
	local firstLine = GameTooltip:NumLines() + 1

	if mobData.lowHpAction == 1 and MobInfoConfig.ShowLowHpAction == 1 then
		GameTooltip:AddLine( mifontLightRed..">>  "..MI2_CHATMSG_MONSTEREMOTE.."  <<" )
	end

	if mobData.class and MobInfoConfig.ShowClass == 1 then
		GameTooltip:AddDoubleLine( mifontGold..MI_TXT_CLASS, mifontWhite..mobData.class )
	end

	if (mobData.healthCur or mobData.manaMax and mobData.manaMax > 0)  
			and (MobInfoConfig.ShowHealth == 1 or MobInfoConfig.ShowMana == 1) then
		GameTooltip:AddDoubleLine( mifontGold.."HP    "..mifontWhite..(mobData.healthCur or 0).." / "..(mobData.healthMax or 0), mifontWhite..(mobData.manaCur or 0).." / "..(mobData.manaMax or 0)..mifontGold.." Mana" )
		MI2_HealthLine = GameTooltip:NumLines()
		if mobData.manaMax and mobData.manaMax > 0 then
			MI2_ManaLine = MI2_HealthLine
		end
	end

	local mobGivesXp = not (mobData.color.r == 0.5  and  mobData.color.g == 0.5  and  mobData.color.b == 0.5)
	if mobGivesXp and mobData.xp and (MobInfoConfig.ShowXp == 1 or MobInfoConfig.ShowNo2lev == 1) then
		GameTooltip:AddDoubleLine( mifontGold.."XP    "..mifontWhite..mobData.xp, mifontWhite..mobData.mob2Level..mifontGold.." KtL    " )
	end

	if (mobData.minDamage or mobData.dps) and MobInfoConfig.ShowDamage == 1 then
		GameTooltip:AddDoubleLine( mifontGold.."Dmg "..mifontWhite..(mobData.minDamage or 0).."-"..(mobData.maxDamage or 0), mifontWhite..(mobData.dps or 0)..mifontGold.." Dps   " )
	end


	if (mobData.kills or mobData.loots) and (MobInfoConfig.ShowKills == 1 or MobInfoConfig.ShowLoots == 1)  then
		GameTooltip:AddDoubleLine( mifontGold.."Kills  "..mifontWhite..(mobData.kills or 0), mifontWhite..(mobData.loots or 0)..mifontGold.." Loots" )
	end

	if  (mobData.emptyLoots or mobData.clothCount) and (MobInfoConfig.ShowCloth == 1 or MobInfoConfig.ShowEmpty == 1)  then
		local emptyLootsStr = mifontWhite..(mobData.emptyLoots or 0)
		if  mobData.loots  then
			emptyLootsStr = emptyLootsStr.." ("..ceil(((mobData.emptyLoots or 0)/mobData.loots)*100).."%) "
		end
		local clothStr = mifontWhite..(mobData.clothCount or 0)
		if mobData.loots then
			clothStr = clothStr.." ("..ceil(((mobData.clothCount or 0)/mobData.loots)*100).."%) "
		end
		GameTooltip:AddDoubleLine( mifontGold.."CL     "..mifontWhite..clothStr, mifontWhite..emptyLootsStr..mifontGold.." EL      " )
	end

	local computedIV = MI2_ComputeItemValue( mobData, mobIndex )
	if (mobData.copper or computedIV) and mobData.loots and MobInfoConfig.ShowTotal == 1 then
		local copperAvg = ceil( (mobData.copper or 0) / mobData.loots )
		local itemValueAvg = computedIV and ceil( computedIV / mobData.loots ) or 0
		local totalValue = copperAvg + itemValueAvg
		if totalValue > 0 then
			GameTooltip:AddDoubleLine( mifontGold.."Val    "..mifontWhite..copper2text(totalValue), mifontWhite..copper2text(copperAvg)..mifontGold.." Coins" )
		end
	end

	if  mobData.qualityStr ~= ""  and  MobInfoConfig.ShowQuality == 1  then
		GameTooltip:AddLine( mifontGold.."Q      "..mifontWhite..mobData.qualityStr )
	end

	if mobData.resists and MobInfoConfig.ShowResists == 1 then
		MI2_AddResistToTooltip( mobData.resists, true )
	end

	if mobData.location and MobInfoConfig.ShowLocation == 1 then
		MI2_AddLocationToTooltip( mobData.location, showFullLocation )
	end
	
	if mobData.itemList and (MobInfoConfig.ShowItems == 1 or MobInfoConfig.ShowClothSkin == 1) then
		MI2_AddItemsToTooltip( mobData )
	end
end

-----------------------------------------------------------------------------
-- MI2_BuildQualityString()
--
-- Build a string drepresenting the loot quality overview for the given mob.
-----------------------------------------------------------------------------
local function MI2_BuildQualityString( mobData, mobIndex )
	local rt = mobData.loots or 1

	-- Ensure itemList is decoded
	local mobInfo = MobInfoDB[mobIndex or ""]
	if not mobData.itemList and mobInfo then
		MI2_DecodeItemList( mobInfo, mobData )
	end

	-- Count total dropped items per quality tier from the item list.
	-- itemList[itemID] = total number of times that item was looted.
	local counts = {}
	if mobData.itemList then
		for itemID, amount in pairs(mobData.itemList) do
			local q = C_Item.GetItemQualityByID(itemID)
			if q then
				local idx = q + 1  -- 0-based WoW quality -> 1-based r1..r6
				counts[idx] = (counts[idx] or 0) + amount
			end
		end
	end

	mobData.qualityStr = ""
	for idx = 1, 6 do
		local count = counts[idx]
		if count and count > 0 then
			local chance = ceil( count / rt * 100.0 )
			if chance > 100 then chance = 100 end
			mobData.qualityStr = mobData.qualityStr..MI2_QualityColor[idx]..count.."("..chance.."%) "
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_BuildMobInfoTooltip()
--
-- create game tooltip contents
-- this includes handling the combined mode where data for several mobs
-- with same name but different levels has to be added up
-----------------------------------------------------------------------------
function MI2_BuildMobInfoTooltip( creatureID, mobLevel, showFullLocation )
	-- do not add anything to the tooltip for players
	if  UnitIsPlayer("mouseover")  then  return  end

	-- skip transient NPC summons with no permanent creature template
	if type(creatureID) == "number" and not C_CreatureInfo.GetCreatureInfoByID( creatureID ) then return end

	-- record mob location at mouseover
	if creatureID == nil then return end
	local mobIndex = creatureID..":"..mobLevel
	-- If this encounter is at level -1 (mob too high to display) and we
	-- already have at least one real-level entry for this non-boss creature,
	-- redirect to the highest known real level so the tooltip works and all
	-- recording lands on the correct key instead of creating a -1 entry.
	local originalLevelUnknown = (mobLevel == -1)
	local mobName = UnitName("mouseover")
	if mobLevel == -1 and not showFullLocation then
		local info = C_CreatureInfo.GetCreatureInfoByID( creatureID )
		if not info or info.rank ~= 3 then
			local idPrefix = tostring(creatureID)..":"
			local idLen    = string.len(idPrefix)
			for key in pairs(MobInfoDB) do
				if string.len(key) > idLen and string.sub(key, 1, idLen) == idPrefix then
					local lv = tonumber( string.sub(key, idLen + 1) )
					if lv and lv ~= -1 then
						mobLevel = lv
						mobIndex = key
						break
					end
				end
			end
		end
	end
	if not showFullLocation then
		-- If we previously recorded this creature at level -1 (too high to
		-- display at the time) and it is not a world boss, migrate that entry
		-- to the now-known real level before doing anything else.
		MI2_UpgradeBossLevelEntry( creatureID, mobLevel )
		MI2_RecordLocationAndType( mobIndex )
		-- Only update the global mouseover index for real in-world mouseovers,
		-- not for browser tooltip calls (showFullLocation == true).
		-- MI2_MouseoverIndex is used by health tracking and MI2_BuildQualityString;
		-- corrupting it with browser mob indices causes cross-mob data contamination.
		MI2_MouseoverIndex = mobIndex
		-- Invalidate the cache after recording so the tooltip fetch below
		-- gets a fresh decode from MobInfoDB, not a stale object written
		-- by MI2_RecordLocationAndType's own internal FetchMobData call.
		MI2_MobCache[mobIndex] = nil
	end

	-- get mob data for hovered mob
	local mobData = MI2_FetchMobData( mobIndex )
	-- handle combined Mob mode : try to find the other Mobs with same
	-- name but differing level, add their data to the tooltip data
	if  MobInfoConfig.CombinedMode == 1 and mobLevel > 0 then
		local combined = {}
		MI2_AddTwoMobs( combined, mobData )
		for levelToCombine = mobLevel-4, mobLevel+4, 1 do
			if levelToCombine ~= mobLevel  then
				local mobIndex = creatureID..":"..levelToCombine
				if MobInfoDB[mobIndex] then
					local dataToCombine = MI2_FetchMobData( mobIndex )
					MI2_AddTwoMobs( combined, dataToCombine )
					combined.color = GetDifficultyColor( levelToCombine )
				end
			end
		end
		mobData = combined
	elseif originalLevelUnknown and not showFullLocation then
		-- Level unknown (mob too high to display) but we have a known real-level
		-- entry for this creature. Use the first one found for the tooltip.
		local idPrefix = tostring(creatureID)..":"
		local idLen    = string.len(idPrefix)
		for key in pairs(MobInfoDB) do
			if string.len(key) > idLen and string.sub(key, 1, idLen) == idPrefix then
				local lv = tonumber( string.sub(key, idLen + 1) )
				if lv and lv ~= -1 then
					mobData = MI2_FetchMobData(key)
					break
				end
			end
		end
	end

	-- add unit and xp data for hovered mob
	MI2_GetUnitBasedMobData( mobIndex, mobData, "mouseover", mobLevel )
	if not mobData.color then mobData.color = {r=1.0;b=1.0;c=1.0} end
	if mobData.xp then
		-- calculate number of mobs to next level based on mob experience
		local xpCurrent = UnitXP("player") + mobData.xp
		local xpToLevel = UnitXPMax("player") - xpCurrent
		mobData.mob2Level = ceil(abs(xpToLevel / mobData.xp))+1
	end

	-- display the Mob data within the game tooltip
	MI2_BuildQualityString( mobData, mobIndex )
	if MobInfoConfig.CompactMode == 1 then
		MI2_CreateCompactTooltip( mobData, mobIndex, showFullLocation )
	else
		MI2_CreateNormalTooltip( mobData, mobIndex, showFullLocation )
	end
end

-----------------------------------------------------------------------------
-- MI2_BuildItemDataTooltip()
--
-- Build the additional game tooltip content for a given item name.
-- If the item is a known loot item this function will add the names of
-- all Mobs that drop the item to the game tooltip. Each Mob name will
-- appear on its own line.
-----------------------------------------------------------------------------
function MI2_BuildItemDataTooltip( itemName )
		if MobInfoConfig.ItemTooltip ~= 1 then return end

	-- get the table of all Mobs that drop the item, exit if none
	local itemFound = MI2_XRefItemTable[itemName]
	if not itemFound then
		return
	end

	-- Create a list of mobs dropping this item that is indexed by only
	-- the base Mob name. For each Mob calculate the chance to drop.
	-- Create a second list referencing the same data that is indexed
	-- numerically so that it can then be sorted by chance to get.
	local numMobs = 0
	local resultList = {}
	local sortList = {}
	local mobIndex, itemAmount
	for mobIndex, itemAmount in pairs(itemFound) do
		local mobData = {}
		MI2_DecodeBasicMobData( nil, mobData, mobIndex )

		local mobName, mobLevel = MI2_GetIndexComponents( mobIndex )
		local itemData = resultList[mobName]
		if not itemData then
			numMobs = numMobs + 1
			itemData = { name = mobName, loots = 0, count = 0 }
			resultList[mobName] = itemData
			sortList[numMobs] = itemData
		end

		itemData.loots = itemData.loots + (mobData.loots or 0)
		itemData.count = itemData.count + itemAmount
		if itemData.loots > 0 then
			itemData.chance = floor(100.0 * itemData.count / itemData.loots + 0.5)
			if itemData.loots < 6 then
				itemData.rating = itemData.chance + itemData.loots * 1000
			else
				itemData.rating = itemData.chance + 6000
			end
		else
			itemData.chance = itemData.count
			itemData.rating = itemData.chance
		end
	end

	-- sort list of Mobs by chance to get
	table.sort( sortList, function(a,b) return (a.rating > b.rating) end  )

	-- add Mobs to tooltip
	if numMobs == 1 then
		GameTooltip:AddLine( mifontLightBlue..MI_TXT_DROPPED_BY )
	else
		GameTooltip:AddLine( mifontLightBlue..string.format(MI_TXT_DROPPED_BY_MANY, numMobs) )
	end
	if numMobs > 8 then numMobs = 8 end
	local uncachedIDs = {}
	for idx = 1, numMobs do
		local data = sortList[idx]
		local creatureID = tonumber(data.name)
		local displayName = MI2_GetMobName( creatureID ) or ("#"..data.name)
		if creatureID and not C_CreatureInfo.GetCreatureInfoByID(creatureID) then
			uncachedIDs[table.getn(uncachedIDs) + 1] = creatureID
		end
		if data.loots > 0 then
			GameTooltip:AddDoubleLine( mifontLightBlue.."  "..displayName, mifontWhite..data.chance.."% ("..data.count.."/"..data.loots..")" )
		else
			GameTooltip:AddDoubleLine( mifontLightBlue.."  "..displayName, mifontWhite..data.chance )
		end
	end

	-- request any uncached creature names AFTER the tooltip is fully built
	-- so synchronous CREATURE_DATA_LOAD_RESULT callbacks cannot re-enter
	-- the tooltip building code and break the tooltip
	if table.getn(uncachedIDs) > 0 then
		C_Timer.After(0, function()
			for _, creatureID in ipairs(uncachedIDs) do
				C_CreatureInfo.RequestLoadCreatureByID(creatureID)
			end
		end)
	end

	return true
end

-----------------------------------------------------------------------------
-- MI2_ScanSpellbook()
--
-- Scan the spellbook to enter all spells and their spell school into
-- the "MI2_SpellToSchool" conversion table that is needed for resistances
-- and immunities recording.
-----------------------------------------------------------------------------
function MI2_ScanSpellbook()
	local spellBookPage = 2
	
	while spellBookPage > 0 do
		local pageName, texture, offset, numSpells = GetSpellTabInfo( spellBookPage )
		if pageName and offset and numSpells then
			for spellIndex = (offset+1), (offset + numSpells) do
				local spellName = GetSpellName( spellIndex, BOOKTYPE_SPELL )
				if spellName and (not string.find(spellName,":")) then
					for school in pairs(MI2_SpellSchools) do
						local schoolOK = string.find( pageName, school )
						if schoolOK and string.len(school) > 2 then
							MI2_SpellToSchool[spellName] = school
						end
					end
				end
			end
			spellBookPage = spellBookPage + 1
		else
			spellBookPage = 0
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordHit()
--
-- Calculate an updated DPS (damage per second) based on the current target
-- data in "MI2_Target" and the new damage value given as parameter.
-----------------------------------------------------------------------------
function MI2_RecordHit( damage, spell, school, isPeriodic )
	if not MI2_Target.FightStartTime then
		MI2_Target.FightStartTime = GetTime() - 1.0
		MI2_Target.FightEndTime = GetTime()
		MI2_Target.FightDamage = damage
	elseif MI2_Target.FightEndTime then
		MI2_Target.FightEndTime = GetTime()
		MI2_Target.FightDamage = MI2_Target.FightDamage + damage
	end

	if spell and school and MI2_SpellSchools[school] then
		MI2_SpellToSchool[spell] = school
	elseif spell then
		school = MI2_SpellToSchool[spell]
	end

	-- record spell hit data (needed for spell resist calculations)
	local acronym = MI2_SpellSchools[school]
	if school and acronym and not isPeriodic then
		local mobData = MI2_FetchMobData( MI2_Target.mobIndex )
		mobData.resists[acronym.."Hits"] = (mobData.resists[acronym.."Hits"] or 0)+ 1
	end
end

-----------------------------------------------------------------------------
-- MI2_RecordImmunResist()
--
-- Record that the given mob has either resisted a spell or is immune to
-- a spell.
-----------------------------------------------------------------------------
function MI2_RecordImmunResist( mobName, spell, isResist )
	if mobName == MI2_Target.name and MI2_Target.ResOk then
		local mobIndex = MI2_Target.mobIndex
		local mobData = MI2_FetchMobData( mobIndex )
		local school = MI2_SpellToSchool[spell]
		if school then
			local acronym = MI2_SpellSchools[school]
			if isResist then
				mobData.resists[acronym] = (mobData.resists[acronym] or 0) + 1
			else
				mobData.resists[acronym] = -1
			end
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_GetChildren()
--
-- recursivly get all children of a given frame
-----------------------------------------------------------------------------
function MI2_GetChildren( list, frame )
	local children = { frame:GetChildren() }
	for idx, subFrame in pairs(children) do
		if subFrame:GetNumChildren() > 0 then
			MI2_GetChildren( list, subFrame )
		else
			tinsert( list, subFrame )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_UpdateMobInfoState()
--
-- Enable or disable all Mob ToolTip options depending on state of
-- "DisableMobInfo". Update event handlers accordingly.
-----------------------------------------------------------------------------
function MI2_UpdateMobInfoState()
	local children = { MI2_FrmTooltipOptions:GetChildren() }
	local controls = {}
	
	MI2_GetChildren( controls, MI2_FrmTooltipOptions )

	for idx, frame in pairs(controls) do
		if MobInfoConfig.DisableMobInfo == 0 then
			if frame.Enable then
				frame:Enable()
				getglobal(frame:GetName().."Text"):SetTextColor( 1.0, 0.8, 0.0 )
			else
				frame:Show()
			end
		else
			if frame.Disable then
				frame:Disable()
				getglobal(frame:GetName().."Text"):SetTextColor( 0.5, 0.5, 0.5 )
			else
				frame:Hide()
			end
		end
	end
	MI2_OptDisableMobInfo:Enable()
	MI2_OptDisableMobInfo:SetScale( 1.2 )
	MI2_OptDisableMobInfoText:SetTextColor( 1.0, 1.0, 1.0 )
end

-----------------------------------------------------------------------------
-- MI2_UpdateTooltipHealthMana()
--
-- Update the health and mana values in the Mob tooltip, if they exist.
-----------------------------------------------------------------------------
function MI2_UpdateTooltipHealthMana( healthCur, healthMax )
	local tooltip = "GameTooltip"
	if TipBuddyTooltip then tooltip = "TipBuddyTooltip" end
	if MI2_HealthLine and healthCur then
		local hCurStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(healthCur) or tostring(healthCur)
		local hMaxStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(healthMax) or tostring(healthMax)
		local healthText = hCurStr.." / "..hMaxStr
		if MobInfoConfig.CompactMode == 1 then
			local healthLine = getglobal(tooltip.."TextLeft"..MI2_HealthLine)
			healthLine:SetText( mifontGold.."HP    "..mifontWhite..healthText )
		else
			local healthLine = getglobal(tooltip.."TextRight"..MI2_HealthLine)
			healthLine:SetText( mifontWhite..healthText )
		end
	end

	if MI2_ManaLine then
		local manaCur = UnitMana("mouseover")
		local manaMax = UnitManaMax("mouseover")
		local mCurStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(manaCur) or tostring(manaCur)
		local mMaxStr = MobInfoConfig.AbbrevHP == 1 and MI2_AbbrevNumber(manaMax) or tostring(manaMax)
		local manaText = mifontWhite..mCurStr.." / "..mMaxStr
		local manaLine = getglobal(tooltip.."TextRight"..MI2_ManaLine)
		if MobInfoConfig.CompactMode == 1 then
			manaLine:SetText( manaText..mifontGold.." Mana" )
		else
			manaLine:SetText( manaText )
		end
	end
end