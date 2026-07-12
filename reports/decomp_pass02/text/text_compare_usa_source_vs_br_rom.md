# USA source text vs BR ROM text

Total text entries checked: **1177**
Changed at same address: **1153**

## Changed entries by bank

| Bank | Entries | Changed | Changed % |
|---|---:|---:|---:|
| B6 | 210 | 207 | 98.6% |
| B7 | 208 | 208 | 100.0% |
| B8 | 233 | 226 | 97.0% |
| B9 | 204 | 200 | 98.0% |
| BA | 232 | 222 | 95.7% |
| BB | 90 | 90 | 100.0% |

## First changed examples

### Text_Forecast_Spring_Sunny @ $B68000 / 0x1B0000

USA/source:
```text
Hello: this is the weather  forecast for tomorrow.      It'll be sunny and calm
for the whole day tomorrow.
```
BR ROM same address:
```text
Olá: esta é a previsão do   tempo para amanhã.          Será ensolarado e calmo
amanhã o dia inteiro.
```

### Text_Forecast_Summer_Sunny @ $B680D8 / 0x1B00D8

USA/source:
```text
It's been hot recently.     The weather forecast for    tomorrow is fair.
```
BR ROM same address:
```text
Tem sido quente ultimamente.A previsão para amanhã é de tempo bom.
```

### Text_Forecast_Fall_Sunny @ $B6816C / 0x1B016C

USA/source:
```text
The autumn mountains are    beautifully colored  The skywill be clear and blue
tomorrow.
```
BR ROM same address:
```text
As montanhas estão lindamen-te coloridas.  O céu vai    estar claro e azul
amanhã.
```

### Text_Forecast_Winter_Sunny @ $B6821E / 0x1B021E

USA/source:
```text
It's getting colder day by  day but how are you doing?  It'll be fair tomorrow.
```
BR ROM same address:
```text
Está ficando frio dia após  dia:mas o que está havendo? Amanhã será tempo bom.
```

### Text_Forecast_Spring_Rain @ $B682BE / 0x1B02BE

USA/source:
```text
Hello. The weather forecast for tomorrow is that it'll  begin to rain at midnight
and will be rainy for the   whole day.
```
BR ROM same address:
```text
Olá. A previsão do tempo    para amanhã é que vai come- çar a chover à meia-noite
e o dia inteiro será        chuvoso.
```

### Text_Forecast_Summer_Rain @ $B683B0 / 0x1B03B0

USA/source:
```text
This is the weather forecastfor tomorrow. It'll start torain hard in the morning
with lightening in some     places.
```
BR ROM same address:
```text
Esta é a previsão do tempo  para amanhã. Vai começar a  chover forte pela manhã
com relâmpagos em alguns    locais.
```

### Text_Forecast_Fall_Rain @ $B6849A / 0x1B049A

USA/source:
```text
It's getting cooler         everyday. It'll be raining  for the whole day tomorrow.
```
BR ROM same address:
```text
Está cada dia mais frio.    Amanhã vai chover durante o dia inteiro.
```

### Text_Forecast_Winter_Snow @ $B68542 / 0x1B0542

USA/source:
```text
It's pretty cold now.       The weather forecast for    tomorrow is snow.
```
BR ROM same address:
```text
Está muito frio agora.      O tempo previsto para amanhãé de neve.
```

### Text_Forecast_Summer_Hurricane @ $B685D6 / 0x1B05D6

USA/source:
```text
Here's the hurricane        information. The hurricane  is becoming stronger and
is getting nearer. Please   don't forget to keep all thelivestock inside,
```
BR ROM same address:
```text
Aqui está a informação do   furacão.  O furacão está    ficando mais forte e
chegando perto. Por favor:  não esqueça de manter todo oestoque dentro,
```

### Text_LogBook @ $B6870C / 0x1B070C

USA/source:
```text
Latest funds                         <CTRL_FFFC>hb<CTRL_B2>G
Cow     <CTRL_FFFC>cc                  Chicken <CTRL_FFFC>cd
Dog     <CTRL_FFFD>eb                Horse   <CTRL_FFFD>ec
```
BR ROM same address:
```text
Últimos fundos                       <CTRL_FFFC>hb<CTRL_B2>G
Vaca    <CTRL_FFFC>cc                  Galinha <CTRL_FFFC>cd
Cão     <CTRL_FFFD>eb                Cavalo  <CTRL_FFFD>ec
```

### Text_Diary @ $B68802 / 0x1B0802

USA/source:
```text
Shall I write in my diary   before I go to bed?
 Yes                         No<CHOICE_OR_WAIT>c
```
BR ROM same address:
```text
Devo escrever em meu diário antes de ir dormir?
 <$0060><$0061>                          <$0062><$0063><CHOICE_OR_WAIT>c
```

### DATA16_B688A4 @ $B688A4 / 0x1B08A4

USA/source:
```text
I'll work hard again        tomorrow.
```
BR ROM same address:
```text
Amanhã trabalharei muito no-vamente.
```

### Text_Diary2 @ $B688F0 / 0x1B08F0

USA/source:
```text
 I'm going to bed.           Oh: I've got something      to do.<CHOICE_OR_WAIT>c
```
BR ROM same address:
```text
 Estou indo pra cama.        Oh: achei algo para eu      fazer.<CHOICE_OR_WAIT>c
```

### DATA16_B68972 @ $B68972 / 0x1B0972

USA/source:
```text
Good night.
```
BR ROM same address:
```text
Boa noite.
```

### Text_Sign_House_Expansion @ $B6898A / 0x1B098A

USA/source:
```text
"Allocated land for the     annex of the house"
Necessary Materials                  <CTRL_FFFC>depiece
```
BR ROM same address:
```text
"Terra destinada ao anexo dacasa"
Materiais Necessários                <CTRL_FFFC>depeças
```

### Text_Manual_Sickle @ $B68A46 / 0x1B0A46

USA/source:
```text
"Sickle"                    Cut the grass to make feed,
It's the feed for cows and  chickens. I would be thrown into a pinch if
it's gone.
```
BR ROM same address:
```text
"Foice"                     Corta a grama,
É a comida para vacas e     galinhas. Não sei o que eu faria sem
isso....
```

### Text_Manual_Hoe @ $B68B5E / 0x1B0B5E

USA/source:
```text
"Hoe"                       Plow the ground to make a   field.
Raise vegetables in the     field.
Try various ways to make thefield.
```
BR ROM same address:
```text
"Enxada"                    Cavouca o chão para fazer umcampo.
Plante vegetais no campo.
Tente em várias direções.
```

### Text_Manual_Axe @ $B68C68 / 0x1B0C68

USA/source:
```text
"Axe"                       Split logs to make lumber.  Lumber is useful.
Focus on one point and hit. Don't enter the control pad.
```
BR ROM same address:
```text
"Machado"                   Corta toras para fazer lenhaLenha é útil.
Concentre em um ponto e bata.   Não mexa no direcional.
```

### Text_Manual_Hammer @ $B68D6E / 0x1B0D6E

USA/source:
```text
"Hammer"                    Breaks rocks and breaks     fences down.
Big rocks can be knocked    down when focusing on one   spot.
Don't ever enter the        control pad.
```
BR ROM same address:
```text
"Martelo"                   Quebra rochas e derruba     cercas.
Derrube rochas grandes      batendo em um único ponto.
Não mexa no direcional.
```

### Text_Manual_Can @ $B68EC6 / 0x1B0EC6

USA/source:
```text
"Watering can"              Water the crops. Once a day.No watering is necessary
on rainy days.              Dip up water at a well or a pond when it runs out.
```
BR ROM same address:
```text
"Regador"                   Rega a plantação. Uma vez aodia. Não precisa regar
em dias chuvosos.           Pegue água no poço ou em umalagoa quando acabar.
```

### Text_Manual_Milker @ $B69006 / 0x1B1006

USA/source:
```text
"Milker"                    Milk cows and ship the milk.
```
BR ROM same address:
```text
"Leiteira"                  Para ordenhar vacas.
```

### Text_Manual_Brush @ $B69078 / 0x1B1078

USA/source:
```text
"Brush"                     Brushing raises the cows'   level of affection.
A cow with High affection   gives a lot of milk.
```
BR ROM same address:
```text
"Escova"                    Escovar aumenta o nível de  afeição das vacas.
Uma vaca com alta afeição dámuito leite.
```

### Text_Manual_Bell @ $B69172 / 0x1B1172

USA/source:
```text
"Bell"                      A tool used to herd cows.   Look at the cows carefully
and move them properly.
```
BR ROM same address:
```text
"Sino"                      Usado para guiar vacas.     Tenha atenção com as vacas
e guie-as corretamente.
```

### Text_Manual_CropSeeds @ $B69248 / 0x1B1248

USA/source:
```text
"Vegetable seeds"           Sowing season is different. Ask the florist for the
proper season.              Seeds must be sown in the   field. They won't bud
without watering.
```
BR ROM same address:
```text
"Sementes  de vegetais"     A estação de plantação varia  Pergunte à florista
sobre a estação correta.    Sementes devem ser plantadasno campo. Elas não
brotam sem água.
```

### Text_Manual_GrassSeeds @ $B693A8 / 0x1B13A8

USA/source:
```text
"Grass seeds"               Sow the field from spring tosummer.
It grows without watering.  The Meadow must be ready forraising cows and chickens.
Grass is ready for mowing   when it turns a deep green.
```
BR ROM same address:
```text
"Sementes de grama"         Semeie campos da primevera averão.
Elas crescem sem agoar.     Apronte o gramado para criarvacas e galinhas.
A grama deve ser cortada ao ficar verde-escura.
```

### Text_Manual_Paint @ $B6953E / 0x1B153E

USA/source:
```text
"Paint"                     Paint the house right.
```
BR ROM same address:
```text
"Tinta"                     Pinta a casa.
```

### DATA16_B695A4 @ $B695A4 / 0x1B15A4

USA/source:
```text
No: don't tell me you are   working on New Years' Day.  Just relax today.
```
BR ROM same address:
```text
Não me diga que você está   trabalhando no dia de ano   novo, Relaxe.
```

### Text_Sign_Wood @ $B69638 / 0x1B1638

USA/source:
```text
Latest materials                     <CTRL_FFFC>dfpiece           Split logs and collect them.
```
BR ROM same address:
```text
Últimos materiais                    <CTRL_FFFC>dfpeças           Corte toras e colete-as.
```

### Text_Sign_Fodder @ $B696E2 / 0x1B16E2

USA/source:
```text
Feed                                 <CTRL_FFFC>dgpiece           Mow grass to make more feed.
```
BR ROM same address:
```text
Comida                               <CTRL_FFFC>dgpeças           Corte grama para fazer mais.
```

### DATA16_B6978C @ $B6978C / 0x1B178C

USA/source:
```text
Oh yes: I've nailed down thedoor to prepare for the     hurricane.
```
BR ROM same address:
```text
Ah: eu preguei a porta para se preparar para o tornado.
```

### Text_Sign_Fork @ $B69812 / 0x1B1812

USA/source:
```text
 Neighbor town               Back hill
```
BR ROM same address:
```text
 Cidade vizinha              Montanha
```

### Text_Sign_Mountain_Top @ $B69860 / 0x1B1860

USA/source:
```text
 to the top
```
BR ROM same address:
```text
 topo
```

### Text_Sign_Hotspring @ $B69878 / 0x1B1878

USA/source:
```text
Get undressed here.
```
BR ROM same address:
```text
Fique sem roupas.
```

### Text_Sign_Cave @ $B698A0 / 0x1B18A0

USA/source:
```text
Dangerous, Easy to collapse,
```
BR ROM same address:
```text
Perigoso, Fácil de desabar,
```

### Text_Sign_Workmans @ $B698DA / 0x1B18DA

USA/source:
```text
workman's House Call us for annex <$0040> extension
Closed on weekends and      holidays.
```
BR ROM same address:
```text
Casa dos construtores. Ane- xos e extensões.
Fechado em fins de semana e feriados.
```

### Text_Bachellorete_Diary @ $B69982 / 0x1B1982

USA/source:
```text
Found the diary,
 Read                        Not read<CHOICE_OR_WAIT>c
```
BR ROM same address:
```text
Achou o diário,
 Ler                         Não ler <CHOICE_OR_WAIT>c
```

### Text_Mayor_House_Bookcase1 @ $B699F2 / 0x1B19F2

USA/source:
```text
"Myths of Gods"             There are lots of difficult books.
```
BR ROM same address:
```text
"Mitos de Deuses"           Tem um monte de livros difíceis.
```

### Text_Mayor_House_Bookcase2 @ $B69A70 / 0x1B1A70

USA/source:
```text
"History <$0040> Myths"           There's a lot others too.
```
BR ROM same address:
```text
"História e Mitos"          Tem muitos outros também.
```

### Text_Mayor_House_Bookcase3 @ $B69ADC / 0x1B1ADC

USA/source:
```text
"Simple lessons from God"   "Happiness lies in life"
```
BR ROM same address:
```text
"Simples lições Divinas"    "Felicidade tá na vida"
```

### Text_Flowershop_Rooms_Bookcase @ $B69B46 / 0x1B1B46

USA/source:
```text
"Plants"                    "Artistic Flowers"
```
BR ROM same address:
```text
"Plantas"                   "Flores de Arte"
```

### Text_Bar_Bookcase @ $B69BA4 / 0x1B1BA4

USA/source:
```text
"Cocktails: Best <CTRL_B3><CTRL_B2><CTRL_B2>"       "How to make berry juice"
```
BR ROM same address:
```text
"Coquetéis: <CTRL_B3><CTRL_B2><CTRL_B2> Melhores"   "Como fazer suco de baga"
```

### Text_Restaurant_Bookcase @ $B69C10 / 0x1B1C10

USA/source:
```text
"Tasty Cakes"               "Dishes for today"
```
BR ROM same address:
```text
"Bolos Gostosos"            "Pratos para hoje"
```

### Text_GeneralStore_Rooms_Bookcase @ $B69C6E / 0x1B1C6E

USA/source:
```text
"Get into invention"        "Daily life and groceries"
```
BR ROM same address:
```text
"Entre nas invenções"       "Dia-a-dia e mantimentos."
```

### Text_WitchHouse_Bookcase @ $B69CDC / 0x1B1CDC

USA/source:
```text
"Encyclopedia of fortune    telling "
"Heart pounding             compatibility of partner"
```
BR ROM same address:
```text
"Enciclopédia dos videntes"
"Corações medindo           compatibilidade de pares"
```

### Text_Carpenters_Bookcase @ $B69D94 / 0x1B1D94

USA/source:
```text
"House and living"          "We are carpenters"
```
BR ROM same address:
```text
"O Lar e a Vida"            "A carpinteiros"
```

### Text_Shop_Closed @ $B69DF4 / 0x1B1DF4

USA/source:
```text
"We're closed"
```
BR ROM same address:
```text
"FECHADO"
```

### Text_Bar_Closed @ $B69E12 / 0x1B1E12

USA/source:
```text
"We're preparing"
```
BR ROM same address:
```text
"Logo abriremos."
```

### Text_Cow_Talk @ $B69E36 / 0x1B1E36

USA/source:
```text
Yes:<CTRL_FFFD>ed: good girl         You look fine today.
```
BR ROM same address:
```text
Sim:<CTRL_FFFD>ed: boa garota.       Você parece bem.
```

### Text_Cow_Talk_Cranky @ $B69E96 / 0x1B1E96

USA/source:
```text
<CTRL_FFFD>ee looks cranky.
```
BR ROM same address:
```text
<CTRL_FFFD>ee parece louco.
```

### Text_Cow_Talk_Sick @ $B69EBA / 0x1B1EBA

USA/source:
```text
<CTRL_FFFD>ef is sick,               I've got to give ....       medicine right away,
```
BR ROM same address:
```text
<CTRL_FFFD>ef está doente,           Eu tenho que dar ....       o remédio logo ali,
```

### Text_Cow_Talk_Pregnant @ $B69F52 / 0x1B1F52

USA/source:
```text
<CTRL_FFFC>ch more days for delivery.  Come on <CTRL_FFFD>eg.
```
BR ROM same address:
```text
<CTRL_FFFC>ch dias para o recebimento. Venha <CTRL_FFFD>eg.
```

### Text_Elf_Cave_Door_Closed @ $B69FA6 / 0x1B1FA6

USA/source:
```text
I can't open it.It's locked.
```
BR ROM same address:
```text
Não posso abrir.Tá fechado.
```

### DATA16_B69FE0 @ $B69FE0 / 0x1B1FE0

USA/source:
```text
I can't open it.            something's stuck.
```
BR ROM same address:
```text
Não posso abrir.  Há alguma coisa emperrando.
```

### DATA16_B6A03E @ $B6A03E / 0x1B203E

USA/source:
```text
Hey: how's it going?        Don't work too hard.        Just take time.
```
BR ROM same address:
```text
Ei: como está indo?         Não trabalhe tanto.         Dê um tempo.
```

### DATA16_B6A0CE @ $B6A0CE / 0x1B20CE

USA/source:
```text
Ask the florist for flowers and ask the livestock delaerfor livestock.
Better ask Mrs.             Fortune-teller for girls.
```
BR ROM same address:
```text
Peça flores ao florista e   gado para o comerciante de  gados.
E é melhor falar com a Sra. Vidente sobre garotas.
```

### DATA16_B6A1C8 @ $B6A1C8 / 0x1B21C8

USA/source:
```text
Don't hang around.          Listen to the priest.
```
BR ROM same address:
```text
Não fique andando por aí.   Escute o padre.
```

### DATA16_B6A22C @ $B6A22C / 0x1B222C

USA/source:
```text
You are off today:          aren't you?
We can't keep it up all the time.
```
BR ROM same address:
```text
Você está descansando: não  é?  Não
podemos trabalhar sem parar.
```

### DATA16_B6A2C0 @ $B6A2C0 / 0x1B22C0

USA/source:
```text
People in town talk         differently according to theweather: day: and season.
```
BR ROM same address:
```text
O povo na cidade fala semprediferente: de acordo com o  clima: dia: e estação.
```

### DATA16_B6A364 @ $B6A364 / 0x1B2364

USA/source:
```text
Everybody has different     ideas on what happiness     means:right?
I guess the best thing is   to do what you want to do.  But it's probably not
real happiness when you     annoy someone or are blamed.
```
BR ROM same address:
```text
Todos têm diferentes idéias sobre o que é a felicidade: certo?
Eu acho que a melhor coisa éfazer o que você quiser.    Mas provavelmente a
felicidade é falsa quando   você pertuba outras pessoas.
```

### DATA16_B6A4FC @ $B6A4FC / 0x1B24FC

USA/source:
```text
You are working so hard.    You should have a chat with your friends or go to
mountains...                to relax once in a while.
```
BR ROM same address:
```text
Você está trabalhando muito.Vá conversar com seus amigosou vá para as
montanhas...                para relaxar um pouco.
```

### DATA16_B6A604 @ $B6A604 / 0x1B2604

USA/source:
```text
This church is dedicated to the God of the crops.       I suggest you pray
faithfully.
```
BR ROM same address:
```text
Esta igreja é dedicada ao   Deus das colheitas.         Sugiro você rezar
com fé.
```

### DATA16_B6A6B2 @ $B6A6B2 / 0x1B26B2

USA/source:
```text
I like taking my time       reading books.That's one of my happiest times.
```
BR ROM same address:
```text
Gosto de passar meu tempo   lendo livros. São as minhas melhores horas.
```

### DATA16_B6A748 @ $B6A748 / 0x1B2748

USA/source:
```text
Have you heard of the water imp? Someone has seen it in the pond of the mountain.
```
BR ROM same address:
```text
Você já ouviu falar do diabod'água? Alguém o viu na     fonte da montanha.
```

### DATA16_B6A7EC @ $B6A7EC / 0x1B27EC

USA/source:
```text
Don't think it's OK to do   bad things if it's not      discovered.
No one is perfect. We all   make mistakes.              That's the way we are.
But it's wrong to not feel  guilty about what you've    done wrong.
```
BR ROM same address:
```text
Não pense que é bom fazer   coisas ruins se você não fordescoberto.
Ninguém é perfeito. Todos   erramos.  É assim que as    coisas são.
Mas é errado não sentir     culpa de coisas que você fezerrado.
```

### DATA16_B6A99A @ $B6A99A / 0x1B299A

USA/source:
```text
I wonder if our daughter Anncan get married living like that.
```
BR ROM same address:
```text
Não sei como nossa filha Annpode se casar vivendo assim.
```

### DATA16_B6AA16 @ $B6AA16 / 0x1B2A16

USA/source:
```text
Hi: how's your work going?  There are some wild dogs:   so you should fix the fence.
```
BR ROM same address:
```text
Oi: como vai seu trabalho?  Há cães selvagens: então    você deve repôr a cerca.
```

### DATA16_B6AAC0 @ $B6AAC0 / 0x1B2AC0

USA/source:
```text
I believe God exists.       You believe it: don't you?
```
BR ROM same address:
```text
Acredito que Deus exista.   Você também: não é?
```

### DATA16_B6AB2E @ $B6AB2E / 0x1B2B2E

USA/source:
```text
Hey: it's strange. She is   always here by now.
.....oh no:                 it's nothing at all.
```
BR ROM same address:
```text
Ei: é estranho. Ela está    sempre aqui agora.
.....oh não:                não é nada.
```

### DATA16_B6ABF0 @ $B6ABF0 / 0x1B2BF0

USA/source:
```text
Hi. Are you taking a walk   too? It's important to get afew days off.
Working hard till late at   night will drive you crazy: mentally and physically.
```
BR ROM same address:
```text
Oi. Você está dando uma     passeada? É importante      descansar.
Trabalhar duro até tarde    da noite acaba com você:men-talmente e fisicamente.
```

### DATA16_B6AD1E @ $B6AD1E / 0x1B2D1E

USA/source:
```text
I just can't help myself    worrying about Ann so much. Mr. <CTRL_FFFD>eh: you are of the
same generation as Ann.     What do you think of her?   ....oh: sorry.
Maybe I'm a little confused.
```
BR ROM same address:
```text
Eu não posso ficar me preo- cupando toda hora com Ann.  Sr. <CTRL_FFFD>eh: você é da
mesma geração de Ann.       O que você pensa dela?      ..oh:desculpe.
Talvez eu esteja confuso.
```

### DATA16_B6AE86 @ $B6AE86 / 0x1B2E86

USA/source:
```text
Hello. You always look fine.The bag of seed for sowing. It's convenient to buy
a few bags at once.
```
BR ROM same address:
```text
Olá. Você sempre parece bem.O saco de sementes. É con-  veniente comprar sem-
pre alguns sacos.
```

### DATA16_B6AF4C @ $B6AF4C / 0x1B2F4C

USA/source:
```text
Grass grows in Autumn so youdon't have to mow much      before Winter.
```
BR ROM same address:
```text
A grama cresce no Outono:   então não é preciso cortar  até o Inverno.
```

### DATA16_B6AFDA @ $B6AFDA / 0x1B2FDA

USA/source:
```text
May everyone give kindness  to everyone else....
```
BR ROM same address:
```text
Todos devem ser bondosos comos outros....
```

### DATA16_B6B046 @ $B6B046 / 0x1B3046

USA/source:
```text
What? The shop is closed on Saturdays. So I'm bathing inthe sun. Nice:huh?
```
BR ROM same address:
```text
Quê? A loja está fechada nosSábados. Então eu tomo banhode sol. Legal:né?
```

### DATA16_B6B0DC @ $B6B0DC / 0x1B30DC

USA/source:
```text
It's kind of dark on rainy  days....feels slightly      lonely:doesn't it?
But the rain is good when itcomes to producing crops.
```
BR ROM same address:
```text
É muito escuro em dias chu- vosos...nos faz sentir soli-tários: não é?
Mas a chuva é boa quando vempara aumentar a colheita.
```

### DATA16_B6B1DE @ $B6B1DE / 0x1B31DE

USA/source:
```text
What a coincidence. Are you having a meal here today?
```
BR ROM same address:
```text
Que coincidência.   Você    está comendo aqui hoje?
```

### DATA16_B6B24A @ $B6B24A / 0x1B324A

USA/source:
```text
It's not easy to work       steadily but it's           worthwhile.
```
BR ROM same address:
```text
Não é fácil trabalhar sem   parar: mas é muito recompen-sador.
```

### DATA16_B6B2D2 @ $B6B2D2 / 0x1B32D2

USA/source:
```text
Hope business will be       better:it will be better   ....
What? Isn't it the God of   business? Oh:well.
```
BR ROM same address:
```text
Espero que os negócios me-  lhorem:sim:vão melhorar sim....
Quê? Não é o Deus dos negó- cios? Ah: bom.
```

### DATA16_B6B3A8 @ $B6B3A8 / 0x1B33A8

USA/source:
```text
It's good to bathe in the   sun. Eat well and work hard.Good health is the
foundation of happiness.
```
BR ROM same address:
```text
É bom tomar um pouco de sol.Coma bem e trabalhe muito.  A boa saúde é a
base da felicidade.
```

### DATA16_B6B470 @ $B6B470 / 0x1B3470

USA/source:
```text
Eat something when you are  tired. Our cakes are the    best to get more energy.
```
BR ROM same address:
```text
Coma quando ficar cansado.  Nossos bolos são os melho-  res para se recuperar.
```
