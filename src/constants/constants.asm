;;; Some predefined values for some common values for registers, to make
;code easier to read, not having to remember all of this things.

;;Register Sizes, some stats for fun
macro Set16bit(reg)
    REP <reg>
endmacro

macro Set8bit(reg)
    SEP <reg>
endmacro

!MX = #$30 ;2466 Resets,   11 Sets
!M = #$20  ;1626 Resets, 3010 Sets
!X = #$10  ; 692 Resets,   96 Sets

;;INIDISP
!INIDISP_FORCE_BLANK = #$80

;;NMITIMEN
!NMITIMEN_ENABLE_NMI_NO_JOY = #$80
!NMITIMEN_ENABLE_NMI_AND_JOY = #$A1

;;VMAIN
!VMAIN_16BIT_MODE = #$80

;;MDMAEN
!MDMAEN_Enable_Channel_1 = #$01

;;DMAPX
!DMAPX_8BIT_FIXED_SOURCE = #$08
!DMAPX_16BIT_FIXED_SOURCE = #$09
!DMAPX_16BIT = #$01
!BBADX_DMA_CGRAMPORT = #$22
!BBADX_DMA_VRAMPORT = #$18
!BBADX_DMA_OAMPORT = #$04

;;HVBJOY
!HVBJOY_Joy_Ready = #$01

;;SRAM Check
!ASCII_F = #$46
!ASCII_A = #$41
!ASCII_R = #$52
!ASCII_M = #$4D

!CHAR_EMPTY = #$B1

;;Joy Keys flags
!key_Down = #$0400
!key_Up = #$0800
!key_Left = #$0100
!key_Right = #$0200
!key_B = #$8000
!key_A = #$0080
!key_X = #$0040
!key_Y = #$4000
!key_R = #$0010
!key_L = #$0020
!key_Select = #$2000
!key_Start = #$1000

;;Items
!item_egg = #$14

;;Calendar / season IDs - Pass 19 festival/weather documentation
!SEASON_SPRING = #$00
!SEASON_SUMMER = #$01
!SEASON_FALL   = #$02
!SEASON_WINTER = #$03

;;Weather / climate IDs - Pass 19 festival/weather documentation
!WEATHER_SUNNY              = #$00
!WEATHER_RAIN               = #$01
!WEATHER_SNOW               = #$02
!WEATHER_HURRICANE          = #$03
!WEATHER_FAIR               = #$04
!WEATHER_THUNDER_CALM       = #$05
!WEATHER_FLOWER_FESTIVAL    = #$06
!WEATHER_HARVEST_FESTIVAL   = #$07
!WEATHER_THANKSGIVING       = #$08
!WEATHER_STARRY_NIGHT       = #$09
!WEATHER_NEW_YEAR           = #$0A
!WEATHER_EGG_FESTIVAL       = #$0B
!WEATHER_HEAVY_SNOW         = #$0C

;;Fixed festival dates used by Weather_RollTomorrow - Pass 19
!DAY_FLOWER_FESTIVAL  = #22
!DAY_HARVEST_FESTIVAL = #11
!DAY_EGG_FESTIVAL     = #19
!DAY_THANKSGIVING     = #9
!DAY_STARRY_NIGHT     = #23
!DAY_NEW_YEAR         = #30
!DAY_SPECIAL_FAIR     = #$07
!DAY_FORCED_THUNDER   = #29

;;Maps
!map_farm_winter = #04
!map_mountain_spring = #$10
!map_house_1 = #$15
!map_barn = #$27
!map_coop = #$28
!NATSUME_LOGO = #$5D


;;Farm tile IDs - Pass 17 crop/growth documentation
;These constants document tile-state values used by the farm map lifecycle.
;They are immediate constants by convention, matching the style of this project.
!FARM_TILE_UNUSED_00 = #$00
!FARM_TILE_EMPTY_01 = #$01
!FARM_TILE_EMPTY_02 = #$02
!FARM_TILE_RANDOM_TRASH = #$03
!FARM_TILE_STONE = #$04
!FARM_TILE_FENCE = #$05
!FARM_TILE_BROKEN_FENCE = #$06
!FARM_TILE_TILLED_SOIL = #$07
!FARM_TILE_WATERED_SOIL = #$08
!FARM_TILE_GRASS_SEED = #$1D
!FARM_TILE_CROP_BASE_DRY = #$1E
!FARM_TILE_CROP_BASE_WATERED = #$1F
!FARM_TILE_CROP_RANGE_START = #$20
!FARM_TILE_TOMATO_READY_WATERED = #$39
!FARM_TILE_CORN_READY_WATERED = #$53
!FARM_TILE_POTATO_READY_WATERED = #$61
!FARM_TILE_TURNIP_READY_WATERED = #$6F
!FARM_TILE_GRASS_RANGE_START = #$70
!FARM_TILE_GRASS_STAGE_2_SPECIAL = #$7C
!FARM_TILE_GRASS_MATURE_START = #$76
!FARM_TILE_GRASS_MATURE_END = #$79
!FARM_TILE_GRASS_MARKED_FOR_FEED = #$7A
!FARM_TILE_OUT_OF_BOUNDS_START = #$A0

;;Structs $CC indexes
!CCSTRUCT_USED = #$0000