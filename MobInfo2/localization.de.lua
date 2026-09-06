if not C_Item then return end
if GetLocale() ~= "deDE" then return end

-- German (deDE)

MI_DESCRIPTION = "Fügt dem Tooltip Informationen über Gegner hinzu und zeigt Lebens-/Manainfos im Ziel-Rahmen an"

MI2_SpellSchools = { Arcane="ma", Fire="fe", Frost="fr", Shadow="sc", Holy="he", Nature="na" }

MI_TXT_GOLD   = " Gold"
MI_TXT_SILVER = " Silber"
MI_TXT_COPPER = " Kupfer"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  Optionen"
MI_TXT_WELCOME			= "Willkommen bei MobInfo 2"
MI_TXT_OPEN				= "Öffnen"
MI_TXT_CLASS			= "Klasse "
MI_TXT_HEALTH			= "Leben "
MI_TXT_MANA				= "Mana "
MI_TXT_XP				= "EP "
MI_TXT_KILLS			= "Kills "
MI_TXT_DAMAGE			= "Schaden + [DPS] "
MI_TXT_TIMES_LOOTED		= "Mal geplündert "
MI_TXT_EMPTY_LOOTS		= "Leere Plünderungen "
MI_TXT_TO_LEVEL			= "# zum Aufsteigen"
MI_TXT_QUALITY			= "Qualität "
MI_TXT_CLOTH_DROP		= "Stoff-Drops "
MI_TXT_COIN_DROP		= "Ø Münzabwurf "
MI_TEXT_ITEM_VALUE		= "Ø Gegenstandswert "
MI_TXT_MOB_VALUE		= "Gesamtwert des Gegners "
MI_TXT_MOB_DB_SIZE		= "MobInfo-Datenbankgröße:  "
MI_TXT_HEALTH_DB_SIZE	= "Lebenspunkte-Datenbankgröße:  "
MI_TXT_PLAYER_DB_SIZE	= "Spieler-Lebenspunkte-Datenbankgröße:  "
MI_TXT_ITEM_DB_SIZE		= "Gegenstands-Datenbankgröße:  "
MI_TXT_CUR_TARGET		= "Aktuelles Ziel:  "
MI_TXT_USAGE			= " Verwendung: /mobinfo2 oder /mi2 eingeben, um die Oberfläche zu öffnen"
MI2_TXT_MINIMAP_TIP1	= "Linksklick zum Öffnen des MobInfo2-Menüs."
MI2_TXT_MINIMAP_TIP2	= "Rechtsklick halten zum Bewegen des Minimap-Buttons."
MI_TXT_MH_DISABLED		= "MobInfo WARNUNG: Separates MobHealth-AddOn gefunden. Die interne MobHealth-Funktionalität ist deaktiviert, bis das separate MobHealth-AddOn entfernt wird."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n Deine Daten gehen beim Deaktivieren des separaten MobHealth NICHT verloren.\n\nVorteile: bewegliche Lebens-/Manaanzeige mit Prozentanzeige und einstellbarer Schriftart und -größe")
MI_TXT_CLR_ALL_CONFIRM	= "Möchtest du wirklich die folgende Löschoperation durchführen: "
MI_TXT_SEARCH_LEVEL		= "Gegnerstufe:"
MI_TXT_SEARCH_MOBTYPE	= "Gegnertyp:"
MI_TXT_SEARCH_LOOTS		= "Gegner geplündert:"
MI_TXT_TRIM_DOWN_CONFIRM = "WARNUNG: Dies ist eine sofortige und dauerhafte Löschung. Möchtest du wirklich alle nicht ausgewählten Gegnerdaten löschen?"
MI_TXT_CLAM_MEAT		= "Muschellfleisch"
MI_TXT_SHOWING			= "Liste zeigt: "
MI_TXT_DROPPED_BY		= "Fallengelassen von:"
MI_TXT_DROPPED_BY_MANY	= "Fallengelassen von %d Gegnern:"
MI_TXT_LOCATION			= "Ort: "
MI_TXT_IMMUNE			= "Immun"
MI_TXT_RESIST			= "Resistenz"
MI_TXT_DEL_SEARCH_CONFIRM = "Möchtest du wirklich die %d Gegner aus der Suchergebnisliste aus der MobInfo-Datenbank LÖSCHEN?"

MI2_CHATMSG_MONSTEREMOTE = "versucht zu fliehen"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "MobInfo2-Optionen öffnen"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "Gegner-Tooltip-Inhalt"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Gegner-Lebensoptionen"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Datenbankoptionen"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Lebenswert"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Manawert"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Suchoptionen"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "Gegnerstufe"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "Beute-Gegenstandsqualität"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "Beute-Gegenstandsqualität"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Gegenstands-Tooltip"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Externe MobInfo-Datenbank importieren"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "Min"; help = "Mindeststufe des Gegners für Suchoptionen."; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "Max"; help = "Höchststufe des Gegners für Suchoptionen (muss < 66 sein)."; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "Normal"; help = "Normale Gegner in Suchergebnissen einschließen."; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "Selten"; help = "Seltene Gegner in Suchergebnissen einschließen."; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "Elite"; help = "Elite-Gegner in Suchergebnissen einschließen."; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "Boss"; help = "Boss-Gegner in Suchergebnissen einschließen."; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "Min"; help = "Mindestanzahl, wie oft der Gegner geplündert worden sein muss."; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "Gegnername"; help = "Teilweiser oder vollständiger Gegnername für die Suche.";
info = 'Leer lassen, um die Suche nicht auf bestimmte Gegner einzuschränken.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "Gegenstandsname"; help = "Teilweiser oder vollständiger Gegenstandsname für die Suche.";
info = 'Leer lassen, um alle Gegenstandsnamen zu durchsuchen.'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "Nach Gewinn sortieren"; help = "Suchergebnisliste nach Gegnergewinn sortieren.";
info = 'Gegner nach dem Gewinn sortieren, den du durch das Töten erzielen kannst.'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "Nach Gegenstandsanzahl sortieren"; help = "Suchergebnisliste nach Gegenstandsanzahl sortieren.";
info = 'Gegner danach sortieren, wie viele der angegebenen Gegenstände sie fallen lassen.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "Gegner im Gegenstands-Tooltip auflisten"; help = "Namen der Gegner, die einen Gegenstand fallen lassen, im Tooltip anzeigen.";
info = "Namen aller Gegner auflisten, die einen gehoverten Gegenstand fallen lassen,\nim Gegenstands-Tooltip. Für jeden Gegenstand die gefallene Menge\nmit Prozentsatz auflisten." }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "Tooltip-Info deaktivieren"; help = "Anzeige von Gegnerinformationen in Tooltips deaktivieren.";
info = "Dies deaktiviert vollständig die Addon-Informationen sowohl im Gegner-Tooltip\nals auch im Gegenstands-Tooltip." }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "Gegnerklasse"; help = "Gegnerklasseninformationen anzeigen."; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "Leben"; help = "Gegnerlebensinfos anzeigen (aktuell/max).\nDas Aufzeichnen von Gegnerlebensdaten muss AKTIVIERT sein, damit dies funktioniert."; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "Mana"; help = "Gegner-Mana/Wut/Energie-Infos anzeigen (aktuell/max)."; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "EP"; help = "Zeigt die Erfahrungspunkte an, die ein Gegner gibt.";
info = "Dies ist der tatsächliche letzte EP-Wert, den der Gegner dir gegeben hat.\nNicht für triviale Gegner angezeigt." }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "Anzahl zum Aufsteigen"; help = "Zeigt die Anzahl der Kills an, die zum Aufstieg benötigt werden.";
info = "Zeigt an, wie oft du denselben Gegner töten musst, um aufzusteigen.\nNicht für triviale Gegner angezeigt." }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "Schaden / DPS"; help = "Gegner-Schadensbereich (Min/Max) und DPS anzeigen.";
info = "Schadensbereich und DPS werden separat pro Charakter berechnet und gespeichert.\nDPS wird langsam, aber progressiv mit jedem Kampf aktualisiert." }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "Getötet"; help = "Anzahl der Male anzeigen, die du einen Gegner getötet hast.";
info = "Der Kill-Zähler wird separat\npro Charakter berechnet und gespeichert." }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "Geplündert"; help = "Anzahl der Male anzeigen, die ein Gegner geplündert wurde."; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "Stoff-Aufnahmen"; help = "Anzeigen, wie oft der Gegner Stoff als Beute gegeben hat."; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "Leere Plünderungen"; help = "Anzahl der gefundenen leeren Leichen anzeigen (Anzahl/Prozent).";
info = "Dieser Zähler wird erhöht, wenn du eine Leiche öffnest,\ndie keine Beute enthält." }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "Gesamtwert"; help = "Gesamten durchschnittlichen Gegnerwert anzeigen.";
info = "Dies ist die Summe aus durchschnittlichem Münzabwurf und\ndurchschnittlichem Gegenstandswert." }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "Münzabwurf"; help = "Durchschnittlichen Münzabwurf pro Gegner anzeigen.";
info = "Der gesamte Münzwert wird aufaddiert und durch\nden Plünderungszähler geteilt. Nicht angezeigt, wenn Münzanzahl 0 ist." }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "Gegenstandswert"; help = "Durchschnittlichen Gegenstandswert pro Gegner anzeigen.";
info = "Der gesamte Gegenstandswert wird aufaddiert und durch\nden Plünderungszähler geteilt. Nicht angezeigt, wenn Gegenstandswert 0 ist." }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "Beute-Qualitätsübersicht"; help = "Beute-Qualitätszähler und Prozentsatz anzeigen.";
info = "Zählt, wie viele Gegenstände aus den 6 Seltenheitskategorien\nder Gegner fallen gelassen hat. Kategorien mit 0 Drops werden nicht\nangezeigt. Der Prozentsatz ist die Chance, einen Gegenstand\nder jeweiligen Seltenheit als Beute zu erhalten." }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "Gegnerort"; help = "Zeigt die Orte an, wo ein Gegner gefunden werden kann.\nBis zu 4 Orte können pro Gegner aufgezeichnet werden.";
info = "Das Aufzeichnen von Ortsdaten muss AKTIVIERT sein, damit dies funktioniert."; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "Basis-Beutegegenstandsliste"; help = "Namen und Anzahl aller Basis-Beutegegenstände anzeigen.";
info = "Basis-Beutegegenstände sind alle Beutegegenstände außer Stoff-, Abzieh- und Questbeute.\nDas Aufzeichnen von Beutegegenstandsdaten muss AKTIVIERT sein, damit dies funktioniert."; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "Stoff- & Abziehbeute"; help = "Namen und Anzahl aller Stoff- & Abziehbeutegegenstände anzeigen.";
info = "Das Aufzeichnen von Beutegegenstandsdaten muss AKTIVIERT sein, damit dies funktioniert."; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "Questbeute"; help = "Namen und Anzahl aller Questbeutegegenstände anzeigen.";
info = "Das Aufzeichnen von Beutegegenstandsdaten muss AKTIVIERT sein, damit dies funktioniert."; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "Resistenzen und Immunitäten"; help = "Gegner-Resistenzen und -Immunitäten anzeigen.";
info = "Zauberschulresistenzen und -immunitäten werden basierend auf der Anzahl\nerfolgreicher versus resistierter Zaubertreffer berechnet.\nDas Aufzeichnen von Resistenz- und Immunitätsdaten muss AKTIVIERT sein." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "Fliehender-Gegner-Anzeige"; help = "Anzeige für Gegner anzeigen, die bei niedrigen Lebenspunkten fliehen.";
info = "Die Anzeige ist eine rote Nachrichtenzeile, die nur\nfür fliehende Gegner angezeigt wird." }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Kompakter Gegner-Tooltip"; help = "Aktiviert ein kompaktes Gegner-Tooltip-Layout mit 2 Werten pro Tooltip-Zeile.";
info = "Kompakter Tooltip verwendet kurze, abgekürzte Texte für die Tooltip-Beschreibungen.\nUm eine Tooltip-Zeile zu deaktivieren, müssen beide Einträge in dieser Zeile deaktiviert werden." }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "Gleiche Gegner zusammenfassen"; help = "Daten für Gegner mit derselben ID zusammenfassen.";
info = "Der kombinierte Modus summiert die Daten für Gegner mit\nderselben ID, aber unterschiedlicher Stufe." }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "ALT-Taste für Gegnerinfos halten"; help = "Gegnerinfos im Tooltip nur anzeigen, wenn die ALT-Taste gehalten wird."; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "Leerzeilen anzeigen"; help = "Leerzeilen im Tooltip anzeigen.";
info = "Leerzeilen sollen die Lesbarkeit verbessern,\nindem Abschnitte im Tooltip erstellt werden." }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "Tooltip auf 30 Zeilen begrenzen"; help = "Den Gegner-Tooltip auf maximal 30 Zeilen begrenzen.";
info = "Verhindert, dass der Tooltip bei Gegnern mit vielen Gegenstandsdrops übermäßig groß wird.\nGegenstandszeilen über 30 werden nicht angezeigt." }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "Beutegegenstand-Filter"; help = "Filterausdruck für die Beutegegenstandsanzeige in Tooltips festlegen.";
info = "Nur die Beutegegenstände im Gegner-Tooltip anzeigen, die den\nFiltertext enthalten. Z.B. 'Stoff' eingeben, um nur Gegenstände mit\n'Stoff' im Namen anzuzeigen.\nNichts eingeben, um alle Gegenstände zu sehen." }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "Gegner-Lebensdaten aufzeichnen"; help = "Gegner-Lebensdaten für die Anzeige im Tooltip aufzeichnen.";
info = "Wenn aktiviert, zeichnet MobInfo die Lebenspunkte der angetroffenen Gegner auf.\nDeaktivieren verhindert, dass Lebensdaten aufgezeichnet oder aktualisiert werden.\nDie Lebens-Tooltip-Option erfordert, dass dies aktiviert ist." }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "Spieler-Lebensdaten aufzeichnen"; help = "Spieler-Lebensdaten während einer Sitzung aufzeichnen. Werden beim Ausloggen\ngelöscht, es sei denn, das dauerhafte Speichern ist ebenfalls aktiviert.";
info = "Wenn aktiviert, verfolgt MobInfo Lebensdaten von Spielern, die im PvP angetroffen werden.\nDiese Daten werden normalerweise am Ende einer Sitzung verworfen.\nDeaktivieren, um das Aufzeichnen von Spieler-Lebensdaten vollständig zu stoppen." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "Spieler-Lebensdaten dauerhaft speichern"; help = "Spieler-Lebensdaten aus PvP-Kämpfen dauerhaft speichern.";
info = "Normalerweise werden Spieler-Lebensdaten aus PvP-Kämpfen nach\neiner Sitzung verworfen. Diese Option behält diese Daten bei." }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "Alle AN"; help = "Alle MobInfo-Anzeigeoptionen auf AN stellen."; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "Alle AUS"; help = "Alle MobInfo-Anzeigeoptionen auf AUS stellen."; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "Minimal"; help = "Ein Minimum an nützlichen Gegnerinfos anzeigen."; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "Standard"; help = "Einen Standardsatz nützlicher Gegnerinfos anzeigen."; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "Minimap-Button anzeigen"; help = "Den MobInfo2-Minimap-Button anzeigen oder ausblenden.";
info = "Aktiviert oder deaktiviert den Minimap-Button, mit dem du\ndas MobInfo2-Optionsmenü mit einem einzigen Klick öffnen kannst." }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "Fertig"; help = "Den MobInfo-Optionsrahmen schließen."; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "Lebenswert anzeigen"; help = "Lebenswert im Zielrahmen anzeigen."; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "Manawert anzeigen"; help = "Manawert im Zielrahmen anzeigen."; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "Prozent anzeigen"; help = "Prozentangabe zum Leben im Zielrahmen hinzufügen."; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "Prozent anzeigen"; help = "Prozentangabe zum Mana im Zielrahmen hinzufügen."; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "Werte abkürzen"; help = "Lebens- und Manawerte als abgekürzte Zahlen anzeigen."; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "Horizontale Position"; help = "Horizontale Position des Lebens im Zielrahmen anpassen."; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "Vertikale Position"; help = "Vertikale Position des Lebens im Zielrahmen anpassen."; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "Horizontale Position"; help = "Horizontale Position des Manas im Zielrahmen anpassen."; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "Vertikale Position"; help = "Vertikale Position des Manas im Zielrahmen anpassen."; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "Schriftart"; help = "Schriftart für Lebens-/Manawerte im Zielrahmen festlegen.";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "Schriftgröße"; help = "Schriftgröße für Lebens-/Manawerte im Zielrahmen festlegen."; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "Zieldaten löschen"; help = "Daten des aktuellen Ziels aus der Datenbank löschen."; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "Datenbank löschen"; help = "Gesamten Inhalt der Gegner-Info-Datenbank löschen."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "Datenbank löschen"; help = "Gesamten Inhalt der Gegner-Lebenspunkte-Datenbank löschen."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "Datenbank löschen"; help = "Gesamten Inhalt der Spieler-Lebenspunkte-Datenbank löschen."; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "Gegner-Beutegegenstandsdaten für Qualität aufzeichnen:"; help = "Aktivieren, um Beutegegenstandsdetails für alle Gegner aufzuzeichnen.";
info = "Du kannst die Qualitätsstufe der aufzuzeichnenden Gegenstände wählen."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "Grundlegende Gegnerinfos aufzeichnen"; help = "Einen Satz grundlegender Gegnerinformationen aufzeichnen.";
info = "Grundlegende Gegnerinfos umfassen: Gegnertyp, Zähler für:\nBeute, leere Beute, Stoff, Geld, Gegenstandswert, Gegenstands-Qualitätsübersicht."; }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "Charakterspezifische Gegnerdaten aufzeichnen"; help = "Alle charakterspezifischen Gegnerdaten aufzeichnen.";
info = "Dies aktiviert oder deaktiviert das Speichern der folgenden Daten:\nAnzahl der Kills, Min/Max-Schaden, DPS und Gegner-EP.\n\nDiese Daten werden separat für jeden Charakter gespeichert. Das Speichern\nkann nur für den gesamten Satz von 4 Werten aktiviert/deaktiviert werden." }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "Daten zum Gegnerort aufzeichnen"; help = "Die Zone(n) aufzeichnen, in denen der Gegner gefunden werden kann." }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "Daten über Resistenzen & Immunitäten aufzeichnen"; help = "Daten über Resistenzen und Immunitäten eines Gegners gegenüber Zauberschulen aufzeichnen.";
info = "Für Zauberschulen zeichnet MobInfo auf, wie viele Zauber pro Schule\nerfolgreich treffen im Vergleich zu denen, die resistiert werden."; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "Beutegegenstandsdetails für ausgewählte Qualität und besser aufzeichnen.";
choice1 = "|cff888888Grau|r & Besser"; choice2="Weiß & Besser"; choice3="|cff00ff00Grün|r & Besser" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888Schlecht|r"; help = "Schlechte (graue) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffffGewöhnlich|r"; help = "Gewöhnliche (weiße) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00Ungewöhnlich|r"; help = "Ungewöhnliche (grüne) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ffSelten|r"; help = "Seltene (blaue) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ffEpisch|r"; help = "Epische (lila) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000Legendär|r"; help = "Legendäre (orange) Qualitätsgegenstände im Gegner-Tooltip anzeigen."; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "Gegnerdatenbank minimieren"; help = "Gegnerdatenbankgröße durch Entfernen überflüssiger Daten minimieren.";
info = "Überflüssige Daten sind alle Daten in der Datenbank, die nicht als\naufzuzeichnend markiert sind."; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "Import starten"; help = "Eine externe Gegnerdatenbank in deine eigene importieren.";
info = "WICHTIG: Bitte die Importanweisungen lesen!\nSichere deine eigene Gegnerdatenbank IMMER BEVOR du importierst!"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "LÖSCHEN"; help = "Löscht alle Gegner in der Suchergebnisliste aus der MobInfo-Datenbank.";
info = "WARNUNG: Diese Operation kann nicht rückgängig gemacht werden.\nBitte mit Vorsicht verwenden!\nDu solltest deine MobInfo-Datenbank sichern, bevor du Gegner löschst."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "Nur unbekannte Gegner importieren"; help = "Nur Gegner importieren, die nicht in deiner eigenen Datenbank vorhanden sind.";
info = "Diese Option verhindert, dass Daten vorhandener Gegner\ngeändert werden. Nur unbekannte (neue) Gegner werden importiert.\nDies ermöglicht das Importieren teilweise überlappender Datenbanken\nohne Konsistenzprobleme zu verursachen."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "Tooltip"; help = "Optionen für die Anzeige von Gegnerinfos im Tooltip festlegen."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "Leben/Mana"; help = "Optionen für die Anzeige von Leben/Mana im Zielrahmen festlegen."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "Datenbank"; help = "Datenbankverwaltungsoptionen."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "Suche"; help = "Die Datenbank durchsuchen."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "Gegnerliste"; help = "Listet alle Gegner in der Datenbank auf."; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "Gegenstandsliste"; help = "Listet alle Gegenstände in der Datenbank auf."; }

MI_TXT_PFQUEST_RESOLVED		= "pfQuest-Namensauflösung: %d Gegner auf ID aufgelöst"
MI_TXT_PFQUEST_AMBIGUOUS	= ", %d übersprungen (mehrdeutiger Name)"
MI_TXT_PFQUEST_NOTFOUND		= ", %d nicht in pfQuest-DB gefunden"
MI_TXT_RANK_COMPLETE		= "Rangauflösung abgeschlossen: %d Kreatur(en) aktualisiert."
MI_TXT_RANK_PENDING			= "Rangauflösung: %d Kreatur(en) werden aktualisiert (%d Cache ausstehend). Dies kann einen Moment dauern."
