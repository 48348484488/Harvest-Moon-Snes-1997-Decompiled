# Pass 88 - EventScript Owner Precision Tiers
This pass does not change ROM bytes. It converts the broad Pass 87 owner buckets into deterministic precision tiers and refinement lanes.
## Summary
| Metric | Count | Percent |
|---|---:|---:|
| Total EventScript entries | 1288 | 100.000% |
| Exact/text-anchored owner | 68 | 5.280% |
| Domain-specific inferred owner | 268 | 20.807% |
| Structural owner lane still needing final exact name | 952 | 73.913% |
| Pass87 broad owners triaged into lanes | 960 | 74.534% |

## Remaining final-name work
The remaining rows are no longer unbucketed broad owners; they are split into specific refinement lanes in `pass88_remaining_final_name_targets.csv`.

## Top structural lanes
| Lane | Entries |
|---|---:|
| `StewCookingPotDialogueAlias::family_romance_matrix_lane` | 32 |
| `ObjectAnimalHouseUpgradeDialogHub::object_visual_setup_lane` | 16 |
| `ParentsVisitCameraMotionCutsceneSetup::family_romance_matrix_lane` | 16 |
| `TableDrivenCutsceneObjectScript_FA::family_romance_matrix_lane` | 16 |
| `TableDrivenEventScript_Opcode88Cluster::eve_family_romance_lane` | 16 |
| `MapTransitionDestinationRouter::family_romance_matrix_lane` | 16 |
| `AudioCueMusicSequenceTable_A::family_romance_matrix_lane` | 16 |
| `TableDrivenTransitionScript_D8Cluster_A::family_romance_matrix_lane` | 16 |
| `EventCore2TableDrivenSceneRouter::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_C0Cluster::eve_family_romance_lane` | 16 |
| `EventCore3TableDrivenSceneRouter::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_F2Cluster_A::eve_family_romance_lane` | 16 |
| `StateGateFlagRouter_MiscA::family_romance_matrix_lane` | 16 |
| `CCObjectParam3SetupCluster::family_romance_matrix_lane` | 16 |
| `TableDrivenEventScript_E5Cluster::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_B5Cluster::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_F3Cluster::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_D3Cluster::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_F2Cluster_B::eve_family_romance_lane` | 16 |
| `TableDrivenEventScript_5CCluster::eve_family_romance_lane` | 16 |
