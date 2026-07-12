# Pass 79 - family/romance/festival semantic naming map

This file promotes the Pass 78 text xref into practical semantic names for the event groups most relevant to NPC, family, romance, gifts and festivals.

| Group | Semantic name | Dominant roles | Text anchors |
|---|---|---|---|
| `$01` | `MixedNpcFestivalRomanceDialogHub` | npc_or_event_dialogue:56 romance_or_marriage_dialogue:14 event_dialogue_unknown_specific_owner:14 festival_event:13 weather_context:11 npc_maria_romance_or_family:8 | 116 unique ids / 142 commands |
| `$02` | `FamilyRomanceDialogueMatrix_A` | npc_or_event_dialogue:31 romance_or_marriage_dialogue:5 event_dialogue_unknown_specific_owner:5 child_family_event:3 npc_maria_romance_or_family:3 npc_nina_romance_or_family:2 | 44 unique ids / 53 commands |
| `$03` | `MarriageChurchBlueFeatherDialogueMatrix` | npc_or_event_dialogue:24 event_dialogue_unknown_specific_owner:11 child_family_event:4 romance_or_marriage_dialogue:3 npc_maria_romance_or_family:2 weather_forecast_system:2 | 38 unique ids / 49 commands |
| `$04` | `FamilyRomanceWeatherDialogueMatrix_B` | npc_or_event_dialogue:53 weather_forecast_system:13 romance_or_marriage_dialogue:7 weather_context:5 child_family_event:4 npc_maria_romance_or_family:3 | 61 unique ids / 91 commands |
| `$05` | `EveFamilyRomanceDialogueSet` | npc_or_event_dialogue:11 npc_eve_romance_or_family:2 child_family_event:1 romance_or_marriage_dialogue:1 weather_forecast_system:1 money_context:1 | 14 unique ids / 17 commands |
| `$06` | `EveWeatherLivestockDialogueMatrix` | npc_or_event_dialogue:50 weather_forecast_system:12 weather_context:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 family_romance_gift_context:1 | 48 unique ids / 73 commands |
| `$07` | `MountainWeatherRomanceDialogueMatrix` | npc_or_event_dialogue:44 weather_forecast_system:9 event_dialogue_unknown_specific_owner:8 weather_context:8 romance_or_marriage_dialogue:7 child_family_event:3 | 68 unique ids / 89 commands |
| `$08` | `GeneralNpcWeatherFamilyDialogueMatrix` | npc_or_event_dialogue:54 weather_forecast_system:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 romance_or_marriage_dialogue:1 livestock_cow_context:1 | 38 unique ids / 65 commands |
| `$24` | `FestivalTomorrowAnnouncementDialogues` | festival_event:6 weather_context:6 event_dialogue_unknown_specific_owner:2 festival_or_title_context:1 npc_or_event_dialogue:1 | 9 unique ids / 9 commands |
| `$43` | `GiftReactionHouseFamilyDialogRouter` | npc_or_event_dialogue:103 child_family_event:16 house_upgrade_context:10 event_dialogue_unknown_specific_owner:8 house_upgrade_or_family_context:8 festival_event:8 | 67 unique ids / 186 commands |
| `$44` | `NpcGiftFestivalLivestockDialogRouter` | npc_or_event_dialogue:72 event_dialogue_unknown_specific_owner:9 ranch_livestock_context:8 festival_event:8 weather_context:7 family_romance_gift_context:6 | 55 unique ids / 120 commands |
| `$45` | `FamilyCelebrationBirthdayDialogues` | npc_or_event_dialogue:16 family_romance_gift_context:2 | 6 unique ids / 18 commands |

## Entry-level alias candidates

### Group `$01` - `MixedNpcFestivalRomanceDialogHub`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 1 | `$B39D05` | `EventScript_G01_Entry001_MariaEveFlorist` | 24 | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| 2 | `$B39F3E` | `EventScript_G01_Entry002_MariaEveChurch` | 12 | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| 3 | `$B3A086` | `EventScript_G01_Entry003_NinaEveShipping` | 10 | Don't be silly:I'm married. | Thank you. | I could be in trouble. |
| 4 | `$B3A162` | `EventScript_G01_Entry004_AnnEveLivestock` | 34 | You have to give it to the girl you love: OK? To the gi... | Thank you. | .... |
| 5 | `$B3A438` | `EventScript_G01_Entry005_EveEllenLivestock` | 17 | Who are you playing a joke on:young man? | Thank you. | What? I can't take this kindof stuff. |
| 6 | `$B3A5B1` | `EventScript_G01_Entry006_MariaAnnNina` | 16 | You have to give it to the girl you love: OK? To the gi... | Thank you. | What? I can't take this kindof stuff. |
| 7 | `$B3A727` | `EventScript_G01_Entry007_EveEllenLivestock` | 10 | Hey: you are giving it to a wrong person. | Thank you. | What? I can't take this kindof stuff. |
| 9 | `$B3AD24` | `EventScript_G01_Entry009_EveLivestockHouseUpgrade` | 8 | That's it, Come on, | What? Do you give it to me? | What? I can't take this kindof stuff. |
| 10 | `$B3ADB1` | `EventScript_G01_Entry010_EveLivestockCow` | 3 | Hey:listen: we can go through the rock. | It might be able to go to the end of the ranch faster t... | Have you seen a mole?It scares the cows sometimes. You'... |

### Group `$02` - `FamilyRomanceDialogueMatrix_A`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3AE23` | `EventScript_G02_Entry000_EveRomanceMarriageRomance` | 3 | You have to give it to the girl you love: OK? To the gi... | Thank you. | .... |
| 1 | `$B3B44A` | `EventScript_G02_Entry001_MariaEveChild` | 9 | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| 2 | `$B3B4E3` | `EventScript_G02_Entry002_MariaEveWeather` | 13 | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| 3 | `$B3B6E1` | `EventScript_G02_Entry003_EveChildShipping` | 9 | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| 4 | `$B3B8D2` | `EventScript_G02_Entry004_NinaEveLivestock` | 17 | ........Uummm:well:I can't answer now. If it's sunny...... | I'm afraid it's too early... | Thank you. |

### Group `$03` - `MarriageChurchBlueFeatherDialogueMatrix`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3BA59` | `EventScript_G03_Entry000_EveChurchEventDialog` | 2 | This is "Blue feather of happiness."Well:happiness is d... | God bless you, |
| 1 | `$B3BD2D` | `EventScript_G03_Entry001_MariaAnnEve` | 34 | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| 2 | `$B3C1E4` | `EventScript_G03_Entry002_EveChildChildFamily` | 4 | Hey: you are giving it to a wrong person. | What? Do you give it to me? | .... |

### Group `$04` - `FamilyRomanceWeatherDialogueMatrix_B`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3C527` | `EventScript_G04_Entry000_MariaEveChurch` | 19 | Hey: you are giving it to a wrong person. | Thank you. | I don't want it. |
| 1 | `$B3C6AE` | `EventScript_G04_Entry001_MariaEveWeatherForecast` | 5 | That's a tradition in this area called "Blue feather of... | Thank you. | ......Th-thank you. |
| 2 | `$B3C6FE` | `EventScript_G04_Entry002_NinaEveWeatherForecast` | 12 | Don't be silly:I'm married. | Thank you. | I could be in trouble. |
| 3 | `$B3C810` | `EventScript_G04_Entry003_AnnEveWife` | 12 | You have to give it to the girl you love: OK? To the gi... | Thank you. | .... |
| 4 | `$B3C92A` | `EventScript_G04_Entry004_EveEllenLivestock` | 17 | Who are you playing a joke on:young man? | Thank you. | What? I can't take this kindof stuff. |
| 5 | `$B3CA98` | `EventScript_G04_Entry005_MariaEveFortune` | 11 | You have to give it to the girl you love: OK? To the gi... | Thank you. | What? I can't take this kindof stuff. |
| 6 | `$B3CB60` | `EventScript_G04_Entry006_EveLivestockChild` | 4 | Hey: you are giving it to a wrong person. | Thank you. | What? I can't take this kindof stuff. |
| 7 | `$B3CBA5` | `EventScript_G04_Entry007_EveWeather` | 4 | That's it, Come on, | What? Do you give it to me? | What? I can't take this kindof stuff. |

### Group `$05` - `EveFamilyRomanceDialogueSet`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3CC91` | `EventScript_G05_Entry000_EveChildWeatherForecast` | 14 | Hey: you are giving it to a wrong person. | What? Do you give it to me? | What? I can't take this kindof stuff. |

### Group `$06` - `EveWeatherLivestockDialogueMatrix`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3D467` | `EventScript_G06_Entry000_EveChurchWeatherForecast` | 14 | Thank you. | I don't want it. | Good Lord: what's happening here? Hey: Is your place al... |
| 1 | `$B3D59D` | `EventScript_G06_Entry001_EveWeatherForecastWeather` | 4 | Thank you. | ......Th-thank you. | You'd better pray to God that there is no damage fromth... |
| 2 | `$B3D5E3` | `EventScript_G06_Entry002_EveLivestockRanchLivestock` | 11 | Thank you. | I could be in trouble. | The wind is blowing harder now. I don't like hurricanes... |
| 3 | `$B3D6CF` | `EventScript_G06_Entry003_EveWeatherForecastWeather` | 11 | Thank you. | .... | Oh well: the sky looks threatening. We'll probably have... |
| 4 | `$B3D7C9` | `EventScript_G06_Entry004_EveLivestockRanchLivestock` | 14 | Thank you. | What? I can't take this kindof stuff. | What are you hanging around here for? Don't you know a ... |
| 5 | `$B3D90E` | `EventScript_G06_Entry005_EveWeatherForecastWeather` | 7 | Thank you. | What? I can't take this kindof stuff. | What are you hanging around here for? Don't you know a ... |
| 6 | `$B3D99B` | `EventScript_G06_Entry006_EveLivestockChild` | 6 | Thank you. | What? I can't take this kindof stuff. | Hey:son:the hurricane is getting near. Have you put you... |

### Group `$07` - `MountainWeatherRomanceDialogueMatrix`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3DA17` | `EventScript_G07_Entry000_MariaEveChurch` | 18 | Thank you. | Hey: you are giving it to a wrong person. | The mountain top is a mysterious place. I recommend you... |
| 1 | `$B3DB72` | `EventScript_G07_Entry001_MariaEveChurch` | 6 | Thank you. | That's a tradition in this area called "Blue feather of... | Day like today: it's good tothink of your life a little... |
| 2 | `$B3DBD5` | `EventScript_G07_Entry002_EveShippingWeatherForecast` | 12 | Thank you. | Don't be silly:I'm married. | It is said that a happy flower blooms when you eat aber... |
| 3 | `$B3DCD1` | `EventScript_G07_Entry003_AnnEveWife` | 12 | Thank you. | You have to give it to the girl you love: OK? To the gi... | Fences are easy to break after rain and snow. Please ma... |
| 4 | `$B3DDC7` | `EventScript_G07_Entry004_EveEllenLivestock` | 16 | Thank you. | Who are you playing a joke on:young man? | Are you working hard? You know: No food for lazy worker... |
| 5 | `$B3DF0F` | `EventScript_G07_Entry005_MariaEveWeather` | 10 | Thank you. | You have to give it to the girl you love: OK? To the gi... | You won't die without money.Money is not necessary to l... |
| 6 | `$B3DFCE` | `EventScript_G07_Entry006_EveEllenLivestock` | 5 | Thank you. | Hey: you are giving it to a wrong person. | Hey:young boy, Put your livestock inside the pen before... |
| 7 | `$B3E037` | `EventScript_G07_Entry007_EveWeather` | 4 | What? Do you give it to me? | That's it, Come on, | Hey: it's tough when the weather is gloomy. |

### Group `$08` - `GeneralNpcWeatherFamilyDialogueMatrix`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B3E0DF` | `EventScript_G08_Entry000_EveLivestockChurch` | 10 | Thank you. | I could be in trouble. | It's important for a human to overcome difficulties. |
| 1 | `$B3E1C9` | `EventScript_G08_Entry001_EveRomance` | 5 | Thank you. | ......Th-thank you. | Are you all right? I feel ease knowing no one was hurt.... |
| 2 | `$B3E232` | `EventScript_G08_Entry002_EveLivestockRanchLivestock` | 10 | Thank you. | I could be in trouble. | I was surprised.Is your ranch alright? |
| 3 | `$B3E31F` | `EventScript_G08_Entry003_EveWeatherForecastWeather` | 9 | Thank you. | .... | Oh yes:I was pretty surprised. |
| 4 | `$B3E413` | `EventScript_G08_Entry004_EveLivestockWeatherForecast` | 10 | Thank you. | What? I can't take this kindof stuff. | Such a hard time you had, But experience teaches you al... |
| 5 | `$B3E4ED` | `EventScript_G08_Entry005_Eve` | 5 | Thank you. | What? I can't take this kindof stuff. | You'd better inspect here and there. |
| 6 | `$B3E560` | `EventScript_G08_Entry006_EveLivestockCow` | 3 | Thank you. | What? I can't take this kindof stuff. | Cows are simple. So don't keep them out on the ground w... |
| 7 | `$B3E59A` | `EventScript_G08_Entry007_EveEventDialogSign` | 4 | What? Do you give it to me? | What? I can't take this kindof stuff. | Did you see the rock up there collapsed? |

### Group `$24` - `FestivalTomorrowAnnouncementDialogues`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B4A475` | `EventScript_G24_Entry000_EveFestivalWeather` | 6 | It's the Flower Festival tomorrow. I'll stop work earli... | The Harvest Festival is tomorrow.I'll stop work earlier... | It's the Thanksgiving Festival tomorrow. It's for all t... |
| 1 | `$B4A531` | `EventScript_G24_Entry001_EveEventDialogSign` | 1 | Hey:how are you doing? I'm making a great thing now, It... |
| 2 | `$B4A55D` | `EventScript_G24_Entry002_Eve` | 1 | I heard an awful sound from here this morning. Are you ... |
| 3 | `$B4A589` | `EventScript_G24_Entry003_EveEventDialogSign` | 1 | Hi,I was scared by the earthquake this morning. Come up... |

### Group `$43` - `GiftReactionHouseFamilyDialogRouter`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B58020` | `EventScript_G43_Entry000_AnnEveLivestock` | 37 | Thank you. | ......Th-thank you. | Thank you. It looks delicious. |
| 1 | `$B584DA` | `EventScript_G43_Entry001_AnnEveLivestock` | 35 | Thank you. | Are you playing a nasty trick on me? | Wow:thanks a lot. Mmmm:it smells so good. |
| 2 | `$B58990` | `EventScript_G43_Entry002_AnnEveLivestock` | 35 | Thank you. | Don't pick up herbs without thinking what they are for. | Wow:thanks a lot. Mmmm:it smells so good. |
| 3 | `$B58E4E` | `EventScript_G43_Entry003_AnnEveLivestock` | 37 | Thank you. | How rude, | Thank you. It looks delicious. |
| 4 | `$B59313` | `EventScript_G43_Entry004_AnnEveLivestock` | 35 | Thank you. | Are you playing a nasty trick on me? | Thank you. It looks delicious. |

### Group `$44` - `NpcGiftFestivalLivestockDialogRouter`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B597F1` | `EventScript_G44_Entry000_AnnEveLivestock` | 24 | Thank you. | ......Th-thank you. | Thank you. It looks delicious. |
| 1 | `$B599EB` | `EventScript_G44_Entry001_AnnEveLivestock` | 22 | Thank you. | Are you playing a nasty trick on me? | Wow:thanks a lot. Mmmm:it smells so good. |
| 2 | `$B59BE3` | `EventScript_G44_Entry002_AnnEveLivestock` | 23 | Thank you. | Don't pick up herbs without thinking what they are for. | Wow:thanks a lot. Mmmm:it smells so good. |
| 3 | `$B59DD3` | `EventScript_G44_Entry003_AnnEveLivestock` | 24 | Thank you. | How rude, | Thank you. It looks delicious. |
| 4 | `$B59FCA` | `EventScript_G44_Entry004_AnnEveLivestock` | 22 | Thank you. | Are you playing a nasty trick on me? | Thank you. It looks delicious. |

### Group `$45` - `FamilyCelebrationBirthdayDialogues`

| Entry | Target | Alias | Text ids | Sample |
|---:|---:|---|---:|---|
| 0 | `$B5A205` | `EventScript_G45_Entry000_EveFamilyGift` | 6 | Boo-boo... | Boo-boo... | Celebration of <CTRL_FFFD>eE's birthday. It's been a ye... |
| 3 | `$B5A484` | `EventScript_G45_Entry003_EveFamilyGift` | 6 | Boo-boo... | Boo-boo... | Celebration of <CTRL_FFFD>eE's birthday. It's been a ye... |

