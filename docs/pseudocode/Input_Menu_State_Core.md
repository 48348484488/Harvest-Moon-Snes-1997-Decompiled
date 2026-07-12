# Pseudocodigo - Input / Menu State Core

```c
void Input_DispatchByState(void) {
    switch (inputstate) {
        case 0x01:
            PlayerMovementInputs();
            break;

        case 0x02:
            ImmobileInputs();
            break;

        case 0x03:
            PromptCursorInput_GridCursorMode();
            break;

        case 0x04:
            MenuInput_DispatchByMenuMode();
            break;

        case 0x05:
            NameEntryInput_Dispatch();
            break;

        case 0x06:
            ModalInput_Mode06();
            break;

        default:
            return;
    }
}
```

## MenuInput_DispatchByMenuMode

```c
void MenuInput_DispatchByMenuMode(void) {
    switch (menu_submode_95) {
        case 0x01:
            MenuInput_MainFieldMenuMode();
            break;

        case 0x02:
        case 0x03:
            MenuInput_StartButtonCloseOrAdvanceMode();
            break;

        case 0x05:
            MenuInput_ThreeChoicePromptMode();
            break;

        case 0x07:
            MenuInput_SaveSlotSelectMode();
            break;

        case 0x08:
            MenuInput_LoadSlotSelectMode();
            break;

        default:
            return;
    }
}
```

## NameEntryInput_Dispatch

```c
void NameEntryInput_Dispatch(void) {
    if (joy_autorepeat & DOWN)  NameMenuKeyDown();
    if (joy_autorepeat & UP)    NameMenuKeyUp();
    if (joy_autorepeat & LEFT)  NameMenuKeyLeft();
    if (joy_autorepeat & RIGHT) NameMenuKeyRight();

    if (joy_new & B) NameEntryInput_BackspaceOrCancel();
    if (joy_new & A) NameEntryInput_AcceptOrAppendChar();
}
```

## PromptCursorInput_GridCursorMode

```c
void PromptCursorInput_GridCursorMode(void) {
    if (joy_autorepeat & DOWN)  PromptCursorInput_MoveDown();
    if (joy_autorepeat & UP)    PromptCursorInput_MoveUp();
    if (joy_autorepeat & RIGHT) PromptCursorInput_MoveRightColumn();
    if (joy_autorepeat & LEFT)  PromptCursorInput_MoveLeftColumn();

    if (joy_new & A) {
        PromptCursorInput_AcceptSelectionOrStartText();
    }
}
```

## Fluxo geral

```text
NMI/frame -> ReadJoypad -> MainLoop -> Input_DispatchByState
```

O dispatcher de input e chamado junto com tempo, textbox e animacoes. Por isso ele e o ponto central para entender quando o jogador pode andar, usar ferramenta, responder dialogo, abrir menu, selecionar texto ou inserir nomes.

