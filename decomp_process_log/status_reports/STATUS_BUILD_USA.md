# Status da tentativa com ROM USA e Asar

## Resultado da ROM USA

A ROM USA enviada foi validada e bate com a ROM esperada pelo projeto.

- Tamanho: `2097152` bytes / `0x200000`
- Header copier: `nao`
- MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- SHA1: `a64a5634429a4f5341868a40c220d7be89fda70a`
- SHA256: `73a3aa87ddd5ce5df5ba51292316f42b6e128280179b0a1b11b4dcddc17d4163`

## Resultado do Asar enviado

O `asar191.zip` enviado contem `asar.exe`, que e executavel Windows `PE32+`.

Este ambiente de trabalho e Linux. Eu tentei localizar/instalar uma forma de executar esse Asar aqui, mas:

- nao existe `asar` Linux instalado no PATH;
- nao existe `wine`/`wine64` instalado;
- o ambiente nao conseguiu acessar os repositorios do Debian para instalar pacotes;
- o ZIP enviado nao contem fonte C++ nem binario Linux do Asar.

Por isso, a montagem byte-a-byte nao foi executada neste ambiente.

## O que foi preparado

Este pacote foi deixado pronto para rodar localmente:

- `build_windows.bat`: usa o `tools/bin/windows/asar.exe` incluido neste pacote.
- `build_linux.sh`: usa `tools/bin/linux/asar` ou `asar` no PATH.
- `tools/build_and_compare.py`: agora aceita `--asar` para apontar o binario manualmente.
- `tools/rom_info.py`: valida a ROM antes da comparacao.
- `reports/rom_info.md`: relatorio da ROM USA enviada.

## Como rodar no Windows

1. Copie sua ROM USA limpa para:

   `roms/Harvest Moon (USA).sfc`

2. Execute:

   `build_windows.bat`

3. Veja o resultado em:

   `build/Harvest_Moon_USA_rebuild.sfc`

4. Veja os relatorios em:

   `reports/`

## Como eu conseguiria executar aqui na proxima etapa

Envie um destes arquivos:

1. `asar` Linux x86_64 ja compilado; ou
2. o pacote/fonte do Asar que contenha o projeto C++ para compilar localmente; ou
3. um ZIP contendo `asar` para Linux dentro de uma pasta simples.

O arquivo ideal seria exatamente:

`asar`

com permissao de execucao, ou um ZIP contendo esse binario.
