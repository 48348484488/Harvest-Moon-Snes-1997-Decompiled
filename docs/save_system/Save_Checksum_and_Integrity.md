# Save Checksum and Integrity - Pass 12

## Resumo

O save usa uma validacao simples baseada em assinatura `FARM` e checksum de 16 bits.

## Campos relevantes

| Offset | Papel |
|---:|---|
| `$002E` | Byte de estado/slot ativo. A rotina zera temporariamente este byte durante a soma. |
| `$002F-$0030` | Checksum salvo. |
| `$003C-$003F` | Assinatura `FARM`. |

## Comportamento observado

1. A rotina seleciona a base do slot SRAM.
2. Para calcular/verificar checksum, os campos `$002E-$0030` sao tratados como zero temporario.
3. A soma percorre o bloco de `$1000` bytes do slot.
4. O resultado e comparado com o valor armazenado em `$002F-$0030`.
5. Se a integridade falhar, a rotina limpa/reinicializa area SRAM e restaura a assinatura `FARM`.

## Pseudocodigo conceitual

```c
uint16 calc_save_checksum(uint8 slot[0x1000]) {
    uint16 sum = 0;
    for (int i = 0; i < 0x1000; i++) {
        if (i == 0x002E || i == 0x002F || i == 0x0030) {
            continue; // tratado como zero
        }
        sum += slot[i];
    }
    return sum;
}
```

## Nota

A rotina e suficiente para detectar save corrompido, mas nao e criptografia. Para editar saves manualmente, qualquer alteracao exige recalcular `$002F-$0030`.
