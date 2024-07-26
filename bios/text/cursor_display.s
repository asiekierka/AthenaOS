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

#include "../common.inc"

/**
 * INT 13h AH=10h - cursor_display
 * Input:
 * - AL = Mode
 * Output:
 */
    .global cursor_display
cursor_display:
    push bx
    // text_cursor_mode = (text_cursor_mode & 0xFE) | (AL & 0x01)
    mov bh, al
    ss mov bl, [text_cursor_mode]
    and bx, 0x01FE
    or bl, bh
    ss mov [text_cursor_mode], bl
    pop bx
    ret
