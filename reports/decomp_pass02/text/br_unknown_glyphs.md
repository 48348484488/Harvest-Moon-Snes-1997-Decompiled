# Undecoded BR glyph/control report

These codes remained undecoded after the common BR accent table was applied. Many of them are probably menu glyphs, numbers, prices, choice labels, or special control codes rather than normal text.

| Code | Count | Example contexts |
|---:|---:|---|
| `$0042` | 57 | `DATA16_BAAE0C` $BAAE0C:  <$0042><br>`DATA16_BAAE12` $BAAE12:  <$0042><$0042><br>`DATA16_BAAE12` $BAAE12:  <$0042><$0042><br>`DATA16_BAAE1A` $BAAE1A:  <$0042><$0042><$0042> |
| `$0062` | 46 | `Text_Diary` $B68802: 1>                          <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6D604` $B6D604: 1>                          <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6D896` $B6D896: 1>                          <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6DC76` $B6DC76: 1>                          <$0062><$0063><CHOICE_OR_WAIT>c |
| `$0063` | 46 | `Text_Diary` $B68802:                      <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6D604` $B6D604:                      <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6D896` $B6D896:                      <$0062><$0063><CHOICE_OR_WAIT>c<br>`DATA16_B6DC76` $B6DC76:                      <$0062><$0063><CHOICE_OR_WAIT>c |
| `$0060` | 42 | `Text_Diary` $B68802: diário antes de ir dormir? /  <$0060><$0061>                     <br>`DATA16_B6D604` $B6D604: Ei: você quer pescar? /  <$0060><$0061>                     <br>`DATA16_B6D896` $B6D896: Você acredita em Deus? /  <$0060><$0061>                     <br>`DATA16_B6DC76` $B6DC76: h:você veio ouvir o padre. /  <$0060><$0061>                      |
| `$0061` | 42 | `Text_Diary` $B68802: antes de ir dormir? /  <$0060><$0061>                          <$<br>`DATA16_B6D604` $B6D604: : você quer pescar? /  <$0060><$0061>                          <$<br>`DATA16_B6D896` $B6D896: ê acredita em Deus? /  <$0060><$0061>                          <$<br>`DATA16_B6DC76` $B6DC76: veio ouvir o padre. /  <$0060><$0061>                          <$ |
| `$00B7` | 9 | `DATA16_B7C4E0` $B7C4E0: Custa <$00B7><CTRL_B2><CTRL_B2><CTRL_B2>G<br>`DATA16_B9B534` $B9B534: cresce sem água.      Custa <$00B7><CTRL_B2><CTRL_B2>G. / Quer? /  <br>`DATA16_B9B924` $B9B924: ra a   casa. Custa <CTRL_B3><$00B7><CTRL_B2><CTRL_B2>G mas você<br>`DATA16_B9C0B6` $B9C0B6: Uma vaca custa <$00B7><CTRL_B2><CTRL_B2><CTRL_B2>G |
| `$00B8` | 6 | `DATA16_B7C88E` $B7C88E: materiais.   Precisa de uns <$00B8> gol- / pes para cortá-los<br>`DATA16_B9FE82` $B9FE82: em: compro ela por <CTRL_B3><$00B8><CTRL_B2>G. Você aceita? /  <$<br>`DATA16_BA8782` $BA8782: heia.Compro ela de / você por <$00B8><CTRL_B2><CTRL_B2>G. Aceita?<br>`DATA16_BB8BF6` $BB8BF6:       Cebola!<CTRL_B3> peça <$00B8><CTRL_B2>G           Batata! |
| `$00B6` | 6 | `DATA16_B7E660` $B7E660: O terremoto dessa noite deu <$00B6> pontos na escala richter. / O<br>`DATA16_B9E238` $B9E238: stado está inclusa  e custa <$00B6><CTRL_B2><CTRL_B2><CTRL_B2>G<br>`DATA16_B9FB88` $B9FB88: Leite? Compro ele por <$00B6><CTRL_B2><CTRL_B2>G. Certo a<br>`DATA16_B9FC6A` $B9FC6A: m... Compro por    <CTRL_B4><$00B6><CTRL_B2>G. Tudo bem? /  <$006 |
| `$00BA` | 4 | `DATA16_B9C7E4` $B9C7E4: a vaca com isso. É <CTRL_B3><$00BA><CTRL_B2><CTRL_B2>G. /  Compra<br>`DATA16_B9C93E` $B9C93E: sta uma vez ao dia.       É <$00BA><CTRL_B2><CTRL_B2>G. /  Compra<br>`DATA16_BB8BF6` $BB8BF6:      Batata!<CTRL_B3> peça  <$00BA><CTRL_B2>G<br>`DATA16_BBA590` $BBA590: >cV de <CTRL_FFFD>gW.   São <$00BA> horas agora.          Grana |
| `$00B9` | 4 | `DATA16_B9CE24` $B9CE24: funcionamento    Na semana: <$00B9>:<CTRL_B2><CTRL_B2> - <CTRL_<br>`DATA16_B9CE24` $B9CE24: TRL_B2><CTRL_B2> - <CTRL_B3><$00B9>:<CTRL_B2><CTRL_B2>     fim <br>`DATA16_BB978C` $BB978C: les se tornam   galinhas em <$00B9> dias.         Se você aumen<br>`DATA16_BBA514` $BBA514: >cS de <CTRL_FFFD>gT.   São <$00B9> da tarde agora.       Grana |
| `$003B` | 2 | `DATA16_BA8782` $BA8782:           Grana <CTRL_FFFC>h<$003B><CTRL_B2>G<CHOICE_OR_WAIT>c<br>`DATA16_BBA79A` $BBA79A: j::<CTRL_FFFC>câ<CTRL_FFFD>c<$003B> de <CTRL_FFFD>g<$003C>.   S |
| `$003C` | 2 | `DATA16_BA88D2` $BA88D2:           Grana <CTRL_FFFC>h<$003C><CTRL_B2>G<CHOICE_OR_WAIT>c<br>`DATA16_BBA79A` $BBA79A: FFD>c<$003B> de <CTRL_FFFD>g<$003C>.   São <CTRL_B3><CTRL_B4> h |
| `$003F` | 2 | `DATA16_BB85E0` $BB85E0:  Vaca    <CTRL_FFFC>c<$003F>                  Galinha <C<br>`DATA16_BBA832` $BBA832: CTRL_FFFD>c- de <CTRL_FFFD>g<$003F>.   É <CTRL_B3> hora agora.  |
| `$0040` | 2 | `DATA16_BB85E0` $BB85E0:         Galinha <CTRL_FFFC>c<$0040><br>`DATA16_BBA8AE` $BBA8AE:  <CTRL_FFFD>j<$0040>:<CTRL_FFFC>cÚ<CTRL_FFFD>c:  |
| `$0046` | 2 | `DATA16_BB8704` $BB8704:  Amor de Ellen<CTRL_FFFC>d<$0046><br>`DATA16_BBA9DE` $BBA9DE:  <CTRL_FFFD>j<$0046>:<CTRL_FFFC>c<$0063><CTRL_FF |
| `$0048` | 2 | `DATA16_BB874C` $BB874C: e tomates pegos <CTRL_FFFC>d<$0048><br>`DATA16_BBA9DE` $BBA9DE: CTRL_FFFD>cÀ de <CTRL_FFFD>g<$0048>.   São <$00B6> horas agora. |
| `$0049` | 2 | `DATA16_BB878E` $BB878E: e milho pego    <CTRL_FFFC>d<$0049><br>`DATA16_BBAA86` $BBAA86:  <CTRL_FFFD>j<$0049>:<CTRL_FFFC>c<$0065><CTRL_FF |
| `$004A` | 2 | `DATA16_BB87D0` $BB87D0: e batatas pegas <CTRL_FFFC>d<$004A><br>`DATA16_BBAA86` $BBAA86: RL_FFFC>c<$0065><CTRL_FFFD>c<$004A> de <CTRL_FFFD>gó.   São <$0 |
| `$004F` | 2 | `DATA16_BBA436` $BBA436:  <CTRL_FFFD>jO:<CTRL_FFFC>c<$004F><CTRL_FFFD>cP de <CTRL_FFFD><br>`DATA16_BBAC02` $BBAC02:  <CTRL_FFFD>j<$004F>:<CTRL_FFFC>c<$0069><CTRL_FF |
| `$0050` | 2 | `DATA16_BBA436` $BBA436:           Grana <CTRL_FFFC>h<$0050><CTRL_B2>G<br>`DATA16_BBAC02` $BBAC02: RL_FFFC>c<$0069><CTRL_FFFD>c<$0050> de <CTRL_FFFD>g<$0051>.   S |
| `$0051` | 2 | `DATA16_BBA514` $BBA514:  <CTRL_FFFD>jR:<CTRL_FFFC>c<$0051><CTRL_FFFD>cS de <CTRL_FFFD><br>`DATA16_BBAC02` $BBAC02: FFD>c<$0050> de <CTRL_FFFD>g<$0051>.   São <$00B7> horas agora. |
| `$0052` | 1 | `DATA16_BBA514` $BBA514: ra.       Grana <CTRL_FFFC>h<$0052><CTRL_B2>G |
| `$00BB` | 1 | `DATA16_BBA60C` $BBA60C: >cY de <CTRL_FFFD>gZ.   São <$00BB> horas agora.          Grana |
| `$0056` | 1 | `DATA16_BBA60C` $BBA60C:           Grana <CTRL_FFFC>h<$0056><CTRL_B2>G |
| `$0058` | 1 | `DATA16_BBA688` $BBA688: .         Grana <CTRL_FFFC>h<$0058><CTRL_B2>G |
| `$0059` | 1 | `DATA16_BBA704` $BBA704:  <CTRL_FFFD>j?:<CTRL_FFFC>c<$0059><CTRL_FFFD>c" de <CTRL_FFFD> |
| `$005A` | 1 | `DATA16_BBA704` $BBA704: om fome. /  Grana <CTRL_FFFC>h<$005A><CTRL_B2>G |
| `$005E` | 1 | `DATA16_BBA832` $BBA832:           Grana <CTRL_FFFC>h<$005E><CTRL_B2>G |
| `$0064` | 1 | `DATA16_BBA9DE` $BBA9DE: ortador. /  Grana <CTRL_FFFC>h<$0064><CTRL_B2>G |
| `$0065` | 1 | `DATA16_BBAA86` $BBAA86: L_FFFD>j<$0049>:<CTRL_FFFC>c<$0065><CTRL_FFFD>c<$004A> de <CTRL |
| `$0066` | 1 | `DATA16_BBAA86` $BBAA86: cansado. /  Grana <CTRL_FFFC>h<$0066><CTRL_B2>G |
| `$0067` | 1 | `DATA16_BBAB1A` $BBAB1A:  <CTRL_FFFD>jú:<CTRL_FFFC>c<$0067><CTRL_FFFD>cã de <CTRL_FFFD> |
| `$0068` | 1 | `DATA16_BBAB1A` $BBAB1A:           Grana <CTRL_FFFC>h<$0068><CTRL_B2>G |
| `$0069` | 1 | `DATA16_BBAC02` $BBAC02: L_FFFD>j<$004F>:<CTRL_FFFC>c<$0069><CTRL_FFFD>c<$0050> de <CTRL |
| `$006A` | 1 | `DATA16_BBAC02` $BBAC02:           Grana <CTRL_FFFC>h<$006A><CTRL_B2>G |
| `$006B` | 1 | `DATA16_BBB384` $BBB384: ntos do rancho  <CTRL_FFFC>d<$006B>       Você foi MUITO mal, |
| `$006C` | 1 | `DATA16_BBB640` $BBB640: ntos do rancho  <CTRL_FFFC>d<$006C>       Faça melhor |
| `$006D` | 1 | `DATA16_BBB692` $BBB692: ntos do rancho  <CTRL_FFFC>d<$006D>       Vamos lá: está tão pe |
| `$006E` | 1 | `DATA16_BBB700` $BBB700: ntos do rancho  <CTRL_FFFC>d<$006E>       Ótimo, Mas tente ser  |
| `$006F` | 1 | `DATA16_BBB78E` $BBB78E: ntos do rancho  <CTRL_FFFC>d<$006F>       Parabéns, Você é o ra |
| `$0070` | 1 | `DATA16_BBB832` $BBB832: mento do rancho <CTRL_FFFC>d<$0070>& |