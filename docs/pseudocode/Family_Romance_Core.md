# Pseudocodigo - Family / Romance Core

## Atualizacao diaria de familia

```text
Family_DailyPregnancyAndChildGrowth():
    limpar flags temporarias de familia em family_event_flags

    if marriage_flags nao tem Maria/Ann/Nina/Ellen/Eve:
        return

    wife_pregnancy += 1

    esposa = esposa ativa em marriage_flags

    if primeiro filho ainda nao existe:
        required_hearts = 450
    else:
        required_hearts = 650

    if hearts[esposa] >= required_hearts:
        if wife_pregnancy >= 20:
            if house/event flags tem upgrade de casa nivel 2:
                if primeiro filho ainda nao existe:
                    child_flags |= primeiro_filho_existe
                else if kid1_age >= 90:
                    child_flags |= segundo_filho_existe

    if primeiro filho existe:
        kid1_age += 1
        if kid1_age == 60:
            child_flags |= evento_nascimento
            AddPlayerHappiness(50)
        else if (kid1_age - 60) % 120 == 0:
            family_event_flags |= milestone_idade_filho_1

    if segundo filho existe:
        kid2_age += 1
        if kid2_age == 60:
            child_flags |= evento_nascimento
            AddPlayerHappiness(100)
        else if (kid2_age - 60) % 120 == 0:
            family_event_flags |= milestone_idade_filho_2
```

## Nome da garota mais amada

```text
Romance_UpdateMostLovedGirlNameBuffer():
    maior = hearts_maria
    indice = Maria

    para cada garota restante:
        se hearts[garota] >= maior:
            maior = hearts[garota]
            indice = garota

    escrever nome da garota no buffer most_hearts_girl_name_1..5
```

Observacao: o uso de `>=` faz empates favorecerem a garota encontrada mais tarde na varredura, respeitando a ordem real da rotina.
