# Pass 79 - EventScript semantic naming by text cross-reference

- Generated: `2026-07-05T02:29:58`
- ROM MD5 target: `c9bf36a816b6d54aed79d43a6c45111a`
- Basis: Pass 78 direct EventScript textbox xref.

## Closure metrics

| Metric | Value |
|---|---:|
| Dialog-anchored groups semantically named | `18/18` |
| Dialog-anchored entries with proposed aliases | `75/75` |
| Direct textbox command rows preserved | `959` |
| Unique direct text ids used as anchors | `361` |

## Group semantic names

| Group | Pass79 semantic name | Dialog entries | Text cmds | Unique text ids | Confidence | Reason |
|---|---|---:|---:|---:|---|---|
| `$00` | `ObjectAnimalHouseUpgradeDialogHub` | 3 | 7 | 4 | `high` | Chicken feather + carpenter/house-expansion dialog anchors. |
| `$01` | `MixedNpcFestivalRomanceDialogHub` | 9 | 142 | 116 | `high` | Large mixed NPC dialogue hub: gifts, festivals, family/romance, livestock/weather hints. |
| `$02` | `FamilyRomanceDialogueMatrix_A` | 5 | 53 | 44 | `high` | Family/romance matrix with Maria/Nina/child-family anchors. |
| `$03` | `MarriageChurchBlueFeatherDialogueMatrix` | 3 | 49 | 38 | `high` | Blue Feather, church, marriage/family dialog anchors. |
| `$04` | `FamilyRomanceWeatherDialogueMatrix_B` | 8 | 91 | 61 | `high` | Family/romance matrix with strong weather forecast/dialog branches. |
| `$05` | `EveFamilyRomanceDialogueSet` | 1 | 17 | 14 | `high` | Small Eve/family/romance oriented dialogue set. |
| `$06` | `EveWeatherLivestockDialogueMatrix` | 7 | 73 | 48 | `high` | Weather/livestock/Eve dialogue matrix. |
| `$07` | `MountainWeatherRomanceDialogueMatrix` | 8 | 89 | 68 | `high` | Mountain/sign/weather/family-romance dialogue matrix. |
| `$08` | `GeneralNpcWeatherFamilyDialogueMatrix` | 8 | 65 | 38 | `high` | General NPC/weather/family-ranch dialogue matrix. |
| `$0B` | `MountainAnglerFishingSignDialogue` | 3 | 5 | 3 | `high` | Mountain angler/fishing sign dialogue anchors. |
| `$15` | `RanchToolManualAndWorkResultDialogue` | 1 | 7 | 6 | `high` | Ranch manual/tool-use/work-result dialogue anchors. |
| `$24` | `FestivalTomorrowAnnouncementDialogues` | 4 | 9 | 9 | `high` | Festival tomorrow announcements and weather/festival reminders. |
| `$26` | `StewCookingPotEventDialogue` | 1 | 4 | 3 | `high` | Stew/cooking-pot event dialogue sequence. |
| `$43` | `GiftReactionHouseFamilyDialogRouter` | 5 | 186 | 67 | `high` | Large gift reaction / house / child-family / event-dialog router. |
| `$44` | `NpcGiftFestivalLivestockDialogRouter` | 5 | 120 | 55 | `high` | Gift/festival/livestock/NPC dialog router. |
| `$45` | `FamilyCelebrationBirthdayDialogues` | 2 | 18 | 6 | `high` | Family celebration and birthday-like dialogue anchors. |
| `$46` | `ShippingLivestockStatusDialogues` | 1 | 23 | 23 | `high` | Shipping/livestock/status/money dialogue anchors. |
| `$47` | `StewCookingPotDialogueAlias` | 1 | 1 | 1 | `medium` | Stew/cooking-pot dialogue alias/related entry. |

## Highest-impact entry aliases

| Group | Entry | Target | Proposed alias | Text ids | Confidence | Sample preview |
|---|---:|---:|---|---:|---|---|
| `$43` | 0 | `$B58020` | `EventScript_G43_Entry000_AnnEveLivestock` | 37 | `high_text_named` | Thank you. | ......Th-thank you. | Thank you. It looks delicious. |
| `$43` | 3 | `$B58E4E` | `EventScript_G43_Entry003_AnnEveLivestock` | 37 | `high_text_named` | Thank you. | How rude, | Thank you. It looks delicious. |
| `$43` | 1 | `$B584DA` | `EventScript_G43_Entry001_AnnEveLivestock` | 35 | `high_text_named` | Thank you. | Are you playing a nasty trick on me? | Wow:thanks a lot. Mmmm:it smells so good. |
| `$43` | 2 | `$B58990` | `EventScript_G43_Entry002_AnnEveLivestock` | 35 | `high_text_named` | Thank you. | Don't pick up herbs without thinking what they are for. | Wow:thanks a lot. Mmmm:it smells so good. |
| `$43` | 4 | `$B59313` | `EventScript_G43_Entry004_AnnEveLivestock` | 35 | `high_text_named` | Thank you. | Are you playing a nasty trick on me? | Thank you. It looks delicious. |
| `$01` | 4 | `$B3A162` | `EventScript_G01_Entry004_AnnEveLivestock` | 34 | `high_text_named` | You have to give it to the girl you love: OK? To the gi... | Thank you. | .... |
| `$03` | 1 | `$B3BD2D` | `EventScript_G03_Entry001_MariaAnnEve` | 34 | `high_text_named` | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| `$01` | 1 | `$B39D05` | `EventScript_G01_Entry001_MariaEveFlorist` | 24 | `high_text_named` | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| `$44` | 0 | `$B597F1` | `EventScript_G44_Entry000_AnnEveLivestock` | 24 | `high_text_named` | Thank you. | ......Th-thank you. | Thank you. It looks delicious. |
| `$44` | 3 | `$B59DD3` | `EventScript_G44_Entry003_AnnEveLivestock` | 24 | `high_text_named` | Thank you. | How rude, | Thank you. It looks delicious. |
| `$44` | 2 | `$B59BE3` | `EventScript_G44_Entry002_AnnEveLivestock` | 23 | `high_text_named` | Thank you. | Don't pick up herbs without thinking what they are for. | Wow:thanks a lot. Mmmm:it smells so good. |
| `$46` | 12 | `$B5A85D` | `EventScript_G46_Entry012_MariaAnnNina` | 23 | `high_text_named` | Money <CTRL_FFFC>h-<CTRL_B2>G | Cow <CTRL_FFFC>c<$003F> Chicken <CTRL_FFFC>c<$0040> | Stamina <CTRL_FFFC>d: |
| `$44` | 1 | `$B599EB` | `EventScript_G44_Entry001_AnnEveLivestock` | 22 | `high_text_named` | Thank you. | Are you playing a nasty trick on me? | Wow:thanks a lot. Mmmm:it smells so good. |
| `$44` | 4 | `$B59FCA` | `EventScript_G44_Entry004_AnnEveLivestock` | 22 | `high_text_named` | Thank you. | Are you playing a nasty trick on me? | Thank you. It looks delicious. |
| `$04` | 0 | `$B3C527` | `EventScript_G04_Entry000_MariaEveChurch` | 19 | `high_text_named` | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| `$07` | 0 | `$B3DA17` | `EventScript_G07_Entry000_MariaEveChurch` | 18 | `high_text_named` | Thank you. | Hey: you are giving it to a wrong person. | The mountain top is a mysterious place. I recommend you... |
| `$01` | 5 | `$B3A438` | `EventScript_G01_Entry005_EveEllenLivestock` | 17 | `high_text_named` | Who are you playing a joke on:young man? | Thank you. | What? I can't take this kindof stuff. |
| `$02` | 4 | `$B3B8D2` | `EventScript_G02_Entry004_NinaEveLivestock` | 17 | `high_text_named` | ........Uummm:well:I can't answer now. If it's sunny...... | I'm afraid it's too early... | Thank you. |
| `$04` | 4 | `$B3C92A` | `EventScript_G04_Entry004_EveEllenLivestock` | 17 | `high_text_named` | Who are you playing a joke on:young man? | Thank you. | What? I can't take this kindof stuff. |
| `$01` | 6 | `$B3A5B1` | `EventScript_G01_Entry006_MariaAnnNina` | 16 | `high_text_named` | You have to give it to the girl you love: OK? To the gi... | Thank you. | What? I can't take this kindof stuff. |
| `$07` | 4 | `$B3DDC7` | `EventScript_G07_Entry004_EveEllenLivestock` | 16 | `high_text_named` | Thank you. | Who are you playing a joke on:young man? | Are you working hard? You know: No food for lazy worker... |
| `$05` | 0 | `$B3CC91` | `EventScript_G05_Entry000_EveChildWeatherForecast` | 14 | `high_text_named` | Hey: you are giving it to a wrong person. | What? Do you give it to me? | What? I can't take this kindof stuff. |
| `$06` | 0 | `$B3D467` | `EventScript_G06_Entry000_EveChurchWeatherForecast` | 14 | `high_text_named` | Thank you. | I don't want it. | Good Lord: what's happening here? Hey: Is your place al... |
| `$06` | 4 | `$B3D7C9` | `EventScript_G06_Entry004_EveLivestockRanchLivestock` | 14 | `high_text_named` | Thank you. | What? I can't take this kindof stuff. | What are you hanging around here for? Don't you know a ... |
| `$02` | 2 | `$B3B4E3` | `EventScript_G02_Entry002_MariaEveWeather` | 13 | `high_text_named` | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| `$01` | 2 | `$B39F3E` | `EventScript_G01_Entry002_MariaEveChurch` | 12 | `high_text_named` | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| `$04` | 2 | `$B3C6FE` | `EventScript_G04_Entry002_NinaEveWeatherForecast` | 12 | `high_text_named` | Don't be silly:I'm married. | Thank you. | I could be in trouble. |
| `$04` | 3 | `$B3C810` | `EventScript_G04_Entry003_AnnEveWife` | 12 | `high_text_named` | You have to give it to the girl you love: OK? To the gi... | Thank you. | .... |
| `$07` | 2 | `$B3DBD5` | `EventScript_G07_Entry002_EveShippingWeatherForecast` | 12 | `high_text_named` | Thank you. | Don't be silly:I'm married. | It is said that a happy flower blooms when you eat aber... |
| `$07` | 3 | `$B3DCD1` | `EventScript_G07_Entry003_AnnEveWife` | 12 | `high_text_named` | Thank you. | You have to give it to the girl you love: OK? To the gi... | Fences are easy to break after rain and snow. Please ma... |
| `$04` | 5 | `$B3CA98` | `EventScript_G04_Entry005_MariaEveFortune` | 11 | `high_text_named` | You have to give it to the girl you love: OK? To the gi... | Thank you. | What? I can't take this kindof stuff. |
| `$06` | 2 | `$B3D5E3` | `EventScript_G06_Entry002_EveLivestockRanchLivestock` | 11 | `high_text_named` | Thank you. | I could be in trouble. | The wind is blowing harder now. I don't like hurricanes... |
| `$06` | 3 | `$B3D6CF` | `EventScript_G06_Entry003_EveWeatherForecastWeather` | 11 | `high_text_named` | Thank you. | .... | Oh well: the sky looks threatening. We'll probably have... |
| `$01` | 3 | `$B3A086` | `EventScript_G01_Entry003_NinaEveShipping` | 10 | `high_text_named` | Don't be silly:I'm married. | Thank you. | I could be in trouble. |
| `$01` | 7 | `$B3A727` | `EventScript_G01_Entry007_EveEllenLivestock` | 10 | `high_text_named` | Hey: you are giving it to a wrong person. | Thank you. | What? I can't take this kindof stuff. |
| `$07` | 5 | `$B3DF0F` | `EventScript_G07_Entry005_MariaEveWeather` | 10 | `high_text_named` | Thank you. | You have to give it to the girl you love: OK? To the gi... | You won't die without money.Money is not necessary to l... |
| `$08` | 0 | `$B3E0DF` | `EventScript_G08_Entry000_EveLivestockChurch` | 10 | `high_text_named` | Thank you. | I could be in trouble. | It's important for a human to overcome difficulties. |
| `$08` | 2 | `$B3E232` | `EventScript_G08_Entry002_EveLivestockRanchLivestock` | 10 | `high_text_named` | Thank you. | I could be in trouble. | I was surprised.Is your ranch alright? |
| `$08` | 4 | `$B3E413` | `EventScript_G08_Entry004_EveLivestockWeatherForecast` | 10 | `high_text_named` | Thank you. | What? I can't take this kindof stuff. | Such a hard time you had, But experience teaches you al... |
| `$02` | 1 | `$B3B44A` | `EventScript_G02_Entry001_MariaEveChild` | 9 | `high_text_named` | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |

## Notes

- This pass does not rename executable labels. It adds safe semantic naming metadata and pointer-table comments only.
- The names are intended as handoff targets for future hard symbol renaming once NPC/sprite/RAM evidence confirms ownership.
- Rebuild should remain byte-perfect because source-byte directives are not changed.
