# Pseudocodigo - NameEntry Character Entry UI Core

```c
void NameEntryScene_LoadAndRun(void) {
    tilemap_to_load = 0x5F;
    Audio_SelectAndFadeForNameScene();
    VideoFade_Out();
    ForceBlank();
    VRAM_ClearAll();
    PaletteAnim_ClearAllPointer42Slots();
    ClearSpriteDataTables();
    InitializeOBJs();

    inputstate = 0x05; // NameEntryInput_Dispatch
    ManageGraphicPresets(0x04);
    MapLoad_DecompressAreaGraphicsAndSetCamera();
    Palette_LoadBGHalfToWRAM(0x006F);
    UploadNameEntryGraphicsDMA();

    cursorObject = GameOBJ_AllocateAndInitNewSlot(
        anim = 0x0219,
        x = 0x0028,
        y = 0x0044
    );

    NameEntryUI_DrawNameSlotFrameDMA();
    NameEntryUI_ClearAllNameSlotGlyphs();

    menu_pos = 0;
    namePage = 0;       // $0993
    name_entry_index = 0;
    temp_name[0..3] = CHAR_EMPTY;

    VideoFade_In();

    while (namePage != 3) {
        WaitForNMI();
        BlinkCurrentNameSlotIfNotFull();
        Input_DispatchByState();
        NameEntryCursor_UpdateSpritePositionFromGrid();
        UpdateCursorGameOBJ();
        PrepareOAMData();
    }

    switch (nameTarget /* $099F */) {
        case 0: SetPlayerName(); break;
        case 1: SetCowNameBought(); break;
        case 2: SetCowNameBorn(); break;
        case 3: SetDogName(); break;
        case 4: SetHorseName(); break;
        case 5: SetKid1Name(); break;
        case 6: SetKid2Name(); break;
    }
}

void NameEntryInput_AcceptOrAppendChar(void) {
    action = NameEntryGrid_ReadCurrentEntryField(5);

    if (action == 1) { SelectPage(0); return; }
    if (action == 2) { SelectPage(1); return; }
    if (action == 3) { SelectPage(2); return; }
    if (action == 4) {
        if (name_entry_index != 0) namePage = 3;
        else PlayRejectSFX();
        return;
    }

    if (name_entry_index == 4) {
        PlayConfirmSFX();
        return;
    }

    glyph = NameEntryGrid_ReadCurrentEntryField(4);
    temp_name[name_entry_index] = glyph;
    NameEntryUI_DrawGlyphIntoCurrentSlot(glyph);
    name_entry_index++;
    PlayConfirmSFX();
}

void NameEntryInput_BackspaceOrCancel(void) {
    if (name_entry_index == 0) {
        PlayCancelSFX();
        return;
    }

    if (name_entry_index < 4) {
        NameEntryUI_DrawGlyphIntoCurrentSlot(BLANK_GLYPH);
    }

    name_entry_index--;
    temp_name[name_entry_index] = CHAR_EMPTY;
    PlayCancelSFX();
}

void NameEntryInput_Move(direction) {
    field = DirectionToGridField(direction);
    menu_pos = NameEntryGrid_ReadCurrentEntryField(field);
    PlayCursorSFX();
}
```
