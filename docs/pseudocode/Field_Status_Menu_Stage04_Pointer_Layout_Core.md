# Pseudocodigo - Field Status/Menu Stage04 Pointer/Layout Core

```c
void IntroScreen_MenuStage04PointerLayout(void) {
    if ((transition_timer_94 & 1) == 0) {
        bg2_x++;
    }

    if (transition_timer_94 != 0x3C) {
        transition_timer_94++;
        IntroScreen_democheck();
        return;
    }

    PaletteAnim_ClearAllPointer42Slots();

    set_pointer42(slot: 0x04, ptr: 0x82F2A4, a: 0x0A, y: 0x07);
    set_pointer42(slot: 0x05, ptr: 0x82F2B5, a: 0x0B, y: 0x07);

    switch (choice_098D) {
        case 1:
            set_pointer42(slot: 0x06, ptr: 0x82F2DA, a: 0x0D, y: 0x07);
            set_pointer42(slot: 0x07, ptr: 0x82F2C9, a: 0x0F, y: 0x07);
            set_pointer42(slot: 0x08, ptr: 0x82F2DA, a: 0x09, y: 0x02);
            break;

        case 2:
            set_pointer42(slot: 0x06, ptr: 0x82F2DA, a: 0x0D, y: 0x07);
            set_pointer42(slot: 0x07, ptr: 0x82F2DA, a: 0x0F, y: 0x07);
            set_pointer42(slot: 0x08, ptr: 0x82F2C9, a: 0x09, y: 0x02);
            break;

        default:
            set_pointer42(slot: 0x06, ptr: 0x82F2C9, a: 0x0D, y: 0x07);
            set_pointer42(slot: 0x07, ptr: 0x82F2DA, a: 0x0F, y: 0x07);
            set_pointer42(slot: 0x08, ptr: 0x82F2DA, a: 0x09, y: 0x02);
            break;
    }

    intro_stage_95 = 0x05;
    transition_timer_94 = 0;
    IntroScreen_democheck();
}
```
