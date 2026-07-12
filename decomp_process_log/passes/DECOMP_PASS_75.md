# DECOMP PASS 75 - EventScript B4 Inline Payload Closure

Objetivo: continuar depois da Pass 74 atacando os 99 residuos reais in-group de EventScript sem alterar bytes da ROM.

## Resultado

| Metrica | Antes | Depois | Status |
|---|---:|---:|---|
| EventCmd dispatch audit | 90/90 | 90/90 | 100% mantido |
| True in-group residuals Pass 74 | 99 | analisados | fechado como etapa |
| `$B4` inline tile/object payload residuals | 73 | 0 pendente nessa classe | 100% fechado |
| Residuals non-B4 restantes | 99 | 26 | alvo reduzido |
| Grupos fechados em nivel residual | 36/72 | 63/72 | melhorou |
| Cobertura efetiva EventScript | 98.847% | 99.697% | melhorou |
| Rebuild byte-perfect | 100% | 100% | mantido |

## Interpretacao tecnica

A Pass 75 separa o byte `$B4` dos residuos reais. Ele aparece acima da faixa oficial de EventCmd (`$00-$59`) e ocorre repetidamente logo depois de prefixos validos de script, seguido por payload de tile/objeto: bytes de tile, coordenadas, direcao/estado e flags runtime. Portanto ele foi classificado como payload inline alcancado pelo scanner linear conservador, nao como opcode oficial faltando.

## Grupos ainda com residuos non-B4

| Grupo | Residuals restantes | Cobertura efetiva |
|---:|---:|---:|
| `$00` | 5 | 98.958% |
| `$01` | 7 | 97.872% |
| `$02` | 1 | 99.556% |
| `$03` | 1 | 99.517% |
| `$09` | 1 | 98.684% |
| `$0B` | 2 | 97.802% |
| `$15` | 1 | 98.387% |
| `$24` | 4 | 88.889% |
| `$43` | 4 | 98.268% |

## Arquivos gerados

- `reports/pass75_eventscript_b4_inline_payload_closure.md`
- `reports/pass75_eventscript_b4_inline_payload_classification.csv`
- `reports/pass75_eventscript_group_residual_status.csv`
- `tools/event_script_b4_inline_payload_classifier_pass75.py`
- `logs/build_pass75.log`

## Proximo alvo

Atacar os 26 residuos non-B4 restantes nos grupos `$00`, `$01`, `$02`, `$03`, `$09`, `$0B`, `$15`, `$24` e `$43`. O foco deve ser trace manual de payload inline de ponteiro/texto/flag, nao novos opcodes oficiais.
