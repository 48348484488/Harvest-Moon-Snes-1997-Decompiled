# Pseudocodigo - TextBox / Dialog Renderer Core

```c
void TextBox_StartByTextId(uint16_t text_id) {
    active_text_id = text_id;
    vram_cursor = 0x5010;
    token_index = 0;
    textbox_flags |= TEXTBOX_ACTIVE;

    active_text_ptr = Text_Pointer_Table[text_id];

    scroll_bg3_up_for_textbox();
    time_running = 0;
    persistent_flags |= TEXTBOX_OPEN_FLAG;
}

void TextBox_UpdateRendererAndControlCodes() {
    if (!(textbox_flags & TEXTBOX_ACTIVE)) {
        return;
    }

    token = active_text_ptr[token_index];

    switch (token) {
        case 0xFFFC:
            render_number_variable();
            break;
        case 0xFFFD:
            render_name_variable();
            break;
        case 0xFFFE:
            setup_choice_prompt();
            break;
        case 0xFFFF:
            textbox_flags |= TEXTBOX_END_OR_WAIT;
            break;
        default:
            glyph_ptr = TextBox_GetGlyphGraphicsPointer(token);
            TextBox_QueueGlyphDMA(glyph_ptr, vram_cursor);
            TextBox_AdvanceVRAMCursor();
            token_index++;
            break;
    }
}

void TextBox_CloseAndRestoreScrollAndTime() {
    textbox_flags = 0;
    scroll_bg3_down_to_normal();
    TextBox_RestoreDialogueFontDMAAfterClose();

    if (close_flags_allow_time_resume) {
        time_running |= 1;
    }

    persistent_flags &= ~TEXTBOX_OPEN_FLAG;
}
```
