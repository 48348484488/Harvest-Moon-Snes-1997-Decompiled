# Pseudocode - EventScript RAM dependency tool

## Entrada

```text
python3 tools/event_script_ram_dependency.py --rom "roms/Harvest Moon (USA).sfc"
```

## Processo

1. Le todos os grupos `EventScriptGroup_00` ate `EventScriptGroup_47`.
2. Decodifica comandos de leitura/escrita de RAM e flags.
3. Registra referencias de texto por `text_id`.
4. Filtra o ranking principal para simbolos na janela esperada `7E/7F/80`.
5. Gera CSV bruto e Markdown resumido.

## Saida

```text
reports/event_script_ram_dependency_pass57.csv
reports/event_script_ram_dependency_top_symbols_pass57.csv
reports/event_script_ram_dependency_pass57.md
```

## Uso recomendado

Use este indice para escolher nomes futuros. Exemplo: se um grupo le muito `$80091E` e varios `Text_$0200`, ele provavelmente e uma matriz de dialogo/estado que deve ser cruzada com as tabelas de texto.
