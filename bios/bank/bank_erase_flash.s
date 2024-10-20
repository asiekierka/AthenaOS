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
#include "bank/bank_macros.inc"

/**
 * INT 18h AH=09h - bank_erase_flash
 * Input:
 * - BX = Bank ID
 *   - 0000 ~ FFFF = ROM/Flash
 */
    .global bank_erase_flash
bank_erase_flash:
#if defined(BIOS_BANK_MAPPER_SIMPLE_ROM)
    jmp error_handle_write_to_rom
#else
#if defined(BIOS_BANK_MAPPER_SIMPLE_RAM)
    mov al, 0xFF
    or bh, 0x80
    xor cx, cx
    xor dx, dx
    call bank_fill_block
#else
    bank_rw_bx_to_segment_start es
    mov bp, offset __bank_erase_flash_ram_size
    mov di, offset __bank_erase_flash_ram
    call __call_to_ram
    bank_rw_bx_to_segment_end_unsafe
#endif
    xor ax, ax
    ret
#endif
