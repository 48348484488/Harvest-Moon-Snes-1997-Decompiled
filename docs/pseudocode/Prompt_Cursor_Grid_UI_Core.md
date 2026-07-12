# Pseudocodigo - Prompt / Cursor / Grid UI Core

```c
void PromptCursorInput_DispatchModalAndGridModes(void) {
    if (promptFlags & CONFIRM_ONLY) {
        if (newInput & A) result = CONFIRMED;
        return;
    }

    if (promptFlags & CLOSE_TEXT) {
        if (newInput & A) {
            TextBox_CloseAndRestoreScrollAndTime();
            inputstate = FIELD_CONTROL;
            consumeA();
        }
        return;
    }

    if (promptFlags & PAGE_ADVANCE) {
        if (newInput & A) {
            TextBox_RestoreDialogueFontDMAAfterClose();
            pageIndex++;
            vramCursor = 0x5010;
            clearCursorState();
        }
        return;
    }

    if (promptFlags & GRID_CURSOR) {
        PromptGridInput_DispatchDirectionalAndConfirm();
        return;
    }
}

void PromptGridInput_DispatchDirectionalAndConfirm(void) {
    if (newInput & A) {
        playConfirmSfx();
        TextBox_CloseAndRestoreScrollAndTime();
        inputstate = FIELD_CONTROL;
        return;
    }

    if (newInput & DOWN)  PromptGridInput_MoveDown();
    if (newInput & UP)    PromptGridInput_MoveUp();
    if (newInput & RIGHT) PromptGridInput_MoveRight();
    if (newInput & LEFT)  PromptGridInput_MoveLeft();
}

void PromptGridInput_MoveDown(void) {
    playCursorSfx();
    eraseOldCursorGlyph();
    cursorIndex = nextDown(cursorIndex, gridLimit);
    cursorLatch = 0;
}
```
