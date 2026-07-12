# Pass 10 - Sistema livestock / animais

Esta passada mapeia a parte mais segura do sistema de animais sem alterar comportamento do jogo.

## Arquivos fonte principais

| Area | Arquivo | Funcao atual |
|---|---|---|
| Nome de animais | `src/code_banks/bank_80.asm` | copia nomes temporarios para dog/horse/cow e chama criacao de vaca |
| Ferramentas/feed | `src/code_banks/bank_82_toolused_subrutines.asm` | cow medicine, milker, brush, chicken feed e cow feed |
| Ciclo diario | `src/code_banks/bank_83.asm` | alimentacao, doenca, gravidez, nascimento, crescimento, morte, ovo/galinha |
| Eventos | `src/code_banks/bank_84.asm` | rotinas de eventos relacionadas a chicken/cow/dog |
| Textos | `src/data_banks/bank_B6-BB.asm` | dialogos de cow, milk, egg, animal shop, placas, manuais |

## Labels principais depois da Pass 10

| Label | Uso |
|---|---|
| `Livestock_DailyStatusAndFeedingUpdate` | rotina diaria que atualiza vacas e galinhas |
| `Livestock_SpawnVisibleAnimalObjects` | prepara objetos visiveis de chicken/cow/dog/horse de acordo com mapa atual |
| `AddNewChicken` | cria uma galinha em slot livre |
| `AddNewCow` | cria uma vaca em slot livre |
| `GetChickenPointer` | calcula ponteiro para slot de galinha |
| `GetCowPointer` | calcula ponteiro para slot de vaca |
| `Chicken_CoopSpawnPositionTable` | posicoes iniciais de galinhas compradas no galinheiro |
| `Cow_BarnSpawnPositionTable` | posicoes iniciais de vacas no celeiro |
| `Chicken_EggLaidBitmaskTable` | bitmask para marcar ovos/galinhas em slots |

## Estrutura geral inferida

O jogo usa arrays fixos em RAM:

```text
chicken_array: base $7E:C286, 8 bytes por slot, 13 slots
cow_array:     base $7E:C1C6, 16 bytes por slot, 12 slots
```

A rotina diaria faz em blocos:

1. percorre vacas e verifica se existem;
2. verifica se estao no barn ou fora;
3. confere feed no barn ou grama madura na fazenda;
4. aplica penalidade de felicidade se nao comeu ou sofreu clima;
5. pode marcar vaca como sick/cranky;
6. processa gravidez, nascimento e crescimento de bezerro;
7. processa galinhas, ovos chocando, pintinhos, adultos e alimentacao;
8. atualiza flags globais para eventos como funeral, nascimento e egg/festival state.

## Limites importantes

| Sistema | Limite observado |
|---|---:|
| Vacas | 12 slots |
| Galinhas | 13 slots |
| Cow slot | 16 bytes |
| Chicken slot | 8 bytes |
| Vaca gravida feed slot | usa slot especial `$0018` em `Cow_Feed_Flags` |

## O que ja da para modificar com menor risco

- Precos/dialogos de venda ja mapeados anteriormente.
- Quantidades de feed por compra, com cuidado.
- Posicoes de spawn no barn/coop, alterando tabelas existentes.
- Textos de animal shop/manual/placas.

## O que ainda exige mais engenharia reversa antes de mexer

- Inserir novo animal alem do limite de slots.
- Alterar estrutura de save dos animais.
- Criar novos estados de animal.
- Adicionar novo sprite/animação de animal do zero.
- Mudar profundamente a rotina diaria de doenca/gravidez/crescimento.
