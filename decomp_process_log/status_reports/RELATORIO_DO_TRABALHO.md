# HM-Decomp - pacote revisado

Eu analisei o ZIP enviado e constatei que ele e uma disassembly/decompilation parcial de Harvest Moon SNES USA, nao um ROM cru.

## O que foi feito neste pacote

1. Extraido o projeto DiztinGUIsh compactado para XML legivel:
   - `decomps/Harvest_Moon_USA_Main.diz.xml`

2. Criada auditoria automatica do estado da decompilacao:
   - `tools/decomp_audit.py`
   - `reports/decomp_audit.md`
   - `reports/decomp_audit.csv`

3. Criado script de montagem/comparacao:
   - `tools/build_and_compare.py`

4. Criado script para reextrair o `.diz`:
   - `tools/extract_diz_xml.py`

5. Corrigidos includes internos inconsistentes:
   - `src/code_banks/bank_80.asm`
   - `src/code_banks/bank_82.asm`
   - patch resumido em `patches/fix_nested_includes.diff`

6. Criada documentacao de continuidade:
   - `docs/COMO_CONTINUAR_DECOMP.md`

## Estado real encontrado

- Arquivos ASM analisados: 74
- Linhas ASM: 182165
- Marcacoes TODO: 93
- Referencias `UNK_`: 934
- Referencias `DATA8_`: 503
- Referencias `DATA16_`: 2380
- Linhas brutas `db/dw/dl`: 108822 / 14239 / 2000

## Bancos mais importantes para continuar

1. `bank_83.asm` - muito audio, ponteiros e `DATA16_`.
2. `bank_84.asm` - muito controle/logica ainda com TODO.
3. `bank_81.asm` - banco pouco entendido, com muitos labels genericos.
4. `bank_82.asm` - ferramentas, clima, textos e eventos.
5. `bank_B3` a `bank_B5` - provavel bytecode de eventos/scripts.
6. `bank_B6` a `bank_BB` - texto/dialogos.
7. bancos de dados/sprites/tilemaps - ainda estao majoritariamente como `db` bruto.

## Limite importante

Nao foi possivel gerar um ROM final validado byte-a-byte aqui porque o projeto nao inclui o ROM original e o ambiente nao possui `asar` instalado. O pacote agora esta preparado para voce compilar localmente usando uma copia legal de `Harvest Moon (USA).sfc` e comparar o resultado.
