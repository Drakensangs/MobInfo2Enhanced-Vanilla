if not C_Item then return end
if GetLocale() ~= "zhTW" then return end

-- Traditional Chinese (zhTW)

MI_DESCRIPTION = "在提示框中添加怪物信息，並在目標框中顯示生命/法力信息"

MI2_SpellSchools = { Arcane="奧", Fire="火", Frost="冰", Shadow="暗", Holy="神", Nature="自" }

MI_TXT_GOLD   = " 金"
MI_TXT_SILVER = " 銀"
MI_TXT_COPPER = " 銅"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  選項"
MI_TXT_WELCOME			= "歡迎使用 MobInfo 2"
MI_TXT_OPEN				= "開啟"
MI_TXT_CLASS			= "職業 "
MI_TXT_HEALTH			= "生命 "
MI_TXT_MANA				= "法力 "
MI_TXT_XP				= "經驗 "
MI_TXT_KILLS			= "擊殺 "
MI_TXT_DAMAGE			= "傷害 + [DPS] "
MI_TXT_TIMES_LOOTED		= "拾取次數 "
MI_TXT_EMPTY_LOOTS		= "空拾取 "
MI_TXT_TO_LEVEL			= "# 升級所需"
MI_TXT_QUALITY			= "品質 "
MI_TXT_CLOTH_DROP		= "布料掉落 "
MI_TXT_COIN_DROP		= "平均金幣掉落 "
MI_TEXT_ITEM_VALUE		= "平均物品價值 "
MI_TXT_MOB_VALUE		= "怪物總價值 "
MI_TXT_MOB_DB_SIZE		= "MobInfo 資料庫大小：  "
MI_TXT_HEALTH_DB_SIZE	= "生命資料庫大小：  "
MI_TXT_PLAYER_DB_SIZE	= "玩家生命資料庫大小：  "
MI_TXT_ITEM_DB_SIZE		= "物品資料庫大小：  "
MI_TXT_CUR_TARGET		= "當前目標：  "
MI_TXT_USAGE			= " 使用方法：輸入 /mobinfo2 或 /mi2 以開啟介面"
MI2_TXT_MINIMAP_TIP1	= "左鍵點擊開啟 MobInfo2 選單。"
MI2_TXT_MINIMAP_TIP2	= "按住右鍵拖動小地圖按鈕。"
MI_TXT_MH_DISABLED		= "MobInfo 警告：偵測到獨立的 MobHealth 插件。在移除獨立的 MobHealth 插件之前，內建的 MobHealth 功能將被停用。"
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n 停用獨立 MobHealth 時，你的資料不會遺失。\n\n優點：可移動的生命/法力顯示，支援百分比顯示及可調整字體和大小")
MI_TXT_CLR_ALL_CONFIRM	= "你真的要執行以下刪除操作嗎："
MI_TXT_SEARCH_LEVEL		= "怪物等級："
MI_TXT_SEARCH_MOBTYPE	= "怪物類型："
MI_TXT_SEARCH_LOOTS		= "怪物拾取："
MI_TXT_TRIM_DOWN_CONFIRM = "警告：這是立即且永久的刪除操作。你真的要刪除所有未選擇記錄的怪物資料嗎？"
MI_TXT_CLAM_MEAT		= "蛤蜊肉"
MI_TXT_SHOWING			= "列表顯示："
MI_TXT_DROPPED_BY		= "掉落自："
MI_TXT_DROPPED_BY_MANY	= "掉落自 %d 個怪物："
MI_TXT_LOCATION			= "位置："
MI_TXT_IMMUNE			= "免疫"
MI_TXT_RESIST			= "抵抗"
MI_TXT_DEL_SEARCH_CONFIRM = "你真的要從 MobInfo 資料庫中刪除搜尋結果列表中的 %d 個怪物嗎？"

MI2_CHATMSG_MONSTEREMOTE = "試圖逃跑"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "開啟 MobInfo2 選項"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "怪物提示框內容"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "怪物生命選項"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "資料庫選項"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "生命值"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "法力值"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "搜尋選項"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "怪物等級"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "戰利品物品品質"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "戰利品物品品質"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "物品提示框"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "匯入外部 MobInfo 資料庫"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "最小"; help = "搜尋選項的怪物最低等級。"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "最大"; help = "搜尋選項的怪物最高等級（必須 < 66）。"; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "普通"; help = "在搜尋結果中包含普通類型怪物。"; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "稀有"; help = "在搜尋結果中包含稀有類型怪物。"; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "精英"; help = "在搜尋結果中包含精英類型怪物。"; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "首領"; help = "在搜尋結果中包含首領類型怪物。"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "最小"; help = "怪物必須被拾取的最少次數。"; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "怪物名稱"; help = "要搜尋的部分或完整怪物名稱。";
info = '留空以不限制搜尋到特定怪物。'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "物品名稱"; help = "要搜尋的部分或完整物品名稱。";
info = '留空以搜尋所有物品名稱。'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "按利潤排序"; help = "按怪物利潤排序搜尋結果列表。";
info = '按殺死怪物所能獲得的利潤排序。'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "按物品數量排序"; help = "按物品數量排序搜尋結果列表。";
info = '按怪物掉落指定物品的數量排序。'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "在物品提示框中列出怪物"; help = "在物品提示框中顯示掉落物品的怪物名稱。";
info = "在物品提示框中列出所有掉落懸停物品的怪物名稱。\n對每個物品列出怪物掉落的數量及百分比。" }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "停用提示框信息"; help = "停用在提示框中顯示怪物信息。";
info = "這將完全停用插件在怪物提示框和物品提示框中的信息。" }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "怪物職業"; help = "顯示怪物職業信息。"; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "生命"; help = "顯示怪物生命信息（當前/最大）。\n必須啟用記錄怪物生命資料才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "法力"; help = "顯示怪物法力/怒氣/能量信息（當前/最大）。"; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "經驗"; help = "顯示怪物給予的經驗值。";
info = "這是怪物給你的最後實際經驗值。\n對微不足道的怪物不顯示。" }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "升級所需數量"; help = "顯示升級所需的擊殺次數。";
info = "顯示需要擊殺同一怪物多少次才能升級。\n對微不足道的怪物不顯示。" }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "傷害 / DPS"; help = "顯示怪物傷害範圍（最小/最大）和每秒傷害。";
info = "傷害範圍和 DPS 按角色分別計算和儲存。\nDPS 隨每次戰鬥緩慢但持續地更新。" }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "已擊殺"; help = "顯示你擊殺怪物的次數。";
info = "擊殺計數按角色分別計算和儲存。" }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "已拾取"; help = "顯示怪物被拾取的次數。"; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "布料拾取"; help = "顯示怪物給予布料戰利品的次數。"; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "空拾取"; help = "顯示發現的空屍體數量（數量/百分比）。";
info = "當你開啟沒有戰利品的屍體時，此計數器會增加。" }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "總價值"; help = "顯示怪物的平均總價值。";
info = "這是平均金幣掉落和平均物品價值的總和。" }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "金幣掉落"; help = "顯示每個怪物的平均金幣掉落。";
info = "總金幣價值累積後除以拾取計數。\n如果金幣數量為 0 則不顯示。" }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "物品價值"; help = "顯示每個怪物的平均物品價值。";
info = "總物品價值累積後除以拾取計數。\n如果物品價值為 0 則不顯示。" }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "戰利品品質概覽"; help = "顯示戰利品品質計數器和百分比。";
info = "統計怪物掉落的 6 個稀有度類別中的物品數量。\n掉落數量為 0 的類別不顯示。\n百分比是從怪物獲得特定稀有度物品作為戰利品的機率。" }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "怪物位置"; help = "顯示可以找到怪物的位置。\n每個怪物最多可記錄 4 個位置。";
info = "必須啟用記錄位置資料才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "基本戰利品列表"; help = "顯示所有基本戰利品物品的名稱和數量。";
info = "基本戰利品物品是除布料、剝皮和任務戰利品以外的所有物品。\n必須啟用記錄戰利品物品資料才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "布料和剝皮戰利品"; help = "顯示所有布料和剝皮戰利品物品的名稱和數量。";
info = "必須啟用記錄戰利品物品資料才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "任務戰利品"; help = "顯示所有任務戰利品物品的名稱和數量。";
info = "必須啟用記錄戰利品物品資料才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "抵抗和免疫"; help = "顯示怪物的抵抗和免疫。";
info = "法術學派抵抗和免疫根據成功擊中與被抵抗的法術數量計算。\n必須啟用記錄抵抗和免疫資料才能使用此功能。" }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "逃跑怪物指示器"; help = "顯示血量低時逃跑的怪物的指示器。";
info = "指示器是一條紅色消息行，\n僅對逃跑的怪物顯示。" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "緊湊怪物提示框"; help = "啟用每行顯示 2 個值的緊湊怪物提示框佈局。";
info = "緊湊提示框使用簡短縮寫的文字。\n要停用一行，該行的兩個項目都必須停用。" }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "合併相同怪物"; help = "合併相同 ID 怪物的資料。";
info = "合併模式將累積具有相同 ID 但不同等級的怪物資料。" }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "按住 ALT 顯示怪物信息"; help = "僅在按住 ALT 鍵時在提示框中顯示怪物信息。"; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "顯示空行"; help = "在提示框中顯示空行。";
info = "空行通過在提示框中創建分節來提高可讀性。" }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "將提示框限制為 30 行"; help = "將怪物提示框限制為最多 30 行。";
info = "防止提示框在掉落物品多的怪物上變得過大。\n超過 30 行的物品行不會顯示。" }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "戰利品物品過濾器"; help = "設置提示框中戰利品物品顯示的過濾表達式。";
info = "只顯示提示框中包含過濾文字的戰利品物品。\n例如輸入「布料」將只顯示名稱中有「布料」的物品。\n不輸入任何內容以查看所有物品。" }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "記錄怪物生命資料"; help = "記錄怪物生命資料以在提示框中顯示。";
info = "啟用後，MobInfo 記錄遇到的怪物的生命值。\n停用將停止記錄或更新生命資料。\n生命提示框選項需要啟用此功能。" }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "記錄玩家生命資料"; help = "在會話期間記錄玩家生命資料。";
info = "啟用後，MobInfo 追蹤在 PvP 中遇到的玩家的生命資料。\n這些資料通常在會話結束時丟棄。\n停用以完全停止記錄玩家生命資料。" }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "永久保存玩家生命資料"; help = "永久保存 PvP 戰鬥中的玩家生命資料。";
info = "通常 PvP 戰鬥中的玩家生命資料在會話後丟棄。\n此選項保留這些資料。" }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "全部開啟"; help = "將所有 MobInfo 顯示選項設為開啟。"; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "全部關閉"; help = "將所有 MobInfo 顯示選項設為關閉。"; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "最小化"; help = "顯示最少量的有用怪物信息。"; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "預設"; help = "顯示預設的有用怪物信息集合。"; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "顯示小地圖按鈕"; help = "顯示或隱藏 MobInfo2 小地圖按鈕。";
info = "啟用或停用允許你單擊開啟 MobInfo2 選項選單的小地圖按鈕。" }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "完成"; help = "關閉 MobInfo 選項框。"; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "顯示生命值"; help = "在目標框中顯示生命值。"; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "顯示法力值"; help = "在目標框中顯示法力值。"; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "顯示百分比"; help = "在目標框中的生命值旁添加百分比。"; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "顯示百分比"; help = "在目標框中的法力值旁添加百分比。"; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "縮寫數值"; help = "以縮寫數字顯示生命和法力值。"; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "水平位置"; help = "調整目標框中生命的水平位置。"; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "垂直位置"; help = "調整目標框中生命的垂直位置。"; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "水平位置"; help = "調整目標框中法力的水平位置。"; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "垂直位置"; help = "調整目標框中法力的垂直位置。"; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "字體"; help = "設置目標框中生命/法力值的字體。";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "字體大小"; help = "設置目標框中生命/法力值的字體大小。"; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "刪除目標資料"; help = "從資料庫中刪除當前目標的資料。"; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "刪除資料庫"; help = "刪除怪物信息資料庫的全部內容。"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "刪除資料庫"; help = "刪除怪物生命資料庫的全部內容。"; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "刪除資料庫"; help = "刪除玩家生命資料庫的全部內容。"; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "記錄以下品質的怪物戰利品物品資料："; help = "開啟以記錄所有怪物的戰利品物品詳情。";
info = "你可以選擇要記錄的物品品質等級。"; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "記錄基本怪物信息"; help = "記錄一組基本怪物信息。";
info = "基本怪物信息包括：怪物類型，計數器：\n戰利品、空戰利品、布料、金幣、物品價值、物品品質概覽。"; }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "記錄角色特定怪物資料"; help = "記錄所有角色特定的怪物資料。";
info = "這將啟用或停用以下資料的保存：\n擊殺次數、最小/最大傷害、DPS 和怪物經驗值。\n\n這些資料為每個角色單獨保存。" }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "記錄怪物位置資料"; help = "記錄可以找到怪物的區域。" }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "記錄抵抗和免疫資料"; help = "記錄怪物對法術學派的抵抗和免疫資料。";
info = "對於法術學派，MobInfo 記錄每個學派成功命中的法術數量\n與被抵抗的法術數量。"; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "記錄所選品質及以上的戰利品物品詳情。";
choice1 = "|cff888888灰色|r 及以上"; choice2="白色及以上"; choice3="|cff00ff00綠色|r 及以上" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888差|r"; help = "在怪物提示框中顯示差（灰色）品質物品。"; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffff普通|r"; help = "在怪物提示框中顯示普通（白色）品質物品。"; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00優秀|r"; help = "在怪物提示框中顯示優秀（綠色）品質物品。"; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ff稀有|r"; help = "在怪物提示框中顯示稀有（藍色）品質物品。"; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ff史詩|r"; help = "在怪物提示框中顯示史詩（紫色）品質物品。"; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000傳說|r"; help = "在怪物提示框中顯示傳說（橙色）品質物品。"; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "最小化怪物資料庫大小"; help = "通過刪除多餘資料最小化怪物資料庫大小。";
info = "多餘資料是資料庫中所有未標記為被記錄的資料。"; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "開始匯入"; help = "將外部怪物資料庫匯入到你自己的怪物資料庫。";
info = "重要：請閱讀匯入說明！\n匯入前請務必備份你自己的怪物資料庫！"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "刪除"; help = "從 MobInfo 資料庫中刪除搜尋結果列表中的所有怪物。";
info = "警告：此操作無法撤銷。\n請謹慎使用！\n刪除怪物前建議備份你的 MobInfo 資料庫。"; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "只匯入未知怪物"; help = "只匯入你自己資料庫中不存在的怪物。";
info = "啟用此選項可防止現有怪物的資料被修改。\n只有未知（新）怪物會被匯入。這允許匯入部分重疊的資料庫\n而不會造成一致性問題。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "提示框"; help = "設置在提示框中顯示怪物信息的選項。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "生命/法力"; help = "設置在目標框中顯示生命/法力的選項。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "資料庫"; help = "資料庫管理選項。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "搜尋"; help = "搜尋資料庫。"; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "怪物列表"; help = "列出資料庫中的所有怪物。"; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "物品列表"; help = "列出資料庫中的所有物品。"; }

MI_TXT_PFQUEST_RESOLVED		= "pfQuest 名稱解析：%d 個怪物已解析為 ID"
MI_TXT_PFQUEST_AMBIGUOUS	= "，%d 個已跳過（名稱不明確）"
MI_TXT_PFQUEST_NOTFOUND		= "，%d 個在 pfQuest 資料庫中未找到"
MI_TXT_RANK_COMPLETE		= "等級解析完成：已更新 %d 個生物。"
MI_TXT_RANK_PENDING			= "等級解析：正在更新 %d 個生物（%d 個快取待處理）。這可能需要一些時間。"
