# Relatorio da etapa com ROM USA + Asar

## 1. ROM USA

A ROM USA enviada foi validada com sucesso. Ela bate com o MD5 esperado pelo projeto original.

- MD5 esperado: `c9bf36a816b6d54aed79d43a6c45111a`
- MD5 encontrado: `c9bf36a816b6d54aed79d43a6c45111a`
- Tamanho: `2097152` bytes
- Header copier: `nao`
- Mapeamento: LoROM

Relatorio completo:

- `reports/rom_info.md`

## 2. Asar

O arquivo `asar191.zip` enviado contem apenas o executavel Windows:

- `asar.exe`
- Tipo: `PE32+ executable for MS Windows x86-64`

O ambiente usado aqui e Linux. Ele nao tem `wine`, `wine64` nem `asar` Linux. Tambem nao conseguiu acessar repositorios externos para instalar pacotes. Por isso a montagem byte-a-byte nao pode ser executada aqui com esse `asar.exe`.

Relatorio completo:

- `reports/toolchain_status.md`
- `logs/build_attempt_linux_with_windows_asar.log`

## 3. O que foi feito no pacote

Foram adicionados scripts para voce rodar sem configurar muita coisa:

- `build_windows.bat`
- `build_linux.sh`
- `tools/build_and_compare.py` com suporte a `--asar`
- `roms/COLOQUE_A_ROM_AQUI.txt`
- `tools/bin/windows/asar.exe`

A ROM nao foi incluida no ZIP final.

## 4. Como rodar no Windows

1. Coloque a ROM USA limpa em:

   `roms/Harvest Moon (USA).sfc`

2. Execute:

   `build_windows.bat`

3. O script vai:

   - validar a ROM;
   - montar `src/main.asm` com Asar;
   - gerar `build/Harvest_Moon_USA_rebuild.sfc`;
   - comparar o rebuild com a ROM original;
   - informar a primeira diferenca, caso exista.

## 5. Como liberar a execucao aqui comigo

Para eu executar a montagem dentro deste ambiente, envie um Asar Linux x86_64. O arquivo ideal seria um ZIP contendo:

`asar`

Esse arquivo precisa ser binario Linux, nao `.exe` Windows.

Tambem serve um ZIP com o codigo-fonte completo do Asar, desde que seja compilavel localmente sem baixar dependencias externas.
