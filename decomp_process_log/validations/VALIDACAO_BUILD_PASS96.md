# Validacao Build Pass 96

## Build command

```bash
./build_linux.sh
```

The build was run locally with the clean USA ROM placed temporarily at:

```text
project_buildable/roms/Harvest Moon (USA).sfc
```

The ROM and generated rebuild were removed before final packaging.

## MD5 validation

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte ao original.
```

## Final NO-ROM validation

Final tree scan result:

```text
.sfc files: 0
.smc files: 0
.fig files: 0
.swc files: 0
.rom files: 0
```

## Final audit

See:

```text
reports/pass96_final_audit_summary.md
reports/pass96_final_audit_matrix.csv
reports/pass96_rom_absence_scan.csv
```
