# 🌾 Harvest Moon (SNES, 1997) - Decompilation Project

> **⚠️ AVISO LEGAL (DISCLAIMER EDUCACIONAL):**
> Este projeto foi criado **estritamente para fins educacionais, de pesquisa acadêmica, estudo de arquitetura de hardware e preservação histórica**. Este é um repositório sem fins lucrativos ou comerciais.
> 
> Todo o código aqui presente é resultado de engenharia reversa. **NENHUMA** ROM, imagem, faixa de áudio, texto ou ativo (asset) protegido por direitos autorais da Amccus, Natsume, Marvelous Inc. ou Nintendo está incluído neste repositório. 
>
> Para compilar ou utilizar as ferramentas deste projeto, o usuário deve possuir e extrair os recursos de sua própria cópia legalmente adquirida do jogo. A pirataria não é apoiada de forma alguma por este projeto.

## 📖 Sobre o Projeto

Este repositório contém o esforço de descompilação e engenharia reversa do clássico *Harvest Moon*, lançado originalmente para o Super Nintendo Entertainment System (SNES) em 1997. 

O objetivo principal deste repositório é documentar a lógica de programação da era dos 16-bits e entender como os primeiros jogos de simulação agrícola foram arquitetados lidando com as severas restrições de memória da época.

## 🎯 Objetivos de Estudo

* **Estudo da Arquitetura do SNES:** Compreender a interação com o processador Ricoh 5A22, gerenciamento de PPU (Picture Processing Unit) e o chip de áudio SPC700.
* **Engenharia Reversa e Assembly:** Praticar a leitura, documentação e tradução de código Assembly 65816.
* **Documentação de Engine:** Mapear estruturas de dados complexas, como o calendário interno do jogo, o sistema de crescimento de safras e as rotinas de inteligência artificial (IA) dos NPCs.

## 🛠️ Como Funciona (Build)

*(Nota: Adicione aqui as instruções de como rodar o seu projeto, lembrando sempre de focar que a pessoa precisa da própria ROM)*

1. Obtenha a sua própria ROM legalizada de *Harvest Moon (US)*.
2. Coloque o arquivo com o nome exato de `baserom.sfc` na pasta raiz.
3. Execute o script `make extract` para separar os *assets*.
4. Execute `make` para compilar o código fonte de volta em uma ROM funcional.

## ⚖️ Direitos Autorais

A propriedade intelectual, os personagens, a trilha sonora e a marca "Harvest Moon" (e "Story of Seasons") pertencem aos seus respectivos criadores e detentores de direitos. Este repositório não reivindica a posse de nenhuma dessas propriedades. 

Se você é fã da série, **apoie os desenvolvedores originais comprando os lançamentos e remakes oficiais mais recentes!**
