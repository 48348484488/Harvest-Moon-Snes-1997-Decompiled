# Build Guide v1.0

## 1. Required ROM

Place your clean USA ROM locally at:

```text
project_buildable/roms/Harvest Moon (USA).sfc
```

Expected MD5:

```text
c9bf36a816b6d54aed79d43a6c45111a
```

## 2. Linux build

From the package root:

```bash
./build_linux.sh
```

Expected result:

```text
MD5 rebuild: c9bf36a816b6d54aed79d43a6c45111a
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
OK: rebuild identico byte-a-byte ao original.
```

## 3. Windows build

From the package root:

```bat
build_windows.bat
```

## 4. Output

The local build creates files under:

```text
project_buildable/build/
```

Those generated ROM outputs are local build artifacts and must not be included in shared NO-ROM packages.

## 5. Final release rule

Before packaging or sharing, remove:

```text
project_buildable/roms/*.sfc
project_buildable/roms/*.smc
project_buildable/build/*.sfc
project_buildable/build/*.smc
```
