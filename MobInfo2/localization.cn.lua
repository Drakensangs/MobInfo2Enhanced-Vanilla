if not C_Item then return end
if GetLocale() ~= "zhCN" then return end

-- Simplified Chinese (zhCN)

MI_DESCRIPTION = "在提示框中添加怪物信息，并在目标框中显示生命/法力信息"

MI2_SpellSchools = { Arcane="奥", Fire="火", Frost="冰", Shadow="暗", Holy="神", Nature="自" }

MI_TXT_GOLD   = " 金"
MI_TXT_SILVER = " 银"
MI_TXT_COPPER = " 铜"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  选项"
MI_TXT_WELCOME			= "欢迎使用 MobInfo 2"
MI_TXT_OPEN				= "打开"
MI_TXT_CLASS			= "职业 "
MI_TXT_HEALTH			= "生命 "
MI_TXT_MANA				= "法力 "
MI_TXT_XP				= "经验 "
MI_TXT_KILLS			= "击杀 "
MI_TXT_DAMAGE			= "伤害 + [DPS] "
MI_TXT_TIMES_LOOTED		= "拾取次数 "
MI_TXT_EMPTY_LOOTS		= "空拾取 "
MI_TXT_TO_LEVEL			= "# 升级所需"
MI_TXT_QUALITY			= "品质 "
MI_TXT_CLOTH_DROP		= "布料掉落 "
MI_TXT_COIN_DROP		= "平均金币掉落 "
MI_TEXT_ITEM_VALUE		= "平均物品价值 "
MI_TXT_MOB_VALUE		= "怪物总价值 "
MI_TXT_MOB_DB_SIZE		= "MobInfo 数据库大小：  "
MI_TXT_HEALTH_DB_SIZE	= "生命数据库大小：  "
MI_TXT_PLAYER_DB_SIZE	= "玩家生命数据库大小：  "
MI_TXT_ITEM_DB_SIZE		= "物品数据库大小：  "
MI_TXT_CUR_TARGET		= "当前目标：  "
MI_TXT_USAGE			= " 使用方法：输入 /mobinfo2 或 /mi2 以打开界面"
MI2_TXT_MINIMAP_TIP1	= "左键单击打开 MobInfo2 菜单。"
MI2_TXT_MINIMAP_TIP2	= "按住右键拖动小地图按钮。"
MI_TXT_MH_DISABLED		= "MobInfo 警告：检测到独立的 MobHealth 插件。在移除独立的 MobHealth 插件之前，内置的 MobHealth 功能将被禁用。"
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n 禁用独立 MobHealth 时，你的数据不会丢失。\n\n优点：可移动的生命/法力显示，支持百分比显示及可调整字体和大小")
MI_TXT_CLR_ALL_CONFIRM	= "你真的要执行以下删除操作吗："
MI_TXT_SEARCH_LEVEL		= "怪物等级："
MI_TXT_SEARCH_MOBTYPE	= "怪物类型："
MI_TXT_SEARCH_LOOTS		= "怪物拾取："
MI_TXT_TRIM_DOWN_CONFIRM = "警告：这是立即且永久的删除操作。你真的要删除所有未选择记录的怪物数据吗？"
MI_TXT_CLAM_MEAT		= "蛤蜊肉"
MI_TXT_SHOWING			= "列表显示："
MI_TXT_DROPPED_BY		= "掉落自："
MI_TXT_DROPPED_BY_MANY	= "掉落自 %d 个怪物："
MI_TXT_LOCATION			= "位置："
MI_TXT_IMMUNE			= "免疫"
MI_TXT_RESIST			= "抵抗"
MI_TXT_DEL_SEARCH_CONFIRM = "你真的要从 MobInfo 数据库中删除搜索结果列表中的 %d 个怪物吗？"

MI2_CHATMSG_MONSTEREMOTE = "试图逃跑"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "打开 MobInfo2 选项"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "怪物提示框内容"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "怪物生命选项"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "数据库选项"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "生命值"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "法力值"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "搜索选项"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "怪物等级"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "战利品物品品质"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "战利品物品品质"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "物品提示框"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "导入外部 MobInfo 数据库"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "最小"; help = "搜索选项的怪物最低等级。"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "最大"; help = "搜索选项的怪物最高等级（必须 < 66）。"; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "普通"; help = "在搜索结果中包含普通类型怪物。"; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "稀有"; help = "在搜索结果中包含稀有类型怪物。"; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "精英"; help = "在搜索结果中包含精英类型怪物。"; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "首领"; help = "在搜索结果中包含首领类型怪物。"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "最小"; help = "怪物必须被拾取的最少次数。"; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "怪物名称"; help = "要搜索的部分或完整怪物名称。";
info = '留空以不限制搜索到特定怪物。'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "物品名称"; help = "要搜索的部分或完整物品名称。";
info = '留空以搜索所有物品名称。'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "按利润排序"; help = "按怪物利润排序搜索结果列表。";
info = '按杀死怪物所能获得的利润排序。'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "按物品数量排序"; help = "按物品数量排序搜索结果列表。";
info = '按怪物掉落指定物品的数量排序。'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "在物品提示框中列出怪物"; help = "在物品提示框中显示掉落物品的怪物名称。";
info = "在物品提示框中列出所有掉落悬停物品的怪物名称。\n对每个物品列出怪物掉落的数量及百分比。" }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "禁用提示框信息"; help = "禁用在提示框中显示怪物信息。";
info = "这将完全禁用插件在怪物提示框和物品提示框中的信息。" }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "怪物职业"; help = "显示怪物职业信息。"; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "生命"; help = "显示怪物生命信息（当前/最大）。\n必须启用记录怪物生命数据才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "法力"; help = "显示怪物法力/怒气/能量信息（当前/最大）。"; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "经验"; help = "显示怪物给予的经验值。";
info = "这是怪物给你的最后实际经验值。\n对微不足道的怪物不显示。" }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "升级所需数量"; help = "显示升级所需的击杀次数。";
info = "显示需要击杀同一怪物多少次才能升级。\n对微不足道的怪物不显示。" }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "伤害 / DPS"; help = "显示怪物伤害范围（最小/最大）和每秒伤害。";
info = "伤害范围和 DPS 按角色分别计算和储存。\nDPS 随每次战斗缓慢但持续地更新。" }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "已击杀"; help = "显示你击杀怪物的次数。";
info = "击杀计数按角色分别计算和储存。" }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "已拾取"; help = "显示怪物被拾取的次数。"; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "布料拾取"; help = "显示怪物给予布料战利品的次数。"; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "空拾取"; help = "显示发现的空尸体数量（数量/百分比）。";
info = "当你打开没有战利品的尸体时，此计数器会增加。" }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "总价值"; help = "显示怪物的平均总价值。";
info = "这是平均金币掉落和平均物品价值的总和。" }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "金币掉落"; help = "显示每个怪物的平均金币掉落。";
info = "总金币价值累积后除以拾取计数。\n如果金币数量为 0 则不显示。" }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "物品价值"; help = "显示每个怪物的平均物品价值。";
info = "总物品价值累积后除以拾取计数。\n如果物品价值为 0 则不显示。" }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "战利品品质概览"; help = "显示战利品品质计数器和百分比。";
info = "统计怪物掉落的 6 个稀有度类别中的物品数量。\n掉落数量为 0 的类别不显示。\n百分比是从怪物获得特定稀有度物品作为战利品的概率。" }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "怪物位置"; help = "显示可以找到怪物的位置。\n每个怪物最多可记录 4 个位置。";
info = "必须启用记录位置数据才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "基本战利品列表"; help = "显示所有基本战利品物品的名称和数量。";
info = "基本战利品物品是除布料、剥皮和任务战利品以外的所有物品。\n必须启用记录战利品物品数据才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "布料和剥皮战利品"; help = "显示所有布料和剥皮战利品物品的名称和数量。";
info = "必须启用记录战利品物品数据才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "任务战利品"; help = "显示所有任务战利品物品的名称和数量。";
info = "必须启用记录战利品物品数据才能使用此功能。"; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "抵抗和免疫"; help = "显示怪物的抵抗和免疫。";
info = "法术学派抵抗和免疫根据成功命中与被抵抗的法术数量计算。\n必须启用记录抵抗和免疫数据才能使用此功能。" }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "逃跑怪物指示器"; help = "显示血量低时逃跑的怪物的指示器。";
info = "指示器是一条红色消息行，\n仅对逃跑的怪物显示。" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "紧凑怪物提示框"; help = "启用每行显示 2 个值的紧凑怪物提示框布局。";
info = "紧凑提示框使用简短缩写的文字。\n要禁用一行，该行的两个项目都必须禁用。" }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "合并相同怪物"; help = "合并相同 ID 怪物的数据。";
info = "合并模式将累积具有相同 ID 但不同等级的怪物数据。" }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "按住 ALT 显示怪物信息"; help = "仅在按住 ALT 键时在提示框中显示怪物信息。"; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "显示空行"; help = "在提示框中显示空行。";
info = "空行通过在提示框中创建分节来提高可读性。" }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "将提示框限制为 30 行"; help = "将怪物提示框限制为最多 30 行。";
info = "防止提示框在掉落物品多的怪物上变得过大。\n超过 30 行的物品行不会显示。" }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "战利品物品过滤器"; help = "设置提示框中战利品物品显示的过滤表达式。";
info = "只显示提示框中包含过滤文字的战利品物品。\n例如输入「布料」将只显示名称中有「布料」的物品。\n不输入任何内容以查看所有物品。" }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "记录怪物生命数据"; help = "记录怪物生命数据以在提示框中显示。";
info = "启用后，MobInfo 记录遇到的怪物的生命值。\n禁用将停止记录或更新生命数据。\n生命提示框选项需要启用此功能。" }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "记录玩家生命数据"; help = "在会话期间记录玩家生命数据。";
info = "启用后，MobInfo 追踪在 PvP 中遇到的玩家的生命数据。\n这些数据通常在会话结束时丢弃。\n禁用以完全停止记录玩家生命数据。" }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "永久保存玩家生命数据"; help = "永久保存 PvP 战斗中的玩家生命数据。";
info = "通常 PvP 战斗中的玩家生命数据在会话后丢弃。\n此选项保留这些数据。" }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "全部开启"; help = "将所有 MobInfo 显示选项设为开启。"; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "全部关闭"; help = "将所有 MobInfo 显示选项设为关闭。"; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "最小化"; help = "显示最少量的有用怪物信息。"; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "默认"; help = "显示默认的有用怪物信息集合。"; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "显示小地图按钮"; help = "显示或隐藏 MobInfo2 小地图按钮。";
info = "启用或禁用允许你单击打开 MobInfo2 选项菜单的小地图按钮。" }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "完成"; help = "关闭 MobInfo 选项框。"; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "显示生命值"; help = "在目标框中显示生命值。"; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "显示法力值"; help = "在目标框中显示法力值。"; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "显示百分比"; help = "在目标框中的生命值旁添加百分比。"; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "显示百分比"; help = "在目标框中的法力值旁添加百分比。"; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "缩写数值"; help = "以缩写数字显示生命和法力值。"; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "水平位置"; help = "调整目标框中生命的水平位置。"; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "垂直位置"; help = "调整目标框中生命的垂直位置。"; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "水平位置"; help = "调整目标框中法力的水平位置。"; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "垂直位置"; help = "调整目标框中法力的垂直位置。"; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "字体"; help = "设置目标框中生命/法力值的字体。";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "字体大小"; help = "设置目标框中生命/法力值的字体大小。"; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "删除目标数据"; help = "从数据库中删除当前目标的数据。"; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "删除数据库"; help = "删除怪物信息数据库的全部内容。"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "删除数据库"; help = "删除怪物生命数据库的全部内容。"; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "删除数据库"; help = "删除玩家生命数据库的全部内容。"; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "记录以下品质的怪物战利品物品数据："; help = "开启以记录所有怪物的战利品物品详情。";
info = "你可以选择要记录的物品品质等级。"; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "记录基本怪物信息"; help = "记录一组基本怪物信息。";
info = "基本怪物信息包括：怪物类型，计数器：\n战利品、空战利品、布料、金币、物品价值、物品品质概览。"; }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "记录角色特定怪物数据"; help = "记录所有角色特定的怪物数据。";
info = "这将启用或禁用以下数据的保存：\n击杀次数、最小/最大伤害、DPS 和怪物经验值。\n\n这些数据为每个角色单独保存。" }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "记录怪物位置数据"; help = "记录可以找到怪物的区域。" }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "记录抵抗和免疫数据"; help = "记录怪物对法术学派的抵抗和免疫数据。";
info = "对于法术学派，MobInfo 记录每个学派成功命中的法术数量\n与被抵抗的法术数量。"; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "记录所选品质及以上的战利品物品详情。";
choice1 = "|cff888888灰色|r 及以上"; choice2="白色及以上"; choice3="|cff00ff00绿色|r 及以上" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888差|r"; help = "在怪物提示框中显示差（灰色）品质物品。"; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffff普通|r"; help = "在怪物提示框中显示普通（白色）品质物品。"; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00优秀|r"; help = "在怪物提示框中显示优秀（绿色）品质物品。"; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ff稀有|r"; help = "在怪物提示框中显示稀有（蓝色）品质物品。"; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ff史诗|r"; help = "在怪物提示框中显示史诗（紫色）品质物品。"; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000传说|r"; help = "在怪物提示框中显示传说（橙色）品质物品。"; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "最小化怪物数据库大小"; help = "通过删除多余数据最小化怪物数据库大小。";
info = "多余数据是数据库中所有未标记为被记录的数据。"; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "开始导入"; help = "将外部怪物数据库导入到你自己的怪物数据库。";
info = "重要：请阅读导入说明！\n导入前请务必备份你自己的怪物数据库！"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "删除"; help = "从 MobInfo 数据库中删除搜索结果列表中的所有怪物。";
info = "警告：此操作无法撤销。\n请谨慎使用！\n删除怪物前建议备份你的 MobInfo 数据库。"; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "只导入未知怪物"; help = "只导入你自己数据库中不存在的怪物。";
info = "启用此选项可防止现有怪物的数据被修改。\n只有未知（新）怪物会被导入。这允许导入部分重叠的数据库\n而不会造成一致性问题。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "提示框"; help = "设置在提示框中显示怪物信息的选项。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "生命/法力"; help = "设置在目标框中显示生命/法力的选项。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "数据库"; help = "数据库管理选项。"; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "搜索"; help = "搜索数据库。"; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "怪物列表"; help = "列出数据库中的所有怪物。"; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "物品列表"; help = "列出数据库中的所有物品。"; }

MI_TXT_PFQUEST_RESOLVED		= "pfQuest 名称解析：%d 个怪物已解析为 ID"
MI_TXT_PFQUEST_AMBIGUOUS	= "，%d 个已跳过（名称不明确）"
MI_TXT_PFQUEST_NOTFOUND		= "，%d 个在 pfQuest 数据库中未找到"
MI_TXT_RANK_COMPLETE		= "等级解析完成：已更新 %d 个生物。"
MI_TXT_RANK_PENDING			= "等级解析：正在更新 %d 个生物（%d 个缓存待处理）。这可能需要一些时间。"
