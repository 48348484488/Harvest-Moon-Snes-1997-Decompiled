# EventScript Symbolic Disassembly B3-B5

A Pass 57 adiciona uma camada simbolica para ler os scripts de evento `B3-B5` sem depender apenas de `db $xx`.

## Objetivo

Transformar o material das Passes 55 e 56 em uma visao pratica para decompilacao humana:

- cada entrada de grupo ganha um preview em pseudocodigo;
- opcodes recebem nomes descritivos;
- jumps e nested scripts aparecem como enderecos simbolicos;
- comandos de texto mostram somente `text_id`;
- dependencias de RAM/flags ficam pesquisaveis por CSV.

## Arquivos principais

```text
tools/event_script_symbolic_disasm.py
tools/event_script_ram_dependency.py
reports/event_script_symbolic_disasm_priority_b3_b5.md
reports/event_script_symbolic_index_pass57.csv
reports/event_script_ram_dependency_pass57.md
```

## Grupos prioritarios expandidos

Foram expandidos os grupos de maior valor para cenas/NPCs/eventos:

```text
$00, $44, $04, $07, $01, $06, $08, $02, $43, $45, $03, $47
```

## Leitura do relatorio simbolico

Exemplo conceitual:

```text
StartNestedScriptSlot(slot=$01, target=$B59BD5)
JumpIfFlagSet(mem=$800196, bit=$01, target=$B599EA)
StartTextBox(text_id=$0212, mode=$00)
SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8AEC, mode=$00)
```

Isso nao significa que todos os opcodes estao 100% semanticamente fechados. A pass cria uma camada de nomeacao conservadora para orientar a proxima rodada de renomeacao manual.

## Ganho pratico

Antes da Pass 57, os grupos B3-B5 tinham catalogo e perfil. Depois da Pass 57, e possivel responder rapidamente:

- qual grupo usa mais dialogo;
- qual script le determinada flag/RAM;
- quais entradas chamam `StartTextBox`;
- quais scripts criam/movem objetos CC;
- quais scripts devem ser atacados primeiro para nomear NPCs e cenas.
