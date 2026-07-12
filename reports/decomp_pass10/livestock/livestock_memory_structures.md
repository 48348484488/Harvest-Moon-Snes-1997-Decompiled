# Estruturas de RAM - animais / livestock

Este arquivo documenta a leitura atual das estruturas de animais. Ainda e engenharia reversa incremental, mas ja e suficiente para evitar edicoes cegas.

## Chicken slot

Base calculada por `GetChickenPointer`: `$7E:C286 + slot * 8`.

Tamanho: **8 bytes por galinha**, ate **13 slots**.

| Offset | Tamanho | Leitura atual | Observacao |
|---:|---:|---|---|
| `$00` | 8-bit | status/flags | bit `$01` existe; `$02` ovo chocando; `$04` pintinho; `$08` adulto/ativo; `$10` cranky/unfed; `$20` ignorar em spawn; outros ainda em analise |
| `$01` | 8-bit | map/area ou localizacao logica | `$28` aparece como coop/feed check; valores `< $04` indicam fazenda/outdoor por grupo |
| `$02` | 8-bit | timer/idade/cranky | usado para hatch/growth e countdown de cranky |
| `$03` | 8-bit | desconhecido | pouco usado na rotina analisada |
| `$04` | 16-bit | pos X | posicao do objeto quando renderizado/spawnado |
| `$06` | 16-bit | pos Y | posicao do objeto quando renderizado/spawnado |

## Cow slot

Base calculada por `GetCowPointer`: `$7E:C1C6 + slot * 16`.

Tamanho: **16 bytes por vaca**, ate **12 slots**.

| Offset | Tamanho | Leitura atual | Observacao |
|---:|---:|---|---|
| `$00` | 8-bit | status/flags | `$01` existe, `$02` baby/pregnancy-born state, `$04` child, `$08` adult/healthy child/adult flow, `$10` cranky, `$20` sick, `$40` pregnant, `$80` birth pending/special |
| `$01` | 8-bit | daily flags | bit `$80` usado como gatilho de gravidez/milked-today-like flag; zera com `AND #$F8` no ciclo diario |
| `$02` | 8-bit | map/area | `$27` barn; `< $04` outdoor/farm group |
| `$03` | 8-bit | timer | gravidez, idade ou countdown de cranky/doenca dependendo do status |
| `$04` | 8-bit | happiness | usado para calcular felicidade inicial do bezerro |
| `$05` | 8-bit | contador/estado auxiliar | se `#$0A`, pode virar cranky |
| `$06-$07` | 16-bit | ainda incerto | pouco tocado nesta passada |
| `$08` | 16-bit | pos X no barn/farm | usado para spawn do objeto |
| `$0A` | 16-bit | pos Y no barn/farm | usado para spawn do objeto |
| `$0C-$0F` | 4 bytes | nome da vaca | preenchido apos compra/nascimento |

## Flags globais relacionados

| Simbolo/endereco | Uso atual |
|---|---|
| `!cow_N` | quantidade de vacas |
| `!chicks_N` | quantidade de galinhas adultas/pintinhos ativos |
| `!fed_cows_flags` | bitmask de vacas alimentadas no barn |
| `!fed_cows_N` | contador de vacas alimentadas |
| `!fed_chicks_N` | contador de galinhas alimentadas |
| `!feed_cow_N` | quantidade de racoes de vaca disponiveis |
| `!feed_chicks_N` | quantidade de racoes de galinha disponiveis |
| `$7F1F6E` | flags de eventos livestock: funeral cow, egg/chicken flags, born flag etc. ainda parcial |
