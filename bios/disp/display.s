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

	.align 2
irq_disp_handlers:
	.word display_control
	.word display_status
	.word font_set_monodata
	.word font_set_colordata
	.word font_get_data
	.word font_set_color
	.word font_get_color
	.word screen_set_char
	.word screen_get_char
	.word screen_fill_char
	.word screen_fill_attr
	.word sprite_set_range
	.word sprite_set_char
	.word sprite_get_char
	.word sprite_set_location
	.word sprite_get_location
	.word sprite_set_char_location
	.word sprite_get_char_location
	.word sprite_set_data
	.word screen_set_scroll
	.word screen_get_scroll
	.word screen2_set_window
	.word screen2_get_window
	.word sprite_set_window
	.word sprite_get_window
	.word palette_set_color
	.word palette_get_color
	.word lcd_set_color
	.word lcd_get_color
	.word lcd_set_segments
	.word lcd_get_segments
	.word lcd_set_sleep
	.word lcd_get_sleep
	.word screen_set_vram
	.word sprite_set_vram

	.global irq_disp_handler
irq_disp_handler:
	m_irq_table_handler irq_disp_handlers, 34
	iret

    .section ".bss"
    .global disp_font_color
disp_font_color: .byte 0
