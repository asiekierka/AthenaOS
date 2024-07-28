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

	.align 2
irq_sound_handlers:
	.word sound_init
	.word sound_set_channel
	.word sound_get_channel
	.word sound_set_output
	.word sound_get_output
	.word sound_set_wave
	.word sound_set_pitch
	.word sound_get_pitch
	.word sound_set_volume
	.word sound_get_volume
	.word sound_set_sweep
	.word sound_get_sweep
	.word sound_set_noise
	.word sound_get_noise
	.word sound_get_random

	.global irq_sound_handler
irq_sound_handler:
	m_irq_table_handler irq_sound_handlers, 15, 0, error_handle_irq21
	iret
