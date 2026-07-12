# Pass 39 - Field HUD / Status Menu Gate Core 100%

Escopo fechado: mapear o gate que permite abrir o menu secundario de campo/status pelo botao Start durante gameplay normal.

Esta pass nao afirma que todo o layout grafico do HUD/status esta documentado. Ela fecha a ponte de controle que:

- roda o dispatcher de input normal enquanto o menu ainda nao abre;
- verifica se o menu/status de campo esta liberado;
- detecta Start;
- muda o submodo de menu;
- toca SFX de confirmacao;
- sinaliza a abertura/atualizacao via flag persistente.

## Rotinas e flags

| Item | Local | Funcao |
|---|---:|---|
| `MenuInput_MainFieldMenuMode` | `$84C2B8` | Handler do submodo `$95 = $01`, usado no campo. |
| `MenuInput_OpenSecondaryMenuFromStart` | `$84C2DA` | Aciona o menu secundario/status quando Start e aceito. |
| `PlayerInput_DispatchBufferedFieldButtons` | `$84C7D6` | Reaplica botoes de campo guardados em `$08FD` usando os handlers normais. |
| `$7F1F5A & $8000` | flag | Gate que permite abrir o menu/status de campo. |
| `$95 = $09` | submodo | Marca o menu secundario/status como pendente. |
| `$7F1F5C |= $0004` | flag | Solicita abertura/atualizacao do menu/status. |

## Fluxo

1. `Input_DispatchByState` ve `!inputstate = $04` e chama `MenuInput_DispatchByMenuMode`.
2. Com `$95 = $01`, o jogo entra em `MenuInput_MainFieldMenuMode`.
3. Se o jogador nao esta pulando (`!player_action != $0003`), o codigo passa por `PlayerInput_DispatchBufferedFieldButtons`.
4. O gate `$7F1F5A & $8000` precisa estar ativo.
5. Se Start foi pressionado (`!Joy1_New_Input & $1000`), `MenuInput_OpenSecondaryMenuFromStart` roda.
6. O submodo `$95` vira `$09`.
7. O SFX `$03/$06` e tocado.
8. `$7F1F5C` recebe bit `$0004`, sinalizando abertura/refresh do menu secundario/status.

## Limites do escopo

Fechado nesta pass:

- gate de Start/status;
- submodo e flag de abertura;
- dispatcher de botoes em buffer `$08FD`;
- documentacao do fluxo seguro.

Nao fechado nesta pass:

- layout completo do HUD/status;
- tabelas graficas do menu;
- todos os bits de `$7F1F5A/$7F1F5C`;
- logica completa do submodo `$95 = $09`.

Esses itens ficam como proximas metas naturais.
