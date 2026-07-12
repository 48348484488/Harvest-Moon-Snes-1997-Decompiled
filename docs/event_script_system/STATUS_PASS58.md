# STATUS PASS 58

Escopo: **Full EventScript Symbolic Export B3-B5**.

## Estado

| Item | Estado |
|---|---|
| ROM USA limpa validada localmente | OK |
| Rebuild byte-perfect | OK |
| Pacote final NO-ROM | obrigatorio antes de zipar |
| 72 grupos EventScript exportados | OK |
| 1288 entradas decodificadas | OK |
| CSV de mapa semantico | OK |
| Arquivos por grupo | OK |
| Comentarios P58 na tabela mestre | OK |

## Melhor proxima pass

A Pass 59 deve focar em reduzir os grupos `unknown_opcode_cluster_needs_manual_decode`, principalmente pelos opcodes dominantes:

- `$88`
- `$C0`
- `$F2`
- `$E5`
- `$B5`
- `$F3`
- `$D3`
- `$5C`
- `$5F`
- `$75`
- `$68`
- `$A4`

O caminho mais seguro e cruzar esses opcodes com as rotinas do interpretador de EventScript ja documentadas, depois atualizar `OPCODE_NAME` e `PAYLOAD_LEN` somente quando o tamanho for confirmado.
