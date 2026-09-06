# 🐲 **MobInfo2 Enhanced** (Vanilla 1.12.1)

> [!IMPORTANT]
> **MobInfo2 Enhanced** requires [**ClassicAPI**](https://github.com/brues-code/ClassicAPI) in order to function.
> 
Skeeve & Dizzarian's MobInfo2 for World of Warcraft 1.12.1 with the following enhancements/changes/additions:

 - [**ClassicAPI**](https://github.com/brues-code/ClassicAPI) implementation which records mobs, locations and items as IDs rather than names
 - player databases can be shared regardless of the locale they were recorded on, for example a database recorded on a German client will work on an English client
 - reduced SavedVariable filesize
 - fixes an issue with the old version of the addon where mob drops were ignored if they were similar, for example if a Rabid Dire Wolf dropped just a Lean Wolf Flank, further Rabid Dire Wolf similar drops would not be recorded for a while
 - mob item drops are sorted by rarity and drop chance in the tooltip
 - removed the item value database as the addon now gets an item's sellPrice from ClassicAPI's C_Item.GetItemInfo(itemInfo)
 - quest items are no longer counted in a mob's overall item drop count and percentage calculation; they are now listed in a similar fashion to Tailoring and Skinning items, at the bottom of the mob's drop list and have a yellow exclamation mark prefix; items that start quests receive two exclamation marks
 - item suffixes (of the Tiger, of the Monkey etc) are no longer listed and just the base item itself is shown on the mob's drop list; should help to prevent the mob tooltip from getting too cluttered
 - addon records up to 4 locations for mobs now; should be useful for the Emerald Dragons and several other mobs
 - legendary items are now listed in the Loot Quality Overview line in the tooltip
 - added option to abbreviate health and mana values
 - added option to filter item rarities on mob tooltips
 - added Rare mob filter to the Mob List in the Search tab
 - full item tooltip is now shown on the Item List in the Search Tab
 - Total Mob Value, Average Item Value & Loot Quality Overview are now calculated on the fly and are no longer written to the SavedVariable
 - mob & player health data recording can be toggled off
 - player health, when the option to permanently record it is enabled, is saved using the player's GUID instead of name; this means that health values survive even after a player has done a name change
 - added toggleable minimap button
 - added option to limit the number of mob tooltip lines to 30; ClassicAPI uncaps the number of lines a tooltip can display, so this option can be useful to prevent the mob's tooltip from taking up the way too much space
 - multiple other miscellaneous/under the hood/too minor to list changes

The addon comes with a database that can be imported by going to the Database tab of the options menu.

Old databases will still work with the Enhanced version. The addon will migrate almost everything and upgrade it to the new version. The only values which will not survive migration are Player Health and Mob Location, but those shouldn't be such a big deal. 

> [!IMPORTANT]
> Since the Enhanced version uses mob IDs, old databases will import the mob names as there's no way to resolve the name to ID conversion without encountering the mob in-game. Mobs will be listed as "?" in the Mob List until encountered normally at which point the name to ID conversion will take place. If you use [**pfQuest**](https://github.com/brues-code/pfQuest), then name to ID conversions will happen immediately upon database migration or if the MI2 has detected mob names instead of IDs in its SavedVariable, as the addon will scan pfQuest's locale appropriate `units.lua`.
>
To fully finalize old database migration, [**pfQuest**](https://github.com/brues-code/pfQuest) is recommended. Since old databases use names, the name to ID conversion can only happen unassisted by encountering mobs in the game. If pfQuest is detected, the addon will scan its locale appropriate `units.lua` and convert the names to IDs. Just to be clear though, this isn't necessary, it's just if you want the database to be fully converted immediately.

# **MobInfo2 Browser Enhanced** 

Chester & Skeeve's MobInfo2 Browser has been updated and enhanced to work with the new MobInfo2 version. It is completely optional and serves as a way to easier view your MI2 database.

## 👨‍💻 **Authors**

Original addon: Skeeve & Dizzarian;

Enhanced version: Drakensangs

## 📸 **Screenshots**

<img width="427" height="893" alt="MI2T3" src="https://github.com/user-attachments/assets/e6d24020-61b2-4ddd-a307-ea87b8fab549" />
<img width="388" height="691" alt="MI2T2" src="https://github.com/user-attachments/assets/d9273d8c-653a-430b-a1db-44c35501ae12" />
<img width="448" height="756" alt="MI2T1" src="https://github.com/user-attachments/assets/6e2d54ac-7b20-41ea-b0a1-f8c813810b0d" />
<img width="376" height="541" alt="MI2T6" src="https://github.com/user-attachments/assets/c1638c24-6f9e-4dda-9699-e8b29278d6e1" />
<img width="461" height="1295" alt="MI2T5" src="https://github.com/user-attachments/assets/789fb042-25e7-485a-b30e-43d827d0b009" />
<img width="407" height="752" alt="MI2T4" src="https://github.com/user-attachments/assets/c5b73de5-c44f-40d3-9fe1-6d2563f8524e" />
<img width="589" height="1307" alt="MI2T" src="https://github.com/user-attachments/assets/57c8a6c6-ff15-4dbd-bae9-217e4e24c38b" />
<img width="760" height="833" alt="MI2UI1" src="https://github.com/user-attachments/assets/b584d8e1-5e29-4b43-b8bd-6be56755c032" />
<img width="754" height="843" alt="MI2UI2" src="https://github.com/user-attachments/assets/32d41efd-e63e-4122-8a70-47b591b7c667" />
<img width="739" height="833" alt="MI2UI3" src="https://github.com/user-attachments/assets/c9a34b39-822f-4b17-9340-5dcdb04f55fd" />
<img width="1458" height="913" alt="MI2B" src="https://github.com/user-attachments/assets/3a7ee28e-8dc8-4e10-8c9e-d3bb9646a028" />
