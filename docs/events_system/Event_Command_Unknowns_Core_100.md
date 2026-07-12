# Pass 48 - Remaining Event Command Unknowns Core 100%

Esta pass fecha o escopo **Remaining Event Command Unknowns Core**.

O objetivo foi revisar os comandos de evento que ainda estavam nomeados como `Unknown` dentro do interpretador principal de eventos em `bank_84.asm` e substitui-los por nomes funcionais baseados no comportamento observado no codigo.

## Escopo fechado

Foram resolvidos os tres comandos restantes com label `EventCmd_*Unknown*`:

| Opcode | Antes | Agora | Endereco | Funcao documentada |
|---:|---|---|---|---|
| `$37` | `EventCmd_37_Unknown1` | `EventCmd_37_ClearAttachedObjectSlot` | `$84:B34B` | Limpa/libera o GameOBJ anexado ao slot de evento usando o offset local `+$12`. |
| `$38` | `EventCmd_38_Unknown2` | `EventCmd_38_WaitForFieldMenuGateFlag` | `$84:B365` | Aguarda `$7F1F5A & $8000`; quando a flag esta ativa, avanca o script; caso contrario incrementa contador local `+$10`. |
| `$4A` | `EventCmd_4A_Unknown3` | `EventCmd_4A_GiveHeldItem08OnAButton` | `$84:B93C` | Quando o jogador pode interagir e esta com maos vazias, A-button coloca `!item_on_hand=$08` e define `!player_action=$0004`. |

## Evidencia usada

### Opcode `$37`

O comando avanca o ponteiro de script em 1 byte, le o valor em `event_slot + $12`, copia para `$A5` e chama:

```asm
JSL.L GameOBJ_ClearSlotAndReleaseComponents
```

Isso indica um comando de limpeza/liberacao do objeto visual anexado ao evento.

### Opcode `$38`

O comando testa:

```asm
LDA.L $7F1F5A
AND.W #$8000
```

Se o bit esta ativo, avanca o ponteiro de script. Se nao, incrementa `event_slot + $10`. A flag `$7F1F5A & $8000` ja tinha sido documentada nas passes de Field Status/Menu como gate que permite abrir menu/status de campo.

### Opcode `$4A`

O comando e protegido por varias checagens:

- slot ativo em `event_slot + $0C`;
- `!player_action` nao pode estar em acoes bloqueadas;
- `!game_state` nao pode conter flags impeditivas;
- `$7F1F60 & $0006` precisa estar limpo;
- precisa de A-button novo em `!Joy1_New_Input & $0080`;
- `!item_on_hand` precisa ser zero.

Quando passa, faz:

```asm
STZ event_slot + $00
ORA event_slot + $01, #$40
INC event_slot + $10
!item_on_hand = $08
!player_action = $0004
```

Por isso o nome escolhido foi conservador: `GiveHeldItem08OnAButton`. O item `$08` ainda aparece como item carregado especial/nao totalmente classificado no catalogo antigo de held items; a funcao do comando, porem, esta fechada.

## Limites conhecidos

- O significado tematico exato do item carregado `$08` ainda depende de uma futura classificacao completa de todos os held items.
- O significado completo de todos os bits de `$7F1F5A` e `$7F1F60` ainda e tratado em documentacao de flags/eventos.
- Esta pass fecha o nucleo dos comandos `Unknown` restantes do interpretador de evento, nao todos os scripts individuais dos bancos B3-B5.

## Resultado

Nao restaram labels no formato:

```text
EventCmd_*Unknown*
```

no source ASM principal.

A build foi revalidada e continua byte-perfect.
