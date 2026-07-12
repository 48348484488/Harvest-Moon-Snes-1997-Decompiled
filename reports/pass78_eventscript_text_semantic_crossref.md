# Pass 78 - EventScript text semantic cross-reference

Pass 78 links decoded B3-B5 EventScript textbox commands to the existing text pointer catalog. This closes the text-anchor layer for script/event naming: every direct `StartTextBox`, `StartTextBoxCopy`, and `StartTextBoxAndAdvanceSlot` text id found by the decoder is resolved to a text label/category/preview when present in the catalog.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- EventScript groups scanned: `72`
- EventScript entries scanned: `1288`
- Commands decoded under corrected model: `12948`
- Direct textbox commands resolved: `959`
- Direct textbox ids missing from text catalog: `0`
- TextRelated argument links resolved separately: `0`
- Groups with direct dialog anchors: `18/72`

## Closure metric

| Metric | Value |
|---|---:|
| Direct EventScript textbox commands resolved to text catalog | `959/959` |
| Direct textbox text-id coverage | `100.000%` |
| Direct textbox missing ids | `0` |
| EventScript groups with at least one direct dialog text anchor | `18/72` |

## High-value groups for semantic event naming

| Group | Bucket | Direct cmds | Unique text ids | Top inferred roles | Next action |
|---:|---|---:|---:|---|---|
| `$43` | `state_gate_or_flag_router` | 186 | 67 | `npc_or_event_dialogue:103 child_family_event:16 house_upgrade_context:10 event_dialogue_unknown_specific_owner:8 house_upgrade_or_family_context:8 festival_event:8` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$01` | `mixed_event_script` | 142 | 116 | `npc_or_event_dialogue:56 romance_or_marriage_dialogue:14 event_dialogue_unknown_specific_owner:14 festival_event:13 weather_context:11 npc_maria_romance_or_family:8` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$44` | `family_romance_dialogue_matrix` | 120 | 55 | `npc_or_event_dialogue:72 event_dialogue_unknown_specific_owner:9 ranch_livestock_context:8 festival_event:8 weather_context:7 family_romance_gift_context:6` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$04` | `family_romance_dialogue_matrix` | 91 | 61 | `npc_or_event_dialogue:53 weather_forecast_system:13 romance_or_marriage_dialogue:7 weather_context:5 child_family_event:4 npc_maria_romance_or_family:3` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$07` | `family_romance_dialogue_matrix` | 89 | 68 | `npc_or_event_dialogue:44 weather_forecast_system:9 event_dialogue_unknown_specific_owner:8 weather_context:8 romance_or_marriage_dialogue:7 child_family_event:3` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$06` | `family_romance_dialogue_matrix` | 73 | 48 | `npc_or_event_dialogue:50 weather_forecast_system:12 weather_context:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 family_romance_gift_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$08` | `family_romance_dialogue_matrix` | 65 | 38 | `npc_or_event_dialogue:54 weather_forecast_system:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 romance_or_marriage_dialogue:1 livestock_cow_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$02` | `family_romance_dialogue_matrix` | 53 | 44 | `npc_or_event_dialogue:31 romance_or_marriage_dialogue:5 event_dialogue_unknown_specific_owner:5 child_family_event:3 npc_maria_romance_or_family:3 npc_nina_romance_or_family:2` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$03` | `family_romance_dialogue_matrix` | 49 | 38 | `npc_or_event_dialogue:24 event_dialogue_unknown_specific_owner:11 child_family_event:4 romance_or_marriage_dialogue:3 npc_maria_romance_or_family:2 weather_forecast_system:2` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$46` | `mixed_event_script` | 23 | 23 | `ranch_livestock_context:6 shipping_context:4 npc_or_event_dialogue:3 house_upgrade_or_family_context:3 livestock_cow_context:2 livestock_chicken_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$45` | `state_gate_or_flag_router` | 18 | 6 | `npc_or_event_dialogue:16 family_romance_gift_context:2` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$05` | `family_romance_dialogue_matrix` | 17 | 14 | `npc_or_event_dialogue:11 npc_eve_romance_or_family:2 child_family_event:1 romance_or_marriage_dialogue:1 weather_forecast_system:1 money_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$24` | `mixed_event_script` | 9 | 9 | `festival_event:6 weather_context:6 event_dialogue_unknown_specific_owner:2 festival_or_title_context:1 npc_or_event_dialogue:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$00` | `animal_or_object_visual_setup` | 7 | 4 | `npc_or_event_dialogue:4 house_upgrade_or_family_context:2 livestock_chicken_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$15` | `mixed_event_script` | 7 | 6 | `npc_or_event_dialogue:5 ranch_livestock_context:2` | Entries can now be split/name-refined using resolved text labels and previews. |
| `$0B` | `mixed_event_script` | 5 | 3 | `event_dialogue_unknown_specific_owner:4 house_upgrade_or_family_context:1` | Entries can now be split/name-refined using resolved text labels and previews. |

## Family/romance/NPC dialogue groups

| Group | Direct cmds | Unique text ids | Top categories | Top inferred roles |
|---:|---:|---:|---|---|
| `$44` | 120 | 55 | `Dialog:88 Sign:9 Animal:7 Festival:7 Romance:6` | `npc_or_event_dialogue:72 event_dialogue_unknown_specific_owner:9 ranch_livestock_context:8 festival_event:8 weather_context:7 family_romance_gift_context:6` |
| `$04` | 91 | 61 | `Dialog:56 Weather:18 Romance:12 Sign:3 Animal:2` | `npc_or_event_dialogue:53 weather_forecast_system:13 romance_or_marriage_dialogue:7 weather_context:5 child_family_event:4 npc_maria_romance_or_family:3` |
| `$07` | 89 | 68 | `Dialog:50 Weather:14 Romance:12 Animal:5 Sign:4` | `npc_or_event_dialogue:44 weather_forecast_system:9 event_dialogue_unknown_specific_owner:8 weather_context:8 romance_or_marriage_dialogue:7 child_family_event:3` |
| `$06` | 73 | 48 | `Dialog:53 Weather:18 Romance:2` | `npc_or_event_dialogue:50 weather_forecast_system:12 weather_context:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 family_romance_gift_context:1` |
| `$08` | 65 | 38 | `Dialog:56 Weather:5 Romance:3 Sign:1` | `npc_or_event_dialogue:54 weather_forecast_system:4 ranch_livestock_context:2 npc_eve_romance_or_family:2 romance_or_marriage_dialogue:1 livestock_cow_context:1` |
| `$02` | 53 | 44 | `Dialog:34 Romance:10 Sign:3 Animal:2 Weather:2` | `npc_or_event_dialogue:31 romance_or_marriage_dialogue:5 event_dialogue_unknown_specific_owner:5 child_family_event:3 npc_maria_romance_or_family:3 npc_nina_romance_or_family:2` |
| `$03` | 49 | 38 | `Dialog:26 Romance:8 Church:7 Animal:3 Weather:3` | `npc_or_event_dialogue:24 event_dialogue_unknown_specific_owner:11 child_family_event:4 romance_or_marriage_dialogue:3 npc_maria_romance_or_family:2 weather_forecast_system:2` |
| `$05` | 17 | 14 | `Dialog:12 Romance:3 Manual:1 Weather:1` | `npc_or_event_dialogue:11 npc_eve_romance_or_family:2 child_family_event:1 romance_or_marriage_dialogue:1 weather_forecast_system:1 money_context:1` |
| `$01` | 142 | 116 | `Dialog:65 Romance:29 Animal:22 Sign:8 Festival:7` | `npc_or_event_dialogue:56 romance_or_marriage_dialogue:14 event_dialogue_unknown_specific_owner:14 festival_event:13 weather_context:11 npc_maria_romance_or_family:8` |
| `$45` | 18 | 6 | `Dialog:18` | `npc_or_event_dialogue:16 family_romance_gift_context:2` |

## Sample resolved text anchors

| Group | Entry | Text id | Label | Category | Inferred role | Preview |
|---:|---:|---:|---|---|---|---|
| `$44` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$44` | 0 | `$03B0` | `Text_3B0_Dialog_ThThank` | `Dialog` | `npc_or_event_dialogue` | ......Th-thank you. |
| `$44` | 0 | `$03B2` | `Text_3B2_Dialog_ThankLooksDelicious` | `Dialog` | `npc_or_event_dialogue` | Thank you. It looks delicious. |
| `$44` | 0 | `$03B5` | `Text_3B5_Dialog_GladGivingMeNeatPresent` | `Dialog` | `npc_or_event_dialogue` | So glad. Are you giving me this neat present? Thank you. |
| `$04` | 0 | `$01C9` | `Text_1C9_Dialog_GivingWrongPerson` | `Dialog` | `child_family_event` | Hey: you are giving it to a wrong person. |
| `$04` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$04` | 0 | `$03B8` | `Text_3B8_Dialog_Want` | `Dialog` | `npc_or_event_dialogue` | I don't want it. |
| `$04` | 0 | `$0039` | `Text_039_Weather_PeopleTownTalkDifferentlyAccording` | `Weather` | `child_family_event;weather_context` | People in town talk differently according to theweather: day: and season. |
| `$07` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$07` | 0 | `$01C9` | `Text_1C9_Dialog_GivingWrongPerson` | `Dialog` | `child_family_event` | Hey: you are giving it to a wrong person. |
| `$07` | 0 | `$0393` | `Text_393_Sign_MountainTopMysteriousPlaceRecommend` | `Sign` | `event_dialogue_unknown_specific_owner` | The mountain top is a mysterious place. I recommend you plant a different seed over there when… |
| `$07` | 0 | `$01CD` | `Text_1CD_Romance_MariaDadWasWrongCome` | `Romance` | `npc_maria_romance_or_family` | Oh:Maria, Your dad was wrong.Please:please come back to me, |
| `$01` | 1 | `$01C9` | `Text_1C9_Dialog_GivingWrongPerson` | `Dialog` | `child_family_event` | Hey: you are giving it to a wrong person. |
| `$01` | 1 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$01` | 1 | `$03B8` | `Text_3B8_Dialog_Want` | `Dialog` | `npc_or_event_dialogue` | I don't want it. |
| `$01` | 1 | `$0035` | `Text_035_Dialog_HowsGoingWorkTooHard` | `Dialog` | `npc_or_event_dialogue` | Hey: how's it going? Don't work too hard. Just take time. |
| `$02` | 0 | `$01CA` | `Text_1CA_Romance_HaveGiveGirlLoveGirl` | `Romance` | `romance_or_marriage_dialogue` | You have to give it to the girl you love: OK? To the girl you want to marry. |
| `$02` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$02` | 0 | `$0049` | `Text_049_Dialog_Entry` | `Dialog` | `npc_or_event_dialogue` | .... |
| `$02` | 1 | `$01C9` | `Text_1C9_Dialog_GivingWrongPerson` | `Dialog` | `child_family_event` | Hey: you are giving it to a wrong person. |
| `$03` | 0 | `$01C3` | `Text_1C3_Shop_BlueFeatherHappinessHappinessDifferent` | `Sign` | `event_dialogue_unknown_specific_owner` | This is "Blue feather of happiness."Well:happiness is different for each one though. Right now:… |
| `$03` | 0 | `$01C4` | `Text_1C4_Church_GodBless` | `Church` | `event_dialogue_unknown_specific_owner` | God bless you, |
| `$03` | 1 | `$01E0` | `Text_1E0_Animal_TraditionAreaCalledBlueFeather` | `Animal` | `event_dialogue_unknown_specific_owner` | That's a tradition in this area called "Blue feather ofhappiness." Use it when you make a marri… |
| `$03` | 1 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$06` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$06` | 0 | `$03B8` | `Text_3B8_Dialog_Want` | `Dialog` | `npc_or_event_dialogue` | I don't want it. |
| `$06` | 0 | `$0153` | `Text_153_Dialog_GoodLordWhatsHappeningPlace` | `Dialog` | `npc_or_event_dialogue` | Good Lord: what's happening here? Hey: Is your place alright? |
| `$06` | 0 | `$0400` | `Text_400_Dialog_AhMrEdFieldAndmeadow` | `Dialog` | `npc_or_event_dialogue` | Ah:Mr.<CTRL_FFFD>eD:is your field andmeadow all right? |
| `$08` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$08` | 0 | `$03B9` | `Text_3B9_Dialog_Trouble` | `Dialog` | `npc_or_event_dialogue` | I could be in trouble. |
| `$08` | 0 | `$0401` | `Text_401_Dialog_ImportantHumanOvercomeDifficulties` | `Dialog` | `npc_or_event_dialogue` | It's important for a human to overcome difficulties. |
| `$08` | 0 | `$043D` | `Text_43D_Weather_ThankButAnsweryouRightNow` | `Weather` | `weather_forecast_system` | Thank you but I can't answeryou right now. If it's sunny:I'll be waiting for you at the church… |
| `$43` | 0 | `$0200` | `Text_200_Dialog_Thank` | `Dialog` | `npc_or_event_dialogue` | Thank you. |
| `$43` | 0 | `$03B0` | `Text_3B0_Dialog_ThThank` | `Dialog` | `npc_or_event_dialogue` | ......Th-thank you. |
| `$43` | 0 | `$03B2` | `Text_3B2_Dialog_ThankLooksDelicious` | `Dialog` | `npc_or_event_dialogue` | Thank you. It looks delicious. |
| `$43` | 0 | `$03B5` | `Text_3B5_Dialog_GladGivingMeNeatPresent` | `Dialog` | `npc_or_event_dialogue` | So glad. Are you giving me this neat present? Thank you. |
| `$45` | 0 | `$01C2` | `Text_1C2_Dialog_BooBoo` | `Dialog` | `npc_or_event_dialogue` | Boo-boo... |
| `$45` | 0 | `$01C2` | `Text_1C2_Dialog_BooBoo` | `Dialog` | `npc_or_event_dialogue` | Boo-boo... |
| `$45` | 0 | `$041D` | `Text_41D_Dialog_CelebrationEesBirthdayYearNow` | `Dialog` | `npc_or_event_dialogue` | Celebration of <CTRL_FFFD>eE's birthday. It's been a year now. Time goes too fast. |
| `$45` | 0 | `$041E` | `Text_41E_Dialog_WowCakeEfsBirthday` | `Dialog` | `family_romance_gift_context` | Wow:cake <CTRL_FFFD>eF's birthday:isn't it? |
| `$47` | 25 | `$0241` | `Text_241_Dialog_WelcomePutBroughtStewNow` | `Dialog` | `npc_or_event_dialogue` | Welcome.Put what you brought in the stew now. |

## Practical result

- EventScript opcode/payload/residual layer was already closed in Pass 77.
- Pass 78 closes the direct text-id resolution layer for decoded dialog commands.
- The next semantic pass should use this xref to rename event entries by real scene/person/festival where the text label is decisive.
