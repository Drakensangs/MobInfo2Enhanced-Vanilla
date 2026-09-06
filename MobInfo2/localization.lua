if not C_Item then return end

-- 
-- Default English Localisation
--
-- created by Stephan Wilms 
--

MI_DESCRIPTION = "adds information about mobs to the tooltip and adds health/mana info to the target frame"

MI2_SpellSchools = { Arcane="ar", Fire="fi", Frost="fr", Shadow="sh", Holy="ho", Nature="na" }


MI_TXT_GOLD   = " Gold"
MI_TXT_SILVER = " Silver"
MI_TXT_COPPER = " Copper"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  Options"
MI_TXT_WELCOME			= "Welcome to MobInfo 2"
MI_TXT_OPEN				= "Open"
MI_TXT_CLASS			= "Class "
MI_TXT_HEALTH			= "Health "
MI_TXT_MANA				= "Mana "
MI_TXT_XP				= "XP "
MI_TXT_KILLS			= "Kills "
MI_TXT_DAMAGE			= "Damage + [DPS] "
MI_TXT_TIMES_LOOTED		= "Times Looted "
MI_TXT_EMPTY_LOOTS		= "Empty Loots "
MI_TXT_TO_LEVEL			= "# to level"
MI_TXT_QUALITY			= "Quality "
MI_TXT_CLOTH_DROP		= "Cloth drops "
MI_TXT_COIN_DROP		= "Avg Coin Drop "
MI_TEXT_ITEM_VALUE		= "Avg Item Value "
MI_TXT_MOB_VALUE		= "Total Mob Value "
MI_TXT_MOB_DB_SIZE		= "MobInfo Database Size:  "
MI_TXT_HEALTH_DB_SIZE	= "Health Database Size:  "
MI_TXT_PLAYER_DB_SIZE	= "Player Health Database Size:  "
MI_TXT_ITEM_DB_SIZE		= "Item Database Size:  "
MI_TXT_CUR_TARGET		= "Current Target:  "
MI_TXT_USAGE			= " Usage: enter /mobinfo2 or /mi2 to open interface"
MI2_TXT_MINIMAP_TIP1	= "Left click to open MobInfo2 menu."
MI2_TXT_MINIMAP_TIP2	= "Hold right click to move minimap button."
MI_TXT_MH_DISABLED		= "MobInfo WARNING: Separate MobHealth AddOn found. The internal MobHealth functionality is disabled until the separate MobHealth AddOn is removed."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n You will NOT loose your data when disabling separate MobHealth.\n\nBenefits: movable health/mana display with percentage support and adjustable font and size")
MI_TXT_CLR_ALL_CONFIRM	= "Do you really want to perform the following delete operation: "
MI_TXT_SEARCH_LEVEL		= "Mob Level:"
MI_TXT_SEARCH_MOBTYPE	= "Mob Type:"
MI_TXT_SEARCH_LOOTS		= "Mob Looted:"
MI_TXT_TRIM_DOWN_CONFIRM = "WARNING: this is an immediate permanent delete. Do you really want to delete all mob data not selected as being recorded."
MI_TXT_CLAM_MEAT		= "Clam Meat"
MI_TXT_SHOWING			= "List Shows: "
MI_TXT_DROPPED_BY		= "Dropped By:"
MI_TXT_DROPPED_BY_MANY	= "Dropped By %d Mobs:"
MI_TXT_LOCATION			= "Location: "
MI_TXT_IMMUNE			= "Immune"
MI_TXT_RESIST			= "Resist"
MI_TXT_DEL_SEARCH_CONFIRM = "Do you really want to DELETE the %d Mobs in the search result list from the MobInfo database ?"

MI2_CHATMSG_MONSTEREMOTE = "attempts to run"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG	= "Open MobInfo2 Options"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "Mob Tooltip Content"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Mob Health Options"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Database Options"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Health Value"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Mana Value"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Search Options"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "Mob Level"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"] = "Loot Item Quality"

MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "Loot Item Quality"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Item Tooltip"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Import External MobInfo Database"

--
-- This section defines all buttons in the options dialog
--	text : the text displayed on the button
--	help : the (short) one line help text for the button
-- 	info : additional multi line info text for button
--		   info is displayed in the help tooltip below the "help" line
--		   info is optional and can be omitted if not required
--

MI2_OPTIONS = {};

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
{ text = "Min"; help = "Minimum Mob level for search options."; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "Maximum Mob level for search options (must be < 66)."; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normal"; help = "Include Normal type mobs in search results."; }

MI2_OPTIONS["MI2_OptSearchRare"] = 
{ text = "Rare"; help = "Include Rare type mobs in search results."; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Elite"; help = "Include Elite type mobs in search results."; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Boss"; help = "Include Boss type mobs in search results."; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "Minimum number of times the Mob must have been looted."; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Mob Name"; help = "Partial or complete mob name to search for.";
info = 'Leave empty to not retrict search to specific items.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Item Name"; help = "Partial or complete item name to search for.";
info = 'Leave empty to search for all item names.'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Sort by Profit"; help = "Sort search result list by Mob profit.";
info = 'Sort the mobs by the profit you can make from killing them.'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Sort by Item Count"; help = "Sort search result list by item count.";
info = 'Sort the Mobs by how many of the specified item(s) they drop.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "List Mobs in Item Tooltip"; help = "Display names of Mobs dropping an item in item tooltip.";
info = "List the names of all Mobs that drop a hovered item in\nthe item tooltip. For each item list the amount dropped\nby the Mob along with percentage." }

MI2_OPTIONS["MI2_OptDisableMobInfo"] = 
{ text = "Disable Tooltip Info"; help = "Disable displaying Mob info in the tooltips.";
info = "This will totally disable the addon's information in both the Mob tooltip\nand the item tooltip." }

MI2_OPTIONS["MI2_OptShowClass"] = 
{ text = "Mob Class"; help = "Show Mob class info."; }

MI2_OPTIONS["MI2_OptShowHealth"] = 
{ text = "Health"; help = "Show Mob health info (current/max).\nRecording Mob health data must be ENABLED for this to work."; }

MI2_OPTIONS["MI2_OptShowMana"] = 
{ text = "Mana"; help = "Show Mob mana/rage/energy info (current/max)."; }

MI2_OPTIONS["MI2_OptShowXp"] = 
{ text = "XP"; help = "Shows the number of experience points a Mob gives.";
info = "This is the actual last XP value that the Mob gave you. \nNot shown for trivial Mobs." }

MI2_OPTIONS["MI2_OptShowNo2lev"] = 
{ text = "Number to Level"; help = "Shows the number of kills required to level up.";
info = "This shows you how many times you have to kill \nsame Mob to level up. Not shown for trivial Mobs." }

MI2_OPTIONS["MI2_OptShowDamage"] = 
{ text = "Damage / DPS"; help = "Show Mob damage range (Min/Max) and DPS (damage per second)."; 
info = "Damage range and DPS is calculated and stored separately per character.\nDPS updates slowly but progressively with each fight." }

MI2_OPTIONS["MI2_OptShowKills"] = 
{ text = "Killed"; help = "Show number of times you killed a Mob.";
info = "The kill count is calculated and stored\nseparately per character." }

MI2_OPTIONS["MI2_OptShowLoots"] = 
{ text = "Looted"; help = "Show the number of times a Mob has been looted."; }

MI2_OPTIONS["MI2_OptShowCloth"] = 
{ text = "Cloth Pickups"; help = "Show how often the Mob has given cloth loot."; }

MI2_OPTIONS["MI2_OptShowEmpty"] = 
{ text = "Empty Loots"; help = "Show the number of empty corpses found (num/percent).";
info = "This counter gets incremented when you open a corpse\nthat has no loot." }

MI2_OPTIONS["MI2_OptShowTotal"] = 
{ text = "Total Value"; help = "Show the total average Mob value.";
info = "This is the sum of average coin drop and \naverage item value." }

MI2_OPTIONS["MI2_OptShowCoin"] = 
{ text = "Coin Drop"; help = "Show average coin drop per Mob.";
info = "The total coin value is accumulated and divided by\nthe looted counter. Not shown if coin count is 0." }

MI2_OPTIONS["MI2_OptShowIV"] = 
{ text = "Item Value"; help = "Show average item value per Mob.";
info = "The total item value is accumulated and divided by\nthe looted counter. Not shown if item value is 0." }

MI2_OPTIONS["MI2_OptShowQuality"] = 
{ text = "Loot Quality Overview"; help = "Show loot quality counters and percentage.";
info = "Counts how many items out of the 6 rarity categories\nthe Mob has dropped. Categories with 0 drops aren't\nshown. The percentage is the chance to get an item\nof the specific rarity from the Mob as loot." }

MI2_OPTIONS["MI2_OptShowLocation"] = 
{ text = "Mob Location"; help = "Shows the locations where a Mob can be found.\nUp to 4 locations can be recorded per Mob.";
info = "Recording location data must be ENABLED for this to work."; }

MI2_OPTIONS["MI2_OptShowItems"] = 
{ text = "Basic Loot Item List"; help = "Show the names and amount of all basic loot items.";
info = "Basic loot items are all loot items except for cloth, skinning & quest loot.\nRecording loot item data must be ENABLED for this to work."; }

MI2_OPTIONS["MI2_OptShowClothSkin"] = 
{ text = "Cloth & Skinning Loot"; help = "Show names and amount of all cloth & skinning loot items.";
info = "Recording loot item data must be ENABLED for this to work."; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] = 
{ text = "Quest Loot"; help = "Show names and amount of all quest loot items.";
info = "Recording loot item data must be ENABLED for this to work."; }

MI2_OPTIONS["MI2_OptShowResists"] = 
{ text = "Resists and Immunities"; help = "Show Mob resistances and immunities.";
info = "Spell school resistances and immunities are calculated based on the amount\nof successful versus resisted spell hits.\nRecording resistance and immunity data must be ENABLED for this to work." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] = 
{ text = "Runaway Mob Indicator"; help = "Show indicator for Mobs that run when low on health.";
info = "The indicator is a red message line that gets shown\nfor the runaway Mobs only." }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Compact Mob Tooltip"; help = "Enables a compact Mob tooltip layout with 2 values per tooltip line.";
info = "Compact tooltip uses short abbreviated texts for the tooltip desriptions.\nTo disable a tolltip line both entries on that line must be disabled." }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
{ text = "Combine Same Mobs"; help = "Combine data for Mobs with same ID.";
info = "Combined mode will accumulate the data for Mobs with\nthe same ID but different level." }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
{ text = "Hold ALT Key for Mob Info"; help = "Only show Mob info in tooltip when the ALT key is held."; }

MI2_OPTIONS["MI2_OptShowBlankLines"] = 
{ text = "Show Blank Lines"; help = "Show blank lines in tooltip.";
info = "Blank lines are meant to improve readability\nby creating sections in the tooltip." }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "Limit Tooltip to 30 Lines"; help = "Limit the Mob tooltip to a maximum of 30 lines.";
info = "Prevents the tooltip from growing excessively large on mobs\nwith many item drops. Item lines beyond 30 are not shown." }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = "Loot Item Filter"; help = "Set filtering expression for loot item display in tooltips.";
info = "Display only those loot items in the Mob tooltip that include\nthe filter text. E.g. entering 'cloth' will show only items with\n'cloth' in the item name.\nEnter nothing to see all items." }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "Record Mob Health Data"; help = "Record Mob health data for display in the tooltip.";
info = "When enabled, MobInfo records the health of Mobs you encounter.\nDisabling this stops health data from being recorded or updated.\nThe Health tooltip option requires this to be enabled." }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "Record Player Health Data"; help = "Record player health data during a session. Scrubbed on logout\nunless save player health data permanently is also enabled.";
info = "When enabled, MobInfo tracks health data for players encountered\nduring PvP. This data is normally discarded at end of a session.\nDisable to stop recording player health data entirely." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Save player health data permanently"; help = "Permanently store player health data from PvP battles.";
info = "Normally player health data from PvP fights is discarded after\na session. This option retains that data." }

MI2_OPTIONS["MI2_OptAllOn"] = 
{ text = "All ON"; help = "Switch all MobInfo show options to ON."; }

MI2_OPTIONS["MI2_OptAllOff"] = 
{ text = "All OFF"; help = "Switch all MobInfo show options to OFF."; }

MI2_OPTIONS["MI2_OptMinimal"] = 
{ text = "Minimal"; help = "Show a minimum of useful Mob info."; }

MI2_OPTIONS["MI2_OptDefault"] = 
{ text = "Default"; help = "Show a default set of useful Mob info."; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "Show Minimap Button"; help = "Show or hide the MobInfo2 minimap button.";
info = "Enables or disables the minimap button that lets you\nopen the MobInfo2 options menu with a single click." }

MI2_OPTIONS["MI2_OptBtnDone"] = 
{ text = "Done"; help = "Close the MobInfo options frame."; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
{ text = "Show Health Value"; help = "Show health value in target frame."; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
{ text = "Show Mana Value"; help = "Show mana value in target frame."; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
{ text = "Show Percent"; help = "Add percentage to health in target frame."; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
{ text = "Show Percent"; help = "Add percentage to mana in target frame."; }

MI2_OPTIONS["MI2_OptAbbrevHP"] = 
{ text = "Abbreviate Values"; help = "Show health and mana as abbreviated numbers."; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
{ text = "Horizontal Position"; help = "Adjust horizontal position of health in target frame."; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
{ text = "Vertical Position"; help = "Adjust vertical position of health in target frame."; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
{ text = "Horizontal Position"; help = "Adjust horizontal position of mana in target frame."; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
{ text = "Vertical Position"; help = "Adjust vertical position of mana in target frame."; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
{ text = "Font"; help = "Set font for health/mana values in target frame.";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
{ text = "Font Size"; help = "Set font size for health/mana values in target frame."; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
{ text = "Delete Target Data"; help = "Delete the current target's data from the database."; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of mob info database."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of mob health database."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of player health database."; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Record Mob loot item data for quality:"; help = "Turn this on to record loot item details for all Mobs.";
info = "You can choose the quality level of items to be recorded."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Record basic Mob info"; help = "Record a set of basic Mob information.";
info = "Basic Mob info includes: Mob type, counters for:\nloot, empty loot, cloth, money, items value, items quality overview."; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Record character specific Mob data"; help = "Record all Mob data that is character specific.";
info = "This will enable or disable saving of the following data:\nnumber of kills, min/max damage, DPS and Mob XP.\n\nThis data is saved separately for each character. Saving it can\nonly be enabled/disabled for the entire set of 4 values"; }

MI2_OPTIONS["MI2_OptSaveLocation"] = 
{ text = "Record data describing the Mob location"; help = "Record the zone(s) where the Mob can be found." }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Record data about Resistances & Immunities"; help = "Record data about a Mobs resistances and immunities to spell schools.";
info = "For spell schools MobInfo records how many spells per school hit\nsuccessfully versus how many are resisted."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = ""; help = "Record loot item details for selected quality and better.";
choice1 = "|cff888888Grey|r & Better"; choice2="White & Better"; choice3="|cff00ff00Green|r & Better" }

MI2_OPTIONS["MI2_OptShowQualPoor"] = 
{ text = "|cff888888Poor|r"; help = "Show Poor (grey) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptShowQualCommon"] = 
{ text = "|cffffffffCommon|r"; help = "Show Common (white) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] = 
{ text = "|cff00ff00Uncommon|r"; help = "Show Uncommon (green) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptShowQualRare"] = 
{ text = "|cff0080ffRare|r"; help = "Show Rare (blue) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptShowQualEpic"] = 
{ text = "|cffe040ffEpic|r"; help = "Show Epic (purple) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] = 
{ text = "|cffff7000Legendary|r"; help = "Show Legendary (orange) quality items on mob tooltip."; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "Minimize Mob Database Size"; help = "Minimize Mob database size by removing surplus data.";
info = "Surplus data is all data within the database that is not marked as\nbeing recorded."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Start the Import"; help = "Import an external Mob Database into your own Mob Database.";
info = "IMPORTANT: please read the import instructions!\nALWAYS backup your own Mob database BEFORE importing!"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "DELETE"; help = "Deletes all Mobs in the search result list from the MobInfo database.";
info = "WARNING: this operation can not be undone.\nPlease use with care!\nYou might want to backup your MobInfo database before deleting Mobs."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Import only unknown Mobs"; help = "Import only Mobs that do not exist in your own database.";
info = "Activating this option prevents that the data of existing Mobs\nis modified. Only unknown (ie. new) Mobs will get imported. This\nallows importing partially overlapping database without causing\nconsistency problems."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] = 
{ text = "Tooltip"; help = "Set options for displaying Mob info in tooltip."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] = 
{ text = "Health/Mana"; help = "Set options for displaying health/mana in target frame."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] = 
{ text = "Database"; help = "Database management options."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] = 
{ text = "Search"; help = "Search through the Database."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Mob List"; help = "Lists all mobs in the database."; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Items List"; help = "Lists all items in the database."; }


MI_TXT_PFQUEST_RESOLVED		= "pfQuest name resolution: %d mob(s) resolved to ID"
MI_TXT_PFQUEST_AMBIGUOUS	= ", %d skipped (ambiguous name)"
MI_TXT_PFQUEST_NOTFOUND		= ", %d not found in pfQuest DB"
MI_TXT_RANK_COMPLETE		= "Rank resolution complete: %d creature(s) updated."
MI_TXT_RANK_PENDING			= "Rank resolution: updating %d creature(s) (%d pending cache). This may take a moment."
