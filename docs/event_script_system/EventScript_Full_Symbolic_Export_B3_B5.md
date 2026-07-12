# EventScript Full Symbolic Export B3-B5 - Pass 58

## Objetivo

A Pass 58 transforma a massa de scripts dos bancos `B3`, `B4` e `B5` em material navegavel para decompilacao manual/IA.

Diferenca em relacao a Pass 57:

- Pass 57 expandia pseudocodigo detalhado para 12 grupos prioritarios.
- Pass 58 cria arquivos separados para todos os 72 grupos.
- Pass 58 adiciona um mapa semantico geral, buckets por grupo e dicas de RAM/flags.

## Arquivos principais

```text
reports/event_script_full_symbolic_export_pass58.md
reports/event_script_group_semantic_map_pass58.csv
reports/event_script_full_symbolic_entries_pass58.csv
reports/event_script_memory_role_hints_pass58.md
reports/event_script_groups_pass58/EventScriptGroup_XX.md
```

## Como usar

1. Abra `reports/event_script_full_symbolic_export_pass58.md`.
2. Escolha um grupo de alta prioridade.
3. Abra o arquivo correspondente em `reports/event_script_groups_pass58/`.
4. Cruze:
   - `Text_$NNNN` com o catalogo de textos;
   - RAM/flags com `src/constants/ram.asm` e `reports/event_script_memory_role_hints_pass58.md`;
   - comandos CC/object com `docs/event_script_system/EventScript_CC_AttachedObject_Core_100.md`;
   - comandos de item/dinheiro com docs de item/shop/shipping.

## Interpretacao dos buckets

| Bucket | Uso pratico |
|---|---|
| `family_romance_dialogue_matrix` | Provavel matriz de dialogo social/familia, com condicoes de casamento, filhos, coracoes, hora, dia ou estacao. |
| `animal_or_object_visual_setup` | Provavel inicializacao visual de animais/objetos anexados a cutscenes. |
| `cutscene_object_transition_setup` | Scripts com objetos CC e mudancas de tela/mapa. |
| `item_money_shipping_interaction` | Eventos ligados a itens, dinheiro, drop/shipping ou recompensas. |
| `audio_sfx_or_tablelike_event_stub` | Sequencias dominadas por opcode de audio/SFX ou stubs repetitivos. |
| `state_gate_or_flag_router` | Scripts que roteiam por flags/estado antes de executar cena/dialogo. |
| `mixed_event_script` | Grupo misto; precisa cruzar textos, RAM e primeiros opcodes. |
| `unknown_opcode_cluster_needs_manual_decode` | Grupo ainda dominado por opcodes nao resolvidos; prioridade e decodificar o opcode antes de renomear cena. |

## Regras de seguranca

- O exportador nao escreve texto de dialogo, apenas `Text_$NNNN`.
- O exportador nao altera dados de script.
- Comentarios `P58:` na tabela mestre sao informativos e nao afetam o rebuild.
- Qualquer renomeacao futura de label deve ser validada com rebuild byte-perfect.
