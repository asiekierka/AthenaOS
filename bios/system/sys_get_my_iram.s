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

/**
 * INT 17h AH=11h - sys_get_my_iram
 * Input:
 * Output:
 * - AX = Pointer to memory allocated by specified CS
 */
    .global sys_get_my_iram
sys_get_my_iram:
    mov bp, sp

    // AX = handle to compare against
    mov ax, [bp + IRQ_TABLE_HANDLER_CS_OFFSET]
    // BP = current heap location
    mov bp, offset __heap_start

1:
    cmp [bp], ax
    je 7f // Found handle
    add bp, [bp + 2] // Advance to next heap block
    add bp, 4
    cmp bp, offset __heap_end
    jb 1b // Did not find end of heap

    xor ax, ax // Return NULL
    jmp 9f

7:
    // Found handle - return pointer to memory
    mov ax, bp
    add ax, 4

9:
    ret
