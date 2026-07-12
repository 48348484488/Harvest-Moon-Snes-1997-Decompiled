# Relatorio final - HM-Decomp build verificado

Este pacote foi preparado para recompilar a disassembly/decompilation de Harvest Moon SNES com Asar.

## Status principal

A build da ROM USA foi testada com sucesso usando Asar Linux compilado localmente a partir do source correto `RPGHacker/asar`.

Resultado da validacao:

```text
MD5 original USA: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild USA:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

Isso significa que o projeto, no estado atual, consegue reconstruir a ROM USA esperada pelo README.

## Ferramentas incluidas

- `tools/bin/linux/asar` - Asar 1.91 compilado para Linux x86_64 neste ambiente.
- `tools/bin/windows/asar.exe` - Asar Windows enviado anteriormente.
- `build_linux.sh` - build automatica no Linux.
- `build_windows.bat` - build automatica no Windows.
- `tools/build_and_compare.py` - monta e compara o resultado com a ROM original.
- `tools/rom_info.py` - gera informacoes da ROM.

## Como usar no Linux

Coloque a ROM USA limpa em:

```text
roms/Harvest Moon (USA).sfc
```

Depois execute:

```bash
./build_linux.sh
```

## Como usar no Windows

Coloque a ROM USA limpa em:

```text
roms\Harvest Moon (USA).sfc
```

Depois execute:

```bat
build_windows.bat
```

## Importante

A ROM original e a ROM reconstruida nao estao incluidas no pacote final. O pacote contem apenas source, ferramentas, scripts e relatorios.

## Sobre "terminar a decompilacao"

Existem dois niveis diferentes:

1. Rebuild tecnico byte-perfect: concluido. O projeto recompila e gera a mesma ROM USA.
2. Decompilacao semantica completa: ainda nao esta concluida, porque existem muitos labels genericos como `UNK_`, `DATA8_` e `DATA16_`, alem de trechos ainda tratados como dados brutos.

Ou seja: tecnicamente a ROM USA ja recompila perfeitamente; o trabalho restante agora e documentar, nomear rotinas, separar sistemas internos e melhorar a leitura humana do codigo.
