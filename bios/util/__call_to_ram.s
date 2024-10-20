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

    // Input:
	// - DI = pointer to code
	// - BP = size, in words
    // Preserve AX, BX, CX, DX, SI
    .global __call_to_ram
__call_to_ram:
    // Allocate stack
    sub sp, bp
    sub sp, bp
    push bp
    push cx
    mov bp, sp
    add bp, 4

    // Copy code to RAM
    push ds
    push es
    push si
    push di

    push cs
    pop ds
    push ss
    pop es
    mov si, di
    mov di, bp
    mov cx, [bp - 2]
    cld
    rep movsw

    pop di
    pop si
    pop es
    pop ds
    pop cx

    // Push return pointer
    push cs
    push offset __call_to_ram_ret
    // Push code pointer
    push ss
    push bp
    // Jump to code in RAM
    retf

__call_to_ram_ret:
    // Restore stack
    pop bp
    add sp, bp
    add sp, bp
    ret
