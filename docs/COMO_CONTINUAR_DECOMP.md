# Como continuar a decompilacao

Este pacote nao inclui ROM. Use apenas uma copia legal de `Harvest Moon (USA).sfc`.
O README original informa o MD5 esperado: `c9bf36a816b6d54aed79d43a6c45111a`.

## 1. Auditar o estado atual

```bash
python tools/decomp_audit.py
```

Saidas:

- `reports/decomp_audit.md`
- `reports/decomp_audit.csv`

## 2. Extrair o projeto DiztinGUIsh para XML legivel

```bash
python tools/extract_diz_xml.py
```

Saida:

- `decomps/Harvest_Moon_USA_Main.diz.xml`

## 3. Montar com asar

Instale o `asar` e rode:

```bash
python tools/build_and_compare.py
```

Para comparar com seu ROM legal:

```bash
python tools/build_and_compare.py --original "/caminho/Harvest Moon (USA).sfc"
```

## 4. Prioridade real do restante

O projeto ja exportou quase todo o ROM em Assembly/Dados. O que falta nao e simplesmente "decompilar bytes"; falta entender e nomear corretamente:

1. Banco `83`: muito audio/ponteiros e muitas referencias `DATA16_`.
2. Banco `81`: muita logica de jogo ainda com `CODE_`/`DATA8_` generico.
3. Bancos `B3-B5`: scripts/eventos, precisam de decoder de bytecode.
4. Bancos `B6-BB`: texto, ja existem tabelas mas precisa converter mais dialogos para texto legivel.
5. Bancos `88-BF`: muitos dados/sprites/tilemaps ainda estao como `db` bruto.

## 5. Correcao aplicada nesta versao

Foram normalizados 3 includes internos para ficarem relativos aos arquivos dentro de `src/code_banks`:

```asm
incsrc "bank_80_pointersubrutines.asm"
incsrc "bank_82_toolanimation_subrutines.asm"
incsrc "bank_82_toolused_subrutines.asm"
```

A copia do patch resumido esta em `patches/fix_nested_includes.diff`.
