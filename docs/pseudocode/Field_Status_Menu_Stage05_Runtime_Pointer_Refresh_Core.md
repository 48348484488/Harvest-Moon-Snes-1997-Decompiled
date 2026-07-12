# Pseudocodigo - Field Status/Menu Stage05 Runtime Pointer Refresh Core

```c
void IntroScreen_MenuStage05RuntimePointerRefresh(void) {
    if ((transition_timer_94 & 1) == 0) {
        bg2_x++;
    }

    transition_timer_94++;

    if (refresh_flag_97 == 0) {
        stage_frame_counter_90++;
        IntroScreen_democheck();
        return;
    }

    refresh_flag_97 = 0;

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

    stage_frame_counter_90++;
    IntroScreen_democheck();
}
```
