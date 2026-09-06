if not C_Item then return end

local EDITBOX_SHIFT  = 6
local MAXLEVEL_X	 = -5
local MOBVALUES_X	 = -5
local MOBVALUEC_X	 = -5
local XPGT_X		 = 5
local KILLSGT_X		 = 5
local MOBVALUEGT_X	 = 5
local LEVELDASH_X	 = 4
-----------------------------------------------------------------------------

local function MI2B_ApplypfUISkin()
	if not pfUI or not pfUI.RegisterSkin then return end

	pfUI:RegisterSkin("MobInfo2_Browser", function()
		-- Main browser frame
		StripTextures(MI2B_BrowseFrame)
		CreateBackdrop(MI2B_BrowseFrame, nil, nil, .75)
		CreateBackdropShadow(MI2B_BrowseFrame)

		-- Hide all named frame border textures
		local frameTextures = {
			"MI2B_BrowseFrameTopLeft", "MI2B_BrowseFrameTop", "MI2B_BrowseFrameTopRight",
			"MI2B_BrowseFrameBotLeft", "MI2B_BrowseFrameBot", "MI2B_BrowseFrameBotRight",
			"MI2B_ListPortraitTexture",
		}
		for _, name in pairs(frameTextures) do
			local t = _G[name]
			if t then t:Hide() end
		end

		-- Move title down slightly
		if MI2B_BrowseFrameTitle then
			MI2B_BrowseFrameTitle:ClearAllPoints()
			MI2B_BrowseFrameTitle:SetPoint("TOP", MI2B_BrowseFrame, "TOP", 0, -14)
		end

		-- Replace close button with a proper pfUI skinned close button
		if MI2B_ListCloseButton then
			MI2B_ListCloseButton:Hide()
			local closeBtn = CreateFrame("Button", "MI2B_pfCloseButton", MI2B_BrowseFrame)
			closeBtn:SetScript("OnClick", function() MI2B_BrowseFrame:Hide() end)
			SkinCloseButton(closeBtn, MI2B_BrowseFrame, -4, -4)
		end

		-- MI2 Browser button on the MobInfo2 Options frame
		if MI2B_OpenBrowserButton then SkinButton(MI2B_OpenBrowserButton) end

		-- Action buttons
		local buttons = {
			MI2B_ListSearchButton,
			MI2B_ListRefreshButton,
			MI2B_BrowseCloseButton,
		}
		for _, btn in pairs(buttons) do
			if btn then SkinButton(btn) end
		end

		-- Sort column headers: clear textures only, preserve highlight
		local sortbuttons = {
			MI2B_BrowseMobTypeSort, MI2B_BrowseNameSort, MI2B_BrowseLevelSort,
			MI2B_BrowseXPSort, MI2B_BrowseKillsSort, MI2B_BrowseMaxHealthSort,
			MI2B_BrowseMaxDamageSort, MI2B_BrowseDPSSort, MI2B_BrowseLootsSort,
			MI2B_BrowseClothSort, MI2B_BrowseMobValueSort, MI2B_BrowseItemRaritySort,
			MI2B_BrowseLocSort,
		}
		for _, btn in pairs(sortbuttons) do
			if btn then
				btn:SetNormalTexture("")
				btn:SetPushedTexture("")
			end
		end

		-- Checkbox
		if MI2B_CheckButton_1 then SkinCheckbox(MI2B_CheckButton_1) end

		-- Sort bar and list browse frames
		if MI2B_SortBar then StripTextures(MI2B_SortBar) end
		if MI2B_ListBrowse then StripTextures(MI2B_ListBrowse) end

		-- Scrollbar
		if MI2B_ListScrollFrameScrollBar then
			SkinScrollbar(MI2B_ListScrollFrameScrollBar)
		end

		-- Root editboxes (anchored to labels; chained ones follow automatically)
		local rootEditboxes = {
			MI2B_BrowseName, MI2B_BrowseMinLevel, MI2B_BrowseXP,
			MI2B_BrowseKills, MI2B_BrowseMobValueG,
			MI2B_BrowseItemName, MI2B_BrowseLocation,
		}

		-- All editboxes: strip and skin
		local allEditboxes = {
			MI2B_BrowseName, MI2B_BrowseMinLevel, MI2B_BrowseMaxLevel,
			MI2B_BrowseXP, MI2B_BrowseKills,
			MI2B_BrowseMobValueG, MI2B_BrowseMobValueS, MI2B_BrowseMobValueC,
			MI2B_BrowseItemName, MI2B_BrowseLocation,
		}
		for _, eb in pairs(allEditboxes) do
			if eb then
				StripTextures(eb, true, "BACKGROUND")
				eb:SetHeight(22)
				CreateBackdrop(eb, nil, true)
				eb:SetTextInsets(4, 4, 2, 2)
			end
		end

		-- Shift root editboxes up by EDITBOX_SHIFT
		local rootEditboxes = {
			MI2B_BrowseName, MI2B_BrowseMinLevel, MI2B_BrowseXP,
			MI2B_BrowseKills, MI2B_BrowseMobValueG,
			MI2B_BrowseItemName, MI2B_BrowseLocation,
		}
		if EDITBOX_SHIFT ~= 0 then
			for _, eb in pairs(rootEditboxes) do
				if eb then
					local p, rt, rp, x, y = eb:GetPoint()
					if p then
						eb:ClearAllPoints()
						eb:SetPoint(p, rt, rp, x, y + EDITBOX_SHIFT)
					end
				end
			end
		end

		-- Independent positioning for chained editboxes
		local function shiftBox(eb, dx, dy)
			if eb and (dx ~= 0 or dy ~= 0) then
				local p, rt, rp, x, y = eb:GetPoint()
				if p then
					eb:ClearAllPoints()
					eb:SetPoint(p, rt, rp, x + dx, y + dy)
				end
			end
		end
		shiftBox(MI2B_BrowseMaxLevel,   MAXLEVEL_X,  0)
		shiftBox(MI2B_BrowseMobValueS,  MOBVALUES_X, 0)
		shiftBox(MI2B_BrowseMobValueC,  MOBVALUEC_X, 0)

		-- Independent positioning for > and - signs
		local function shiftRegion(r, dx)
			if r and dx ~= 0 then
				local p, rt, rp, x, y = r:GetPoint()
				if p then
					r:ClearAllPoints()
					r:SetPoint(p, rt, rp, x + dx, y)
				end
			end
		end
		shiftRegion(MI2B_BrowseXPGt,      XPGT_X)
		shiftRegion(MI2B_BrowseKillsGt,   KILLSGT_X)
		shiftRegion(MI2B_BrowseMobValueGt, MOBVALUEGT_X)
		shiftRegion(MI2B_BrowseLevelDash,  LEVELDASH_X)

		-- Cover info sub-frame
		if MI2B_ListBrowseCoverInfo then StripTextures(MI2B_ListBrowseCoverInfo) end
	end)
end

local MI2B_pfUI_frame = CreateFrame("Frame")
MI2B_pfUI_frame:RegisterEvent("VARIABLES_LOADED")
MI2B_pfUI_frame:SetScript("OnEvent", function()
	MI2B_ApplypfUISkin()
end)
