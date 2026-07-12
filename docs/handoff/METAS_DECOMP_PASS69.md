# METAS DECOMP PASS69

Estado apos a Pass 69:

- Fechado 100% do `CODE_` generico em `bank_83.asm`.
- Restam 784 labels `CODE_`, todos concentrados em `bank_81.asm`.

Proxima pass sugerida:

1. Renomear `CODE_81xxxx` para aliases estaveis de Bank 81.
2. Validar rebuild byte-perfect.
3. Se todos forem fechados, declarar `CODE_` genericos zerados no source inteiro.

Cuidado:

- Preservar o sufixo de endereco no novo label.
- Nao alterar bytes/instrucoes.
- Remover ROM e rebuild `.sfc` antes de compactar.
