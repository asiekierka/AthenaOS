# AthenaBIOS development

## Calling convention

To facilitate fast IRQ handling, the calling convention is a little strange:

- AX is always callee-saved.
- BP is always caller-saved.
- SS is always callee-saved. It is equal to 0x0000 (IRAM) on entry.
- BX, CX, DX, SI, DI, DS, ES are callee-saved by default, but may be caller-saved within some IRQ handlers.
- Arguments are passed in registers; the function declaration should include inputs, outputs, and (optionally) clobbers.

## Optimization tips

As only ~8-9KB of code space is available after font data is factored in, any non-hot interrupt handlers should
be optimized for size. The `INT` instruction itself adds 35 clock cycles on V30MZ, so losing a few more cycles
is typically not a big deal.

- For rarely executed handlers which don't return any values, consider using `pusha` and `popa` for a simple way to push and pop `AX`, `BX`, `CX`, `DX`, `SI`, `DI` and `BP` in 17 cycles and 2 bytes; pushing and popping registers one by one costs 2 cycles and 2 bytes per register - in the worst-case scenario where you need six of seven (as BP is caller-saved), the difference is "12 cycles and 12 bytes" versus "17 cycles and 2 bytes".
- Optimizing stack segment usage:
  - The `ss` prefix is one way to access IRAM. It adds 1 byte and 1 cycle per instruction, sd it should be preferred for <= 4 accesses per function.
  - Another way is to set `DS` (or `ES`) to the stack segment: `push ds`; `push ss`; `pop ds`; ... `pop ds`. This takes 4 bytes and 10 cycles.
  - `push ds`; `push 0x0000`; `pop ds`; ... `pop ds` takes 5 bytes and 9 cycles.
  - `push ds`; `xor ax, ax`; `mov ds, ax`; ... `pop ds` takes 6 bytes and 8 cycles.
  - When both `DS` and `ES` are set to the stack segment, the above approach scales a little more favorably: 10 bytes and 15 cycles versus 8 bytes and 20 cycles.
