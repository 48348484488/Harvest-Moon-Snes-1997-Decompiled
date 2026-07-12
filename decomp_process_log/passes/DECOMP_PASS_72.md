# DECOMP PASS 72 - EventCmd Dispatch Audit 100%

Pass 72 corrects the EventInstructionPointers comment metadata so the automatic EventCmd dispatch audit reaches 100%.

## Closed area

- EventCmd dispatch audit: 47/90 -> 90/90.
- Missing audit entries: 43 -> 0.
- Opcodes $09 and $27-$50 now have EventCmd_XX symbolic comments.

## Safety

No opcode bytes or assembled data were changed. This pass only updates labels/comments/docs and keeps rebuild byte-perfect.
