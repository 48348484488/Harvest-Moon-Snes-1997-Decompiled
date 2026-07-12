# Pseudocodigo - Math / RNG Utility Core

## Math_MultiplyUnsigned8x8

```text
entrada:
  multiplicand = $011A
  multiplier   = $011B

WRMPYA = multiplicand
WRMPYB = multiplier
espera alguns ciclos
A = RDMPYL/RDMPYH
retorna A
```

## Math_DivideUnsigned16By16

```text
entrada:
  dividend = $7E
  divisor  = $80

se divisor < 256:
  usa registradores WRDIVL/WRDIVB do SNES
  resto = RDMPYL
  quociente = RDDIVL
  retorna quociente
senao:
  executa divisao manual por subtracao/deslocamento
  resto = acumulador
  quociente = scratch82
  retorna quociente
```

## RNG_GetNextByte

```text
usa RNG_mem_1, RNG_mem_2, RNG_mem_3
combina XOR, ADC e rotacoes
atualiza RNG_mem_1
retorna RNG_mem_1 como byte em A
```

## RNG_GetRange0ToAExclusiveStyle

```text
entrada:
  A = parametro de faixa

scratch92 = A
scratch93 = 0
quociente = 255 / A
scratch93 = quociente
random = RNG_GetNextByte()

depois o codigo compara o random contra baldes derivados do quociente
retorna um valor pequeno usado como resultado de chance/faixa
```
