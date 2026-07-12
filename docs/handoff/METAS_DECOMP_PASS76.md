# METAS DECOMP PASS 76

## Done

- Corrected `$1E/$1F` symbolic payload length to 2 bytes.
- Closed 20 false non-B4 residuals that were target low bytes.
- Reduced remaining EventScript non-B4 residuals from 26 to 6.
- Preserved byte-perfect rebuild.

## Next pass

Focus only on the final 6 rows listed in `reports/pass76_eventscript_remaining_non_b4_residuals.csv`:

- `$00` entry 20 at `$B38DD7`
- `$09` entry 0 at `$B3E6D2`
- `$24` entries 0-3 at `$B4A486`, `$B4A542`, `$B4A56E`, `$B4A59A`

Do not treat them as official EventCmd gaps. The official dispatch is already 90/90.
