# Low-level WonderSwan coding tips

## Optimizing for space

In the BIOS, only ~8-9KB of code space is available after font data is factored in. This means that we need to be diligent about saving this space, particularly in non-hot codepaths.
Note that, since the `INT` instruction itself adds 35 clock cycles on V30MZ, losing a few more cycles is typically not a big deal on such paths.

- For rarely executed handlers which don't return any values, consider using `pusha` and `popa` for a simple way to push and pop `AX`, `BX`, `CX`, `DX`, `SI`, `DI` and `BP` in 17 cycles and 2 bytes; pushing and popping registers one by one costs 2 cycles and 2 bytes per register - in the worst-case scenario where you need six of seven (as BP is caller-saved), the difference is "12 cycles and 12 bytes" versus "17 cycles and 2 bytes".
- Optimizing stack segment usage:
  - The `ss` prefix is one way to access IRAM. It adds 1 byte and 1 cycle per instruction, sd it should be preferred for <= 4 accesses per function.
  - Another way is to set `DS` (or `ES`) to the stack segment: `push ds`; `push ss`; `pop ds`; ... `pop ds`. This takes 4 bytes and 10 cycles.
  - `push ds`; `push 0x0000`; `pop ds`; ... `pop ds` takes 5 bytes and 9 cycles.
  - `push ds`; `xor ax, ax`; `mov ds, ax`; ... `pop ds` takes 6 bytes and 8 cycles.
  - When both `DS` and `ES` are set to the stack segment, the above approach scales a little more favorably: 10 bytes and 15 cycles versus 8 bytes and 20 cycles.
