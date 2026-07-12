# Pass 72 - EventCmd dispatch audit closure
A Pass 72 closes the automatic dispatch-table audit that remained inconsistent after Pass 71.
The EventScript decoder already had payload/name metadata for $00-$59, but the audit script checked the `EventInstructionPointers` comment table in `bank_84.asm`. Several comments still pointed to legacy branch aliases, so the audit reported only 47/90 covered.
## Result
| Metric | Before | After | Status |
|---|---:|---:|---|
| EventInstructionPointers audit coverage | 47/90 = 52.222% | 90/90 = 100.000% | closed |
| Missing dispatch comments | 43 | 0 | closed |
| EventCmd `$00-$59` comment symbols | partial | complete | closed |
| ROM bytes/source behavior | unchanged | unchanged | byte-perfect |

## Opcodes fixed in the audit table
`$09`, `$27-$50` now all use `EventCmd_XX_*` dispatch comments instead of legacy aliases.

## Audit output
```text
official_dispatch_entries=90
covered_symbolic_entries=90
coverage_percent=100.000
missing=none
```

## Note
This pass is a documentation/metadata closure only. It does not change emitted ROM bytes.
