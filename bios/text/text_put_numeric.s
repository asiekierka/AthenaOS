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

// Scary...

#define FLAG_HEX        0x01
#define FLAG_PAD_SPACES 0x00
#define FLAG_PAD_ZEROES 0x02
#define FLAG_ALIGN_LEFT 0x04
#define FLAG_SIGNED     0x08
#define FLAG_DS_SI      0x80

text_num_table:
    .byte '0', '1', '2', '3', '4', '5', '6' ,'7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'

text_num_put_char_or_memory:
    test ax, ax // character == 0?
    jz .return

.wrap_put_char:
    test ch, FLAG_DS_SI
    jz 1f
    // write to DS:SI
    mov [si], al
    inc si
    ret

1:
    // write to display
    push cx
    mov cx, ax
    call text_put_char
    pop cx
    inc bl

.return:
    ret

text_num_put_signed:
    push ax
    mov ax, '-'
    call .wrap_put_char
    pop ax
    ret

/**
 * INT 13h AH=07h - text_put_numeric
 * Input:
 * - BL = X position
 * - BH = Y position
 * - CL = width
 * - CH = flags:
 *   - bit 0: output in hexademical
 *   - bit 1: pad with zeroes instead of spaces
 *   - bit 2: align to left instead of right  
 *   - bit 3: treat number as signed instead of unsigned
 *   - bit 7: use DS:SI as output buffer instead of screen
 * - DX = number
 * - DS:SI = buffer, optional
 * Output:
 */
    .global text_put_numeric
text_put_numeric:
    pusha
    mov bp, sp

    mov ax, dx // AX = number

    mov di, bp // DI = end
    sub sp, 8

    test ch, FLAG_SIGNED
    jz .no_signed
    // if signed, clear if number not signed
    test ah, 0x80
    jz .not_signed
    // convert to unsigned - we'll re-add the sign later
    neg ax
    jmp .no_signed
.not_signed:
    and ch, ~FLAG_SIGNED
.no_signed:

    // convert to string
    push bx

.loop:
    test ch, FLAG_HEX
    jz .div_deca
    mov dx, ax
    and dx, 0x000F
    shr ax, 4
    jmp .div_end
.div_deca:
    xor dx, dx
    mov bx, 10
    div bx
    // DX = number % n
    // AX = number / n
.div_end:
    mov bx, dx
    dec bp
    mov dl, cs:[text_num_table + bx]
    mov [bp], dl

    test ax, ax
    jnz .loop

    pop bx
    // end convert to string

    sub di, bp
    mov dx, di // DX = actual string length, BP = string start

    xor ax, ax // AX (pushed) = written byte count

    // handle alignment
    test cl, cl // is length provided?
    jz .align_end
    push cx
    test ch, FLAG_ALIGN_LEFT // no alignment if left-aligned
    jnz .align_put_signed

    cmp cl, dl
    jle .align_put_signed // no alingment if width <= string length

    sub cl, dl

    test ch, FLAG_PAD_ZEROES
    jnz .align_padzero
    test ch, FLAG_SIGNED
    mov ch, ' '             // pad with spaces - sign comes last
    jz .align_pad
    dec cl
    jmp .align_pad

.align_padzero:
    test ch, FLAG_SIGNED
    jz .align_padzero_unsigned
    call text_num_put_signed    // pad with zeroes - sign comes first
    dec cl
.align_padzero_unsigned:
    mov ch, '0'
.align_pad:
    push ax
    mov al, ch      // AH is already clear
    call text_num_put_char_or_memory
    pop ax
    dec cl
    jnz .align_pad

.align_put_signed:
    cmp ch, '0'
    pop cx
    je .align_end // pad with zeroes - sign comes first
    test ch, FLAG_SIGNED
    jz .align_end
    call text_num_put_signed

.align_end:
    mov cx, dx
    add ax, dx
    push ax
    xor ax, ax
.write_number_loop:
    mov al, [bp]      // AH is already clear
    call text_num_put_char_or_memory
    inc bp
    loop .write_number_loop

    xor ax, ax
    call text_num_put_char_or_memory
    pop ax

    add sp, 8

    popa
    ret
