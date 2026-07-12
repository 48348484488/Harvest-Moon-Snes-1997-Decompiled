# Log do Processo de Decompilação

Esta pasta guarda o **histórico bruto** do trabalho de engenharia reversa, mantido por
transparência e reprodutibilidade. Se você só quer usar o código, pode ignorar esta pasta —
comece por [`../README.md`](../README.md) e [`../docs/`](../docs).

## Conteúdo

- [`passes/`](./passes) — 37 arquivos `DECOMP_PASS_N.md`, um por etapa incremental do trabalho,
  descrevendo o que foi feito em cada "pass" de engenharia reversa
- [`validations/`](./validations) — 37 arquivos `VALIDACAO_BUILD_PASSN.md`, confirmando que o
  rebuild continuava byte-perfect contra a ROM de referência após cada pass
- [`pass_summaries/`](./pass_summaries) — resumos mais longos de passes específicos
- [`build_logs/`](./build_logs) — logs brutos de saída do assembler (`asar`) por pass
- [`status_reports/`](./status_reports) — relatórios de status/progresso gerais (progresso
  acumulado, relatórios de build final, notas soltas do processo)

## Por que isso não fica no README principal

O projeto foi trabalhado em ~97 iterações incrementais (muitas geradas com apoio de IA), cada
uma documentada em detalhe. Isso é valioso como registro histórico do processo, mas deixaria o
README principal e a raiz do repositório ilegíveis se misturado com a documentação de uso. Um
resumo condensado de tudo isso está em [`../CHANGELOG.md`](../CHANGELOG.md).
