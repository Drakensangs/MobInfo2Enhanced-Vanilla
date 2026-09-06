if not C_Item then return end
if GetLocale() ~= "esES" then return end

-- Spanish (esES)

MI_DESCRIPTION = "Añade información sobre criaturas en la información emergente y muestra información de vida/maná en el marco del objetivo"

MI2_SpellSchools = { Arcane="ar", Fire="fu", Frost="hi", Shadow="so", Holy="sa", Nature="na" }

MI_TXT_GOLD   = " Oro"
MI_TXT_SILVER = " Plata"
MI_TXT_COPPER = " Cobre"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  Opciones"
MI_TXT_WELCOME			= "Bienvenido a MobInfo 2"
MI_TXT_OPEN				= "Abrir"
MI_TXT_CLASS			= "Clase "
MI_TXT_HEALTH			= "Vida "
MI_TXT_MANA				= "Maná "
MI_TXT_XP				= "XP "
MI_TXT_KILLS			= "Muertes "
MI_TXT_DAMAGE			= "Daño + [DPS] "
MI_TXT_TIMES_LOOTED		= "Veces saqueado "
MI_TXT_EMPTY_LOOTS		= "Saqueos vacíos "
MI_TXT_TO_LEVEL			= "# para subir"
MI_TXT_QUALITY			= "Calidad "
MI_TXT_CLOTH_DROP		= "Drops de tela "
MI_TXT_COIN_DROP		= "Drop medio de monedas "
MI_TEXT_ITEM_VALUE		= "Valor medio de objeto "
MI_TXT_MOB_VALUE		= "Valor total de la criatura "
MI_TXT_MOB_DB_SIZE		= "Tamaño de la base de datos MobInfo:  "
MI_TXT_HEALTH_DB_SIZE	= "Tamaño de la base de datos de vida:  "
MI_TXT_PLAYER_DB_SIZE	= "Tamaño de la base de datos de vida del jugador:  "
MI_TXT_ITEM_DB_SIZE		= "Tamaño de la base de datos de objetos:  "
MI_TXT_CUR_TARGET		= "Objetivo actual:  "
MI_TXT_USAGE			= " Uso: introduce /mobinfo2 o /mi2 para abrir la interfaz"
MI2_TXT_MINIMAP_TIP1	= "Clic izquierdo para abrir el menú de MobInfo2."
MI2_TXT_MINIMAP_TIP2	= "Mantener clic derecho para mover el botón del minimapa."
MI_TXT_MH_DISABLED		= "MobInfo AVISO: Se ha encontrado el AddOn MobHealth separado. La funcionalidad interna de MobHealth está desactivada hasta que se elimine el AddOn MobHealth separado."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n NO perderás tus datos al desactivar MobHealth separado.\n\nBeneficios: pantalla de vida/maná movible con soporte de porcentaje y fuente y tamaño ajustables")
MI_TXT_CLR_ALL_CONFIRM	= "¿Realmente deseas realizar la siguiente operación de borrado: "
MI_TXT_SEARCH_LEVEL		= "Nivel de criatura:"
MI_TXT_SEARCH_MOBTYPE	= "Tipo de criatura:"
MI_TXT_SEARCH_LOOTS		= "Criatura saqueada:"
MI_TXT_TRIM_DOWN_CONFIRM = "AVISO: esto es una eliminación permanente e inmediata. ¿Realmente deseas eliminar todos los datos de criatura no seleccionados como registrados?"
MI_TXT_CLAM_MEAT		= "Carne de almeja"
MI_TXT_SHOWING			= "La lista muestra: "
MI_TXT_DROPPED_BY		= "Conseguido de:"
MI_TXT_DROPPED_BY_MANY	= "Conseguido de %d criaturas:"
MI_TXT_LOCATION			= "Ubicación: "
MI_TXT_IMMUNE			= "Inmune"
MI_TXT_RESIST			= "Resistencia"
MI_TXT_DEL_SEARCH_CONFIRM = "¿Realmente deseas ELIMINAR las %d criaturas de la lista de resultados de la base de datos MobInfo?"

MI2_CHATMSG_MONSTEREMOTE = "intenta huir"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "Abrir opciones de MobInfo2"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "Contenido de información emergente de criatura"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Opciones de vida de criatura"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Opciones de base de datos"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Valor de vida"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Valor de maná"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Opciones de búsqueda"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "Nivel de criatura"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "Calidad de objeto de botín"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "Calidad de objeto de botín"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Información emergente de objeto"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Importar base de datos MobInfo externa"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "Mín"; help = "Nivel mínimo de criatura para las opciones de búsqueda."; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "Máx"; help = "Nivel máximo de criatura para las opciones de búsqueda (debe ser < 66)."; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "Normal"; help = "Incluir criaturas de tipo Normal en los resultados de búsqueda."; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "Raro"; help = "Incluir criaturas de tipo Raro en los resultados de búsqueda."; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "Élite"; help = "Incluir criaturas de tipo Élite en los resultados de búsqueda."; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "Jefe"; help = "Incluir criaturas de tipo Jefe en los resultados de búsqueda."; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "Mín"; help = "Número mínimo de veces que la criatura debe haber sido saqueada."; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "Nombre de criatura"; help = "Nombre parcial o completo de la criatura a buscar.";
info = 'Dejar vacío para no restringir la búsqueda a criaturas específicas.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "Nombre de objeto"; help = "Nombre parcial o completo del objeto a buscar.";
info = 'Dejar vacío para buscar todos los nombres de objetos.'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "Ordenar por beneficio"; help = "Ordenar la lista de resultados por beneficio de criatura.";
info = 'Ordenar las criaturas por el beneficio que puedes obtener al matarlas.'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "Ordenar por cantidad de objetos"; help = "Ordenar la lista de resultados por cantidad de objetos.";
info = 'Ordenar las criaturas por cuántos objetos especificados dejan caer.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "Listar criaturas en información de objeto"; help = "Mostrar nombres de criaturas que dejan caer un objeto en la información emergente.";
info = "Listar los nombres de todas las criaturas que dejan caer un objeto al pasar el cursor\nen la información emergente del objeto. Para cada objeto indicar la cantidad\ndejada caer por la criatura junto con el porcentaje." }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "Desactivar información emergente"; help = "Desactivar la visualización de información de criatura en las informaciones emergentes.";
info = "Esto desactivará completamente la información del addon tanto en la información emergente\nde criatura como en la de objeto." }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "Clase de criatura"; help = "Mostrar información de clase de criatura."; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "Vida"; help = "Mostrar información de vida de criatura (actual/máx).\nEl registro de datos de vida debe estar ACTIVADO para que funcione."; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "Maná"; help = "Mostrar información de maná/rabia/energía de criatura (actual/máx)."; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "XP"; help = "Muestra el número de puntos de experiencia que da una criatura.";
info = "Este es el último valor real de XP que la criatura te dio.\nNo se muestra para criaturas triviales." }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "Número para subir"; help = "Muestra el número de muertes necesarias para subir de nivel.";
info = "Esto muestra cuántas veces tienes que matar a la misma criatura para subir de nivel.\nNo se muestra para criaturas triviales." }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "Daño / DPS"; help = "Mostrar rango de daño de criatura (Mín/Máx) y DPS.";
info = "El rango de daño y los DPS se calculan y almacenan por separado por personaje.\nLos DPS se actualizan lentamente pero progresivamente con cada combate." }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "Matado"; help = "Mostrar el número de veces que has matado a una criatura.";
info = "El contador de muertes se calcula y almacena\npor separado por personaje." }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "Saqueado"; help = "Mostrar el número de veces que una criatura ha sido saqueada."; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "Recogidas de tela"; help = "Mostrar cuántas veces la criatura ha dado tela como botín."; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "Saqueos vacíos"; help = "Mostrar el número de cadáveres vacíos encontrados (número/porcentaje).";
info = "Este contador se incrementa cuando abres un cadáver\nque no tiene botín." }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "Valor total"; help = "Mostrar el valor medio total de la criatura.";
info = "Es la suma del drop medio de monedas y\nel valor medio de los objetos." }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "Drop de monedas"; help = "Mostrar el drop medio de monedas por criatura.";
info = "El valor total de monedas se acumula y divide por\nel contador de saqueos. No se muestra si el número de monedas es 0." }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "Valor de objeto"; help = "Mostrar el valor medio de objeto por criatura.";
info = "El valor total de objetos se acumula y divide por\nel contador de saqueos. No se muestra si el valor de objeto es 0." }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "Resumen de calidad de botín"; help = "Mostrar contadores de calidad de botín y porcentaje.";
info = "Cuenta cuántos objetos de las 6 categorías de rareza\nha dejado caer la criatura. Las categorías con 0 drops no se muestran.\nEl porcentaje es la probabilidad de obtener un objeto\nde la rareza específica como botín." }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "Ubicación de criatura"; help = "Muestra las ubicaciones donde se puede encontrar una criatura.\nSe pueden registrar hasta 4 ubicaciones por criatura.";
info = "El registro de datos de ubicación debe estar ACTIVADO para que funcione."; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "Lista básica de objetos de botín"; help = "Mostrar los nombres y cantidad de todos los objetos de botín básicos.";
info = "Los objetos de botín básicos son todos excepto tela, desollado y botín de misión.\nEl registro de datos de objetos de botín debe estar ACTIVADO para que funcione."; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "Botín de tela y desollado"; help = "Mostrar nombres y cantidad de todos los objetos de tela y desollado.";
info = "El registro de datos de objetos de botín debe estar ACTIVADO para que funcione."; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "Botín de misión"; help = "Mostrar nombres y cantidad de todos los objetos de botín de misión.";
info = "El registro de datos de objetos de botín debe estar ACTIVADO para que funcione."; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "Resistencias e inmunidades"; help = "Mostrar resistencias e inmunidades de criatura.";
info = "Las resistencias e inmunidades de escuela de magia se calculan basándose en el número\nde golpes de hechizo exitosos versus resistidos.\nEl registro de datos de resistencia e inmunidad debe estar ACTIVADO." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "Indicador de criatura huyendo"; help = "Mostrar indicador para criaturas que huyen con poca vida.";
info = "El indicador es una línea de mensaje rojo que se muestra\nsolamente para las criaturas que huyen." }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Información emergente compacta"; help = "Activa un diseño compacto con 2 valores por línea.";
info = "La información emergente compacta usa textos cortos y abreviados.\nPara desactivar una línea, ambas entradas de esa línea deben estar desactivadas." }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "Combinar criaturas iguales"; help = "Combinar datos para criaturas con el mismo ID.";
info = "El modo combinado acumula los datos para criaturas con\nel mismo ID pero diferente nivel." }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "Mantener ALT para información"; help = "Mostrar información de criatura en la información emergente solo cuando se mantiene ALT."; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "Mostrar líneas en blanco"; help = "Mostrar líneas en blanco en la información emergente.";
info = "Las líneas en blanco mejoran la legibilidad\ncreando secciones en la información emergente." }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "Limitar información a 30 líneas"; help = "Limitar la información emergente a un máximo de 30 líneas.";
info = "Evita que la información emergente crezca excesivamente en criaturas\ncon muchos drops. Las líneas más allá de 30 no se muestran." }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "Filtro de objeto de botín"; help = "Establecer expresión de filtro para la visualización de objetos de botín.";
info = "Mostrar solo los objetos de botín en la información emergente que contengan\nel texto del filtro. Ej. introducir 'tela' mostrará solo objetos con\n'tela' en el nombre.\nNo introducir nada para ver todos los objetos." }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "Registrar datos de vida de criatura"; help = "Registrar datos de vida de criatura para mostrar en la información emergente.";
info = "Cuando está activado, MobInfo registra la vida de las criaturas encontradas.\nDesactivar detiene el registro o actualización de datos de vida.\nLa opción de información emergente de vida requiere que esto esté activado." }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "Registrar datos de vida del jugador"; help = "Registrar datos de vida del jugador durante una sesión.";
info = "Cuando está activado, MobInfo sigue los datos de vida de jugadores encontrados en PvP.\nEstos datos normalmente se descartan al final de la sesión.\nDesactivar para detener completamente el registro." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "Guardar datos de vida del jugador permanentemente"; help = "Almacenar permanentemente los datos de vida del jugador de batallas PvP.";
info = "Normalmente los datos de vida de combates PvP se descartan después\nde una sesión. Esta opción retiene esos datos." }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "Todo activo"; help = "Poner todas las opciones de visualización de MobInfo en activo."; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "Todo inactivo"; help = "Poner todas las opciones de visualización de MobInfo en inactivo."; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "Mínimo"; help = "Mostrar un mínimo de información útil sobre criaturas."; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "Por defecto"; help = "Mostrar un conjunto por defecto de información útil sobre criaturas."; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "Mostrar botón de minimapa"; help = "Mostrar u ocultar el botón de minimapa de MobInfo2.";
info = "Activa o desactiva el botón de minimapa que te permite\nabrir el menú de opciones de MobInfo2 con un solo clic." }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "Hecho"; help = "Cerrar el panel de opciones de MobInfo."; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "Mostrar valor de vida"; help = "Mostrar valor de vida en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "Mostrar valor de maná"; help = "Mostrar valor de maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "Mostrar porcentaje"; help = "Añadir porcentaje a la vida en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "Mostrar porcentaje"; help = "Añadir porcentaje al maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "Abreviar valores"; help = "Mostrar valores de vida y maná como números abreviados."; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "Posición horizontal"; help = "Ajustar posición horizontal de la vida en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "Posición vertical"; help = "Ajustar posición vertical de la vida en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "Posición horizontal"; help = "Ajustar posición horizontal del maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "Posición vertical"; help = "Ajustar posición vertical del maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "Fuente"; help = "Establecer fuente para valores de vida/maná en el marco del objetivo.";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "Tamaño de fuente"; help = "Establecer tamaño de fuente para valores de vida/maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "Eliminar datos del objetivo"; help = "Eliminar los datos del objetivo actual de la base de datos."; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "Eliminar base de datos"; help = "Eliminar todo el contenido de la base de datos de información de criaturas."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "Eliminar base de datos"; help = "Eliminar todo el contenido de la base de datos de vida de criaturas."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "Eliminar base de datos"; help = "Eliminar todo el contenido de la base de datos de vida del jugador."; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "Registrar datos de objetos de botín para calidad:"; help = "Activar para registrar detalles de objetos de botín para todas las criaturas.";
info = "Puedes elegir el nivel de calidad de los objetos a registrar."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "Registrar información básica de criatura"; help = "Registrar un conjunto de información básica de criatura.";
info = "La información básica incluye: tipo de criatura, contadores para:\nbotín, botín vacío, tela, dinero, valor de objetos, resumen de calidad." }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "Registrar datos específicos del personaje"; help = "Registrar todos los datos de criatura específicos del personaje.";
info = "Esto activa o desactiva el guardado de los siguientes datos:\nnúmero de muertes, daño mín/máx, DPS y XP de criatura.\n\nEstos datos se guardan por separado para cada personaje." }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "Registrar datos de ubicación de criatura"; help = "Registrar la(s) zona(s) donde se puede encontrar la criatura." }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "Registrar datos de resistencias e inmunidades"; help = "Registrar datos sobre resistencias e inmunidades de criatura a escuelas de magia.";
info = "Para escuelas de magia, MobInfo registra cuántos hechizos por escuela\ngolpean con éxito versus cuántos son resistidos."; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "Registrar detalles de objetos para la calidad seleccionada y mejor.";
choice1 = "|cff888888Gris|r & Mejor"; choice2="Blanco & Mejor"; choice3="|cff00ff00Verde|r & Mejor" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888Pobre|r"; help = "Mostrar objetos de calidad Pobre (gris) en la información emergente."; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffffComún|r"; help = "Mostrar objetos de calidad Común (blanco) en la información emergente."; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00Poco común|r"; help = "Mostrar objetos de calidad Poco común (verde) en la información emergente."; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ffRaro|r"; help = "Mostrar objetos de calidad Raro (azul) en la información emergente."; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ffÉpico|r"; help = "Mostrar objetos de calidad Épico (morado) en la información emergente."; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000Legendario|r"; help = "Mostrar objetos de calidad Legendario (naranja) en la información emergente."; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "Minimizar tamaño de base de datos"; help = "Minimizar el tamaño de la base de datos eliminando datos superfluos.";
info = "Los datos superfluos son todos los datos dentro de la base de datos que no están\nmarcados como siendo registrados."; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "Iniciar importación"; help = "Importar una base de datos de criaturas externa en la tuya propia.";
info = "IMPORTANTE: ¡lee las instrucciones de importación!\n¡SIEMPRE haz una copia de seguridad de tu base de datos antes de importar!"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "ELIMINAR"; help = "Elimina todas las criaturas de la lista de resultados de la base de datos MobInfo.";
info = "AVISO: esta operación no se puede deshacer.\n¡Por favor úsala con cuidado!\nEs recomendable hacer una copia de seguridad antes de eliminar criaturas."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "Importar solo criaturas desconocidas"; help = "Importar solo criaturas que no existen en tu propia base de datos.";
info = "Activar esta opción evita que se modifiquen los datos de criaturas existentes.\nSolo se importarán criaturas desconocidas (nuevas). Esto permite\nimportar bases de datos parcialmente superpuestas sin causar\nproblemas de coherencia."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "Información"; help = "Configurar opciones para mostrar información de criatura en información emergente."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "Vida/Maná"; help = "Configurar opciones para mostrar vida/maná en el marco del objetivo."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "Base de datos"; help = "Opciones de gestión de base de datos."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "Búsqueda"; help = "Buscar en la base de datos."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "Lista de criaturas"; help = "Lista todas las criaturas en la base de datos."; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "Lista de objetos"; help = "Lista todos los objetos en la base de datos."; }

MI_TXT_PFQUEST_RESOLVED		= "Resolución de nombre pfQuest: %d criatura(s) resuelta(s) a ID"
MI_TXT_PFQUEST_AMBIGUOUS	= ", %d omitida(s) (nombre ambiguo)"
MI_TXT_PFQUEST_NOTFOUND		= ", %d no encontrada(s) en la base de datos pfQuest"
MI_TXT_RANK_COMPLETE		= "Resolución de rango completa: %d criatura(s) actualizada(s)."
MI_TXT_RANK_PENDING			= "Resolución de rango: actualizando %d criatura(s) (%d en espera de caché). Esto puede tomar un momento."
