if not C_Item then return end
if GetLocale() ~= "frFR" then return end

-- French (frFR)

MI_DESCRIPTION = "Ajoute des informations sur les créatures dans l'infobulle et affiche les infos de vie/mana dans le cadre de la cible"

MI2_SpellSchools = { Arcane="ar", Fire="fe", Frost="fr", Shadow="om", Holy="sa", Nature="na" }

MI_TXT_GOLD   = " Or"
MI_TXT_SILVER = " Argent"
MI_TXT_COPPER = " Cuivre"

MI_TXT_CONFIG_TITLE		= "MobInfo 2  Options"
MI_TXT_WELCOME			= "Bienvenue dans MobInfo 2"
MI_TXT_OPEN				= "Ouvrir"
MI_TXT_CLASS			= "Classe "
MI_TXT_HEALTH			= "Vie "
MI_TXT_MANA				= "Mana "
MI_TXT_XP				= "XP "
MI_TXT_KILLS			= "Kills "
MI_TXT_DAMAGE			= "Dégâts + [DPS] "
MI_TXT_TIMES_LOOTED		= "Fois pillé "
MI_TXT_EMPTY_LOOTS		= "Pillages vides "
MI_TXT_TO_LEVEL			= "# pour monter"
MI_TXT_QUALITY			= "Qualité "
MI_TXT_CLOTH_DROP		= "Drops de tissu "
MI_TXT_COIN_DROP		= "Drop moyen de pièces "
MI_TEXT_ITEM_VALUE		= "Valeur moy. d'objet "
MI_TXT_MOB_VALUE		= "Valeur totale de la créature "
MI_TXT_MOB_DB_SIZE		= "Taille de la base de données MobInfo :  "
MI_TXT_HEALTH_DB_SIZE	= "Taille de la base de données de vie :  "
MI_TXT_PLAYER_DB_SIZE	= "Taille de la base de données de vie du joueur :  "
MI_TXT_ITEM_DB_SIZE		= "Taille de la base de données d'objets :  "
MI_TXT_CUR_TARGET		= "Cible actuelle :  "
MI_TXT_USAGE			= " Utilisation : entrer /mobinfo2 ou /mi2 pour ouvrir l'interface"
MI2_TXT_MINIMAP_TIP1	= "Clic gauche pour ouvrir le menu MobInfo2."
MI2_TXT_MINIMAP_TIP2	= "Maintenir le clic droit pour déplacer le bouton de la minimap."
MI_TXT_MH_DISABLED		= "MobInfo AVERTISSEMENT : AddOn MobHealth séparé trouvé. La fonctionnalité MobHealth interne est désactivée jusqu'à la suppression de l'AddOn MobHealth séparé."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n Vous ne perdrez PAS vos données en désactivant MobHealth séparé.\n\nAvantages : affichage déplaçable de vie/mana avec support de pourcentage et police et taille réglables")
MI_TXT_CLR_ALL_CONFIRM	= "Voulez-vous vraiment effectuer l'opération de suppression suivante : "
MI_TXT_SEARCH_LEVEL		= "Niveau de créature :"
MI_TXT_SEARCH_MOBTYPE	= "Type de créature :"
MI_TXT_SEARCH_LOOTS		= "Créature pillée :"
MI_TXT_TRIM_DOWN_CONFIRM = "AVERTISSEMENT : il s'agit d'une suppression permanente et immédiate. Voulez-vous vraiment supprimer toutes les données de créature non sélectionnées comme enregistrées ?"
MI_TXT_CLAM_MEAT		= "Chair de palourde"
MI_TXT_SHOWING			= "La liste montre : "
MI_TXT_DROPPED_BY		= "Obtenu de :"
MI_TXT_DROPPED_BY_MANY	= "Obtenu de %d créatures :"
MI_TXT_LOCATION			= "Emplacement : "
MI_TXT_IMMUNE			= "Immunisé"
MI_TXT_RESIST			= "Résistance"
MI_TXT_DEL_SEARCH_CONFIRM = "Voulez-vous vraiment SUPPRIMER les %d créatures de la liste de résultats de la base de données MobInfo ?"

MI2_CHATMSG_MONSTEREMOTE = "tente de fuir"

BINDING_HEADER_MI2HEADER	= "MobInfo 2"
BINDING_NAME_MI2CONFIG		= "Ouvrir les options MobInfo2"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"]	= "Contenu de l'infobulle de créature"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Options de vie de créature"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Options de base de données"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Valeur de vie"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Valeur de mana"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Options de recherche"
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "Niveau de créature"
MI2_FRAME_TEXTS["MI2_LootItemQualityLabel"]	= "Qualité des objets pillés"
MI2_FRAME_TEXTS["MI2_LootQualFrame"]		= "Qualité des objets pillés"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Infobulle d'objet"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Importer une base de données MobInfo externe"

MI2_OPTIONS = {}

MI2_OPTIONS["MI2_OptSearchMinLevel"] =
{ text = "Min"; help = "Niveau minimum de créature pour les options de recherche."; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] =
{ text = "Max"; help = "Niveau maximum de créature pour les options de recherche (doit être < 66)."; }

MI2_OPTIONS["MI2_OptSearchNormal"] =
{ text = "Normal"; help = "Inclure les créatures de type Normal dans les résultats de recherche."; }

MI2_OPTIONS["MI2_OptSearchRare"] =
{ text = "Rare"; help = "Inclure les créatures de type Rare dans les résultats de recherche."; }

MI2_OPTIONS["MI2_OptSearchElite"] =
{ text = "Élite"; help = "Inclure les créatures de type Élite dans les résultats de recherche."; }

MI2_OPTIONS["MI2_OptSearchBoss"] =
{ text = "Boss"; help = "Inclure les créatures de type Boss dans les résultats de recherche."; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] =
{ text = "Min"; help = "Nombre minimum de fois que la créature doit avoir été pillée."; }

MI2_OPTIONS["MI2_OptSearchMobName"] =
{ text = "Nom de créature"; help = "Nom partiel ou complet de la créature à rechercher.";
info = 'Laisser vide pour ne pas restreindre la recherche à des créatures spécifiques.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] =
{ text = "Nom d'objet"; help = "Nom partiel ou complet de l'objet à rechercher.";
info = 'Laisser vide pour rechercher tous les noms d\'objets.'; }

MI2_OPTIONS["MI2_OptSortByValue"] =
{ text = "Trier par profit"; help = "Trier la liste de résultats par profit de créature.";
info = 'Trier les créatures par le profit que vous pouvez tirer en les tuant.'; }

MI2_OPTIONS["MI2_OptSortByItem"] =
{ text = "Trier par nombre d'objets"; help = "Trier la liste de résultats par nombre d'objets.";
info = 'Trier les créatures par le nombre d\'objets spécifiés qu\'elles font tomber.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "Lister les créatures dans l'infobulle d'objet"; help = "Afficher les noms des créatures qui font tomber un objet dans l'infobulle.";
info = "Lister les noms de toutes les créatures qui font tomber un objet survolé\ndans l'infobulle d'objet. Pour chaque objet, indiquer la quantité\ntombée par la créature avec le pourcentage." }

MI2_OPTIONS["MI2_OptDisableMobInfo"] =
{ text = "Désactiver les infos de l'infobulle"; help = "Désactiver l'affichage des infos de créature dans les infobulles.";
info = "Cela désactivera complètement les informations de l'addon dans l'infobulle\nde créature et dans l'infobulle d'objet." }

MI2_OPTIONS["MI2_OptShowClass"] =
{ text = "Classe de créature"; help = "Afficher les infos de classe de créature."; }

MI2_OPTIONS["MI2_OptShowHealth"] =
{ text = "Vie"; help = "Afficher les infos de vie de créature (actuelle/max).\nL'enregistrement des données de vie doit être ACTIVÉ pour que cela fonctionne."; }

MI2_OPTIONS["MI2_OptShowMana"] =
{ text = "Mana"; help = "Afficher les infos de mana/rage/énergie de créature (actuelle/max)."; }

MI2_OPTIONS["MI2_OptShowXp"] =
{ text = "XP"; help = "Affiche le nombre de points d'expérience qu'une créature donne.";
info = "Il s'agit de la dernière valeur XP réelle que la créature vous a donnée.\nNon affiché pour les créatures triviales." }

MI2_OPTIONS["MI2_OptShowNo2lev"] =
{ text = "Nombre pour monter"; help = "Affiche le nombre de kills nécessaires pour monter de niveau.";
info = "Cela vous indique combien de fois vous devez tuer\nla même créature pour monter de niveau. Non affiché pour les créatures triviales." }

MI2_OPTIONS["MI2_OptShowDamage"] =
{ text = "Dégâts / DPS"; help = "Afficher la plage de dégâts de créature (Min/Max) et les DPS.";
info = "La plage de dégâts et les DPS sont calculés et stockés séparément par personnage.\nLes DPS se mettent à jour lentement mais progressivement à chaque combat." }

MI2_OPTIONS["MI2_OptShowKills"] =
{ text = "Tué"; help = "Afficher le nombre de fois que vous avez tué une créature.";
info = "Le compteur de kills est calculé et stocké\nséparément par personnage." }

MI2_OPTIONS["MI2_OptShowLoots"] =
{ text = "Pillé"; help = "Afficher le nombre de fois qu'une créature a été pillée."; }

MI2_OPTIONS["MI2_OptShowCloth"] =
{ text = "Ramassages de tissu"; help = "Afficher combien de fois la créature a donné du tissu comme butin."; }

MI2_OPTIONS["MI2_OptShowEmpty"] =
{ text = "Pillages vides"; help = "Afficher le nombre de cadavres vides trouvés (nombre/pourcentage).";
info = "Ce compteur est incrémenté quand vous ouvrez un cadavre\nqui n'a pas de butin." }

MI2_OPTIONS["MI2_OptShowTotal"] =
{ text = "Valeur totale"; help = "Afficher la valeur moyenne totale de la créature.";
info = "C'est la somme du drop moyen de pièces et\nde la valeur moyenne des objets." }

MI2_OPTIONS["MI2_OptShowCoin"] =
{ text = "Drop de pièces"; help = "Afficher le drop moyen de pièces par créature.";
info = "La valeur totale des pièces est accumulée et divisée par\nle compteur de pillage. Non affiché si le nombre de pièces est 0." }

MI2_OPTIONS["MI2_OptShowIV"] =
{ text = "Valeur d'objet"; help = "Afficher la valeur moyenne d'objet par créature.";
info = "La valeur totale des objets est accumulée et divisée par\nle compteur de pillage. Non affiché si la valeur d'objet est 0." }

MI2_OPTIONS["MI2_OptShowQuality"] =
{ text = "Aperçu qualité du butin"; help = "Afficher les compteurs de qualité de butin et le pourcentage.";
info = "Compte combien d'objets parmi les 6 catégories de rareté\nla créature a fait tomber. Les catégories avec 0 drops ne sont\npas affichées. Le pourcentage est la chance d'obtenir un objet\nde la rareté spécifique comme butin." }

MI2_OPTIONS["MI2_OptShowLocation"] =
{ text = "Emplacement de créature"; help = "Affiche les emplacements où une créature peut être trouvée.\nJusqu'à 4 emplacements peuvent être enregistrés par créature.";
info = "L'enregistrement des données d'emplacement doit être ACTIVÉ pour que cela fonctionne."; }

MI2_OPTIONS["MI2_OptShowItems"] =
{ text = "Liste de butin de base"; help = "Afficher les noms et la quantité de tous les objets de butin de base.";
info = "Les objets de butin de base sont tous les objets sauf le tissu, le dépeçage et le butin de quête.\nL'enregistrement des données d'objets de butin doit être ACTIVÉ pour que cela fonctionne."; }

MI2_OPTIONS["MI2_OptShowClothSkin"] =
{ text = "Butin de tissu & dépeçage"; help = "Afficher les noms et la quantité de tous les objets de tissu & dépeçage.";
info = "L'enregistrement des données d'objets de butin doit être ACTIVÉ pour que cela fonctionne."; }

MI2_OPTIONS["MI2_OptShowQuestLoot"] =
{ text = "Butin de quête"; help = "Afficher les noms et la quantité de tous les objets de butin de quête.";
info = "L'enregistrement des données d'objets de butin doit être ACTIVÉ pour que cela fonctionne."; }

MI2_OPTIONS["MI2_OptShowResists"] =
{ text = "Résistances et immunités"; help = "Afficher les résistances et immunités de créature.";
info = "Les résistances et immunités aux écoles de magie sont calculées sur la base du nombre\nde sorts réussis versus ceux résistés.\nL'enregistrement des données de résistance et d'immunité doit être ACTIVÉ." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] =
{ text = "Indicateur de créature fuyante"; help = "Afficher l'indicateur pour les créatures qui fuient quand elles ont peu de vie.";
info = "L'indicateur est une ligne de message rouge qui s'affiche\nuniquement pour les créatures fuyantes." }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Infobulle de créature compacte"; help = "Active une disposition compacte avec 2 valeurs par ligne d'infobulle.";
info = "L'infobulle compacte utilise des textes courts et abrégés.\nPour désactiver une ligne, les deux entrées de cette ligne doivent être désactivées." }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "Combiner les créatures identiques"; help = "Combiner les données pour les créatures avec le même ID.";
info = "Le mode combiné accumule les données pour les créatures avec\nle même ID mais des niveaux différents." }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "Maintenir ALT pour les infos"; help = "Afficher les infos de créature dans l'infobulle uniquement quand la touche ALT est maintenue."; }

MI2_OPTIONS["MI2_OptShowBlankLines"] =
{ text = "Afficher les lignes vides"; help = "Afficher les lignes vides dans l'infobulle.";
info = "Les lignes vides améliorent la lisibilité\nen créant des sections dans l'infobulle." }

MI2_OPTIONS["MI2_OptLimitTooltipLines"] =
{ text = "Limiter l'infobulle à 30 lignes"; help = "Limiter l'infobulle à un maximum de 30 lignes.";
info = "Empêche l'infobulle de devenir excessivement grande pour les créatures\navec beaucoup de drops. Les lignes au-delà de 30 ne sont pas affichées." }

MI2_OPTIONS["MI2_OptItemFilter"] =
{ text = "Filtre d'objet de butin"; help = "Définir l'expression de filtre pour l'affichage des objets de butin.";
info = "Afficher uniquement les objets de butin dans l'infobulle qui contiennent\nle texte du filtre. Ex. entrer 'tissu' pour voir uniquement les objets avec\n'tissu' dans le nom.\nNe rien entrer pour voir tous les objets." }

MI2_OPTIONS["MI2_OptSaveMobHp"] =
{ text = "Enregistrer les données de vie"; help = "Enregistrer les données de vie de créature pour l'affichage dans l'infobulle.";
info = "Quand activé, MobInfo enregistre la vie des créatures rencontrées.\nDésactiver arrête l'enregistrement ou la mise à jour des données de vie.\nL'option d'infobulle de vie nécessite que ceci soit activé." }

MI2_OPTIONS["MI2_OptRecordPlayerHp"] =
{ text = "Enregistrer les données de vie du joueur"; help = "Enregistrer les données de vie du joueur pendant une session.";
info = "Quand activé, MobInfo suit les données de vie des joueurs rencontrés en PvP.\nCes données sont normalement supprimées en fin de session.\nDésactiver pour arrêter complètement l'enregistrement." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] =
{ text = "Sauvegarder les données de vie du joueur définitivement"; help = "Stocker définitivement les données de vie du joueur des combats PvP.";
info = "Normalement les données de vie des combats PvP sont supprimées après\nune session. Cette option conserve ces données." }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "Tout activer"; help = "Mettre toutes les options d'affichage MobInfo sur ON."; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "Tout désactiver"; help = "Mettre toutes les options d'affichage MobInfo sur OFF."; }

MI2_OPTIONS["MI2_OptMinimal"] =
{ text = "Minimal"; help = "Afficher un minimum d'infos utiles sur les créatures."; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "Défaut"; help = "Afficher un ensemble par défaut d'infos utiles sur les créatures."; }

MI2_OPTIONS["MI2_OptShowMinimapButton"] =
{ text = "Afficher le bouton minimap"; help = "Afficher ou masquer le bouton minimap MobInfo2.";
info = "Active ou désactive le bouton minimap qui vous permet\nd'ouvrir le menu des options MobInfo2 en un seul clic." }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "Terminé"; help = "Fermer le panneau d'options MobInfo."; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "Afficher la valeur de vie"; help = "Afficher la valeur de vie dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "Afficher la valeur de mana"; help = "Afficher la valeur de mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "Afficher le pourcentage"; help = "Ajouter le pourcentage à la vie dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "Afficher le pourcentage"; help = "Ajouter le pourcentage au mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptAbbrevHP"] =
{ text = "Abréger les valeurs"; help = "Afficher les valeurs de vie et de mana sous forme de nombres abrégés."; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "Position horizontale"; help = "Ajuster la position horizontale de la vie dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "Position verticale"; help = "Ajuster la position verticale de la vie dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "Position horizontale"; help = "Ajuster la position horizontale du mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "Position verticale"; help = "Ajuster la position verticale du mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "Police"; help = "Définir la police pour les valeurs de vie/mana dans le cadre de la cible.";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "Taille de police"; help = "Définir la taille de police pour les valeurs de vie/mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "Supprimer les données de cible"; help = "Supprimer les données de la cible actuelle de la base de données."; }

MI2_OPTIONS["MI2_OptClearMobDb"] =
{ text = "Supprimer la base de données"; help = "Supprimer tout le contenu de la base de données d'infos de créature."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] =
{ text = "Supprimer la base de données"; help = "Supprimer tout le contenu de la base de données de vie de créature."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] =
{ text = "Supprimer la base de données"; help = "Supprimer tout le contenu de la base de données de vie du joueur."; }

MI2_OPTIONS["MI2_OptSaveItems"] =
{ text = "Enregistrer les données d'objets de butin pour la qualité :"; help = "Activer pour enregistrer les détails des objets de butin.";
info = "Vous pouvez choisir le niveau de qualité des objets à enregistrer."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] =
{ text = "Enregistrer les infos de base"; help = "Enregistrer un ensemble d'informations de base sur les créatures.";
info = "Les infos de base incluent : type de créature, compteurs pour :\nbutin, butin vide, tissu, argent, valeur des objets, aperçu qualité." }

MI2_OPTIONS["MI2_OptSaveCharData"] =
{ text = "Enregistrer les données spécifiques au personnage"; help = "Enregistrer toutes les données de créature spécifiques au personnage.";
info = "Cela active ou désactive l'enregistrement des données suivantes :\nnombre de kills, dégâts min/max, DPS et XP de créature.\n\nCes données sont sauvegardées séparément pour chaque personnage." }

MI2_OPTIONS["MI2_OptSaveLocation"] =
{ text = "Enregistrer les données d'emplacement"; help = "Enregistrer la/les zone(s) où la créature peut être trouvée." }

MI2_OPTIONS["MI2_OptSaveResist"] =
{ text = "Enregistrer les données de résistances & immunités"; help = "Enregistrer les données sur les résistances et immunités aux écoles de magie.";
info = "Pour les écoles de magie, MobInfo enregistre combien de sorts par école\ntouchent avec succès versus combien sont résistés."; }

MI2_OPTIONS["MI2_OptItemsQuality"] =
{ text = ""; help = "Enregistrer les détails des objets pour la qualité sélectionnée et mieux.";
choice1 = "|cff888888Gris|r & Mieux"; choice2="Blanc & Mieux"; choice3="|cff00ff00Vert|r & Mieux" }

MI2_OPTIONS["MI2_OptShowQualPoor"] =
{ text = "|cff888888Médiocre|r"; help = "Afficher les objets de qualité Médiocre (gris) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptShowQualCommon"] =
{ text = "|cffffffffCommun|r"; help = "Afficher les objets de qualité Commun (blanc) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptShowQualUncommon"] =
{ text = "|cff00ff00Peu commun|r"; help = "Afficher les objets de qualité Peu commun (vert) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptShowQualRare"] =
{ text = "|cff0080ffRare|r"; help = "Afficher les objets de qualité Rare (bleu) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptShowQualEpic"] =
{ text = "|cffe040ffÉpique|r"; help = "Afficher les objets de qualité Épique (violet) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptShowQualLegendary"] =
{ text = "|cffff7000Légendaire|r"; help = "Afficher les objets de qualité Légendaire (orange) dans l'infobulle."; }

MI2_OPTIONS["MI2_OptTrimDownMobData"] =
{ text = "Minimiser la taille de la base de données"; help = "Minimiser la taille en supprimant les données superflues.";
info = "Les données superflues sont toutes les données de la base de données\nqui ne sont pas marquées comme étant enregistrées."; }

MI2_OPTIONS["MI2_OptImportMobData"] =
{ text = "Démarrer l'import"; help = "Importer une base de données externe dans votre propre base.";
info = "IMPORTANT : veuillez lire les instructions d'importation !\nSauvegardez TOUJOURS votre propre base avant d'importer !"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] =
{ text = "SUPPRIMER"; help = "Supprime toutes les créatures de la liste de résultats de la base de données MobInfo.";
info = "AVERTISSEMENT : cette opération ne peut pas être annulée.\nVeuillez l'utiliser avec précaution !\nVous devriez sauvegarder votre base MobInfo avant de supprimer des créatures."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] =
{ text = "Importer uniquement les créatures inconnues"; help = "Importer uniquement les créatures qui n'existent pas dans votre propre base.";
info = "Activer cette option empêche que les données des créatures existantes\nsoient modifiées. Seules les créatures inconnues seront importées.\nCela permet d'importer des bases partiellement chevauchantes sans\ncauser de problèmes de cohérence."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab1"] =
{ text = "Infobulle"; help = "Définir les options d'affichage des infos de créature dans l'infobulle."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab2"] =
{ text = "Vie/Mana"; help = "Définir les options d'affichage de vie/mana dans le cadre de la cible."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab3"] =
{ text = "Base de données"; help = "Options de gestion de la base de données."; }

MI2_OPTIONS["MI2_MainOptionsFrameTab4"] =
{ text = "Recherche"; help = "Rechercher dans la base de données."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] =
{ text = "Liste de créatures"; help = "Liste toutes les créatures dans la base de données."; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] =
{ text = "Liste d'objets"; help = "Liste tous les objets dans la base de données."; }

MI_TXT_PFQUEST_RESOLVED		= "Résolution de nom pfQuest : %d créature(s) résolue(s) en ID"
MI_TXT_PFQUEST_AMBIGUOUS	= ", %d ignorée(s) (nom ambigu)"
MI_TXT_PFQUEST_NOTFOUND		= ", %d non trouvée(s) dans la base pfQuest"
MI_TXT_RANK_COMPLETE		= "Résolution de rang terminée : %d créature(s) mise(s) à jour."
MI_TXT_RANK_PENDING			= "Résolution de rang : mise à jour de %d créature(s) (%d en attente de cache). Cela peut prendre un moment."
