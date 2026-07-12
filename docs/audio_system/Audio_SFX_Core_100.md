# Audio / SFX Core 100%

Esta pass fecha o nucleo conhecido do sistema de audio/SFX do Harvest Moon SNES.

O objetivo aqui nao foi editar musicas, inserir samples novos ou converter trilhas para um formato moderno. O objetivo foi deixar claro como a CPU principal conversa com o SPC/APU, como o jogo escolhe musica por area/estacao, como dispara SFX e como os dados de audio sao enviados para o processador de som.

## Componentes principais

### Bootstrap do SPC/APU

Rotina principal:

```asm
AudioSPC_UploadDriverBootstrap
```

Essa rotina faz o handshake inicial com os registradores `APUIO0-APUIO3`, espera o estado esperado do SPC e envia o bloco inicial do driver de som.

Ela e chamada durante inicializacao do jogo, antes das rotinas normais de musica e efeitos.

### Comandos SNES CPU -> SPC

O jogo usa `APUIO0-APUIO3` como porta de comunicacao. A rotina-base agora esta nomeada como:

```asm
AudioSPC_SendCommandAndWaitAck
```

Fluxo geral:

1. espera o SPC indicar pronto;
2. escreve codigo de comando em `APUIO0`;
3. escreve parametros em `APUIO1/APUIO2` quando necessario;
4. escreve handshake em `APUIO3`;
5. espera confirmacao do SPC;
6. limpa o handshake.

Rotinas auxiliares:

```asm
AudioSPC_WaitReadyAndReadStatusFlags
AudioSPC_WaitReadyAndCheckBusyBit10
AudioSPC_SendCommand04_StopSequenceSlot
AudioSPC_SendCommand07_SimpleParam
AudioSPC_SendCommand08_FadeInCurrentTrack
AudioSPC_SendCommand09_FadeOutPreviousTrack
AudioSPC_SendCommand0A_PlayEffectParams
AudioSPC_SendCommand0B_SetGlobalParam
AudioSPC_SendCommand0C_StopOrReset
```

## Musica de fundo / BGM

A musica principal e controlada pelo valor atual em:

```asm
$0110
```

O valor anterior fica em:

```asm
$0117
```

Isso permite comparar se a musica mudou antes de reiniciar/fazer fade.

Rotinas principais:

```asm
AudioBGM_SelectTrackForAreaSeasonTime
AudioBGM_StartCurrentTrackAndQueueSamples
AudioBGM_FadeOutPreviousTrackIfChanged
AudioBGM_FadeInCurrentTrackIfChanged
AudioBGM_FadeOutPreviousTrackFast
AudioBGM_ForceTrackForTransitionWithDelay
```

### Escolha de musica por mapa/estacao

A rotina:

```asm
AudioBGM_SelectTrackForAreaSeasonTime
```

usa `!tilemap_to_load`, `!season` e `!hour` para escolher a faixa apropriada.

Tabelas relacionadas:

```asm
AudioBGM_AreaProfileIndexTable
AudioBGM_AreaSeasonTrackPointerTable
AudioBGM_SeasonIndexTrackTable
```

Essas tabelas fazem a ponte entre area/mapa, estacao e ID de musica.

## Upload de dados de BGM

As rotinas:

```asm
AudioBGM_UploadCurrentTrackData
AudioBGM_UploadCurrentTrackStream
```

usam descriptors e tamanhos para transferir dados para o SPC.

Tabelas relacionadas:

```asm
AudioBGM_UploadDescriptorTable
AudioBGM_TransferSizeTable
```

A rotina:

```asm
Audio_IndexStrideMultiply
```

calcula deslocamentos em tabelas de audio com registros de tamanho fixo. Ela e usada para transformar ID de musica/SFX em offset dentro das tabelas de descriptor.

## SFX / efeitos sonoros

Rotinas principais:

```asm
AudioSFX_PlayEffectIdWithDuration
AudioSFX_PrepareEffectSampleGroup
AudioSFX_PlayQueuedEffectDefaultVolume
AudioSFX_UploadEffectSampleGroup
AudioSPC_SendCommand0A_PlayEffectParams
```

O fluxo geral e:

1. recebe um ID de efeito;
2. resolve grupo/sample necessario;
3. se necessario, para/libera slot anterior;
4. envia dados de sample/descriptor ao SPC;
5. envia comando para tocar o efeito.

Tabelas relacionadas:

```asm
AudioSFX_SampleGroupByEffectId
AudioSFX_SampleUploadDescriptorTable
AudioSFX_SampleTransferSizeTable
```

## SFX das ferramentas

O uso de ferramenta passa por:

```asm
AudioTool_PlayToolUseSound1
AudioTool_PlayToolUseSoundIfEnabled
```

Essas rotinas conectam o sistema de ferramentas com o audio. Elas usam a tabela ja mapeada em passes anteriores:

```asm
ToolAction_UseSoundTable
```

Assim, uma ferramenta pode executar logica visual/de tile e tambem disparar som se a flag permitir.

## Arquivos principais

```text
src/code_banks/bank_80.asm
src/code_banks/bank_81.asm
src/code_banks/bank_82.asm
src/code_banks/bank_83.asm
src/code_banks/bank_84.asm
src/data_banks/bank_AD.asm
```

O banco `83` concentra a maior parte do core de comunicacao com SPC/APU e tabelas de audio.

## O que esta fechado em 100% neste escopo

- handshake CPU -> SPC para comandos principais;
- bootstrap principal do driver de audio;
- selecao de BGM por mapa/estacao/hora;
- troca/fade de musica atual/anterior;
- upload de dados de BGM por descriptor;
- disparo de SFX por ID;
- upload de sample/grupo de SFX;
- conexao entre ferramentas e efeitos sonoros;
- tabelas principais de BGM/SFX nomeadas.

## O que ainda nao faz parte deste 100%

Nao esta fechado aqui:

- composicao musical em formato humano;
- conversao para MIDI;
- edicao completa de samples;
- sequencer interno do SPC em alto nivel;
- catalogo auditivo nomeando cada faixa pelo nome real ouvido no jogo.

Essas partes seriam outro escopo, possivelmente `Audio Data / Music Sequence Catalog 100%`.
