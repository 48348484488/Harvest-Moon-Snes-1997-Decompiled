# Decomp Pass 01 - Time / Day Cycle

Arquivo analisado: `src/code_banks/bank_82.asm`

## `UpdateTime` - SNES $828000

Funcao responsavel por atualizar o relogio do jogo e disparar eventos ligados ao horario.

### Variaveis principais

| Variavel | Endereco | Uso inferido |
|---|---:|---|
| `!time_running` | `$0973` | controla se o tempo esta parado, rodando, ou avancando para o proximo dia |
| `!seconds` | `$7F1F1E` | segundos internos do relogio |
| `!minutes` | `$7F1F1D` | minutos internos; a cada 15 minutos sobe 1 hora |
| `!hour` | `$7F1F1C` | hora do jogo, formato hex/decimal simples |
| `$7F1F5A` bit `$0400` | flag | ativa fluxo de cena de shipping/entrega |
| `$7F1F5E` bit `$8000` | flag | evita tocar o alerta/audio das 18h em algumas condicoes |

### Pseudocodigo

```c
void UpdateTime(void) {
    if (time_running & 0x02) {
        NightReset();
        return;
    }

    if ((time_running & 0x01) == 0) {
        return;
    }

    if (flags_7F1F5A & 0x0400) {
        ShippingSceneDialogue();
        return;
    }

    seconds++;

    if (seconds == 60) {
        seconds = 0;
        minutes++;

        if (minutes == 15) {
            minutes = 0;

            if (hour != 18) {
                hour++;
                HaveLunch();
                ShippingScene();
            }

            if (hour == 18 && !(flags_7F1F5E & 0x8000)) {
                play_6pm_audio_signal();
            }
        }
    }

    old_palette = palette_to_load;
    SetPaletteToLoad();

    if (old_palette != palette_to_load) {
        PaletteAnim_ClearPointer42SlotsFromIndex(4);
        PaletteAnim_RunMapTimeInstaller();
    }
}
```

### Conclusao

O relogio do jogo nao usa 60 minutos para cada hora de jogo. A cada `60 segundos internos`, ele incrementa `minutes`; quando `minutes == 15`, ele incrementa a hora. Ou seja, a rotina transforma blocos de 15 minutos internos em 1 hora visual/funcional.

Tambem foi confirmado que a mesma rotina dispara:

- almoco ao meio-dia (`HaveLunch`);
- cena/calculo de shipping;
- sinal de 18h;
- atualizacao de paleta por horario.

## `HaveLunch` - SNES $8280AA

### Pseudocodigo resumido

```c
void HaveLunch(void) {
    if (hour != 12) return;

    Stamina_ApplyDeltaAndFatigueState(+20);

    if (game_state & 0x0430) return;

    if (player_action is fishing/casting/short_hop/mid_hop/etc) return;

    // restante da rotina toca animacao/estado de comer, dependendo da acao atual
}
```

### Conclusao

Ao meio-dia, o jogo aumenta stamina em `+20`, mas tenta evitar interromper certas acoes criticas, especialmente pesca e saltos.

## `NightReset` - SNES $8282AC

Responsavel pela virada do dia.

### Fluxo principal observado

```c
void NightReset(void) {
    weekday++;
    if (weekday == 7) weekday = 0;

    day++;
    if (day == 31) {
        season++;
        if (season == 4) {
            year++;
            ClimateFarmDamageCheck(new_year_probabilities);
            season = 0;
        }
        day = 1;
    }

    fade_out_screen();
    force_blank();

    clear_weather_related_flags();
    SetWeatherFlags();

    hour = 6;
    minutes = 0;
    seconds = 0;

    LoadsDateNames();
    NightlyFarmTilesCheck();
    ClimateFarmDamagePrep();
    CowFeedingandStatus();
    WeatherTomorrow();
    FindMostLovedName();
    WifePregnanacyandChilds();

    current_stamina = max_stamina;
    idle_animation_timer = 0;
    player_action = 0;
    player_direction = DOWN;

    AddMoney(shipping_money);
    shipping_money = 0;

    fed_cows_N = 0;
    fed_chicks_N = 0;
    fed_cows_flags = 0;
    fed_chicks_flags = 0;

    clear_daily_flags();
}
```

### Conclusao

`NightReset` e uma das rotinas centrais do jogo. Ela junta calendario, clima, fazenda, animais, dinheiro de shipping, stamina e flags diarias.

