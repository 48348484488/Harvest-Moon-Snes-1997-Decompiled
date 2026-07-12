# Bank80 Branch Cleanup - Pass 68

This pass does not reinterpret instruction bytes. It replaces anonymous branch labels in `bank_80.asm` with stable contextual labels:

```asm
CODE_80xxxx -> Bank80_MainLogicBranch_80xxxx
```

The goal is to make Bank 80 safer for future manual documentation. Bank 80 is now free of raw `CODE_` symbols in the buildable source.
