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

	.section .start, "ax"
	.global _start
_start:
	cli
	cld

	// configure stack pointer, prepare ES for data/BSS
	xor ax, ax
	mov es, ax
	mov ss, ax
	mov ax, MEM_STACK_TOP
	mov sp, ax

	// initialize data/BSS
	push cs
	pop ds
	mov si, offset "__etext"
	mov di, offset "__sdata"
	mov cx, offset "__lwdata"
	rep movsw
	mov cx, offset "__lwbss"
	xor ax, ax
	rep stosw

	// initialize interrupt vectors
	mov di, ax
	mov si, offset "irq_handlers"
	mov cx, offset ((irq_handlers_end - irq_handlers) >> 1)
	mov ax, cs
1:
	movsw // offset
	stosw // segment
	loop 1b

	// initialize interrupts
	mov al, 0x08
	out IO_HWINT_VECTOR, al
	mov al, HWINT_VBLANK
	out IO_HWINT_ENABLE, al
	sti

	// jump to OS
	jmp 0xE000:0x0000

irq_handlers:
	.word error_handle_generic			// TODO: 0x00 (CPU - Divide exception)
	.word error_handle_generic			// TODO: 0x01 (CPU - Single step)
	.word error_handle_generic			// TODO: 0x02 (CPU - Non-maskable interrupt)
	.word error_handle_generic			// TODO: 0x03 (CPU - Break/INT 3)
	.word error_handle_generic			// TODO: 0x04 (CPU - Overflow/INTO)
	.word error_handle_generic			// TODO: 0x05 (CPU - BOUND)
	.word _start						// 0x06 (unused)
	.word _start 						// 0x07 (unused)
	.word hw_irq_serial_tx_handler		// 0x08 (HW - serial TX)
	.word hw_irq_key_handler			// 0x09 (HW - key)
	.word hw_irq_cartridge_handler		// 0x0A (HW - cartridge)
	.word hw_irq_serial_rx_handler		// 0x0B (HW - serial RX)
	.word hw_irq_line_handler			// 0x0C (HW - line)
	.word hw_irq_vblank_timer_handler	// 0x0D (HW - VBlank timer)
	.word hw_irq_vblank_handler			// 0x0E (HW - VBlank)
	.word hw_irq_hblank_timer_handler	// 0x0F (HW - HBlank timer)
	.word irq_exit_handler				// 0x10 (BIOS - Exit)
	.word irq_key_handler				// 0x11 (BIOS - Key)
	.word irq_disp_handler				// 0x12 (BIOS - Display)
	.word irq_text_handler				// 0x13 (BIOS - Text)
	.word error_handle_generic			// TODO: 0x14 (BIOS - Comm)
	.word irq_sound_handler				// 0x15 (BIOS - Sound)
	.word irq_timer_handler 			// 0x16 (BIOS - Timer)
	.word irq_system_handler			// 0x17 (BIOS - System)
	.word irq_bank_handler  			// 0x18 (BIOS - Bank)
irq_handlers_end:
