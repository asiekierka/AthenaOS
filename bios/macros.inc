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

#define M_IRQ_PUSH_BX	(1)
#define M_IRQ_PUSH_CX	(2)
#define M_IRQ_PUSH_DX	(4)
#define M_IRQ_PUSH_SI	(8)
#define M_IRQ_PUSH_DI	(16)
#define M_IRQ_PUSH_DS	(32)
#define M_IRQ_PUSH_ES	(64)

.macro m_far_code_ptr address
	.word \address\(), 0xF000
.endm

/**
 * Create an IRQ table handler.
 *
 * @param jump_table_start Pointer to jump table (each word is a jump destination for subsequent AH=... values).
 * @param entry_count Number of entries in jump table; 0 to skip.
 * @param flags Flags for handler generation.
 */
.macro m_irq_table_handler jump_table_start, entry_count=0, flags=0
.if \entry_count > 0
	cmp ah, \entry_count
	jae 1f
.endif
.if \flags & M_IRQ_PUSH_ES
	push es
.endif
.if \flags & M_IRQ_PUSH_DS
	push ds
.endif
.if \flags & M_IRQ_PUSH_DI
	push di
.endif
.if \flags & M_IRQ_PUSH_SI
	push si
.endif
.if \flags & M_IRQ_PUSH_CX
	push cx
.endif
.if \flags & M_IRQ_PUSH_DX
	push dx
.endif
.if \flags & M_IRQ_PUSH_BX
	push bx
.endif
	push bp
	mov bp, bx
	xor bx, bx
	mov bl, ah
	shl bx, 1
	xchg bp, bx
	cs call [\jump_table_start + bp]
	pop bp
.if \flags & M_IRQ_PUSH_BX
	pop bx
.endif
.if \flags & M_IRQ_PUSH_DX
	pop dx
.endif
.if \flags & M_IRQ_PUSH_CX
	pop cx
.endif
.if \flags & M_IRQ_PUSH_SI
	pop si
.endif
.if \flags & M_IRQ_PUSH_DI
	pop di
.endif
.if \flags & M_IRQ_PUSH_DS
	pop ds
.endif
.if \flags & M_IRQ_PUSH_ES
	pop es
.endif
1:
.endm
