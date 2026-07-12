# Pseudocodigo - Audio / SFX Core

## Enviar comando ao SPC

```text
function AudioSPC_SendCommandAndWaitAck(command, param1, param2):
    wait until APUIO3 is stable
    wait until APUIO3 == READY

    APUIO0 = command
    APUIO1 = param1
    APUIO2 = param2
    APUIO3 = SEND

    wait until SPC acknowledges command
    APUIO3 = 0
```

## Escolher musica por mapa/estacao

```text
function AudioBGM_SelectTrackForAreaSeasonTime():
    if tilemap_to_load == special_case:
        return

    if hour >= 18:
        return

    profile_pointer = AudioBGM_AreaSeasonTrackPointerTable[tilemap_to_load]
    if profile_pointer == null:
        return

    track_id = profile_pointer[season]
    current_bgm = track_id
```

## Atualizar BGM quando area muda

```text
function AudioBGM_StartCurrentTrackAndQueueSamples():
    if current_bgm == previous_bgm:
        return

    stop_or_fade_previous_slot()

    if current_bgm == 0 or current_bgm == FF:
        return

    upload_current_track_data()
    upload_current_track_stream()
    prepare_required_sample_groups()
```

## Fade entre musicas

```text
function AudioBGM_FadeOutPreviousTrackIfChanged():
    if current_bgm != previous_bgm and previous_bgm != 0:
        send fade-out command with speed/volume params

function AudioBGM_FadeInCurrentTrackIfChanged():
    if current_bgm != previous_bgm and current_bgm not in [0, FF]:
        send fade-in command with speed/volume params
```

## Tocar SFX

```text
function AudioSFX_PlayEffectIdWithDuration(effect_id, duration):
    sfx_id = effect_id
    store duration/params

    sample_group = AudioSFX_SampleGroupByEffectId[sfx_id]
    if sample_group != 0:
        AudioSFX_UploadEffectSampleGroup(sample_group)

    AudioSPC_SendCommand0A_PlayEffectParams(sfx_id, duration, extra_param)
```

## Som de ferramenta

```text
function AudioTool_PlayToolUseSoundIfEnabled(tool_id):
    flag = ToolAction_UseSoundTable[tool_id]
    if flag == 0:
        return

    effect_id = resolve_tool_sound(tool_id)
    AudioSFX_PlayQueuedEffectDefaultVolume(effect_id)
```
