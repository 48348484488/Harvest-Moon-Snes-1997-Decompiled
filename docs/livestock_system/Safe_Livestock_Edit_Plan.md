# Plano seguro para editar animais

## Nivel 1 - seguro

Alteracoes que normalmente nao quebram estrutura:

- renomear labels;
- alterar textos relacionados a animais;
- documentar offsets e flags;
- criar viewers/catalogos;
- trocar valores de spawn com o mesmo tamanho `dw`.

## Nivel 2 - medio

Requer build e teste no jogo:

- alterar posicoes de vacas/galinhas no barn/coop;
- alterar chances/penalidades de doenca;
- alterar dias de crescimento de pintinho/bezerro;
- alterar quantidade de felicidade perdida/ganha.

## Nivel 3 - arriscado

Nao fazer sem mapear save/renderer/eventos:

- aumentar limite de vacas/galinhas;
- adicionar novo tipo de animal;
- mudar tamanho dos slots em RAM;
- adicionar nova rotina de IA;
- inserir sprites completamente novos com novo ID.

## Ordem recomendada

1. Confirmar estruturas de RAM de cow/chicken.
2. Mapear todas as chamadas de `GetCowPointer` e `GetChickenPointer`.
3. Separar rotinas de render/spawn de rotinas de estado diario.
4. Fazer patch experimental pequeno: mudar spawn de uma galinha.
5. Fazer patch experimental pequeno: mudar tempo de crescimento de pintinho.
6. Somente depois tentar mexer em sprites/novo animal.
