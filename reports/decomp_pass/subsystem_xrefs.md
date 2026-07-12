# Decomp Pass 01 - Subsystem Cross References

Total references found: `1553`

## time_day_cycle

References: `352`

| Symbol | References |
|---|---:|
| `!season` | 92 |
| `!hour` | 55 |
| `!day` | 46 |
| `!weather_tomorrow` | 36 |
| `!time_running` | 28 |
| `!year` | 25 |
| `!seconds` | 21 |
| `!weekday` | 21 |
| `!minutes` | 20 |
| `!palette_to_load` | 7 |
| `!next_hourly_palette` | 1 |

### First references

| Symbol | Location | Code |
|---|---|---|
| `!hour` | `src/code_banks/bank_80.asm:1875` | `LDA.L !hour` |
| `!time_running` | `src/code_banks/bank_80.asm:1912` | `LDA.W !time_running` |
| `!hour` | `src/code_banks/bank_80.asm:1941` | `LDA.L !hour` |
| `!palette_to_load` | `src/code_banks/bank_80.asm:2115` | `STA.W !palette_to_load` |
| `!hour` | `src/code_banks/bank_80.asm:2363` | `LDA.L !hour` |
| `!palette_to_load` | `src/code_banks/bank_80.asm:2395` | `STA.W !palette_to_load` |
| `!hour` | `src/code_banks/bank_80.asm:2419` | `LDA.L !hour` |
| `!hour` | `src/code_banks/bank_80.asm:2474` | `LDA.L !hour` |
| `!season` | `src/code_banks/bank_80.asm:2498` | `LDA.L !season` |
| `!hour` | `src/code_banks/bank_80.asm:2556` | `LDA.L !hour` |
| `!hour` | `src/code_banks/bank_80.asm:2661` | `LDA.L !hour` |
| `!palette_to_load` | `src/code_banks/bank_80.asm:2693` | `CMP.W !palette_to_load` |
| `!palette_to_load` | `src/code_banks/bank_80.asm:2701` | `STA.W !palette_to_load` |
| `!hour` | `src/code_banks/bank_80.asm:2713` | `LDA.L !hour` |
| `!season` | `src/code_banks/bank_80.asm:2748` | `LDA.L !season` |
| `!hour` | `src/code_banks/bank_80.asm:2798` | `LDA.L !hour                        ;8095EA;7F1F1C;Hour` |
| `!season` | `src/code_banks/bank_80.asm:2828` | `LDA.L !season                        ;809629;7F1F19;Season` |
| `!time_running` | `src/code_banks/bank_80.asm:2975` | `STZ.W !time_running` |
| `!time_running` | `src/code_banks/bank_80.asm:2989` | `STA.W !time_running` |
| `!hour` | `src/code_banks/bank_80.asm:3079` | `LDA.L !hour                        ;809812;7F1F1C;` |
| `!time_running` | `src/code_banks/bank_80.asm:3329` | `; hour/week/season/day/festival flags and can stop !time_running during` |
| `!season` | `src/code_banks/bank_80.asm:3443` | `ADC.L !season` |
| `!day` | `src/code_banks/bank_80.asm:3451` | `LDA.L !day` |
| `!season` | `src/code_banks/bank_80.asm:3468` | `LDA.L !season` |
| `!season` | `src/code_banks/bank_80.asm:3476` | `LDA.L !season` |
| `!hour` | `src/code_banks/bank_80.asm:3493` | `LDA.L !hour` |
| `!hour` | `src/code_banks/bank_80.asm:3503` | `LDA.L !hour` |
| `!weekday` | `src/code_banks/bank_80.asm:3513` | `LDA.L !weekday` |
| `!season` | `src/code_banks/bank_80.asm:3524` | `LDA.L !season` |
| `!day` | `src/code_banks/bank_80.asm:3527` | `LDA.L !day` |
| `!weekday` | `src/code_banks/bank_80.asm:3534` | `LDA.L !weekday` |
| `!weekday` | `src/code_banks/bank_80.asm:3544` | `LDA.L !weekday` |
| `!time_running` | `src/code_banks/bank_80.asm:3574` | `STZ.W !time_running` |
| `!hour` | `src/code_banks/bank_80.asm:3669` | `LDA.L !hour                        ;809CEE;7F1F1C;` |
| `!hour` | `src/code_banks/bank_80.asm:3673` | `STA.L !hour                        ;809CF7;7F1F1C;` |
| `!season` | `src/code_banks/bank_80.asm:3846` | `LDA.L !season                        ;809E01;7F1F19;` |
| `!season` | `src/code_banks/bank_80.asm:3881` | `LDA.L !season                        ;809E43;7F1F19;` |
| `!season` | `src/code_banks/bank_80.asm:3909` | `LDA.L !season                        ;809E81;7F1F19;` |
| `!weekday` | `src/code_banks/bank_81.asm:2216` | `CODE_8190EB: LDA.L !weekday                        ;8190EB;7F1F1A;` |
| `!hour` | `src/code_banks/bank_81.asm:2221` | `CODE_8190F4: LDA.L !hour                        ;8190F4;7F1F1C;` |
| `!hour` | `src/code_banks/bank_81.asm:2328` | `CODE_8191DE: LDA.L !hour                        ;8191DE;7F1F1C;` |
| `!hour` | `src/code_banks/bank_81.asm:2587` | `+ LDA.L !hour` |
| `!hour` | `src/code_banks/bank_81.asm:2838` | `LDA.L !hour                        ;8195FD;7F1F1C;` |
| `!season` | `src/code_banks/bank_81.asm:3409` | `LDA.L !season                        ;81A593;7F1F19;` |
| `!season` | `src/code_banks/bank_81.asm:4633` | `LDA.L !season` |
| `!season` | `src/code_banks/bank_81.asm:4658` | `LDA.L !season` |
| `!season` | `src/code_banks/bank_81.asm:4682` | `LDA.L !season` |
| `!season` | `src/code_banks/bank_81.asm:4693` | `LDA.L !season` |
| `!year` | `src/code_banks/bank_81.asm:4860` | `LDA.L !year` |
| `!season` | `src/code_banks/bank_81.asm:4863` | `LDA.L !season` |
| `!day` | `src/code_banks/bank_81.asm:4867` | `LDA.L !day` |
| `!hour` | `src/code_banks/bank_81.asm:5956` | `LDA.L !hour                        ;81C3DA;7F1F1C;` |
| `!time_running` | `src/code_banks/bank_81.asm:7982` | `LDA.W !time_running` |
| `!season` | `src/code_banks/bank_81.asm:8244` | `LDA.L !season` |
| `!time_running` | `src/code_banks/bank_81.asm:8350` | `LDA.W !time_running                          ;81D833;000973;` |
| `!time_running` | `src/code_banks/bank_81.asm:8352` | `STA.W !time_running                          ;81D838;000973;` |
| `!time_running` | `src/code_banks/bank_81.asm:8435` | `LDA.W !time_running                          ;81D8F2;000973;` |
| `!time_running` | `src/code_banks/bank_81.asm:8437` | `STA.W !time_running                          ;81D8F7;000973;` |
| `!time_running` | `src/code_banks/bank_81.asm:8484` | `LDA.W !time_running                          ;81D961;000973;` |
| `!time_running` | `src/code_banks/bank_81.asm:8486` | `STA.W !time_running                          ;81D966;000973;` |
| `!season` | `src/code_banks/bank_81.asm:8577` | `LDA.L !season                        ;81DA18;7F1F19;` |
| `!season` | `src/code_banks/bank_81.asm:8666` | `LDA.L !season                        ;81DACE;7F1F19;` |
| `!season` | `src/code_banks/bank_81.asm:8848` | `LDA.L !season                        ;81DC2F;7F1F19;` |
| `!year` | `src/code_banks/bank_81.asm:10326` | `LDA.L !year                        ;81E816;7F1F18;` |
| `!season` | `src/code_banks/bank_81.asm:10817` | `LDA.L !season                        ;81EC2B;7F1F19;` |
| `!year` | `src/code_banks/bank_81.asm:11433` | `LDA.L !year                        ;81F14E;7F1F18;` |
| `!season` | `src/code_banks/bank_81.asm:11435` | `LDA.L !season                        ;81F154;7F1F19;` |
| `!time_running` | `src/code_banks/bank_82.asm:4` | `; - Checks !time_running bit 1 ($02) to force the nightly day rollover.` |
| `!time_running` | `src/code_banks/bank_82.asm:5` | `; - Checks !time_running bit 0 ($01) to allow/stop the visible clock.` |
| `!time_running` | `src/code_banks/bank_82.asm:12` | `LDA.W !time_running` |
| `!time_running` | `src/code_banks/bank_82.asm:17` | `+ LDA.W !time_running` |
| `!seconds` | `src/code_banks/bank_82.asm:29` | `LDA.L !seconds` |
| `!seconds` | `src/code_banks/bank_82.asm:31` | `STA.L !seconds` |
| `!seconds` | `src/code_banks/bank_82.asm:35` | `STA.L !seconds` |
| `!minutes` | `src/code_banks/bank_82.asm:36` | `LDA.L !minutes` |
| `!minutes` | `src/code_banks/bank_82.asm:38` | `STA.L !minutes` |
| `!minutes` | `src/code_banks/bank_82.asm:42` | `STA.L !minutes` |
| `!hour` | `src/code_banks/bank_82.asm:43` | `LDA.L !hour` |
| `!hour` | `src/code_banks/bank_82.asm:47` | `STA.L !hour` |
| `!hour` | `src/code_banks/bank_82.asm:51` | `LDA.L !hour` |

## stamina

References: `767`

| Symbol | References |
|---|---:|
| `!game_state` | 484 |
| `!player_action` | 258 |
| `!max_stamina` | 14 |
| `!current_stamina` | 11 |

### First references

| Symbol | Location | Code |
|---|---|---|
| `!game_state` | `src/code_banks/bank_80.asm:50` | `LDA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:52` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:2940` | `LDA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:2942` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3211` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3212` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3219` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3220` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3268` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3269` | `STA.B !game_state` |
| `!player_action` | `src/code_banks/bank_80.asm:3283` | `STA.B !player_action` |
| `!game_state` | `src/code_banks/bank_80.asm:3356` | `LDA.B !game_state` |
| `!player_action` | `src/code_banks/bank_80.asm:3396` | `STA.B !player_action` |
| `!game_state` | `src/code_banks/bank_80.asm:3398` | `LDA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3400` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3563` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_80.asm:3564` | `STA.B !game_state` |
| `!player_action` | `src/code_banks/bank_80.asm:3610` | `STA.B !player_action` |
| `!game_state` | `src/code_banks/bank_80.asm:3767` | `LDA.B !game_state                            ;809D89;0000D2;` |
| `!game_state` | `src/code_banks/bank_80.asm:3775` | `LDA.B !game_state                            ;809D95;0000D2;` |
| `!game_state` | `src/code_banks/bank_80.asm:3783` | `LDA.B !game_state                            ;809DA1;0000D2;` |
| `!player_action` | `src/code_banks/bank_80.asm:3806` | `LDA.B !player_action                            ;809DC5;0000D4;` |
| `!player_action` | `src/code_banks/bank_80.asm:3814` | `LDA.B !player_action                            ;809DD1;0000D4;` |
| `!player_action` | `src/code_banks/bank_80.asm:3822` | `LDA.B !player_action                            ;809DDD;0000D4;` |
| `!player_action` | `src/code_banks/bank_80.asm:3830` | `LDA.B !player_action                            ;809DE9;0000D4;` |
| `!player_action` | `src/code_banks/bank_80.asm:3839` | `STA.B !player_action                            ;809DF8;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:448` | `STA.B !player_action                            ;818350;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:452` | `AND.B !game_state                            ;81835A;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:453` | `STA.B !game_state                            ;81835C;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:476` | `STA.B !player_action                            ;818394;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:480` | `AND.B !game_state                            ;81839E;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:481` | `STA.B !game_state                            ;8183A0;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1035` | `STA.B !player_action                            ;818813;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:1039` | `AND.B !game_state                            ;81881D;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1040` | `STA.B !game_state                            ;81881F;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1452` | `STA.B !player_action                            ;818AB0;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:1456` | `AND.B !game_state                            ;818ABA;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1457` | `STA.B !game_state                            ;818ABC;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1530` | `STA.B !player_action                            ;818B4C;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:1534` | `AND.B !game_state                            ;818B56;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1535` | `STA.B !game_state                            ;818B58;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1589` | `STA.B !player_action                            ;818BBE;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:1593` | `AND.B !game_state                            ;818BC8;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1594` | `STA.B !game_state                            ;818BCA;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1621` | `AND.B !game_state                            ;818C06;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1622` | `STA.B !game_state                            ;818C08;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1628` | `STA.B !player_action                            ;818C11;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:1630` | `LDA.B !game_state                            ;818C15;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:1632` | `STA.B !game_state                            ;818C1A;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:1648` | `LDA.B !player_action                            ;818C34;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:1688` | `LDA.B !player_action                            ;818C87;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:1762` | `STA.B !player_action                            ;818D33;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:1809` | `STA.B !player_action                            ;818DA6;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:2099` | `LDA.B !game_state                            ;819008;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:2101` | `STA.B !game_state                            ;81900D;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:2124` | `STA.B !player_action                            ;81903A;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:2128` | `AND.B !game_state                            ;819044;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:2129` | `STA.B !game_state                            ;819046;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:2141` | `LDA.B !player_action                            ;819059;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:2181` | `LDA.B !player_action                            ;8190AC;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:2276` | `STA.B !player_action                            ;81916D;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:2280` | `AND.B !game_state                            ;819177;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:2281` | `STA.B !game_state                            ;819179;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:2367` | `LDA.B !player_action                            ;819238;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:2407` | `LDA.B !player_action                            ;81928B;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:2519` | `STA.B !player_action                            ;819374;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:2633` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_81.asm:2634` | `STA.B !game_state` |
| `!game_state` | `src/code_banks/bank_81.asm:2649` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_81.asm:2650` | `STA.B !game_state                              ;Allows walking` |
| `!game_state` | `src/code_banks/bank_81.asm:2665` | `AND.B !game_state` |
| `!game_state` | `src/code_banks/bank_81.asm:2666` | `STA.B !game_state                              ;Allows walking` |
| `!game_state` | `src/code_banks/bank_81.asm:2911` | `LDA.B !game_state                            ;8196A7;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:2913` | `STA.B !game_state                            ;8196AC;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:5498` | `LDA.B !game_state                            ;81BFBD;0000D2;` |
| `!game_state` | `src/code_banks/bank_81.asm:5504` | `LDA.B !game_state` |
| `!player_action` | `src/code_banks/bank_81.asm:5511` | `LDA.B !player_action                            ;81BFD5;0000D4;` |
| `!game_state` | `src/code_banks/bank_81.asm:5517` | `LDA.B !game_state                            ;81BFDE;0000D2;` |
| `!player_action` | `src/code_banks/bank_81.asm:5523` | `CODE_81BFE8: LDA.B !player_action                            ;81BFE8;0000D4;` |
| `!player_action` | `src/code_banks/bank_81.asm:5541` | `LDA.B !player_action                            ;81C004;0000D4;` |

## shipping_money

References: `43`

| Symbol | References |
|---|---:|
| `!moneyH` | 11 |
| `!moneyL` | 11 |
| `!shipping_moneyL` | 11 |
| `!shipping_moneyH` | 10 |

### First references

| Symbol | Location | Code |
|---|---|---|
| `!shipping_moneyL` | `src/code_banks/bank_81.asm:2337` | `ADC.L !shipping_moneyL                        ;8191F2;7F1F07;` |
| `!shipping_moneyL` | `src/code_banks/bank_81.asm:2338` | `STA.L !shipping_moneyL                        ;8191F6;7F1F07;` |
| `!shipping_moneyH` | `src/code_banks/bank_81.asm:2340` | `LDA.L !shipping_moneyH                        ;8191FC;7F1F09;` |
| `!shipping_moneyH` | `src/code_banks/bank_81.asm:2342` | `STA.L !shipping_moneyH                        ;819202;7F1F09;` |
| `!shipping_moneyL` | `src/code_banks/bank_81.asm:2596` | `ADC.L !shipping_moneyL` |
| `!shipping_moneyL` | `src/code_banks/bank_81.asm:2597` | `STA.L !shipping_moneyL` |
| `!shipping_moneyH` | `src/code_banks/bank_81.asm:2599` | `LDA.L !shipping_moneyH` |
| `!shipping_moneyH` | `src/code_banks/bank_81.asm:2601` | `STA.L !shipping_moneyH` |
| `!shipping_moneyL` | `src/code_banks/bank_81.asm:11350` | `LDA.L !shipping_moneyL                        ;81F0AE;7F1F07;` |
| `!shipping_moneyH` | `src/code_banks/bank_81.asm:11353` | `LDA.L !shipping_moneyH                        ;81F0B6;7F1F09;` |
| `!shipping_moneyL` | `src/code_banks/bank_82.asm:198` | `; If !shipping_moneyL/H is non-zero, uses text $031A (daily shipping total).` |
| `!shipping_moneyL` | `src/code_banks/bank_82.asm:218` | `LDA.L !shipping_moneyL` |
| `!shipping_moneyH` | `src/code_banks/bank_82.asm:221` | `LDA.L !shipping_moneyH` |
| `!shipping_moneyL` | `src/code_banks/bank_82.asm:507` | `LDA.L !shipping_moneyL` |
| `!shipping_moneyH` | `src/code_banks/bank_82.asm:510` | `LDA.L !shipping_moneyH` |
| `!shipping_moneyL` | `src/code_banks/bank_82.asm:515` | `STA.L !shipping_moneyL` |
| `!shipping_moneyH` | `src/code_banks/bank_82.asm:518` | `STA.L !shipping_moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:4745` | `STA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:4748` | `STA.L !moneyH` |
| `!shipping_moneyL` | `src/code_banks/bank_83.asm:4854` | `STA.L !shipping_moneyL` |
| `!shipping_moneyH` | `src/code_banks/bank_83.asm:4857` | `STA.L !shipping_moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:5636` | `LDA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:5641` | `LDA.L !moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:5654` | `STA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:5657` | `STA.L !moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:5670` | `STA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:5673` | `STA.L !moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:5974` | `STA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:5978` | `STA.L !moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:6376` | `LDA.L !moneyL` |
| `!moneyH` | `src/code_banks/bank_83.asm:6380` | `LDA.L !moneyH` |
| `!moneyL` | `src/code_banks/bank_83.asm:9450` | `LDA.L !moneyL                        ;83D129;7F1F04;` |
| `!moneyH` | `src/code_banks/bank_83.asm:9454` | `LDA.L !moneyH                        ;83D133;7F1F06;` |
| `!moneyL` | `src/code_banks/bank_83.asm:12887` | `LDA.L !moneyL                        ;83F0A1;7F1F04;` |
| `!moneyH` | `src/code_banks/bank_83.asm:12891` | `LDA.L !moneyH                        ;83F0AB;7F1F06;` |
| `!moneyL` | `src/code_banks/bank_83.asm:13092` | `LDA.L !moneyL` |
| `!moneyL` | `src/code_banks/bank_84.asm:7463` | `STA.L !moneyL                        ;84B659;7F1F04;` |
| `!moneyH` | `src/code_banks/bank_84.asm:7466` | `STA.L !moneyH                        ;84B661;7F1F06;` |
| `!shipping_moneyL` | `src/constants/ram.asm:284` | `!shipping_moneyL = $7F1F07 ;24-bit daily shipping accumulator low word. Added to wallet at night reset.` |
| `!shipping_moneyH` | `src/constants/ram.asm:285` | `!shipping_moneyH = $7F1F09 ;24-bit daily shipping accumulator high byte.` |
| `!moneyL` | `src/constants/ram.asm:327` | `!moneyL = $7F1F04 ;wallet money low word. Used with !moneyH as 24-bit value.` |
| `!moneyH` | `src/constants/ram.asm:327` | `!moneyL = $7F1F04 ;wallet money low word. Used with !moneyH as 24-bit value.` |
| `!moneyH` | `src/constants/ram.asm:328` | `!moneyH = $7F1F06 ;wallet money high byte. AddMoney clamps wallet to $0F423F.` |

## tools_items

References: `391`

| Symbol | References |
|---|---:|
| `!item_on_hand` | 95 |
| `!tool_selected` | 74 |
| `!tool_backpack` | 51 |
| `!shed_items_row_1` | 36 |
| `!shed_items_row_3` | 26 |
| `!shed_items_row_2` | 25 |
| `!shed_items_row_4` | 12 |
| `!seeds_grass_N` | 10 |
| `!seeds_turnip_N` | 10 |
| `!seeds_corn_N` | 9 |
| `!seeds_tomato_N` | 9 |
| `!seeds_potato_N` | 8 |
| `!watering_can_water` | 8 |
| `!feed_chicks_N` | 7 |
| `!feed_cow_N` | 7 |
| `!old_item_on_hand` | 4 |

### First references

| Symbol | Location | Code |
|---|---|---|
| `!item_on_hand` | `src/code_banks/bank_80.asm:3222` | `LDA.W !item_on_hand` |
| `!item_on_hand` | `src/code_banks/bank_80.asm:3264` | `STZ.W !item_on_hand` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:4` | `;;;;;;;; PASS07: main dispatcher for the current held item. Uses !item_on_hand, the tile in front, held-item tables, and may route to shipping/bin/shop/special-place logic.` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:14` | `LDA.W !item_on_hand                          ;818013;00091D;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:253` | `STA.W !item_on_hand                          ;8181C4;00091D;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:266` | `STA.W !item_on_hand                          ;8181DE;00091D;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:279` | `STA.W !item_on_hand                          ;8181F8;00091D;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:445` | `STZ.W !item_on_hand                          ;818348;00091D;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:473` | `STZ.W !item_on_hand                          ;81838C;00091D;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:618` | `LDA.L !shed_items_row_2                        ;8184A5;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:620` | `STA.L !shed_items_row_2                        ;8184AB;7F1F01;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:622` | `LDA.W !tool_selected                          ;8184B1;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:625` | `STZ.W !tool_selected                          ;8184B8;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:628` | `LDA.W !tool_backpack                          ;8184BD;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:631` | `STZ.W !tool_backpack                          ;8184C4;000923;` |
| `!seeds_grass_N` | `src/code_banks/bank_81.asm:634` | `LDA.W !seeds_grass_N                          ;8184C9;000927;` |
| `!seeds_grass_N` | `src/code_banks/bank_81.asm:638` | `STA.W !seeds_grass_N                          ;8184D1;000927;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:647` | `LDA.L !shed_items_row_1                        ;8184E1;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:649` | `STA.L !shed_items_row_1                        ;8184E7;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:651` | `LDA.W !tool_selected                          ;8184ED;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:654` | `STZ.W !tool_selected                          ;8184F4;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:657` | `LDA.W !tool_backpack                          ;8184F9;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:660` | `STZ.W !tool_backpack                          ;818500;000923;` |
| `!seeds_corn_N` | `src/code_banks/bank_81.asm:663` | `LDA.W !seeds_corn_N                          ;818505;000928;` |
| `!seeds_corn_N` | `src/code_banks/bank_81.asm:667` | `STA.W !seeds_corn_N                          ;81850D;000928;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:676` | `LDA.L !shed_items_row_1                        ;81851D;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:678` | `STA.L !shed_items_row_1                        ;818523;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:680` | `LDA.W !tool_selected                          ;818529;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:683` | `STZ.W !tool_selected                          ;818530;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:686` | `LDA.W !tool_backpack                          ;818535;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:689` | `STZ.W !tool_backpack                          ;81853C;000923;` |
| `!seeds_tomato_N` | `src/code_banks/bank_81.asm:692` | `LDA.W !seeds_tomato_N                          ;818541;000929;` |
| `!seeds_tomato_N` | `src/code_banks/bank_81.asm:696` | `STA.W !seeds_tomato_N                          ;818549;000929;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:705` | `LDA.L !shed_items_row_1                        ;818559;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:707` | `STA.L !shed_items_row_1                        ;81855F;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:709` | `LDA.W !tool_selected                          ;818565;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:712` | `STZ.W !tool_selected                          ;81856C;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:715` | `LDA.W !tool_backpack                          ;818571;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:718` | `STZ.W !tool_backpack                          ;818578;000923;` |
| `!seeds_potato_N` | `src/code_banks/bank_81.asm:721` | `LDA.W !seeds_potato_N                          ;81857D;00092A;` |
| `!seeds_potato_N` | `src/code_banks/bank_81.asm:725` | `STA.W !seeds_potato_N                          ;818585;00092A;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:734` | `LDA.L !shed_items_row_1                        ;818595;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:736` | `STA.L !shed_items_row_1                        ;81859B;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:738` | `LDA.W !tool_selected                          ;8185A1;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:741` | `STZ.W !tool_selected                          ;8185A8;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:744` | `LDA.W !tool_backpack                          ;8185AD;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:747` | `STZ.W !tool_backpack                          ;8185B4;000923;` |
| `!seeds_turnip_N` | `src/code_banks/bank_81.asm:750` | `LDA.W !seeds_turnip_N                          ;8185B9;00092B;` |
| `!seeds_turnip_N` | `src/code_banks/bank_81.asm:754` | `STA.W !seeds_turnip_N                          ;8185C1;00092B;` |
| `!item_on_hand` | `src/code_banks/bank_81.asm:767` | `STA.W !item_on_hand                          ;8185DB;00091D;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:776` | `LDA.L !shed_items_row_2                        ;8185EB;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:778` | `STA.L !shed_items_row_2                        ;8185F1;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:787` | `LDA.L !shed_items_row_2                        ;818602;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:789` | `STA.L !shed_items_row_2                        ;818608;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:798` | `LDA.L !shed_items_row_2                        ;818619;7F1F01;` |
| `!shed_items_row_2` | `src/code_banks/bank_81.asm:800` | `STA.L !shed_items_row_2                        ;81861F;7F1F01;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:809` | `LDA.L !shed_items_row_3                        ;818630;7F1F02;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:811` | `STA.L !shed_items_row_3                        ;818636;7F1F02;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:812` | `LDA.L !shed_items_row_1                        ;81863A;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:814` | `STA.L !shed_items_row_1                        ;818640;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:815` | `LDA.W !tool_selected                          ;818644;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:818` | `STZ.W !tool_selected                          ;81864B;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:821` | `LDA.W !tool_backpack                          ;818650;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:824` | `STZ.W !tool_backpack                          ;818657;000923;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:833` | `LDA.L !shed_items_row_3                        ;818667;7F1F02;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:835` | `STA.L !shed_items_row_3                        ;81866D;7F1F02;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:836` | `LDA.L !shed_items_row_1                        ;818671;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:838` | `STA.L !shed_items_row_1                        ;818677;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:839` | `LDA.W !tool_selected                          ;81867B;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:842` | `STZ.W !tool_selected                          ;818682;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:845` | `LDA.W !tool_backpack                          ;818687;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:848` | `STZ.W !tool_backpack                          ;81868E;000923;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:857` | `LDA.L !shed_items_row_3                        ;81869E;7F1F02;` |
| `!shed_items_row_3` | `src/code_banks/bank_81.asm:859` | `STA.L !shed_items_row_3                        ;8186A4;7F1F02;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:860` | `LDA.L !shed_items_row_1                        ;8186A8;7F1F00;` |
| `!shed_items_row_1` | `src/code_banks/bank_81.asm:862` | `STA.L !shed_items_row_1                        ;8186AE;7F1F00;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:863` | `LDA.W !tool_selected                          ;8186B2;000921;` |
| `!tool_selected` | `src/code_banks/bank_81.asm:866` | `STZ.W !tool_selected                          ;8186B9;000921;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:869` | `LDA.W !tool_backpack                          ;8186BE;000923;` |
| `!tool_backpack` | `src/code_banks/bank_81.asm:872` | `STZ.W !tool_backpack                          ;8186C5;000923;` |

