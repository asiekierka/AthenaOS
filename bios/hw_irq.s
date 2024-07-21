/**
 * Copyright (c) 2023, 2024 Adrian "asie" Siekierka
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

	.arch	i186
	.code16
	.intel_syntax noprefix

#include "common.inc"

    // AL = IRQ to acknowledge
    // BX = IRQ offset
    // assumes AX, BX preserved
irq_wrap_routine:
    push ax
    mov ax, ss:[bx]
    or ax, ss:[bx + 2]
    jz 1f

    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es

    mov ax, ss:[bx + 4]
    mov ds, ax
    ss lcall [bx]

    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
1:
    // Acknowledge interrupt
    pop ax
    out IO_HWINT_ACK, al
    ret

.macro irq_default_handler irq,idx
    push ax
    push bx
    mov al, \irq
    mov bx, offset (hw_irq_hook_table + (\idx * 8))
    call irq_wrap_routine
    pop bx
    pop ax
    iret
.endm

    .global hw_irq_serial_tx_handler
hw_irq_serial_tx_handler:
    irq_default_handler HWINT_SERIAL_TX,HWINT_IDX_SERIAL_TX

    .global hw_irq_key_handler
hw_irq_key_handler:
    irq_default_handler HWINT_KEY,HWINT_IDX_KEY

    .global hw_irq_cartridge_handler
hw_irq_cartridge_handler:
    irq_default_handler HWINT_CARTRIDGE,HWINT_IDX_CARTRIDGE

    .global hw_irq_serial_rx_handler
hw_irq_serial_rx_handler:
    irq_default_handler HWINT_SERIAL_RX,HWINT_IDX_SERIAL_RX

    .global hw_irq_line_handler
hw_irq_line_handler:
    irq_default_handler HWINT_LINE,HWINT_IDX_LINE

    .global hw_irq_vblank_timer_handler
hw_irq_vblank_timer_handler:
    irq_default_handler HWINT_VBLANK_TIMER,HWINT_IDX_VBLANK_TIMER

    .global hw_irq_hblank_timer_handler
hw_irq_hblank_timer_handler:
    irq_default_handler HWINT_HBLANK_TIMER,HWINT_IDX_HBLANK_TIMER

    .global hw_irq_vblank_handler
hw_irq_vblank_handler:
    push ax
    push bx
    push cx
    push ds
    push ss
    pop ds

    // Increment tick counter
    add word ptr [tick_count], 1
    adc word ptr [tick_count+2], 0

    // Scan key presses
    mov al, 0x10
    out IO_KEY_SCAN, al
    daa
    in  al, IO_KEY_SCAN
    and al, 0x0F
    mov ch, al

    mov al, 0x20
    out IO_KEY_SCAN, al
    daa
    in  al, IO_KEY_SCAN
    shl al, 4
    mov cl, al

    mov al, 0x40
    out IO_KEY_SCAN, al
    daa
    in  al, IO_KEY_SCAN
    and al, 0x0F
    or  cl, al

    // Update key variables
    mov ax, word ptr [keys_held]
    not ax
    and ax, cx
    // AX = keys pressed
    // CX = keys held
    mov word ptr [keys_pressed], ax
    mov word ptr [keys_held], cx
    // Process repeat:
    // - If new key pressed, reset timer to delay
    // - Otherwise:
    //   - Decrease timer by 1
    //   - If timer == 0, reset timer to rate and set pressed keys to held keys
    test ax, ax
    jz 1f

    // New key pressed
    mov bl, byte ptr [key_repeat_delay]
    mov byte ptr [key_repeat_timer], bl
    jmp 2f
1:
    // No new key pressed
    dec byte ptr [key_repeat_timer]
    // Timer still ticking?
    jnz 2f
    // Reset timer
    mov bl, byte ptr [key_repeat_rate]
    mov byte ptr [key_repeat_timer], bl
    // Set pressed keys to held keys
    mov ax, cx
2:
    mov word ptr [keys_pressed_repeat], ax

    // Call user IRQ routine
    mov al, HWINT_VBLANK
    mov bx, offset (hw_irq_hook_table + (HWINT_IDX_VBLANK * 8))
    call irq_wrap_routine

    pop ds
    pop cx
    pop bx
    pop ax
    iret

    .section ".data"
    .global key_repeat_rate
key_repeat_rate:  .byte 5  // ~65ms
    .global key_repeat_delay
key_repeat_delay: .byte 15 // ~200ms

    .section ".bss"
    .global hw_irq_hook_table
hw_irq_hook_table:
.rept 64 /* 8 IRQs x 8 bytes */
    .byte 0
.endr
    .global tick_count
tick_count: .word 0, 0
    .global keys_held
keys_held: .word 0
    .global keys_pressed
keys_pressed: .word 0
    .global keys_pressed_repeat
keys_pressed_repeat: .word 0
    .global key_repeat_timer
key_repeat_timer:  .byte 0
