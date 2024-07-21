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
 * INT 13h AH=04h - text_put_char
 * Input:
 * - BL = X position
 * - BH = Y position
 * - CX = character code
 * Output:
 */
    .global text_put_char
text_put_char:
    pusha
    push ds
    push es
    push ss
    push ss
    pop ds
    pop es

    cmp bl, [text_ww]
    jae text_put_char_end
    cmp bh, [text_wh]
    jae text_put_char_end

    cmp byte ptr [text_mode], TEXT_MODE_ANK
    je text_put_char_ank

text_put_char_sjis:
    cmp byte ptr [text_mode], TEXT_MODE_ANK_SJIS
    je text_put_char_ank_sjis

    // Shift-JIS only - map ASCII characters to SJIS font
    cmp cx, 0x80
    jae text_put_char_ank_sjis
    cmp cx, 0x20
    jb text_put_char_ank_sjis
    
    // CX = text_ank_sjis_table[CX - 0x20]
    xchg bx, cx
    add bx, bx
    cs mov bx, [bx + text_ank_sjis_table - 0x40]
    xchg bx, cx

text_put_char_ank_sjis:
    sub sp, 8
    mov dx, sp             // DS:DX = destination
    call text_get_fontdata

    mov al, bh
    xor bh, bh
    mul byte ptr [text_ww]
    add bx, ax
    add bx, [text_base]    // BX = text_base = y * text_ww + x
    mov cx, 1              // CX = 1
    call font_set_monodata

    add sp, 8
    jmp text_put_char_end

text_put_char_ank:
    cmp cx, 0x80 // for characters outside of range, use "?"
    jb 1f
    mov cx, '?'
1:
    push cx
    call __text_tilemap_at
    pop cx
    mov bx, ax
    mov al, [text_palette]
    shl ax, 9
    add cx, ax
    mov [bx], cx // [BX] = CX | (text_palette << 9)

text_put_char_end:
    pop es
    pop ds
    popa
    ret
