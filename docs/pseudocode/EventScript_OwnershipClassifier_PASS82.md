# EventScript Ownership Classifier - Pass 82

Input:
- Pass81 all-entry aliases
- Pass78 direct text/dialogue cross-reference
- Pass08 sprite/GOBJ catalog

Algorithm:
1. Join every EventScript entry with direct-dialogue evidence by `(group, entry)`.
2. Inspect semantic alias, group semantic name, first opcode, class histogram and pseudocode preview.
3. Assign `owner_domain` using explicit entity anchors first: chicken/cow/dog/livestock, family/romance, festival, shipping/shop/money, house upgrade, farm/crop/weather, menu, cutscene, player action, object visual, generic dialogue, state router, audio.
4. Assign `scene_role` from command shape: direct dialogue, visual spawn/setup, state gate/router, object parameter setup, motion, text/prompt, transition/map, audio, flag update or table/script-control.
5. Extract pointer-like operands from visual/object commands as `visual_pointer_refs` for later exact GOBJ identity work.

This classifier is intentionally conservative: it closes broad ownership coverage without pretending every structural entry already has an exact human scene title.
