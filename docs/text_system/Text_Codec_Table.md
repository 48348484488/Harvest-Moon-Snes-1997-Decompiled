# Text Codec Table

O Harvest Moon SNES representa texto como palavras de 16 bits em Assembly:

```asm
dw $0021,$0004,$000B,$000B,$000E,$FFFF
```

Cada palavra e um glifo, caractere ou controle.

## Letras basicas

| Codigo | Caractere |
|---:|---|
| `$0000-$0019` | `a-z` |
| `$001A-$0033` | `A-Z` |

Exemplos:

| Codigo | Char | Codigo | Char |
|---:|---|---:|---|
| `$0000` | a | `$001A` | A |
| `$0001` | b | `$001B` | B |
| `$0004` | e | `$001E` | E |
| `$000B` | l | `$0025` | L |
| `$000E` | o | `$0028` | O |
| `$0013` | t | `$002D` | T |
| `$0018` | y | `$0032` | Y |

## Pontuacao e controles conhecidos

| Codigo | Significado |
|---:|---|
| `$0034` | `'` |
| `$0035` | `,` |
| `$0036` | `.` |
| `$0037` | `?` |
| `$0038` | `"` |
| `$0039` | `!` |
| `$003A` | `:` |
| `$003E` | `-` |
| `$00A2` | quebra de linha/pagina visual |
| `$00B1` | espaco/padding |
| `$FFFF` | fim do texto |

## Glifos BR mapeados nesta passada

A ROM BR usa codigos extras para acentos. Estes foram inferidos por contexto nos textos traduzidos:

| Codigo | Char | Exemplo observado |
|---:|---|---|
| `$0043` | á | `Olá`, `Será`, `diário` |
| `$0044` | é | `é`, `também`, `céu` |
| `$0045` | í | `nível`, `difícil` |
| `$0047` | À | `Às vezes` |
| `$004B` | ó | `após`, `negócios` |
| `$004C` | ú | `útil`, `saúde` |
| `$004D` | ã | `amanhã`, `não`, `previsão` |
| `$004E` | Ó | `Ótima`, `Ótimo` |
| `$0053` | õ | `direções`, `condições` |
| `$0054` | ê | `você`, `têm`, `Dê` |
| `$0055` | ô | `pôr`, `avô`, `tô` |
| `$0057` | ç | `começar`, `peças`, `coração` |
| `$005B` | â | `relâmpagos`, `importância` |
| `$005C` | à | `à meia-noite`, `às vezes` |
| `$005D` | É | `É a comida`, `É melhor` |
| `$005F` | Ú | `Últimos` |

## Codigos ainda nao confirmados

Alguns codigos permaneceram undecodificados porque parecem ser glyphs de escolha, numeros, precos, horarios ou controles especiais:

```text
$0042, $0060, $0061, $0062, $0063, $00B6-$00BB, etc.
```

Veja:

```text
reports/decomp_pass02/text/br_unknown_glyphs.md
```

## Ferramenta principal

O codec esta em:

```text
tools/hm_text_codec.py
```

Ele decodifica os textos sem destruir dados desconhecidos. Qualquer codigo nao confirmado aparece como:

```text
<$XXXX>
```
