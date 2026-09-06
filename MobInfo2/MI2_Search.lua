if not C_Item then return end

--
-- MI2_Search.lua
--
-- MobInfo module to control the Mob database search feature.
-- Search option settings and actual search algorithm are located in here.
--

--
-- start up defaults for search options settings
MI2_SearchOptions = {}
MI2_SearchOptions.MinLevel = 1
MI2_SearchOptions.MaxLevel = 65
MI2_SearchOptions.Normal = 1
MI2_SearchOptions.Rare = 0
MI2_SearchOptions.Elite = 0
MI2_SearchOptions.Boss = 0
MI2_SearchOptions.MinLoots = 0
MI2_SearchOptions.MobName = ""
MI2_SearchOptions.ItemName = ""
MI2_SearchOptions.CompactResult = 1
MI2_SearchOptions.ListMode = "Mobs"
MI2_SearchOptions.SortMode = "profit"

local MI2_SearchResultList = {}
local MI2_ItemsIdxList = ":"
MI2_NumMobsFound = 0

-----------------------------------------------------------------------------
-- MI2_SearchForItems()
--
-- Search for all items matching the item name entered in the search dialog.
-- Display the list of items in the result list control (if requested).
-----------------------------------------------------------------------------
local function MI2_SearchForItems( itemName, enterItemsIntoList )
	MI2_ItemsIdxList = ":"
	MI2_NumMobsFound = 0
	if enterItemsIntoList then
		MI2_SearchResultList = {}
	end

	if itemName ~= "" or enterItemsIntoList then
		-- Collect all unique item IDs from MobInfoDB (replaces MI2_ItemNameTable iteration)
		local seenItems = {}
		for mobIndex, mobInfo in pairs(MobInfoDB) do
			local mobData = {}
			MI2_DecodeItemList( mobInfo, mobData )
			if mobData.itemList then
				for idx in pairs(mobData.itemList) do
					if not seenItems[idx] then
						seenItems[idx] = true
						local itemFound = true
						local itemText, itemColor = MI2_GetLootItemString( idx )
						if itemName ~= "*" then
							itemFound = string.find( string.lower(itemText), string.lower(itemName):gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1") ) ~= nil
						end
						if itemFound then
							MI2_ItemsIdxList = MI2_ItemsIdxList..idx..":"
							if enterItemsIntoList then
								MI2_NumMobsFound = MI2_NumMobsFound + 1
								MI2_SearchResultList[MI2_NumMobsFound] = { idx = itemText, itemID = idx, val = "", col = itemColor }
							end
						end
					end
				end
			end
		end
	end
	
	MI2_DisplaySearchResult( "Items" )
end

-----------------------------------------------------------------------------
-- MI2_UpdateSearchResultList()
--
-- Update contents of search result list according to current search options
-- settings. This includes starting a new search run, sorting the result and
-- displaying the result in the scrollable result list.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- MI2_CombineSearchResultsByID()
--
-- When Combine Same Mobs is enabled, merge search result entries that share
-- the same creature ID into a single entry showing the level range.
-----------------------------------------------------------------------------
local function MI2_CombineSearchResultsByID()
	local byID = {}
	local order = {}

	for i = 1, MI2_NumMobsFound do
		local entry = MI2_SearchResultList[i]
		local creatureID = MI2_GetIndexComponents( entry.idx )
		-- decode raw copper+itemValue and loots for value averaging
		local mobInfo = MobInfoDB[entry.idx]
		local mobData = {}
		if mobInfo then MI2_DecodeBasicMobData( mobInfo, mobData ) end
		-- compute item value from item list (stored itemValue may be stale/zero)
		local computedIV = MI2_ComputeItemValue( mobData, entry.idx ) or 0
		local entryCopper = (mobData.copper or 0) + computedIV
		local entryLoots  = mobData.loots or 0
		if byID[creatureID] then
			-- merge: expand level range
			local existing = byID[creatureID]
			local _, thisLevel = MI2_GetIndexComponents( entry.idx )
			thisLevel = tonumber(thisLevel) or 0
			if thisLevel < existing.minLevel then existing.minLevel = thisLevel end
			if thisLevel > existing.maxLevel then existing.maxLevel = thisLevel end
			-- keep highest rank type
			if (entry.type or 1) > (existing.type or 1) then existing.type = entry.type end
			-- accumulate for value averaging
			existing.totalCopper = existing.totalCopper + entryCopper
			existing.totalLoots  = existing.totalLoots  + entryLoots
			-- keep best rank for sorting
			if entry.rank > existing.rank then
				existing.rank = entry.rank
			end
		else
			local _, thisLevel = MI2_GetIndexComponents( entry.idx )
			thisLevel = tonumber(thisLevel) or 0
			local combined = { idx=entry.idx, val=entry.val, rank=entry.rank,
				type=entry.type, minLevel=thisLevel, maxLevel=thisLevel,
				totalCopper=entryCopper, totalLoots=entryLoots }
			byID[creatureID] = combined
			table.insert(order, creatureID)
		end
	end

	-- rebuild result list, compute averaged val and rank, add level range strings
	MI2_SearchResultList = {}
	for _, creatureID in ipairs(order) do
		local e = byID[creatureID]
		if e.minLevel == e.maxLevel then
			e.levelRange = tostring(e.minLevel)
		else
			e.levelRange = e.minLevel.."-"..e.maxLevel
		end
		if e.totalLoots and e.totalLoots > 0 then
			local avgCopper = ceil(e.totalCopper / e.totalLoots)
			-- only overwrite val and rank with profit data in profit mode so that
			-- item count display and sort rank are preserved for "Sort by Item Count"
			if MI2_SearchOptions.SortMode == "profit" then
				e.val = copper2text( avgCopper )
				e.rank = avgCopper
			end
		end
		table.insert(MI2_SearchResultList, e)
	end
	MI2_NumMobsFound = table.getn(MI2_SearchResultList)
	if MI2_NumMobsFound > 1 then
		table.sort( MI2_SearchResultList, function(a,b) return (a.rank > b.rank) end )
	end
end -- MI2_CombineSearchResultsByID()

local function MI2_UpdateSearchResultList( updateItems )
	if updateItems then
		local enterItemsIntoList = MI2_SearchOptions.ListMode == "Items"
		MI2_SearchForItems( MI2_SearchOptions.ItemName, enterItemsIntoList )
	end

	if MI2_SearchOptions.ListMode == "Mobs" then
		MI2_SearchAndSort( "profit" )
		if MobInfoConfig.CombinedMode == 1 then
			MI2_CombineSearchResultsByID()
		end
	end

	MI2_DisplaySearchResult( MI2_SearchOptions.ListMode )
end

-----------------------------------------------------------------------------
-- MI2_SearchOptionsOnShow()
--
-- OnShow event handler for search options page
-- Write current search option settings into the search option controls.
-- Validate all values and update colors accordingly.
-- Allow Search only if all search options are valid.
-----------------------------------------------------------------------------
function MI2_SearchOptionsOnShow()
	MI2_OptSearchMinLevel:SetText( tostring(MI2_SearchOptions.MinLevel) )
	MI2_OptSearchMaxLevel:SetText( tostring(MI2_SearchOptions.MaxLevel) )
	MI2_OptSearchMinLoots:SetText( tostring(MI2_SearchOptions.MinLoots) )
	MI2_OptSearchMobName:SetText( MI2_SearchOptions.MobName )
	MI2_OptSearchItemName:SetText( MI2_SearchOptions.ItemName )

	MI2_OptSearchNormal:SetChecked( MI2_SearchOptions.Normal )
	MI2_OptSearchRare:SetChecked( MI2_SearchOptions.Rare )
	MI2_OptSearchElite:SetChecked( MI2_SearchOptions.Elite )
	MI2_OptSearchBoss:SetChecked( MI2_SearchOptions.Boss )

	MI2_UpdateSearchResultList()
end

-----------------------------------------------------------------------------
-- MI2_ValidateSearchOptions()
--
-- Validate all values and update colors accordingly.
-- Allow Search only if all search options are valid.
-----------------------------------------------------------------------------
local function MI2_ValidateSearchOptions()
	if MI2_SearchOptions.MinLevel < 1 then
		MI2_SearchOptions.MinLevel = 1
		if this:GetText() == "0" then
			this:SetText( "1" )
		end
	end
	if MI2_SearchOptions.MaxLevel < 1 then
		MI2_SearchOptions.MaxLevel = 1
		if this:GetText() == "0" then
			this:SetText( "1" )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_SearchCheckboxClicked()
--
-- OnClicked event handler for checkboxes on search options page
-- Store the checkbox state in the corresponding search options variable.
-----------------------------------------------------------------------------
function MI2_SearchCheckboxClicked()
	local checkboxName = this:GetName()
	local optionName = string.sub( checkboxName, 14 )
	local optionValue = this:GetChecked() or 0

	MI2_SearchOptions[optionName] = optionValue
	MI2_UpdateSearchResultList()
end

-----------------------------------------------------------------------------
-- MI2_SearchValueChanged()
--
-- OnChar event handler for editbox controls on search options page
-- This handler is called whenever the contents of an EditBox control changes.
-- It gets the new value and stores it in the corresponding search options
-- variable
-----------------------------------------------------------------------------
function MI2_SearchValueChanged()
	local editboxName = this:GetName()
	local optionName = string.sub( editboxName, 14 )
	local optionValue = tonumber(this:GetText()) or 0

	if MI2_SearchOptions[optionName] ~= optionValue then
		MI2_SearchOptions[optionName] = optionValue
		MI2_ValidateSearchOptions()
		MI2_UpdateSearchResultList()
	end
end

-----------------------------------------------------------------------------
-- MI2_SearchTextChanged()
--
-- OnChar event handler for textual editbox controls on search options page
-- This handler is called whenever the contents of an EditBox control changes.
-- It gets the new value and stores it in the corresponding search options
-- variable
-----------------------------------------------------------------------------
function MI2_SearchTextChanged()
	local editboxName = this:GetName()
	local optionName = string.sub( editboxName, 14 )

	if MI2_SearchOptions[optionName] ~= this:GetText() then
		MI2_SearchOptions[optionName] = this:GetText()
		MI2_UpdateSearchResultList( true )
	end
end

-----------------------------------------------------------------------------
-- MI2_CalculateRank()
--
-- Calculate ranking and corresponding actual value for a given mob.
-- Ranking depends on search mode. For search mode "profit" ranking is
-- based on the mobs total profit value plus bonus points for rare loot
-- items. For search mode "itemCount" ranking is identical to the overall
-- items count for the loot items being searched for (in this mode
-- rank and value are identical).
-----------------------------------------------------------------------------
local function MI2_CalculateRank( mobData, mobLevel, sortMode, mobIndex )
	local rank, value = 0, 0

	if sortMode == "profit" then
		if mobData.loots > 0 then
			local computedIV = MI2_ComputeItemValue( mobData, mobIndex ) or 0
			value = (mobData.copper or 0) + computedIV
			rank = ceil( value / mobData.loots )
			value = copper2text( rank )
		end
	elseif sortMode == "item" then
		if mobData.itemList then
			if MI2_ItemsIdxList ~= ":" then
				-- specific item filter active: rank by count of matching items
				for idx, val in pairs(mobData.itemList) do
					if string.find( MI2_ItemsIdxList, ":"..idx..":" ) then
						rank = rank + val
					end
				end
			else
				-- no item filter: rank by total number of items dropped
				for idx, val in pairs(mobData.itemList) do
					rank = rank + val
				end
			end
		end
		value = rank.."  "
	end

	return rank, value
end

-----------------------------------------------------------------------------
-- MI2_CheckMob()
--
-- Check a given Mob against the current search criteria. Return the
-- mob data if the mob matches the criteria, or return nil if the Mob
-- does not match.
-----------------------------------------------------------------------------
local function MI2_CheckMob( mobInfo, mobName, mobLevel )
	local levelOk, lootsOk, typeOk, itemsOK, mobData
	local nameOk = true

	-- check name and level of Mob
	-- mobName may be a creatureID (numeric string); resolve to display name for search
	local displayName = MI2_GetMobName( tonumber(mobName) ) or ("#"..mobName)
	if MI2_SearchOptions.MobName ~= "" then
		nameOk = string.find(string.lower(displayName),string.lower(MI2_SearchOptions.MobName),1,true) ~= nil
	end
	if nameOk and mobName ~= "" then
		levelOk = mobLevel >= MI2_SearchOptions.MinLevel and mobLevel <= MI2_SearchOptions.MaxLevel
		levelOk = levelOk or (mobLevel == -1)
	end

	-- check mob data related search conditions	
	if levelOk then
		mobData = {}
		MI2_DecodeBasicMobData( mobInfo, mobData )
		mobData.loots = mobData.loots or 0
		lootsOk = mobData.loots >= MI2_SearchOptions.MinLoots
		typeOk = (MI2_SearchOptions.Normal == 1 and mobData.mobType == 1) or (MI2_SearchOptions.Rare == 1 and mobData.mobType == 4) or (MI2_SearchOptions.Elite == 1 and mobData.mobType == 2) or (MI2_SearchOptions.Boss == 1 and mobData.mobType == 3)
		if lootsOk and typeOk then
			if MI2_ItemsIdxList ~= ":" then
				MI2_DecodeItemList( mobInfo, mobData )
				if mobData.itemList then
					for idx, val in pairs(mobData.itemList) do
						itemsOK = string.find( MI2_ItemsIdxList, ":"..idx..":" ) ~= nil
						if itemsOK then break end
					end
				end
				if not itemsOK then mobData = nil end
			elseif MI2_SearchOptions.SortMode == "item" then
				-- no item filter but sorting by item count: still need itemList decoded
				MI2_DecodeItemList( mobInfo, mobData )
			end
		else
			mobData = nil
		end
	end

	return mobData
end

-----------------------------------------------------------------------------
-- MI2_SearchAndSort()
--
-- Search for most valuable mobs by comparing the mobs average total value.
-- The function creates a result list to be displayed in the search results
-- list.
-----------------------------------------------------------------------------
function MI2_SearchAndSort( )
	local mobName, mobLevel, insertPos, value, rank, mobIndex, mobInfo

	-- initialise search result list  
	MI2_SearchResultList = {}
	MI2_NumMobsFound = 0
	
	-- create a sorted list of mobs matching the search criteria
	-- loop across all mobs in the MobInfo database
	for mobIndex, mobInfo in pairs(MobInfoDB) do
		mobName, mobLevel = MI2_GetIndexComponents( mobIndex )
		mobData = MI2_CheckMob( mobInfo, mobName, mobLevel )

		-- if mob is identified as belonging into the search result its
		-- search result sorting position is calculated based on a ranking
		-- value which in turn is based on the search mode
		if mobData then
			rank, value = MI2_CalculateRank( mobData, mobLevel, MI2_SearchOptions.SortMode, mobIndex )
			MI2_NumMobsFound = MI2_NumMobsFound + 1

			-- insert mob at correct sorted position and store all info we need for printing the result list
			MI2_SearchResultList[MI2_NumMobsFound] = { idx=mobIndex, val=value, rank=rank }
			if mobData.mobType and (mobData.mobType == 2 or mobData.mobType == 3 or mobData.mobType == 4) then
				MI2_SearchResultList[MI2_NumMobsFound].type = mobData.mobType
			end
		end
	end

	if MI2_NumMobsFound > 1 then
		table.sort( MI2_SearchResultList, function(a,b) return (a.rank > b.rank) end  )
	end
end

-----------------------------------------------------------------------------
-- MI2_DisplaySearchResult()
--
-- Display the result of a search in the search results scrollable list.
-- The mobs to be displayed depend on the current list scroll position.
-----------------------------------------------------------------------------
function MI2_DisplaySearchResult( resultType )
	-- update slider and get slider position
	FauxScrollFrame_Update( MI2_SearchResultSlider, MI2_NumMobsFound, 15, 14 );
	local sliderPos = FauxScrollFrame_GetOffset(MI2_SearchResultSlider)

	if resultType then
		MI2_TxtSearchCount:SetText( mifontSubWhite.."("..MI2_NumMobsFound.." "..resultType..")" )
	end

	-- update 15 search result lines with correct search result data
	local resultLine
	for i = 1, 15 do
		if 	(i + sliderPos) <= MI2_NumMobsFound then
			resultLine = getglobal( "MI2_SearchResult"..i.."Index" )
			resultLine:SetText( i + sliderPos )
			resultLine = getglobal( "MI2_SearchResult"..i.."Value" )
			resultLine:SetText( MI2_SearchResultList[i + sliderPos].val )
			resultLine = getglobal( "MI2_SearchResult"..i.."Name" )
			local entry = MI2_SearchResultList[i + sliderPos]
			local displayMobName
			if entry.col then
				-- item list result: resolve name fresh in case cache has filled
				local resolvedName = (entry.itemID and C_Item.GetItemNameByID(entry.itemID)) or entry.idx
				displayMobName = entry.col..resolvedName
			else
				-- mob list result: idx is a mobIndex ("creatureID:level") or a level range entry
				local resultID, resultLevel = MI2_GetIndexComponents( entry.idx )
				displayMobName = MI2_GetMobName( tonumber(resultID) ) or ("#"..resultID)
				local levelStr = entry.levelRange or resultLevel
				if entry.type == 3 then
					displayMobName = displayMobName.." ++"
				elseif entry.type == 2 then
					displayMobName = displayMobName.." "..levelStr.."+"
				elseif entry.type == 4 then
					displayMobName = displayMobName.." "..levelStr.." (R)"
				else
					displayMobName = displayMobName.." "..levelStr
				end
			end
			resultLine:SetText( displayMobName )
		else
			resultLine = getglobal( "MI2_SearchResult"..i.."Index" )
			resultLine:SetText( "" )
			resultLine = getglobal( "MI2_SearchResult"..i.."Value" )
			resultLine:SetText( "" )
			resultLine = getglobal( "MI2_SearchResult"..i.."Name" )
			resultLine:SetText( "" )
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_SortByValue()
--
-- Sort the search result list by mob profit
-----------------------------------------------------------------------------
function MI2_SlashAction_SortByValue()
	MI2_SearchOptions.SortMode = "profit"
	MI2_UpdateSearchResultList()
end

-----------------------------------------------------------------------------
-- MI2_SlashAction_SortByItem()
--
-- Sort the search result list by mob item count
-----------------------------------------------------------------------------
function MI2_SlashAction_SortByItem()
	MI2_SearchOptions.SortMode = "item"
	MI2_UpdateSearchResultList()
end

-----------------------------------------------------------------------------
-- MI2_SearchResult_Update()
--
-- Update contents of search results list based on current scroll bar
-- position. Update tooltip for selected mob if tooltip is visible.
-----------------------------------------------------------------------------
function MI2_SearchResult_Update()
	FauxScrollFrame_Update( MI2_SearchResultSlider, MI2_NumMobsFound, 15, 14 );
	MI2_DisplaySearchResult()
end

-----------------------------------------------------------------------------
-- MI2_ShowSearchResultTooltip()
--
-- Show mob tooltip for search result mob currently under mouse cursor.
-----------------------------------------------------------------------------
function MI2_ShowSearchResultTooltip()
	local sliderPos = FauxScrollFrame_GetOffset(MI2_SearchResultSlider)
	local selection = tonumber(string.sub(this:GetName(), 17)) + sliderPos
	  
	if selection <= MI2_NumMobsFound then
		GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )

		if MI2_SearchOptions.ListMode == "Mobs" then
			local index = MI2_SearchResultList[selection].idx
			local mobID, mobLevel = MI2_GetIndexComponents( index )
			local resolvedName = MI2_GetMobName( tonumber(mobID) ) or ("#"..mobID)
			local selType = MI2_SearchResultList[selection].type
			local levelStr = MI2_SearchResultList[selection].levelRange or mobLevel

			-- determine difficulty colour based on player level vs mob level
			local nameColor
			local mobLevelNum = tonumber(mobLevel) or 0
			if selType == 3 then
				-- boss with no level: always red
				nameColor = mifontDiffRed
			elseif mobLevelNum == -1 then
				-- unknown level (skull mob not yet resolved): always red
				nameColor = mifontDiffRed
			else
				local playerLevel = UnitLevel("player") or 1
				local diff = playerLevel - mobLevelNum
				if diff >= 6 then
					nameColor = mifontDiffGray
				elseif diff >= 3 then
					nameColor = mifontDiffGreen
				elseif diff >= 2 then
					nameColor = mifontYellow
				elseif diff > -3 then
					nameColor = mifontYellow
				elseif diff > -5 then
					nameColor = mifontDiffOrange
				else
					nameColor = mifontDiffRed
				end
			end

			-- build caption with coloured name
			local mobCaption
			if selType == 3 then
				mobCaption = nameColor..resolvedName.."|r  ++"
			elseif selType == 2 then
				mobCaption = nameColor..resolvedName.."|r  "..levelStr.."+"
			elseif selType == 4 then
				mobCaption = nameColor..resolvedName.."|r  "..levelStr.." (R)"
			else
				mobCaption = nameColor..resolvedName.."|r  "..levelStr
			end
			-- create Mob data tooltip with full location info
			GameTooltip:SetText( mobCaption )
			MI2_BuildMobInfoTooltip( tonumber(mobID) or mobID, tonumber(mobLevel) or mobLevel, 1 )
		elseif MI2_SearchOptions.ListMode == "Items" then
			local entry = MI2_SearchResultList[selection]
			if entry.itemID then
				GameTooltip:SetHyperlink("item:" .. entry.itemID)
			else
				local itemName = entry.idx
				GameTooltip:SetText(entry.col..itemName)
				MI2_BuildItemDataTooltip(itemName)
			end
		end
		GameTooltip:Show()
	end
end

-----------------------------------------------------------------------------
-- MI2_SearchTab_OnClick()
--
-- The "OnClick" event handler for the TAB buttons on the search result list.
-- These TAB buttons switch the list content between two modes: mob list
-- and item list
-----------------------------------------------------------------------------
function MI2_SearchTab_OnClick()
	PanelTemplates_Tab_OnClick( MI2_SearchResultFrame )
	local selected = MI2_SearchResultFrame.selectedTab
	if selected == 1 then
		MI2_OptSortByValue:Enable()
		MI2_OptSortByItem:Enable()
		if MI2_NumMobsFound > 0 then
			MI2_OptDeleteSearch:Enable()
		else
			MI2_OptDeleteSearch:Disable()
		end
		MI2_SearchOptions.ListMode = "Mobs"
		MI2_UpdateSearchResultList( true )
	elseif selected == 2 then
		MI2_OptSortByValue:Disable()
		MI2_OptSortByItem:Disable()
		MI2_OptDeleteSearch:Disable()
		MI2_SearchOptions.ListMode = "Items"
		MI2_UpdateSearchResultList( true )
	end
end

-----------------------------------------------------------------------------
-- MI2_DeleteSearchResultMobs()
--
-- Delete all Mobs in the search result list from the MobInfo database.
-- This function is called when the user confirms the delete.
-----------------------------------------------------------------------------
function MI2_DeleteSearchResultMobs()
	for idx, val in pairs(MI2_SearchResultList) do
		local mobIndex = val.idx
		MI2_DeleteMobData( mobIndex, true )
	end
	chattext( "search result deleted : "..MI2_NumMobsFound.." Mobs" )
	MI2_UpdateSearchResultList()
end