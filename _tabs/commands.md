---
icon: fa-solid fa-rectangle-list
order: 1
title: Commands
---

## 🧭 General commands

|Command                |Description                                    |Cooldown           |
|:---                   |:---                                           |        :---:      |
|`/rules`               |Show the main rules of the server              |                   |
|`/report`              |Report issues or players to staff              |                   |
|`/warnings`            |View your warning                              |                   |
|`/holding`             |Show the ID of the item you are holding        |                   |
|`/website`             |Open the this website                          |                   |
|`/fastsell`            |Open the guide for fastsell from this site     |                   |              

## 🚗 Teleport commands

|Command                |Description                                    |Cooldown           |
|:---                   |:---                                           |        :---:      |
| `/tpa <player name>`  |Request to teleport to specific player         |30s                |
| `/tpa c[ancel]`       |Abort teleport request                         |                   |
| `/tpa a[ccept]`       |Accept teleport request from other player      |                   |
| `/tpa d[ecline]`      |Decline teleport request from other player     |                   |

## 🏕️ Home commands

|Command                    |Description                                        |Cooldown           |
|:---                       |:---                                               |        :---:      |
| `/home`                   |Teleport the player to first claimed home, if any  |60s *(see notes)*  |
| `/home <name>`            |Teleport the player to specific claimed home       |60s *(see notes)*  |
| `/homes`                  |List all the claimed homes with their name         |                   |
| `/destroyhome <name>`     |Unclaim a specific home                            |                   |
| `/renamehome <old> <new>` |Rename a specific home                             |                   |
  
**Notes:**
- `/home` cooldown depends on your player rank; see [Donate](/donate) page for more details  

## 🧰 Kits commands

|Command                |Description                                            |Cooldown   |
|:---                   |:---                                                   |   :---:   |
| `/kits`               |Get the available kits based on your rank              |           |
| `/kit license`        |Gives to the player two license plate for vehicle mark |1H         |

## Vote commands

|Command    |Description                                        |Cooldown   |
|:---       |:---                                               |   :---:   |
| `/vote`   |Open the vote page on unturned-servers.net         |24H        |
| `/reward` |Claim a reward after a vote on unturned-servers.net|24H        |

## 💼 Vaults commands

|Command            |Description                                        |Cooldown   |
|:---               |:---                                               |   :---:   |
| `/vault`          |Open your vault                                    |           |
| `/vault <name>`   |Open a specific vault                              |           |
| `/vaults`         |List all available vaults                          |           |
| `/trash`          |Open a temporary trash container                   |           |

## 🛒 Shop commands

|Command                                    |Description                                        |
|:---                                       |:---                                               |
| `/balance`                                |Show the current balance of the player             |
| `/pay <player name> <amount>`             |Pay the specific amount to selected player         |
| `/prices`                                 |Open the prices list spreadsheet on internet       |
| `/cost <item id\|item name>`              |Get the buy and sell prices for a specific item    |       
| `/cost v.<vehicle id\|vehicle name>`      |Get the buy and sell prices for a specific vehicle |
| `/buy <item id\|item name> [<quantity>]`  |Buy an item with optional quantity from the shop   |
| `/sell <item id\|item name> [<quantity>]` |Sell an item with optional MAX quantity on the shop|
| `/buy v.<vehicle id\|vehicle name>`       |Buy a vehicle from the shop                        |

**Notes:**
- Item name can be specified partially (e.g. *Alicep*): the shop do the following logic: 
    1. Search an item with exact name match
    2. Search items with the name that starts with given text
    3. Search items with the name that contains given text

- If the item name contains a space you have to enclose it between double quotes, like: *"military magaz"*
- The item name search is case insensitive
- When you sell items with desired quantity, the shop try to sell all the items in your backpack till the desired quantity: if you have less than desired quantity the shop still sell every item it can find