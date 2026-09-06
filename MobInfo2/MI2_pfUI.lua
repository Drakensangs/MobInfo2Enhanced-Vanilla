if not C_Item then return end

-----------------------------------------------------------------------------
-- MI2_pfUI.lua
--
-- Skins the MobInfo2 options frame for pfUI when pfUI is detected.
-----------------------------------------------------------------------------

local function MI2_ApplypfUISkin()
	if not pfUI or not pfUI.RegisterSkin then return end

	pfUI:RegisterSkin("MobInfo2", function()
		local rawborder, border = GetBorderSize()

		-- Main options frame
		StripTextures(frmMIConfig)
		CreateBackdrop(frmMIConfig, nil, nil, .75)
		CreateBackdropShadow(frmMIConfig)

		-- Move title text down slightly from the upper border
		if txtMIConfigTitle then
			txtMIConfigTitle:ClearAllPoints()
			txtMIConfigTitle:SetPoint("TOP", frmMIConfig, "TOP", 0, -14)
		end

		-- Done button
		SkinButton(MI2_OptBtnDone)

		-- Tab buttons: skin then re-space them horizontally
		local tabs = {
			MI2_MainOptionsFrameTab1,
			MI2_MainOptionsFrameTab2,
			MI2_MainOptionsFrameTab3,
			MI2_MainOptionsFrameTab4,
			MI2_SearchResultFrameTab1,
			MI2_SearchResultFrameTab2,
		}
		for _, tab in pairs(tabs) do
			if tab then SkinTab(tab) end
		end

		-- Search result frame
		if MI2_SearchResultFrame then
			StripTextures(MI2_SearchResultFrame)
			CreateBackdrop(MI2_SearchResultFrame, nil, true, .75)
		end

		-- Re-anchor search sub-tabs: space them apart and align to top of result frame
		if MI2_SearchResultFrameTab1 then
			MI2_SearchResultFrameTab1:ClearAllPoints()
			MI2_SearchResultFrameTab1:SetPoint("BOTTOMLEFT", MI2_SearchResultFrame, "TOPLEFT", 3, 2)
		end
		if MI2_SearchResultFrameTab2 then
			MI2_SearchResultFrameTab2:ClearAllPoints()
			MI2_SearchResultFrameTab2:SetPoint("LEFT", MI2_SearchResultFrameTab1, "RIGHT", 6, 0)
		end
		-- Re-anchor tabs with proper spacing
		if MI2_MainOptionsFrameTab1 then
			MI2_MainOptionsFrameTab1:ClearAllPoints()
			MI2_MainOptionsFrameTab1:SetPoint("TOPLEFT", frmMIConfig, "TOPLEFT", 10, -30)
		end
		if MI2_MainOptionsFrameTab2 then
			MI2_MainOptionsFrameTab2:ClearAllPoints()
			MI2_MainOptionsFrameTab2:SetPoint("LEFT", MI2_MainOptionsFrameTab1, "RIGHT", 6, 0)
		end
		if MI2_MainOptionsFrameTab3 then
			MI2_MainOptionsFrameTab3:ClearAllPoints()
			MI2_MainOptionsFrameTab3:SetPoint("LEFT", MI2_MainOptionsFrameTab2, "RIGHT", 6, 0)
		end
		if MI2_MainOptionsFrameTab4 then
			MI2_MainOptionsFrameTab4:ClearAllPoints()
			MI2_MainOptionsFrameTab4:SetPoint("LEFT", MI2_MainOptionsFrameTab3, "RIGHT", 6, 0)
		end

		-- Push buttons
		local buttons = {
			MI2_OptMinimal, MI2_OptDefault, MI2_OptAllOn, MI2_OptAllOff,
			MI2_OptClearMobDb, MI2_OptClearHealthDb, MI2_OptClearPlayerDb,
			MI2_OptClearTarget, MI2_OptTrimDownMobData, MI2_OptImportMobData,
			MI2_OptSortByValue, MI2_OptSortByItem, MI2_OptDeleteSearch,
		}
		for _, btn in pairs(buttons) do
			if btn then SkinButton(btn) end
		end

		-- Checkboxes (all of them)
		local checkboxes = {
			MI2_OptShowClass, MI2_OptShowHealth, MI2_OptShowMana,
			MI2_OptShowXp, MI2_OptShowNo2lev, MI2_OptShowDamage,
			MI2_OptShowKills, MI2_OptShowLoots, MI2_OptShowCloth,
			MI2_OptShowEmpty, MI2_OptShowTotal, MI2_OptShowCoin,
			MI2_OptShowIV, MI2_OptShowQuality, MI2_OptShowLocation,
			MI2_OptShowItems, MI2_OptShowClothSkin, MI2_OptShowQuestLoot,
			MI2_OptShowResists, MI2_OptShowLowHpAction, MI2_OptDisableMobInfo,
			MI2_OptCompactMode, MI2_OptCombinedMode,
			MI2_OptKeypressMode, MI2_OptShowBlankLines, MI2_OptLimitTooltipLines,
			MI2_OptShowQualPoor, MI2_OptShowQualCommon, MI2_OptShowQualUncommon,
			MI2_OptShowQualRare, MI2_OptShowQualEpic, MI2_OptShowQualLegendary,
			MI2_OptItemTooltip,
			MI2_OptTargetHealth, MI2_OptHealthPercent,
			MI2_OptTargetMana, MI2_OptManaPercent, MI2_OptAbbrevHP,
			MI2_OptSaveBasicInfo, MI2_OptSaveCharData, MI2_OptSaveLocation,
			MI2_OptSaveResist, MI2_OptSaveItems, MI2_OptSaveMobHp,
			MI2_OptRecordPlayerHp, MI2_OptSavePlayerHp, MI2_OptImportOnlyNew,
			MI2_OptSearchNormal, MI2_OptSearchRare,
			MI2_OptSearchElite, MI2_OptSearchBoss,
		}
		for _, cb in pairs(checkboxes) do
			if cb then SkinCheckbox(cb) end
		end

		-- Dropdowns
		local dropdowns = { MI2_OptTargetFont, MI2_OptItemsQuality }
		for _, dd in pairs(dropdowns) do
			if dd then SkinDropDown(dd) end
		end

		-- Sliders: skin and explicitly set thumb size to avoid oversized thumb
		local sliders = {
			MI2_OptTargetFontSize,
			MI2_OptHealthPosX, MI2_OptHealthPosY,
			MI2_OptManaPosX,   MI2_OptManaPosY,
		}
		for _, sl in pairs(sliders) do
			if sl then
				SkinSlider(sl)
				-- SkinSlider sets frame height to 10 after creating the backdrop,
				-- so the backdrop retains the original larger height. Force it down.
				if sl.backdrop then
					sl.backdrop:SetHeight(10)
				end
				-- Keep thumb as a proper small rectangle, not a square
				local thumb = sl:GetThumbTexture()
				if thumb then
					thumb:SetWidth(10)
					thumb:SetHeight(6)
				end
			end
		end

		-- Edit boxes: replace backdrop and set proper text insets
		local editboxes = {
			MI2_OptItemFilter,
			MI2_OptSearchMinLevel, MI2_OptSearchMaxLevel,
			MI2_OptSearchMinLoots, MI2_OptSearchMobName,
			MI2_OptSearchItemName,
		}
		for _, eb in pairs(editboxes) do
			if eb then
				StripTextures(eb, true, "BACKGROUND")
				CreateBackdrop(eb, nil, true)
				eb:SetTextInsets(6, 6, 2, 2)
				local desc = _G[eb:GetName().."Desc"]
				if desc then
					desc:SetDrawLayer("OVERLAY")
					desc:Show()
				end
			end
		end

		-- Search result scroll frame
		if MI2_SearchResultSliderScrollBar then
			SkinScrollbar(MI2_SearchResultSliderScrollBar)
		end

		-- Sub-frames: strip vanilla box backgrounds
		local subframes = {
			MI2_MainOptionsFrame,
			MI2_FrmTooltipOptions,
			MI2_LootQualFrame,
			MI2_FrmItemTooltip,
			MI2_FrmHealthOptions,
			MI2_FrmHealthValueOptions,
			MI2_FrmManaValueOptions,
			MI2_FrmDatabaseOptions,
			MI2_FrmImportDatabase,
			MI2_FrmHealthDisabledInfo,
		}
		for _, sf in pairs(subframes) do
			if sf then StripTextures(sf) end
		end
	end)
end

local MI2_pfUI_frame = CreateFrame("Frame")
MI2_pfUI_frame:RegisterEvent("VARIABLES_LOADED")
MI2_pfUI_frame:SetScript("OnEvent", function()
	MI2_ApplypfUISkin()
end)
