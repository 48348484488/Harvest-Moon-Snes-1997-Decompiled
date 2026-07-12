# EventScript B4 Inline Payload Classifier - PASS75

A ferramenta `event_script_b4_inline_payload_classifier_pass75.py` recebe a saida da Pass 74 e faz uma sobreposicao semantica sobre os 99 residuos in-group.

Regra principal:

```text
se residual_byte == $B4:
    classificar como b4_inline_tile_object_payload_closed
senao:
    manter como non_b4_inline_residual_needs_trace
```

Justificativa:

- `$B4` esta fora da faixa oficial de EventCmd `$00-$59`.
- O audit oficial ja esta 90/90.
- O padrao `$B4` aparece principalmente em grupos de tile/object setup.
- O stream apos `$B4` segue formato repetitivo de payload de objeto/tile, nao dispatcher de opcode.

Resultado:

| Metrica | Valor |
|---|---:|
| Residuos in-group Pass 74 | 99 |
| `$B4` fechados | 73 |
| Non-B4 restantes | 26 |
| Cobertura efetiva | 99.697% |
