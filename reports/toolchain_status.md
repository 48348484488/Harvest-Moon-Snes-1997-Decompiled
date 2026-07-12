# Toolchain status

Gerado em: 2026-07-04T08:24:03

## Asar recebido

- Caminho no pacote: `tools/bin/windows/asar.exe`
- Tamanho: `501248` bytes
- MD5: `e292f4e55205150d11f91d5fcc631dd1`
- SHA256: `ecb04bce4a9a5a3b4dab4c9fafdc7875f30763fec15dec640b9cac11e11496e8`
- Tipo detectado: `tools/bin/windows/asar.exe: PE32+ executable for MS Windows 6.00 (console), x86-64, 7 sections`

## Ambiente desta execucao

- Sistema: Linux x86_64
- `asar` no PATH: nao encontrado
- `wine`/`wine64`: nao encontrado
- Resultado ao tentar executar o `asar.exe`: `Exec format error`

## Consequencia

A ROM USA foi validada, mas a etapa de montagem com Asar nao foi executada neste ambiente porque o Asar enviado e Windows.

No Windows, execute `build_windows.bat`.
No Linux, coloque um binario Linux em `tools/bin/linux/asar` ou instale `asar` no PATH e rode `./build_linux.sh`.
