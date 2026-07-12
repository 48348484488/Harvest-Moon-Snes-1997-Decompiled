# EventCmd 1E/1F dynamic target payload model - PASS 76

Bank 84 shows that EventCmd `$1E` and `$1F` share the same handler. The command pointer `$C9` is first advanced past the opcode. The next word is then used dynamically:

```text
EventCmd_1E_1F:
    C9 += 1
    if player/object interaction gate is ready and A button is accepted:
        C9 = word_at(C9)
        initialize attached object / slot state
        advance slot progress counter
    else:
        C9 += 2
        advance slot progress counter
```

Therefore the symbolic decoder must treat `$1E` and `$1F` as commands with a 2-byte inline target word. The word is not an unknown opcode stream.

Correct symbolic forms:

```text
$1E target_lo target_hi -> WaitForInteractionReadyThenJump(target=$bank:target)
$1F target_lo target_hi -> WaitForInteractionReadyThenJumpDuplicate(target=$bank:target)
```

This closes 20 of the 26 Pass 75 non-B4 residual rows.
