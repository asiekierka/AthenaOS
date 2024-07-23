# AthenaBIOS development

## IRQ function calling convention

The calling convention for IRQ functions (implementations of INT xx/AH=xx calls) is as follows:

- AX is always callee-saved; that is, it must be saved by the function implementation if you modify it and don't return a value.
- BP is always *caller*-saved; that is, it is already preserved by `m_irq_table_handler` and thus can be modified freely.
- SS is always callee-saved. On entry, it is equal to 0x0000 - pointing to the console's internal RAM.
- BX, CX, DX, SI, DI, DS, ES are callee-saved by default, but may be caller-saved within some IRQ handlers.
- Arguments are passed in registers; the function declaration should include inputs, outputs, and (optionally) clobbers.
