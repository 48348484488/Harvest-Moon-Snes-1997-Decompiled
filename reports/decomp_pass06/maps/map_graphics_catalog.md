# Decomp Pass 06 - Catalogo de mapas e assets graficos
Esta passada mapeia a tabela `Maps_Graphics_Table` e os assets `dl $xxxxxx` usados por cada mapa/camada.
## Resumo
- Entradas na tabela de mapas/camadas: **96**
- Referencias `dl` encontradas nessas entradas: **332**
- Assets unicos referenciados: **138**
- Entradas com preview PNG em `tilemaps/`: **87**
- Entradas ainda marcadas como `MapUnknown*`: **38**

## Arquivos gerados
- `map_graphics_catalog.csv` - tabela editavel/filtravel.
- `map_graphics_catalog.json` - dados estruturados.
- `map_asset_usage.md` - assets mais reutilizados.
- `map_asset_viewer.html` - visualizador pesquisavel de mapas/tilemaps.

## Entradas principais

| ID | Label | Addr | Preset | Tilemaps | CharMaps | Assets | Comentario |
|---:|---|---:|---:|---:|---:|---|---|
| 00 | `MapFarmSpring` | `80AB3C` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A18000` |  |
| 01 | `MapFarmSummer` | `80AB5F` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A18000` |  |
| 02 | `MapFarmFall` | `80AB82` | `00` | `3` | `1` | `9282CB;929D10;92BB03;A18000` |  |
| 03 | `MapFarmWinter` | `80ABA5` | `00` | `3` | `1` | `93B736;93D049;93E12B;A18000` |  |
| 04 | `MapTownSpring` | `80ABC8` | `00` | `3` | `1` | `97B45F;998000;999A74;A38000` |  |
| 05 | `MapTownSummer` | `80ABEB` | `00` | `3` | `1` | `97B45F;97CD20;97E7A2;A38000` |  |
| 06 | `MapTownFall` | `80AC0E` | `00` | `3` | `1` | `97B45F;988000;989A52;A38000` |  |
| 07 | `MapTownWinter` | `80AC31` | `00` | `3` | `1` | `99DCBD;9A8000;9A9921;A38000` |  |
| 08 | `MapFlowerFestival` | `80AC54` | `00` | `3` | `1` | `97B45F;998000;99AEC3;A4D379` |  |
| 09 | `MapHarvestFestival` | `80AC77` | `00` | `3` | `1` | `97B45F;988000;98AEDB;A4C5DE` |  |
| 0A | `MapStarNightFestivalSquare` | `80AC9A` | `00` | `3` | `1` | `99DCBD;9A8000;9AAEAB;A58327` |  |
| 0B | `MapEggFestival` | `80ACBD` | `00` | `3` | `1` | `97B45F;988000;99C3F2;A4DC7E` |  |
| 0C | `MapForkSpring` | `80ACE0` | `00` | `1` | `1` | `98CC6B;A4CFAB` |  |
| 0D | `MapForkSummer` | `80ACF9` | `00` | `1` | `1` | `98CC6B;A4CFAB` |  |
| 0E | `MapForkFall` | `80AD12` | `00` | `1` | `1` | `98CC6B;A4CFAB` |  |
| 0F | `MapForkWinter` | `80AD2B` | `00` | `1` | `1` | `98E41D;A4CFAB` |  |
| 10 | `MapMountainSpring` | `80AD44` | `00` | `3` | `1` | `9DE7CE;9E8000;9D8000;A28000` |  |
| 11 | `MapMountainSummer` | `80AD67` | `00` | `3` | `1` | `9CCBA3;9CE37D;9D8000;A28000` |  |
| 12 | `MapMountainFall` | `80AD8A` | `00` | `3` | `1` | `9D991C;9DB15E;9DCE31;A28000` |  |
| 13 | `MapMountainWinter` | `80ADAD` | `00` | `3` | `1` | `9E9EDC;9EB75D;9ED208;A28000` |  |
| 14 | `MapStarNightFestivalSpa` | `80ADD0` | `00` | `3` | `1` | `9E9EDC;9EB75D;9ED208;A59E0B` |  |
| 15 | `MapHouselvl1` | `80ADF3` | `00` | `2` | `1` | `95C000;95D6E2;A49B84` |  |
| 16 | `MapHouselvl2` | `80AE11` | `00` | `2` | `1` | `95C000;95D6E2;A4945C` |  |
| 17 | `MapHouselvl3` | `80AE2F` | `00` | `2` | `1` | `95C000;95D6E2;A49745` |  |
| 18 | `MapMayorHouse` | `80AE4D` | `00` | `1` | `1` | `95E8A3;A49E2E` |  |
| 19 | `MapMayorHouseHall` | `80AE66` | `00` | `1` | `1` | `95E8A3;A49E2E` |  |
| 1A | `MapMariasRoom` | `80AE7F` | `00` | `1` | `1` | `95E8A3;A49E2E` |  |
| 1B | `MapChurch` | `80AE98` | `00` | `1` | `1` | `968000;A4A597` |  |
| 1C | `MapFlowerShop` | `80AEB1` | `00` | `1` | `1` | `969437;A4AA99` |  |
| 1D | `MapFlowerShopRooms` | `80AECA` | `00` | `1` | `1` | `969437;A4AA99` |  |
| 1E | `MapBar` | `80AEE3` | `00` | `1` | `1` | `96AD11;A4AE95` |  |
| 1F | `MapBarRooms` | `80AEFC` | `00` | `1` | `1` | `96AD11;A4AE95` |  |
| 20 | `MapRestaurant` | `80AF15` | `00` | `1` | `1` | `96C489;A4B3D1` |  |
| 21 | `MapRestaurantRooms` | `80AF2E` | `00` | `1` | `1` | `96C489;A4B3D1` |  |
| 22 | `MapGeneralStore` | `80AF47` | `00` | `1` | `1` | `96DC6D;A4B8E0` |  |
| 23 | `MapGeneralStoreRooms` | `80AF60` | `00` | `1` | `1` | `96DC6D;A4B8E0` |  |
| 24 | `MapAnimalShop` | `80AF79` | `00` | `1` | `1` | `978000;A4BCC1` |  |
| 25 | `MapWitchHouse` | `80AF92` | `00` | `1` | `1` | `979A88;A4C065` |  |
| 26 | `MapToolShed` | `80AFAB` | `02` | `2` | `2` | `9AE02D;9B8000;A59C08;A58B49` |  |
| 27 | `MapBarn` | `80AFCE` | `00` | `1` | `1` | `9CA40C;A5C4CD` |  |
| 28 | `MapCoop` | `80AFE7` | `00` | `1` | `1` | `9CA40C;A5C258` |  |
| 29 | `MapMountainCave` | `80B000` | `00` | `1` | `1` | `948000;A48A2D` |  |
| 2A | `MapElfTunnel` | `80B019` | `00` | `1` | `1` | `948000;A481AE` |  |
| 2B | `MapUnknown2B` | `80B032` | `00` | `1` | `1` | `9B9F53;A5B63B` |  |
| 2C | `MapUnknown2C` | `80B04B` | `00` | `1` | `1` | `9B86AD;A5A6A0` |  |
| 2D | `MapUnknown2D` | `80B064` | `00` | `3` | `1` | `97B45F;998000;999A74;A38000` |  |
| 2E | `MapUnknown2E` | `80B087` | `00` | `3` | `1` | `97B45F;97CD20;97E7A2;A38000` |  |
| 2F | `MapUnknown2F` | `80B0AA` | `00` | `3` | `1` | `97B45F;988000;989A52;A38000` |  |
| 30 | `MapUnknown30` | `80B0CD` | `00` | `3` | `1` | `99DCBD;9A8000;9A9921;A38000` | HANGS GAME |
| 31 | `MapSummitSpring` | `80B0F0` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5AD17` |  |
| 32 | `MapSummitSummer` | `80B113` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5AD17` |  |
| 33 | `MapSummitFall` | `80B136` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5AD17` |  |
| 34 | `MapSummitWinter` | `80B159` | `01` | `2` | `2` | `9BCF8F;9C965F;A5B943;A5AD17` |  |
| 35 | `MapUnknown35` | `80B17C` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5B042` |  |
| 36 | `MapUnknown36` | `80B19F` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5B042` |  |
| 37 | `MapUnknown37` | `80B1C2` | `01` | `2` | `2` | `9BB76D;9C8000;A5B042;A5B943` |  |
| 38 | `MapUnknown38` | `80B1E5` | `01` | `2` | `2` | `9BCF8F;9C965F;A5B943;A5B042` |  |
| 39 | `MapStarNightFestivalMountainTop` | `80B208` | `01` | `2` | `2` | `9BCF8F;9C965F;A5B943;A5B361` |  |
| 3A | `MapNewYearsFestival` | `80B22B` | `01` | `2` | `2` | `9BB76D;9C8000;A5B943;A5AD17` |  |
| 3B | `MapUnknown3B` | `80B24E` | `01` | `2` | `2` | `9BB76D;9C8000;A5BD8A;A5AD17` |  |
| 3C | `MapUnknown3C` | `80B271` | `00` | `1` | `1` | `98CC6B;A68DCF` | Intro Scene |
| 3D | `MapUnknown3D` | `80B28A` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5E253` |  |
| 3E | `MapUnknown3E` | `80B2AD` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5E5CE` |  |
| 3F | `MapUnknown3F` | `80B2D0` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5E977` |  |
| 40 | `MapUnknown40` | `80B2F3` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5ECFB` |  |
| 41 | `MapUnknown41` | `80B2F3` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5F671` |  |
| 42 | `MapUnknown42` | `80B339` | `00` | `3` | `1` | `97B45F;97CD20;97E7A2;A5F95C` |  |
| 43 | `MapUnknown43` | `80B35C` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5FBCE` |  |
| 44 | `MapUnknown44` | `80B37F` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A68000` |  |
| 45 | `MapUnknown45` | `80B3A2` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A68229` |  |
| 46 | `MapUnknown46` | `80B3C5` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A68433` |  |
| 47 | `MapUnknown47` | `80B3E8` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A6867E` |  |
| 48 | `MapUnknown48` | `80B40B` | `00` | `3` | `1` | `9CCBA3;9CE37D;9D8000;A68864` |  |
| 49 | `MapUnknown49` | `80B42E` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5F059` |  |
| 4A | `MapUnknown4A` | `80B451` | `00` | `3` | `1` | `92D3AB;938000;939E8E;A5F45A` |  |
| 4B | `MapUnknown4B` | `80B474` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A09232;A690A6` |  |
| 4C | `MapUnknown4C` | `80B49C` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A09232;A690A6` |  |
| 4D | `MapUnknown4D` | `80B4C4` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A09232;A690A6` |  |
| 4E | `MapUnknown4E` | `80B4EC` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A09232;A690A6` |  |
| 4F | `MapUnknown4F` | `80B514` | `05` | `3` | `1` | `9EEB3D;A08000;A088E9;A694EE` |  |
| 50 | `MapUnknown50` | `80B537` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A0E682;A694EE` |  |
| 51 | `MapUnknown51` | `80B55F` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A0AB1E;A694EE` |  |
| 52 | `MapUnknown52` | `80B587` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A09232;A694EE` |  |
| 53 | `MapUnknown53` | `80B5AF` | `05` | `3` | `1` | `9EEB3D;A08000;A088E9;A69996` |  |
| 54 | `MapUnknown54` | `80B5D2` | `05` | `3` | `1` | `9EEB3D;A08000;A088E9;A69996` |  |
| 55 | `MapUnknown55` | `80B5F5` | `05` | `3` | `1` | `9EEB3D;A08000;A088E9;A69996` |  |
| 56 | `MapUnknown56` | `80B618` | `05` | `4` | `1` | `9EEB3D;A08000;A088E9;A0CAAF;A69996` |  |
| 57 | `LayerRain` | `80B640` | `` | `` | `` | `928000;A48000` |  |
| 58 | `LayerClouds` | `80B64E` | `` | `` | `` | `97B11A;A4C3E2` |  |
| 59 | `LayerSnow` | `80B65C` | `` | `` | `` | `9E9C6D;A5C955` |  |
| 5A | `LayerHeavySnow` | `80B66A` | `` | `` | `` | `9B8441;A5A3D5` |  |
| 5B | `IntroFarmScroll` | `80B678` | `02` | `None` | `None` | `9F8000;9F946C;9FAA75;9FC04C;A5CD88;A5D44C` |  |
| 5C | `HarvestMoonLogo` | `80B69A` | `` | `` | `` | `A5D94A` |  |
| 5D | `NatsumeLogo` | `80B6A3` | `` | `` | `` | `9FEF97;A5DE84` |  |
| 5E | `MenuScreenBackgrounds` | `80B6B1` | `02` | `None` | `None` | `9ABF97;9AC489;9ACB41;9AD357;A58000;A5970F` |  |
| 5F | `MenuCharacters` | `80B6D3` | `02` | `None` | `None` | `9ABF97;9AC489;9ACB41;9AD357;A58D8E;A5970F` |  |
