if not C_Item then return end
if GetLocale() ~= "koKR" then return end

-- Korean (koKR)

MI_DESCRIPTION = "툴팁에 몬스터 정보를 추가하고 타겟 프레임에 체력/마나 정보를 표시합니다"

MI2_SpellSchools = { Arcane="비", Fire="화", Frost="냉", Shadow="암", Holy="신", Nature="자" }

MI_TXT_GOLD   = " 금"
MI_TXT_SILVER = " 은"
MI_TXT_COPPER = " 동"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  옵션"
MI_TXT_WELCOME			= "MobInfo 2에 오신 것을 환영합니다"
MI_TXT_OPEN				= "열기"
MI_TXT_CLASS			= "직업 "
MI_TXT_HEALTH			= "체력 "
MI_TXT_MANA				= "마나 "
MI_TXT_XP				= "경험치 "
MI_TXT_KILLS			= "처치 "
MI_TXT_DAMAGE			= "피해 + [DPS] "
MI_TXT_TIMES_LOOTED		= "획득 횟수 "
MI_TXT_EMPTY_LOOTS		= "빈 획득 "
MI_TXT_TO_LEVEL			= "# 레벨업 필요"
MI_TXT_QUALITY			= "품질 "
MI_TXT_CLOTH_DROP		= "천 드롭 "
MI_TXT_COIN_DROP		= "평균 동전 드롭 "
MI_TEXT_ITEM_VALUE		= "평균 아이템 가치 "
MI_TXT_MOB_VALUE		= "몬스터 총 가치 "
MI_TXT_MOB_DB_SIZE		= "MobInfo 데이터베이스 크기:  "
MI_TXT_HEALTH_DB_SIZE	= "체력 데이터베이스 크기:  "
MI_TXT_PLAYER_DB_SIZE	= "플레이어 체력 데이터베이스 크기:  "
MI_TXT_ITEM_DB_SIZE		= "아이템 데이터베이스 크기:  "
MI_TXT_CUR_TARGET		= "현재 타겟:  "
MI_TXT_USAGE			= " 사용법: /mobinfo2 또는 /mi2 를 입력하여 인터페이스 열기"
MI2_TXT_MINIMAP_TIP1	= "왼쪽 클릭으로 MobInfo2 메뉴 열기."
MI2_TXT_MINIMAP_TIP2	= "오른쪽 클릭을 유지하여 미니맵 버튼 이동."
MI_TXT_MH_DISABLED		= "MobInfo 경고: 별도의 MobHealth 애드온이 발견되었습니다. 별도의 MobHealth 애드온이 제거될 때까지 내장 MobHealth 기능이 비활성화됩니다."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n 별도의 MobHealth를 비활성화해도 데이터는 손실되지 않습니다.\n\n장점: 퍼센트 지원과 조정 가능한 폰트 및 크기가 있는 이동 가능한 체력/마나 표시")
MI_TXT_CLR_ALL_CONFIRM	= "정말로 다음 삭제 작업을 수행하시겠습니까: "
MI_TXT_SEARCH_LEVEL		= "몬스터 레벨:"
MI_TXT_SEARCH_MOBTYPE	= "몬스터 유형:"
MI_TXT_SEARCH_LOOTS		= "몬스터 획득:"
MI_TXT_TRIM_DOWN_CONFIRM = "경고: 이것은 즉각적이고 영구적인 삭제입니다. 기록되지 않은 모든 몬스터 데이터를 삭제하시겠습니까?"
MI_TXT_CLAM_MEAT		= "조개 살"
MI_TXT_SHOWING			= "목록 표시: "
MI_TXT_DROPPED_BY		= "드롭 출처:"
MI_TXT_DROPPED_BY_MANY	= "%d 몬스터에서 드롭:"
MI_TXT_LOCATION			= "위치: "
MI_TXT_IMMUNE			= "면역"
MI_TXT_RESIST			= "저항"
MI_TXT_DEL_SEARCH_CONFIRM = "검색 결과 목록의 몬스터 %d개를 MobInfo 데이터베이스에서 정말로 삭제하시겠습니까?"

MI2_CHATMSG_MONSTEREMOTE = "도망치려 합니다"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "MobInfo2 옵션 열기"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "몬스터 툴팁 내용"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "몬스터 체력 옵션"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "데이터베이스 옵션"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "체력 값"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "마나 값"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "검색 옵션"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "몬스터 레벨"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "전리품 아이템 품질"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "전리품 아이템 품질"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "아이템 툴팁"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "외부 MobInfo 데이터베이스 가져오기"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "최소"; help = "검색 옵션의 최소 몬스터 레벨."; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "최대"; help = "검색 옵션의 최대 몬스터 레벨 (66 미만이어야 함)."; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "일반"; help = "검색 결과에 일반 유형 몬스터 포함."; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "희귀"; help = "검색 결과에 희귀 유형 몬스터 포함."; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "정예"; help = "검색 결과에 정예 유형 몬스터 포함."; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "두목"; help = "검색 결과에 두목 유형 몬스터 포함."; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "최소"; help = "몬스터가 획득되어야 하는 최소 횟수."; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "몬스터 이름"; help = "검색할 몬스터의 부분 또는 전체 이름.";
info = '특정 몬스터로 검색을 제한하지 않으려면 비워두세요.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "아이템 이름"; help = "검색할 아이템의 부분 또는 전체 이름.";
info = '모든 아이템 이름을 검색하려면 비워두세요.'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "이익순 정렬"; help = "검색 결과 목록을 몬스터 이익순으로 정렬.";
info = '몬스터를 처치하여 얻을 수 있는 이익순으로 정렬.'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "아이템 수량순 정렬"; help = "검색 결과 목록을 아이템 수량순으로 정렬.";
info = '지정된 아이템을 드롭하는 수량순으로 몬스터 정렬.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "아이템 툴팁에 몬스터 목록"; help = "아이템을 드롭하는 몬스터 이름을 툴팁에 표시.";
info = "아이템 툴팁에 마우스를 올린 아이템을 드롭하는 모든 몬스터 이름을 나열.\n각 아이템에 대해 몬스터가 드롭한 수량과 퍼센트를 나열." }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "툴팁 정보 비활성화"; help = "툴팁에서 몬스터 정보 표시를 비활성화.";
info = "몬스터 툴팁과 아이템 툴팁 모두에서 애드온 정보를 완전히 비활성화합니다." }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "몬스터 직업"; help = "몬스터 직업 정보 표시."; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "체력"; help = "몬스터 체력 정보(현재/최대) 표시.\n이 기능이 작동하려면 몬스터 체력 데이터 기록이 활성화되어야 합니다."; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "마나"; help = "몬스터 마나/분노/에너지 정보(현재/최대) 표시."; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "경험치"; help = "몬스터가 주는 경험치 표시.";
info = "몬스터가 마지막으로 준 실제 경험치 값입니다.\n평범한 몬스터에게는 표시되지 않습니다." }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "레벨업 필요 수"; help = "레벨업에 필요한 처치 횟수 표시.";
info = "레벨업하려면 같은 몬스터를 몇 번 처치해야 하는지 표시합니다.\n평범한 몬스터에게는 표시되지 않습니다." }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "피해 / DPS"; help = "몬스터 피해 범위(최소/최대)와 초당 피해 표시.";
info = "피해 범위와 DPS는 캐릭터별로 별도로 계산 및 저장됩니다.\nDPS는 각 전투마다 천천히 하지만 점진적으로 업데이트됩니다." }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "처치"; help = "몬스터를 처치한 횟수 표시.";
info = "처치 카운터는 캐릭터별로 별도로 계산 및 저장됩니다." }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "획득"; help = "몬스터가 획득된 횟수 표시."; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "천 획득"; help = "몬스터가 전리품으로 천을 준 횟수 표시."; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "빈 획득"; help = "발견된 빈 시체 수 표시(수/퍼센트).";
info = "전리품이 없는 시체를 열 때 이 카운터가 증가합니다." }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "총 가치"; help = "몬스터의 평균 총 가치 표시.";
info = "평균 동전 드롭과 평균 아이템 가치의 합계입니다." }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "동전 드롭"; help = "몬스터당 평균 동전 드롭 표시.";
info = "총 동전 가치를 누적하여 획득 카운터로 나눕니다.\n동전 수가 0이면 표시되지 않습니다." }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "아이템 가치"; help = "몬스터당 평균 아이템 가치 표시.";
info = "총 아이템 가치를 누적하여 획득 카운터로 나눕니다.\n아이템 가치가 0이면 표시되지 않습니다." }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "전리품 품질 개요"; help = "전리품 품질 카운터와 퍼센트 표시.";
info = "몬스터가 드롭한 6개 희귀도 카테고리의 아이템 수를 셉니다.\n0 드롭 카테고리는 표시되지 않습니다.\n퍼센트는 전리품으로 특정 희귀도 아이템을 얻을 확률입니다." }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "몬스터 위치"; help = "몬스터를 찾을 수 있는 위치 표시.\n몬스터당 최대 4개 위치를 기록할 수 있습니다.";
info = "이 기능이 작동하려면 위치 데이터 기록이 활성화되어야 합니다."; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "기본 전리품 목록"; help = "모든 기본 전리품 아이템의 이름과 수량 표시.";
info = "기본 전리품 아이템은 천, 스킨, 퀘스트 전리품을 제외한 모든 아이템입니다.\n이 기능이 작동하려면 전리품 아이템 데이터 기록이 활성화되어야 합니다."; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "천 및 스킨 전리품"; help = "모든 천 및 스킨 전리품 아이템의 이름과 수량 표시.";
info = "이 기능이 작동하려면 전리품 아이템 데이터 기록이 활성화되어야 합니다."; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "퀘스트 전리품"; help = "모든 퀘스트 전리품 아이템의 이름과 수량 표시.";
info = "이 기능이 작동하려면 전리품 아이템 데이터 기록이 활성화되어야 합니다."; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "저항 및 면역"; help = "몬스터 저항 및 면역 표시.";
info = "마법 계열 저항 및 면역은 성공한 주문 적중 수 대 저항된 수를 기반으로 계산됩니다.\n저항 및 면역 데이터 기록이 활성화되어야 합니다." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "도주 몬스터 표시기"; help = "체력이 낮을 때 도주하는 몬스터에 대한 표시기 표시.";
info = "표시기는 도주하는 몬스터에만 표시되는 빨간색 메시지 줄입니다." }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "간결한 몬스터 툴팁"; help = "툴팁 줄당 2개 값을 표시하는 간결한 레이아웃 활성화.";
info = "간결한 툴팁은 짧고 축약된 텍스트를 사용합니다.\n줄을 비활성화하려면 해당 줄의 두 항목 모두 비활성화해야 합니다." }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "동일한 몬스터 합산"; help = "동일한 ID를 가진 몬스터의 데이터를 합산.";
info = "합산 모드는 같은 ID를 가지지만 다른 레벨의 몬스터 데이터를 누적합니다." }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "ALT를 눌러 몬스터 정보"; help = "ALT 키를 누르고 있을 때만 툴팁에 몬스터 정보 표시."; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "빈 줄 표시"; help = "툴팁에 빈 줄 표시.";
info = "빈 줄은 툴팁에 섹션을 만들어 가독성을 향상시킵니다." }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "툴팁을 30줄로 제한"; help = "몬스터 툴팁을 최대 30줄로 제한.";
info = "드롭 아이템이 많은 몬스터에서 툴팁이 과도하게 커지는 것을 방지합니다.\n30줄 이상의 아이템 줄은 표시되지 않습니다." }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "전리품 아이템 필터"; help = "툴팁의 전리품 아이템 표시를 위한 필터 표현식 설정.";
info = "툴팁에서 필터 텍스트가 포함된 전리품 아이템만 표시합니다.\n예: '천'을 입력하면 이름에 '천'이 있는 아이템만 표시됩니다.\n모든 아이템을 보려면 아무것도 입력하지 마세요." }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "몬스터 체력 데이터 기록"; help = "툴팁에 표시하기 위한 몬스터 체력 데이터 기록.";
info = "활성화되면 MobInfo는 만난 몬스터의 체력을 기록합니다.\n비활성화하면 체력 데이터 기록 또는 업데이트가 중지됩니다.\n체력 툴팁 옵션은 이것이 활성화되어야 합니다." }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "플레이어 체력 데이터 기록"; help = "세션 중 플레이어 체력 데이터 기록.";
info = "활성화되면 MobInfo는 PvP에서 만난 플레이어의 체력 데이터를 추적합니다.\n이 데이터는 보통 세션 종료 시 삭제됩니다.\n플레이어 체력 데이터 기록을 완전히 중지하려면 비활성화하세요." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "플레이어 체력 데이터 영구 저장"; help = "PvP 전투에서 플레이어 체력 데이터 영구 저장.";
info = "보통 PvP 전투에서의 플레이어 체력 데이터는 세션 후 삭제됩니다.\n이 옵션은 해당 데이터를 유지합니다." }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "모두 켜기"; help = "모든 MobInfo 표시 옵션을 켜기로 설정."; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "모두 끄기"; help = "모든 MobInfo 표시 옵션을 끄기로 설정."; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "최소"; help = "최소한의 유용한 몬스터 정보 표시."; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "기본"; help = "기본 유용한 몬스터 정보 세트 표시."; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "미니맵 버튼 표시"; help = "MobInfo2 미니맵 버튼 표시 또는 숨기기.";
info = "한 번의 클릭으로 MobInfo2 옵션 메뉴를 열 수 있는 미니맵 버튼을 활성화 또는 비활성화합니다." }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "완료"; help = "MobInfo 옵션 프레임 닫기."; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "체력 값 표시"; help = "타겟 프레임에 체력 값 표시."; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "마나 값 표시"; help = "타겟 프레임에 마나 값 표시."; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "퍼센트 표시"; help = "타겟 프레임의 체력에 퍼센트 추가."; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "퍼센트 표시"; help = "타겟 프레임의 마나에 퍼센트 추가."; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "값 축약"; help = "체력과 마나 값을 축약된 숫자로 표시."; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "가로 위치"; help = "타겟 프레임에서 체력의 가로 위치 조정."; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "세로 위치"; help = "타겟 프레임에서 체력의 세로 위치 조정."; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "가로 위치"; help = "타겟 프레임에서 마나의 가로 위치 조정."; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "세로 위치"; help = "타겟 프레임에서 마나의 세로 위치 조정."; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "글꼴"; help = "타겟 프레임의 체력/마나 값 글꼴 설정.";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "글꼴 크기"; help = "타겟 프레임의 체력/마나 값 글꼴 크기 설정."; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "타겟 데이터 삭제"; help = "데이터베이스에서 현재 타겟의 데이터 삭제."; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "데이터베이스 삭제"; help = "몬스터 정보 데이터베이스의 전체 내용 삭제."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "데이터베이스 삭제"; help = "몬스터 체력 데이터베이스의 전체 내용 삭제."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "데이터베이스 삭제"; help = "플레이어 체력 데이터베이스의 전체 내용 삭제."; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "다음 품질의 몬스터 전리품 아이템 데이터 기록:"; help = "모든 몬스터에 대한 전리품 아이템 세부 정보 기록을 활성화.";
info = "기록할 아이템의 품질 수준을 선택할 수 있습니다."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "기본 몬스터 정보 기록"; help = "기본 몬스터 정보 세트 기록.";
info = "기본 몬스터 정보에는 몬스터 유형, 카운터가 포함됩니다:\n전리품, 빈 전리품, 천, 돈, 아이템 가치, 아이템 품질 개요." }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "캐릭터별 몬스터 데이터 기록"; help = "모든 캐릭터별 몬스터 데이터 기록.";
info = "이것은 다음 데이터의 저장을 활성화 또는 비활성화합니다:\n처치 횟수, 최소/최대 피해, DPS 및 몬스터 경험치.\n\n이 데이터는 각 캐릭터별로 별도로 저장됩니다." }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "몬스터 위치 데이터 기록"; help = "몬스터를 찾을 수 있는 구역 기록." }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "저항 및 면역 데이터 기록"; help = "마법 계열에 대한 몬스터 저항 및 면역 데이터 기록.";
info = "마법 계열의 경우 MobInfo는 계열당 성공적으로 적중한 주문 수\n대 저항된 주문 수를 기록합니다."; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "선택한 품질 이상의 전리품 아이템 세부 정보 기록.";
choice1 = "|cff888888회색|r 이상"; choice2="흰색 이상"; choice3="|cff00ff00초록색|r 이상" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888빈약|r"; help = "몬스터 툴팁에 빈약(회색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffff일반|r"; help = "몬스터 툴팁에 일반(흰색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00고급|r"; help = "몬스터 툴팁에 고급(초록색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ff희귀|r"; help = "몬스터 툴팁에 희귀(파란색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ff영웅|r"; help = "몬스터 툴팁에 영웅(보라색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000전설|r"; help = "몬스터 툴팁에 전설(주황색) 품질 아이템 표시."; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "몬스터 데이터베이스 크기 최소화"; help = "불필요한 데이터를 제거하여 몬스터 데이터베이스 크기 최소화.";
info = "불필요한 데이터는 기록되지 않는 것으로 표시된 모든 데이터베이스 데이터입니다."; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "가져오기 시작"; help = "외부 몬스터 데이터베이스를 자신의 데이터베이스로 가져오기.";
info = "중요: 가져오기 지침을 읽으십시오!\n가져오기 전에 항상 자신의 몬스터 데이터베이스를 백업하십시오!"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "삭제"; help = "검색 결과 목록의 모든 몬스터를 MobInfo 데이터베이스에서 삭제.";
info = "경고: 이 작업은 취소할 수 없습니다.\n주의해서 사용하십시오!\n몬스터를 삭제하기 전에 MobInfo 데이터베이스를 백업하는 것이 좋습니다."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "알 수 없는 몬스터만 가져오기"; help = "자신의 데이터베이스에 없는 몬스터만 가져오기.";
info = "이 옵션을 활성화하면 기존 몬스터의 데이터가 수정되는 것을 방지합니다.\n알 수 없는(새로운) 몬스터만 가져옵니다.\n이를 통해 일관성 문제를 일으키지 않고\n부분적으로 겹치는 데이터베이스를 가져올 수 있습니다."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "툴팁"; help = "툴팁에 몬스터 정보를 표시하기 위한 옵션 설정."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "체력/마나"; help = "타겟 프레임에서 체력/마나를 표시하기 위한 옵션 설정."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "데이터베이스"; help = "데이터베이스 관리 옵션."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "검색"; help = "데이터베이스 검색."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "몬스터 목록"; help = "데이터베이스의 모든 몬스터 나열."; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "아이템 목록"; help = "데이터베이스의 모든 아이템 나열."; }

MI_TXT_PFQUEST_RESOLVED		= "pfQuest 이름 해석: %d 몬스터가 ID로 해석됨"
MI_TXT_PFQUEST_AMBIGUOUS	= ", %d 건너뜀 (모호한 이름)"
MI_TXT_PFQUEST_NOTFOUND		= ", %d pfQuest DB에서 찾을 수 없음"
MI_TXT_RANK_COMPLETE		= "등급 해석 완료: %d 생물이 업데이트되었습니다."
MI_TXT_RANK_PENDING			= "등급 해석: %d 생물 업데이트 중 (%d 캐시 대기 중). 잠시 시간이 걸릴 수 있습니다."
