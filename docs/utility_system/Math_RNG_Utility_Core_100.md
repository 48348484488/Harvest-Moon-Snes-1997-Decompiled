# Math / RNG Utility Core 100%

Esta pass fecha o nucleo utilitario de matematica e RNG usado pelo jogo.

## Escopo fechado

O escopo cobre:

- multiplicacao unsigned usando registradores matematicos do SNES;
- divisao unsigned com caminho rapido por hardware e fallback manual;
- divisao signed aparentemente pouco/usada indiretamente;
- gerador central de RNG;
- helper de RNG limitado por faixa;
- relacao dessas rotinas com clima, fazenda, ferramentas, eventos, animais, audio e textbox.

## Rotinas principais

| Rotina | Endereco | Funcao |
|---|---:|---|
| `Math_MultiplyUnsigned8x8` | `$83:8067` | multiplica `!multiplicand` por `!multiplier` usando `WRMPYA/WRMPYB` e retorna o produto |
| `Math_DivideUnsigned16By16` | `$83:8082` | divide `!dividend` por `!divisor`; retorna quociente em `A` e resto em `!dision_rest` |
| `Math_DivideSigned16By16` | `$83:80D0` | divisao signed auxiliar, aparentemente nao central no gameplay normal |
| `RNG_GetNextByte` | `$83:8138` | atualiza o estado interno de RNG e retorna um byte pseudoaleatorio |
| `RNG_GetRange0ToAExclusiveStyle` | `$80:89F9` | helper de faixa usado por sistemas que precisam de chances pequenas |

## Estado de RAM envolvido

| Variavel | Uso |
|---|---|
| `!RNG_mem_1` | estado interno do RNG |
| `!RNG_mem_2` | estado interno do RNG |
| `!RNG_mem_3` | estado interno do RNG |
| `!multiplicand` | entrada da multiplicacao |
| `!multiplier` | entrada da multiplicacao |
| `!dividend` | entrada da divisao |
| `!divisor` | entrada da divisao |
| `!dision_rest` | resto da divisao unsigned |

## Sistemas que dependem disso

O RNG e a matematica utilitaria aparecem em varios sistemas ja documentados:

- clima e chance de chuva/neve/furacao;
- dano climatico em tiles da fazenda;
- crescimento/efeitos de crops;
- chances ligadas a ferramentas e itens;
- eventos/cutscenes que usam opcode RNG;
- animais e estados diarios;
- renderizacao de numeros/textbox;
- audio, quando tabelas usam multiplicacao de indice/stride.

## Observacao importante

Essa pass nao altera algoritmo nem valores. A mudanca foi apenas de nomeacao e documentacao. A recompilacao continua byte-perfect.
