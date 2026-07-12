# ⚠️ Aviso Legal / Disclaimer

Este é um projeto de engenharia reversa de código aberto criado **estritamente para fins
educativos, pesquisa acadêmica e preservação histórica** da arquitetura de software da era
dos 16-bits (SNES, 1997).

## O que este repositório NÃO contém

- 🛑 **Nenhuma ROM comercial.** O projeto nunca incluiu e nunca incluirá arquivos `.sfc`,
  `.smc`, `.fig`, `.swc` ou qualquer dump binário do cartucho original.
- 🛑 **Nenhum gráfico extraído da ROM.** Sprites, atlases de personagens e tilemaps gerados
  pelas ferramentas de extração (`tools/BitplaneToPng.py`, `tools/TilemapDecomp.py`, etc.)
  foram deliberadamente removidos da versão pública deste repositório, pois são arte original
  do jogo — mesmo obtida via engenharia reversa, ela continua sendo um recurso protegido. As
  ferramentas para você mesmo gerar essas imagens **a partir da sua própria cópia legal da
  ROM** continuam disponíveis em `tools/`.
- 🛑 **Nenhum áudio/música original.**

## O que este repositório contém

Código assembly 65816 re-implementado/documentado através de *clean-room design* e tradução
reversa, além de ferramentas, documentação técnica e catálogos de dados textuais (nomes de
labels, endereços de memória, estruturas de dados, referências cruzadas) produzidos durante o
processo de análise. Nada disso reproduz a arte, o áudio ou o texto narrativo original do jogo.

## Validação de build

O código foi validado localmente (fora deste repositório) fazendo rebuild byte-perfect contra
uma ROM USA limpa (MD5 `c9bf36a816b6d54aed79d43a6c45111a`) — ver histórico em
[`decomp_process_log/`](./decomp_process_log). Para compilar e testar você mesmo, precisa
fornecer sua própria cópia legalmente adquirida da ROM (ver [`BUILD_GUIDE.md`](./BUILD_GUIDE.md)).

## Uso Aceitável (Fair Use)

Este repositório opera sob a doutrina de **Fair Use**, voltado para **interoperabilidade,
pesquisa e estudo educacional**. Não há intenção comercial ou de lucro, e este projeto não
substitui a obra original no mercado.

A propriedade intelectual, o título "Harvest Moon" (atualmente "Story of Seasons"), os
personagens e conceitos pertencem exclusivamente à Marvelous Inc., Natsume e respectivos
detentores de direitos.

## Terceiros

O diretório [`third_party/`](./third_party) contém o código-fonte do assembler
[asar](https://github.com/RPGHacker/asar), ferramenta de terceiros open source usada para
montar o código assembly — licença própria incluída no zip.
