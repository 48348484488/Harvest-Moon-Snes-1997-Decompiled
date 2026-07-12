# Changelog / Histórico do Projeto

Resumo de alto nível da evolução do projeto. Para o log completo, pass a pass, veja
[`decomp_process_log/`](./decomp_process_log).

## Status atual (v1.0 — Pass 97)

- **Source ASM 100% recompilável**, rebuild byte-perfect validado contra a ROM USA limpa
  (MD5 `c9bf36a816b6d54aed79d43a6c45111a`).
- Labels genéricos (`CODE_`, `DATA8_`, `DATA16_`, `SUB_`, `UNK_`) totalmente eliminados do
  source — todo o código tem nomes semânticos.
- Sistema de **EventScript** (o "motor de eventos" do jogo) 100% mapeado: 72/72 grupos e
  1288/1288 entradas nomeadas semanticamente, com cross-reference completo de texto, dono
  (NPC/cena) e referências visuais/GOBJ.
- Dispatch de comandos de evento (`EventCmd`) documentado 90/90.
- ~39 sistemas do jogo documentados individualmente em `docs/` (agricultura, clima, NPCs,
  save, menus, texto, HUD, áudio, etc.).

## Marcos principais por fase

- **Passes 1–11**: extração inicial de dados (itens, mapas, sprites, farm/weather, save,
  texto) e primeiros catálogos/visualizadores HTML.
- **Passes ~46–52**: fechamento de sistemas centrais (tile property/collision, held items).
- **Passes 57–61**: disassembly simbólico do EventScript, mapeamento de dependências de RAM.
- **Passes 62–70**: eliminação total dos labels genéricos (`CODE_`/`DATA8_`/`DATA16_`/`SUB_`)
  em todos os bancos de código.
- **Passes 71–77**: fechamento do dispatch table de `EventCmd` (90/90) e zeragem de resíduos
  do parser simbólico de EventScript.
- **Passes 78–95**: nomeação semântica completa do EventScript — cross-reference com texto,
  classificação de dono/cena/personagem, resolução de referências visuais/GOBJ, fechamento de
  todas as entradas (1288/1288) com nomes finais.
- **Pass 96**: auditoria final independente — confirma rebuild byte-perfect, ausência de
  arquivos de ROM no pacote e paridade entre as árvores de código.
- **Pass 97**: release candidate final v1.0 (NO-ROM).

## Nota sobre esta reorganização

Este repositório foi reorganizado a partir do pacote de trabalho original para ficar navegável
publicamente: consolidação de pastas duplicadas, separação do histórico bruto de passes em
`decomp_process_log/`, e remoção de imagens extraídas da ROM (ver `DISCLAIMER.md`). Nenhum
código-fonte foi alterado nesse processo.
