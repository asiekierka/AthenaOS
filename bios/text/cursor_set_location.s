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
 * INT 13h AH=12h - cursor_set_location
 * Input:
 * - BL = X position
 * - BH = Y position
 * - CL = Width, in tiles
 * - CH = Height, in tiles
 * Output:
 */
    .global cursor_set_location
cursor_set_location:
    pusha
    // Clear previous cursor location
    ss mov dl, [text_color]
    call __cursor_fill
    // Clear counter and "cursor turned on?" bit
    ss and word ptr [text_cursor_mode], 0x0001
    popa

    // Set new cursor location
    ss mov [text_cursor_x], bx
    ss mov [text_cursor_w], cx
    ret
