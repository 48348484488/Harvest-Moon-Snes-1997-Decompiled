# Pseudocodigo - Field HUD / Status Menu Gate Core

```c
void MenuInput_MainFieldMenuMode(void) {
    if (player_action != PLAYER_ACTION_JUMP) {
        PlayerInput_DispatchBufferedFieldButtons();
    }

    if (!(flags_7F1F5A & 0x8000)) {
        return;
    }

    if (!(joy_new_input & START)) {
        return;
    }

    MenuInput_OpenSecondaryMenuFromStart();
}

void MenuInput_OpenSecondaryMenuFromStart(void) {
    menu_submode_95 = 0x09;
    play_sfx(0x03, 0x06);
    flags_7F1F5C |= 0x0004;
}

void PlayerInput_DispatchBufferedFieldButtons(void) {
    if (buffered_buttons_08FD & DOWN)   PlayerMove_StartDown();
    if (buffered_buttons_08FD & UP)     PlayerMove_StartUp();
    if (buffered_buttons_08FD & LEFT)   PlayerMove_StartLeft();
    if (buffered_buttons_08FD & RIGHT)  PlayerMove_StartRight();
    if (buffered_buttons_08FD & A)      PlayerInput_A_InteractOrDrop();
    if (buffered_buttons_08FD & B)      PlayerInput_B_RunOrJump();
    if (buffered_buttons_08FD & SELECT) PlayerInput_Select_Action0C();
    if (buffered_buttons_08FD & X)      PlayerInput_X_Action1C();
    if (buffered_buttons_08FD & R)      PlayerInput_R_WhistleHorse();
    if (buffered_buttons_08FD & L)      PlayerInput_L_WhistleDog();
    if (buffered_buttons_08FD & Y)      PlayerInput_Y_ToolOrFishing();
}
```
