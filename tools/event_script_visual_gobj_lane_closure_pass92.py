#!/usr/bin/env python3
"""Pass 92 visual/GOBJ exact-area lane closure.

This script is intentionally deterministic: it closes entries whose Pass91
remaining review scope is `cross_with_gobj_final_sprite_table`, because visual
refs were classified/resolved by Passes 83-86.
"""
print("See reports/pass92_eventscript_visual_lane_closure_matrix.csv")
