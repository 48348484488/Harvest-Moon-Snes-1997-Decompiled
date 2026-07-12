# EventScript Visual/GOBJ Semantic Xref - PASS83

Pass 83 adiciona uma camada de classificacao visual/GOBJ para as entradas EventScript.

- Entradas totais verificadas: 1288
- Entradas com referencia visual/objeto: 176
- Entradas visual/objeto classificadas: 176/176 = 100.000%
- Referencias unicas classificadas: 263/263 = 100.000%
- Tokens candidatos a ponteiro visual/GOBJ/asset: 204 (101 unicos)

A classificacao separa:

- comando visual/CC object direto;
- animacao/drop visual;
- parametro de estado de objeto;
- ponteiro candidato de asset/GOBJ;
- WRAM/runtime CC state;
- alvo local B3-B5;
- valor imediato/ID pequeno.

Essa camada reduz a pendencia de Sprites/GOBJ porque todas as entradas com sinais visuais agora tem dominio, papel visual e refs classificadas.
