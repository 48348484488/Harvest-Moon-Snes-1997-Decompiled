# PlayerAction Held Object GOBJ Frame Tables

## `PlayerAction_SpawnHeldObjectGOBJFromActionFrame`

Entrada principal para criar o GOBJ visual associado a uma acao do jogador. A rotina usa `$0901` como indice/frame de acao, converte esse indice em entrada de 3 bytes na tabela `PlayerAction_HeldObjectGOBJFrameTripletTable`, preenche scratch registers e chama `GameOBJ_AllocateAndInitNewSlot`.

Pseudocodigo:

```text
frame = $0901
$0903 = frame
entry_offset = frame * 3
object_id = PlayerAction_HeldObjectGOBJFrameTripletTable[entry_offset + 0..1]
variant_or_page = PlayerAction_HeldObjectGOBJFrameTripletTable[entry_offset + 2]
$090F = variant_or_page << 6
spawn_or_update_gobj_at_player_position(object_id, $090F)
$0905 = allocated_gobj_slot
```

## `PlayerAction_UpdateHeldObjectGOBJFromActionFrame`

Atualiza a posicao do GOBJ para acompanhar o jogador. Se `$0901` mudou desde `$0903`, recalcula o triplet e reinicializa metadados do slot existente.

## `PlayerAction_FindFrameBucketFromThresholdTable`

Recebe um valor em A e percorre `PlayerAction_FrameBucketThresholdTable` para encontrar o primeiro bucket cujo threshold seja maior/igual ao valor. Usado por rotinas de acao do jogador para converter frame bruto em faixa logica.
