# Pass 75 - EventScript B4 inline tile/object payload closure

Pass 74 reduced the apparent EventScript problem to 99 true in-group residual markers. Pass 75 analyzes the dominant `$B4` pattern and separates it from real non-B4 residuals. `$B4` is above the official `$00-$59` EventCmd dispatch range and repeatedly appears after valid script prefixes followed by tile/object payload bytes such as `$02 $03 $06/$07`, coordinate words, direction/state bytes, and runtime flags. This pass therefore treats it as inline tile/object payload data reached by the conservative scanner, not as a missing official opcode.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Pass 74 true in-group residuals: `99`
- `$B4` inline tile/object payload residuals closed: `73`
- Remaining non-B4 residuals requiring trace: `26`
- Effective EventScript coverage after Pass 75: `99.697%`
- Groups closed at residual level after Pass 75: `63/72`

## Closure result

| Metric | Value | Status |
|---|---:|---|
| Official EventCmd dispatch audit | 90/90 | 100% closed |
| Pass 74 true in-group residuals | 99 | analyzed |
| `$B4` inline payload residuals | 73 | closed as data/payload |
| Remaining non-B4 residual markers | 26 | needs manual trace |
| Effective unresolved residual percent | 0.303% | reduced |

## Remaining groups

| Group | Remaining non-B4 residuals | Notes |
|---:|---:|---|
| `$01` | 7 | inspect inline pointer/text/flag payload around residual address |
| `$00` | 5 | inspect inline pointer/text/flag payload around residual address |
| `$24` | 4 | inspect inline pointer/text/flag payload around residual address |
| `$43` | 4 | inspect inline pointer/text/flag payload around residual address |
| `$0B` | 2 | inspect inline pointer/text/flag payload around residual address |
| `$02` | 1 | inspect inline pointer/text/flag payload around residual address |
| `$03` | 1 | inspect inline pointer/text/flag payload around residual address |
| `$09` | 1 | inspect inline pointer/text/flag payload around residual address |
| `$15` | 1 | inspect inline pointer/text/flag payload around residual address |

## Remaining residual bytes

| Byte | Hits |
|---:|---:|
| `$93` | 2 |
| `$5C` | 2 |
| `$EE` | 2 |
| `$7B` | 2 |
| `$5F` | 2 |
| `$81` | 1 |
| `$91` | 1 |
| `$C1` | 1 |
| `$CB` | 1 |
| `$62` | 1 |
| `$A8` | 1 |
| `$A4` | 1 |
| `$A3` | 1 |
| `$D2` | 1 |
| `$F3` | 1 |
| `$DB` | 1 |
| `$9B` | 1 |
| `$CD` | 1 |
| `$83` | 1 |
| `$68` | 1 |
| `$C4` | 1 |

## Groups closed by B4 overlay

`$17, $1B, $1C, $26, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $46, $47`

## Next pass target

The next useful target is the remaining non-B4 cluster: groups `$00`, `$01`, `$02`, `$03`, `$09`, `$0B`, `$15`, `$24`, and `$43`. These appear to be inline pointer/text/flag payload tails rather than official opcode gaps, but they need target-by-target tracing.
