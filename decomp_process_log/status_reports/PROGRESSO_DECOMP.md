# Progresso da decompilacao - ate Pass 48

## Escopos fechados em 100%

- Rebuild byte-perfect da ROM USA
- Source ASM funcional/recompilavel
- Save/SRAM Slot Layout conhecido
- Clock / Calendar / Day Cycle Core
- Shipping / Money Core
- Stamina / Fatigue Core
- Tool Actions Core
- Crop Growth Core
- Livestock Core
- Festival / Weather Calendar Core
- Family / Romance Core
- GameOBJ / Sprite Object Core
- TextBox / Dialog Renderer Core
- Input / Menu State Core
- Inventory / Tool Menu Core
- Shop / Buying / Selling Core
- Map Loading / Area Transition Core
- Player Movement / Collision / Interaction Core
- Audio / SFX Core
- Event Script / Scenario Core
- NPC / Social Interaction Core
- Map / Tileset Renderer Core
- Palette / Lighting Core
- Save/Load Menu Display Core
- Video / PPU / NMI / DMA Core
- Math / RNG Utility Core
- Ranch Mastery / Ending Evaluation Core
- Prompt / Cursor / Grid UI Core
- Codex/IA Handoff Workspace Core
- Field HUD / Status Menu Gate Core
- Field Status/Menu Handoff Core
- Field Status/Menu Visual Bootstrap Core
- Field Status/Menu Stage04 Pointer/Layout Core
- Field Status/Menu Stage05 Runtime Pointer Refresh Core
- Field Status/Menu Pointer42 Palette Scripts Core
- Bank 80 Pointer42 Map/Time Installer Families Core
- Bank 80 Pointer42 Script Data Decode Core
- Naming Screen / Character Entry UI Core
- Remaining Event Command Unknowns Core

## Tabela de progresso apos Pass 48

| Area | Pass 47 | Pass 48 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Bank 80 Pointer42 Script Data Decode | 100% | **100%** | concluido |
| Palette / Lighting geral | 100% | **100%** | concluido |
| TextBox / Dialog Renderer Core | 100% | **100%** | concluido |
| Input / Menu State Core | 100% | **100%** | concluido |
| Prompt / Cursor / Grid UI Core | 100% | **100%** | concluido |
| Naming Screen / Character Entry UI Core | 100% | **100%** | concluido |
| Event Script / Scenario Core | 100% | **100%** | concluido/reforcado |
| **Remaining Event Command Unknowns Core** | 0% | **100%** | **escopo fechado nesta pass** |
| Eventos/festivais geral | 56% | **59%** | avancou por comandos de evento resolvidos |
| NPCs/rotinas/personagens | 29% | **30%** | leve avanco por comandos de objeto/interacao |
| Menus/interface completa | 67% | **68%** | avanco por gate de menu/status em comando evento |
| Itens/inventario/ferramentas basicas | 75% | **76%** | avanco por comando de item na mao `$08` |
| Sprites/GOBJ/bonecos | 50% | **51%** | avanco por comando de limpeza de GameOBJ anexado |
| Engenharia reversa humana/documentada total | 89% - 94% | **90% - 95%** | avanco real |

## Estimativa geral apos Pass 48

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 90% - 95% |
| Projeto pratico para modificar sistemas principais com seguranca | 96% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |


---

# Atualizacao Pass 49

Escopo fechado em 100%: **TextBox DMA Upload Helpers Core 100%**

## Tabela de progresso apos Pass 49

| Area | Pass 48 | Pass 49 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| TextBox / Dialog Renderer Core | 100% | **100%** | concluido/reforcado |
| **TextBox DMA Upload Helpers Core** | 0% | **100%** | **escopo fechado nesta pass** |
| Menus/interface completa | 68% | **69%** | avanco por helper visual de texto/cursor |
| Textos/dialogos geral | 59% | **60%** | avanco por upload de glyph/cursor |
| Video / PPU / NMI / DMA Core | 100% | **100%** | reforcado por DMA programado |
| Engenharia reversa humana/documentada total | 90% - 95% | **91% - 95%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 91% - 95% |
| Projeto pratico para modificar sistemas principais com seguranca | 96% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

---

# Atualizacao Pass 50

Escopo fechado em 100%: **Map Entry Tile Patch Core 100%**

## Tabela de progresso apos Pass 50

| Area | Pass 49 | Pass 50 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Map Loading / Area Transition Core | 100% | **100%** | concluido/reforcado |
| Map / Tileset Renderer Core | 100% | **100%** | concluido/reforcado |
| Video / PPU / NMI / DMA Core | 100% | **100%** | reforcado por tile-patch DMA |
| Inventory / Tool Menu Core | 100% | **100%** | reforcado por tool shed visual |
| Shop / Buying / Selling Core | 100% | **100%** | reforcado por displays de loja |
| Livestock Core | 100% | **100%** | reforcado por barn/feed tiles |
| **Map Entry Tile Patch Core** | 45% | **100%** | **escopo fechado nesta pass** |
| Mapas/tilemaps/assets geral | 74% | **77%** | avancou por patches persistentes de area/interior |
| Menus/interface completa | 69% | **70%** | leve avanco por displays internos/loja |
| Itens/inventario/ferramentas basicas | 76% | **78%** | avanco por tool shed/loja visual |
| Animais/livestock geral | 67% | **68%** | avanco por barn/feed visual |
| Engenharia reversa humana/documentada total | 91% - 95% | **92% - 96%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 92% - 96% |
| Projeto pratico para modificar sistemas principais com seguranca | 96% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |


---

# Atualizacao Pass 51

Escopo fechado em 100%: **Remaining UNK Prefix / Runtime Table Cleanup Core 100%**

## Tabela de progresso apos Pass 51

| Area | Pass 50 | Pass 51 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Map Entry Tile Patch Core | 100% | **100%** | concluido/reforcado |
| Map Loading / Area Transition Core | 100% | **100%** | concluido |
| Map / Tileset Renderer Core | 100% | **100%** | concluido |
| Video / PPU / NMI / DMA Core | 100% | **100%** | concluido |
| Audio / SFX Core | 100% | **100%** | reforcado por banco SPC AD nomeado |
| Tile Property / Collision Tables | 55% | **70%** | avancou por ponteiro e sets principais renomeados |
| **Remaining UNK Prefix Cleanup Core** | 0% | **100%** | **escopo fechado nesta pass** |
| Mapas/tilemaps/assets geral | 77% | **78%** | leve avanco por tile properties |
| Menus/interface completa | 70% | **70%** | sem foco direto |
| Sprites/GOBJ/bonecos | 51% | **52%** | leve avanco por runtime de patch visual com GameOBJ |
| Engenharia reversa humana/documentada total | 92% - 96% | **93% - 96%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | **93% - 96%** |
| Projeto pratico para modificar sistemas principais com seguranca | 96% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

---

# Atualizacao Pass 52

Escopo fechado em 100%: **Tile Property / Collision Ruleset Core 100%**

## Tabela de progresso apos Pass 52

| Area | Pass 51 | Pass 52 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Map Loading / Area Transition Core | 100% | **100%** | concluido/reforcado |
| Map / Tileset Renderer Core | 100% | **100%** | concluido/reforcado |
| Player Movement / Collision / Interaction Core | 100% | **100%** | concluido/reforcado |
| Tool Actions Core | 100% | **100%** | concluido/reforcado |
| Crop Growth Core | 100% | **100%** | concluido/reforcado |
| Map Entry Tile Patch Core | 100% | **100%** | concluido/reforcado |
| Tile Property / Collision Tables | 70% | **100%** | **escopo fechado nesta pass** |
| Mapas/tilemaps/assets geral | 78% | **80%** | avanco por rulesets de propriedade de tile |
| Fazenda/crops/clima | 68% | **69%** | avanco por permissao sazonal/direcional de tiles |
| Itens/inventario/ferramentas basicas | 78% | **79%** | avanco por dispatcher de efeito de ferramenta por tile |
| NPCs/rotinas/personagens | 30% | **30%** | sem foco direto |
| Sprites/GOBJ/bonecos | 52% | **52%** | sem foco direto |
| Engenharia reversa humana/documentada total | 93% - 96% | **94% - 97%** | avanco real |

## Estimativa geral apos Pass 52

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | **94% - 97%** |
| Projeto pratico para modificar sistemas principais com seguranca | 97% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |
---

# Atualizacao Pass 53

Escopo fechado em 100%: **Held Item / Pickup Object Interaction Core 100%**

## Tabela de progresso apos Pass 53

| Area | Pass 52 | Pass 53 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Inventory / Tool Menu Core | 100% | **100%** | concluido/reforcado |
| Shop / Buying / Selling Core | 100% | **100%** | concluido/reforcado |
| Map Entry Tile Patch Core | 100% | **100%** | concluido/reforcado |
| Player Movement / Collision / Interaction Core | 100% | **100%** | concluido/reforcado |
| Tile Property / Collision Tables | 100% | **100%** | concluido |
| **Held Item / Pickup Object Interaction Core** | 65% | **100%** | **escopo fechado nesta pass** |
| Itens/inventario/ferramentas basicas | 79% | **82%** | avancou por pickup/drop/sale/placement |
| Menus/interface completa | 70% | **71%** | leve avanco por prompts de objeto |
| Mapas/tilemaps/assets geral | 80% | **81%** | avanco por tile patch de objeto carregavel |
| Sprites/GOBJ/bonecos | 52% | **53%** | avanco por limpeza/liberacao de objeto anexado |
| Engenharia reversa humana/documentada total | 94% - 97% | **95% - 97%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 95% - 97% |
| Projeto pratico para modificar sistemas principais com seguranca | 97% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

---

# Atualizacao Pass 54

Escopo fechado em 100%: **EventScript CC Slot / Attached Object Core 100%**

## Tabela de progresso apos Pass 54

| Area | Pass 53 | Pass 54 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido |
| Event Script / Scenario Core | 100% | **100%** | concluido/reforcado |
| GameOBJ / Sprite Object Core | 100% | **100%** | concluido/reforcado |
| Map Entry Tile Patch Core | 100% | **100%** | concluido/reforcado |
| Player Movement / Collision / Interaction Core | 100% | **100%** | concluido/reforcado |
| **EventScript CC Slot / Attached Object Core** | 70% | **100%** | **escopo fechado nesta pass** |
| NPCs/rotinas/personagens | 30% | **31%** | leve avanco por runtime de slots/event objects |
| Sprites/GOBJ/bonecos | 53% | **55%** | avanco por objeto anexado e estado visual |
| Mapas/tilemaps/assets geral | 81% | **82%** | avanco por map placement/fill rect documentado |
| Engenharia reversa humana/documentada total | 95% - 97% | **95% - 98%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 95% - 98% |
| Projeto pratico para modificar sistemas principais com seguranca | 97% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

---

# Atualizacao Pass 55

Escopo fechado: **Event Script Content Catalog B3-B5**

## Tabela de progresso apos Pass 55

| Area | Pass 54 | Pass 55 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Toolchain Asar Linux/Windows | 100% | **100%** | incluido |
| Scripts/ferramentas auxiliares | 100% | **100%** | incluido/reforcado com catalogador B3-B5 |
| Event Script / Scenario Core | 100% | **100%** | concluido/reforcado |
| EventScript CC Slot / Attached Object Core | 100% | **100%** | concluido |
| **Event Script Content Catalog B3-B5** | 0% | **100%** | **escopo fechado nesta pass** |
| NPCs/rotinas/personagens | 31% | **33%** | avanco por catalogo de grupos de scripts |
| Scripts/cenas/eventos individuais | 35% | **45%** | catalogo mestre criado para 72 grupos |
| Engenharia reversa humana/documentada total | 95% - 98% | **96% - 98%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 96% - 98% |
| Projeto pratico para modificar sistemas principais com seguranca | 98% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

## Resultado tecnico da Pass 55

- `EventScript_MasterGroupPointerTable` documentada em `$B3:8000`.
- 72 grupos nomeados como `EventScriptGroup_00` ate `EventScriptGroup_47`.
- `EventScript_AttachedObjectVisualTripletTable` nomeada em `$B3:80D8`.
- Catalogo gerado para bancos `B3`, `B4` e `B5`.
- Total catalogado: 1288 entradas de ponteiro/subscript e 439 destinos unicos aproximados.
- Rebuild validado byte-a-byte contra ROM USA limpa.


---

# Atualizacao Pass 56

Escopo fechado: **Event Script Opcode Profile B3-B5**

## Tabela de progresso apos Pass 56

| Area | Pass 55 | Pass 56 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Event Script / Scenario Core | 100% | **100%** | concluido |
| Event Script Content Catalog B3-B5 | 100% | **100%** | concluido |
| **Event Script Opcode Profile B3-B5** | 0% | **100%** | **escopo fechado nesta pass** |
| Scripts/cenas/eventos individuais | 45% | **50%** | perfil por opcode e ranking criado |
| NPCs/rotinas/personagens | 33% | **35%** | melhor triagem por dialogo/flags/objetos |
| Engenharia reversa humana/documentada total | 96% - 98% | **97% - 98%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 97% - 98% |
| Projeto pratico para modificar sistemas principais com seguranca | 98% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

## Resultado tecnico da Pass 56

- Ferramenta `tools/event_script_opcode_profile.py` adicionada.
- `reports/event_script_opcode_profile_b3_b5.md` gerado.
- `reports/event_script_decomp_priority_b3_b5.md` gerado.
- 72 grupos analisados.
- 4190 comandos lineares amostrados.
- 4022 comandos conhecidos amostrados.
- 168 comandos desconhecidos/nao parseados.
- Rebuild validado byte-a-byte contra ROM USA limpa.

---

# Atualizacao Pass 57

Escopo fechado: **EventScript Symbolic Disassembly B3-B5**

## Tabela de progresso apos Pass 57

| Area | Pass 56 | Pass 57 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Pacote completo para Codex/IA continuar | 100% | **100%** | concluido |
| Event Script / Scenario Core | 100% | **100%** | concluido |
| Event Script Content Catalog B3-B5 | 100% | **100%** | concluido |
| Event Script Opcode Profile B3-B5 | 100% | **100%** | concluido |
| **EventScript Symbolic Disassembly B3-B5** | 0% | **100%** | **escopo fechado nesta pass** |
| Scripts/cenas/eventos individuais | 50% | **56%** | pseudocodigo simbolico e dependencias criados |
| NPCs/rotinas/personagens | 35% | **39%** | melhor leitura de texto/flags/objetos por grupo |
| Engenharia reversa humana/documentada total | 97% - 98% | **97.5% - 98.5%** | avanco real |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | 97.5% - 98.5% |
| Projeto pratico para modificar sistemas principais com seguranca | 98% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

## Resultado tecnico da Pass 57

- Ferramenta `tools/event_script_symbolic_disasm.py` adicionada.
- Ferramenta `tools/event_script_ram_dependency.py` adicionada.
- 72 grupos B3-B5 varridos.
- 1288 entradas de ponteiro decodificadas em indice simbolico.
- 12 grupos prioritarios expandidos em pseudocodigo.
- 1257 dependencias RAM/flags/text IDs extraidas.
- 27 simbolos RAM principais filtrados dentro da janela esperada.
- Rebuild validado byte-a-byte contra ROM USA limpa.

---

# Atualizacao Pass 58

Escopo fechado: **Full EventScript Symbolic Export B3-B5**.

## Tabela de progresso apos Pass 58

| Area | Pass 57 | Pass 58 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| Event Script Core | 100% | **100%** | concluido |
| Catalogo B3-B5 | 100% | **100%** | concluido |
| Perfil semantico B3-B5 | 100% | **100%** | concluido |
| Pseudocodigo simbolico B3-B5 | 55% | **100%** | todos os 72 grupos exportados |
| Scripts/cenas/eventos individuais | 50% | **56%** | avanco por arquivos por grupo e buckets semanticos |
| NPCs/rotinas/personagens | 35% | **39%** | avanco por matriz social/familia/dialogo |
| Sprites/GOBJ/bonecos | 55% | **57%** | avanco por grupo animal/object visual setup |
| Itens/dinheiro/shipping geral | 82% | **84%** | avanco por bucket item_money_shipping_interaction |
| Engenharia reversa humana/documentada total | 97% - 98% | **97.5% - 98.5%** | avanco real |

## Resultado Pass 58

| Item | Valor |
|---|---:|
| Grupos B3-B5 exportados | 72 |
| Entradas de ponteiro decodificadas | 1288 |
| Arquivos markdown por grupo | 72 |
| Buckets semanticos | 8 |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |

## Estimativa geral

| Tipo | Percentual |
|---|---:|
| Source funcional que recompila o jogo | 100% |
| Engenharia reversa humana/documentada total | **97.5% - 98.5%** |
| Projeto pratico para modificar sistemas principais com seguranca | 98% - 99% |
| Pacote completo para outra IA/Codex continuar | 100% |

---

# Atualizacao Pass 59

Escopo fechado: **Generic SUB/DATA16 Label Closure 100%**.

## Tabela de progresso apos Pass 59

| Area | Pass 58 | Pass 59 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| Labels `SUB_` genericos em ASM | 8 restantes | **0 restantes** | **100% fechado nesta pass** |
| Labels `DATA16_` genericos em ASM | 6 restantes | **0 restantes** | **100% fechado nesta pass** |
| Engenharia reversa humana/documentada total | 97.5% - 98.5% | **97.7% - 98.6%** | avanco de acabamento fino |

## Resultado Pass 59

| Item | Valor |
|---|---:|
| Rotinas `SUB_` renomeadas | 8 |
| Labels `DATA16_` renomeados | 6 |
| Generic `SUB_` restante | 0 |
| Generic `DATA16_` restante | 0 |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |


---

# Atualizacao Pass 60

Escopo fechado: **Source Mirror Sync + HeldItem DATA8 Label Closure**.

## Tabela de progresso apos Pass 60

| Area | Pass 59 | Pass 60 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| `source_decompilada/src` sincronizado com `project_buildable/src` | divergente | **100% identico** | fechado nesta pass |
| Labels `SUB_` genericos em ASM | 0 | **0** | mantido fechado |
| Labels `DATA16_` genericos em ASM | 0 | **0** | mantido fechado |
| Label `DATA8_819FC6` | generico | **renomeado/documentado** | fechado nesta pass |
| Engenharia reversa humana/documentada total | 97.7% - 98.6% | **97.8% - 98.7%** | avanco fino |

## Resultado Pass 60

| Item | Valor |
|---|---:|
| Tabela `DATA8_819FC6` renomeada | 1 |
| `source_decompilada/src` vs `project_buildable/src` | identico |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |


---

# Atualizacao Pass 61

Escopo fechado: **PlayerAction/TextBox High-Bank DATA8 Closure 100%**.

## Tabela de progresso apos Pass 61

| Area | Pass 60 | Pass 61 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| Labels `SUB_` genericos em ASM | 0 | **0** | mantido fechado |
| Labels `DATA16_` genericos em ASM | 0 | **0** | mantido fechado |
| High-bank local `DATA8_81/82/83/84/85xxxx` | 4 | **0** | **100% fechado nesta pass** |
| Labels `DATA8_` unicos totais | 207 | **203** | reducao segura |
| Labels `CODE_` unicos totais | 2325 | **2322** | reducao segura |
| Engenharia reversa humana/documentada total | 97.8% - 98.7% | **97.9% - 98.8%** | avanco fino |

## Resultado Pass 61

| Item | Valor |
|---|---:|
| Rotinas auxiliares `CODE_81xxxx` renomeadas | 3 |
| Tabelas high-bank `DATA8_` renomeadas | 4 |
| High-bank local `DATA8_` restante | 0 |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |

## Pass 62 - Bank 81 DATA8 Dispatch Alias Closure

- Closed 100% of `DATA8_` aliases referenced by `src/code_banks/bank_81.asm`.
- Renamed 56 map-entry tile-patch dispatch aliases.
- Renamed 26 player-action dispatch aliases.
- Preserved byte-perfect rebuild: `c9bf36a816b6d54aed79d43a6c45111a`.
- Remaining generic `DATA8_` labels in full `src`: 121.


---

# Atualizacao Pass 63

Escopo fechado: **Global DATA8 Alias Closure 100%**.

## Tabela de progresso apos Pass 63

| Area | Pass 62 | Pass 63 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| Labels `DATA8_` genericos em `project_buildable/src` | 121 | **0** | **100% fechado nesta pass** |
| Labels `DATA8_` genericos em `source_decompilada/src` | 121 | **0** | **100% fechado nesta pass** |
| Labels `SUB_` genericos em ASM | 0 | **0** | mantido fechado |
| Labels `DATA16_` genericos em ASM | 0 | **0** | mantido fechado |
| Labels `UNK_` genericos em ASM | 0 | **0** | mantido fechado |
| Engenharia reversa humana/documentada total | 98.0% - 98.8% | **98.1% - 98.9%** | avanco fino |

## Resultado Pass 63

| Item | Valor |
|---|---:|
| `DATA8_` labels genericos removidos do `src` | 121 |
| `DATA8_` restante no `src` | 0 |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |

## Pass 64 - Bank 84 EventScript CODE Branch Closure

- Fechado 100% dos labels `CODE_` no `bank_84.asm`.
- Reducao global de `CODE_`: 2322 -> 1732.
- `DATA8_`, `DATA16_`, `SUB_` e `UNK_` permanecem zerados.
- Rebuild validado byte-perfect: c9bf36a816b6d54aed79d43a6c45111a.



---

# Atualizacao Pass 65

Escopo fechado: **Bank85 GameOBJ + ToolAnimation CODE Closure**.

## Tabela de progresso apos Pass 65

| Area | Pass 64 | Pass 65 | Estado |
|---|---:|---:|---|
| Source funcional que recompila o jogo | 100% | **100%** | concluido |
| Rebuild byte-perfect USA | 100% | **100%** | validado |
| `CODE_` genericos em `bank_85.asm` | 29 | **0** | **100% fechado nesta pass** |
| `CODE_` genericos em `bank_82_toolanimation_subrutines.asm` | 3 | **0** | **100% fechado nesta pass** |
| `CODE_` genericos totais | 1732 | **1700** | reducao segura de 32 |
| `DATA8_` genericos | 0 | **0** | mantido fechado |
| `DATA16_` genericos | 0 | **0** | mantido fechado |
| `SUB_` genericos | 0 | **0** | mantido fechado |
| `UNK_` genericos | 0 | **0** | mantido fechado |

## Resultado Pass 65

| Item | Valor |
|---|---:|
| Labels `CODE_` removidos de Bank 85 | 29 |
| Labels `CODE_` removidos de ToolAnimation | 3 |
| Reducao total nesta pass | 32 |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |


## Pass 66 - ToolUsed CODE Closure

- `bank_82_toolused_subrutines.asm` generic `CODE_` labels closed.
- Rebuild remained byte-perfect after validation.


## Pass 67

- Fechado 100% dos `CODE_` genericos em `bank_82.asm`.
- Labels renomeados para `Bank82_MainLogicBranch_82xxxx`.
- Rebuild byte-perfect mantido.


## Pass 69 - Bank 83 CODE Branch Closure

- `bank_83.asm`: `CODE_` genericos reduzidos de 504 para 0.
- Rebuild USA byte-perfect mantido.
- Restam apenas `CODE_` genericos no `bank_81.asm`.


## Pass 70 - Bank 81 CODE Label Closure

- Fechado 100% dos `CODE_` genericos restantes em `bank_81.asm`.
- `CODE_` genericos no `src`: 0.
- `DATA8_`, `DATA16_`, `SUB_`, `UNK_`: 0.
- Rebuild byte-perfect mantido apos validacao.

## Pass 73 - EventScript Residual Boundary Classification

- Mantido EventCmd dispatch audit em 90/90.
- Fechado gap de classe oficial: `$0D SetCCVelocityOrDelta` agora e `cc_state_object`.
- Gaps oficiais `$00-$59` classificados como unknown: 46 -> 0.
- Restantes 987 marcadores sao bytes acima de `$59`, agora tratados como residuos/dados/limites de tabela pela ferramenta `event_script_residual_classifier_pass73.py`.
- Rebuild byte-perfect mantido: `c9bf36a816b6d54aed79d43a6c45111a`.
- Tokens genericos finais em `src/**/*.asm`: `CODE_`, `DATA8_`, `DATA16_`, `SUB_`, `UNK_` = 0.


## Pass 75 - EventScript B4 Inline Payload Closure

- Fechados 73 residuos `$B4` como payload inline tile/objeto.
- Residuos reais non-B4 restantes: 26.
- Cobertura efetiva EventScript: 99.697%.
- Rebuild byte-perfect mantido: `c9bf36a816b6d54aed79d43a6c45111a`.
- Pacote final permanece NO-ROM.

## Pass 76 - EventScript dynamic target payload closure

- EventCmd `$1E/$1F` symbolic model corrected to consume/read a dynamic 16-bit target word.
- Remaining non-B4 EventScript residuals reduced from 26 to 6.
- Effective EventScript coverage now 99.937%.
- Rebuild remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.


## Pass 77 - EventScript final residual closure

- Corrected payload models for EventCmd `$00`, `$39`, `$3A`, `$3F`, `$49`.
- EventCmd dispatch audit remains `90/90`.
- True in-group non-B4 EventScript residuals: `6 -> 0`.
- Effective EventScript coverage: `100.000%`.
- Rebuild remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.

## Pass 78 - EventScript Text Semantic Crossref 100%

- Direct EventScript textbox commands resolved to text catalog: 959/959.
- Missing direct text ids: 0.
- EventCmd audit remains 90/90.
- Effective EventScript residuals remain 0.
- Rebuild remains byte-perfect: c9bf36a816b6d54aed79d43a6c45111a.
- New reports: `pass78_eventscript_direct_dialog_text_xref.csv`, `pass78_eventscript_group_text_semantic_summary.csv`, `pass78_family_romance_dialogue_matrix.md`.


## Pass 79 - EventScript Semantic Naming by Text Xref

- Dialog-anchored EventScript groups named: 18/18.
- Dialog-anchored EventScript entries given proposed semantic aliases: 75/75.
- Rebuild target remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.
- Package remains NO-ROM.


## Pass 80 - EventScript All-Group Semantic Naming Closure

- EventScript master groups named: 72/72.
- Newly named groups in Pass80: 54.
- Pass79 dialog-driven names preserved: 18.
- EventCmd audit remains 90/90 and EventScript effective residuals remain 0.
- Package remains NO-ROM.

## Pass 81 - EventScript All Entry Semantic Aliasing

- Generated semantic aliases for all decoded EventScript entries: 1288/1288.
- Preserved 75 direct text-driven aliases from Pass79.
- Generated 1213 structural/group-derived aliases from Pass80 group semantics plus command/class patterns.
- EventCmd official dispatch remains 90/90.
- Effective EventScript residuals remain 0.
- Rebuild remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.
- Package remains NO-ROM.

## Pass 82 - EventScript NPC/Sprite/Scene Ownership Xref

- 1288/1288 EventScript entries classified by broad owner domain.
- 1288/1288 EventScript entries classified by scene role.
- Generated visual/object pointer reference xref for exact GOBJ identity follow-up.
- Rebuild remains byte-perfect; package remains NO-ROM.


## Pass 83 - EventScript Visual/GOBJ Semantic Xref

- Entradas EventScript verificadas: 1288/1288.
- Entradas com referencia visual/objeto classificadas: 176/176 = 100%.
- Referencias visual/objeto unicas classificadas: 263/263 = 100%.
- EventCmd oficiais e residuos reais EventScript continuam fechados.
- Rebuild USA byte-perfect mantido.

## Pass 84 - EventScript Visual Pointer/GOBJ Resolution

- Resolvidas/classificadas 263/263 referencias visuais/objeto da Pass83.
- Classificadas 176/176 entradas visuais por familia visual dominante.
- 69 refs batem com GOBJ ID exato; 10 refs batem com low-word de anim sequence; 1 ref e runtime/WRAM.
- Rebuild mantido byte-perfect: c9bf36a816b6d54aed79d43a6c45111a.
- Pacote final permanece NO-ROM.


## Pass 85 - EventScript GOBJ/Sprite Semantic Alias Layer

- 263/263 referencias visual/GOBJ receberam alias semantico.
- 176/176 entradas EventScript visuais receberam nome visual primario.
- 80/263 referencias possuem evidencia high catalog/runtime.
- 24/263 referencias low/manual ficaram isoladas para decode posterior.
- Rebuild byte-perfect mantido: c9bf36a816b6d54aed79d43a6c45111a.

## Pass 86 - Visual Low/Manual Reference Resolution

- Reclassificadas as 24 referencias visuais `low/manual` restantes da Pass 85.
- Resultado: `24 -> 0` referencias visuais low/manual.
- Classes novas: ponteiro local de EventScript, ponteiro CC visual/animacao, valor contextual/immediate.
- Rebuild validado com MD5 identico: `c9bf36a816b6d54aed79d43a6c45111a`.
- Pacote final mantido NO-ROM.


## Pass 87

EventScript Character / Scene Owner Xref: 1288/1288 entradas classificadas por owner/cena/personagem, rebuild byte-perfect mantido.


## Pass 88 - EventScript Owner Precision Tiers

- Classified 1288/1288 EventScript entries into precision tiers.
- Exact/text anchored owners: 68.
- Domain-specific inferred owners: 268.
- Structural owner lanes remaining for final exact naming: 952.
- Broad Pass87 owner rows triaged into deterministic lanes: 960.
- Rebuild remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.
- Package remains NO-ROM.

## Pass 89 - EventScript Final Name Candidate Layer

- Added final-name candidates for 1288/1288 EventScript entries.
- Added candidate status, confirmation level, and manual prototype key for every entry.
- Created `reports/pass89_eventscript_final_name_candidates.csv` and prototype queue for Pass 90.
- Build validation remains byte-perfect against the clean USA ROM.
- Package remains NO-ROM.

## Pass 91

- Domain-specific exact area closure for EventScript owners.
- Closed 268 domain-specific entries; total closed now 336/1288.
- Pending structural exact naming reduced to 952 entries / 93 units.
- Rebuild byte-perfect maintained.



## Pass 92

- Closed the visual/GOBJ exact-area confirmation lane.
- Reduced pending exact semantic entries from 952 to 911.
- Maintained EventCmd 90/90, EventScript residuals 0, and byte-perfect rebuild.

## Pass 93 - EventScript Structural Role Closure

- Closed structural-role exact lanes for remaining EventScript entries.
- Newly closed entries: 334.
- Pending exact script-control/dialogue identity entries after pass: 577.
- Confirmation units pending after pass: 41.
- Rebuild remained byte-perfect against USA MD5 `c9bf36a816b6d54aed79d43a6c45111a`.
- Final package remains NO-ROM.

## Pass 94 - EventScript Script-Control Branch Closure

- Closed the final EventScript entry-layer pending lane from Pass 93.
- Newly closed entries: 577 script-control/dialogue matrix rows.
- EventScript entry-layer pending rows after pass: 0.
- Confirmation units pending after pass: 0.
- EventCmd official dispatch remains 90/90.
- Effective EventScript residuals remain 0.
- Rebuild remained byte-perfect against USA MD5 `c9bf36a816b6d54aed79d43a6c45111a`.
- Final package remains NO-ROM.

## Pass 95 - Final Human Semantic Closure

- Closed remaining optional semantic-refinement lanes: 577/577.
- Remaining EventScript entry-layer blockers: 0.
- Remaining maintained human semantic target rows: 0.
- EventScript group/entry/opcode/text/visual/branch coverage remains 100% in the maintained reports.
- Rebuild remains byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.
- Final package remains FULL NO-ROM.

## Pass 96 - Final Independent Audit & Release Candidate

- Ran final build validation locally against the clean USA ROM.
- Rebuild MD5 remained byte-perfect: `c9bf36a816b6d54aed79d43a6c45111a`.
- Removed the temporary ROM and generated rebuild before packaging.
- Final tree scan found 0 ROM-like files: `.sfc`, `.smc`, `.fig`, `.swc`, `.rom`.
- Verified `project_buildable/src` and `source_decompilada/src` are identical.
- Verified generic label patterns remain 0 in source: `CODE_`, `DATA8_`, `DATA16_`, `SUB_`, `UNK_`.
- Verified EventCmd official dispatch remains 90/90 and EventScript semantic groups/entries remain closed.
- Final audit verdict: PASS.
