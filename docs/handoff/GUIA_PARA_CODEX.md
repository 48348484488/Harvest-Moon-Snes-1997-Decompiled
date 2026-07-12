# Guia rapido para Codex/IA continuar

## Validacao obrigatoria

Coloque a ROM USA limpa em:

```text
project_buildable/roms/Harvest Moon (USA).sfc
```

MD5 esperado:

```text
c9bf36a816b6d54aed79d43a6c45111a
```

Rode:

```bash
cd project_buildable
./build_linux.sh
```

O rebuild precisa continuar byte-perfect.

## Nao distribuir

Nao incluir no pacote final:

- ROM original;
- ROM recompilada;
- dumps completos comerciais.

## Ultimo escopo fechado

Pass 50 - Map Entry Tile Patch Core 100%.

## Proximas metas sugeridas

1. Final Unknown Labels Audit.
2. Text/Dialog Content Classification.
3. NPC Schedule Detail Pass.
4. Final Documentation Consolidation.
