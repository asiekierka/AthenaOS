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

// Wrap around ROM indexes to support larger cartridges
// (bank_set_map variant)
.macro bank_adjust_wraparound_set_map reg_bl, reg_cx
#if BIOS_BANK_ROM_FORCE_COUNT > 0
    test \reg_bl, \reg_bl
    jz 1f // SRAM - skip

    or \reg_cx, (0xFFFF - BIOS_BANK_ROM_FORCE_COUNT)
1:
#endif
.endm

// Wrap around ROM indexes to support larger cartridges
// (bank_get_map variant)
.macro bank_adjust_wraparound_get_map reg_bl, reg_cx
#if BIOS_BANK_ROM_FORCE_COUNT > 0
    test \reg_bl, \reg_bl
    jz 1f // SRAM - skip

    and \reg_cx, (BIOS_BANK_ROM_FORCE_COUNT - 1)
1:
#endif
.endm

// Wrap around ROM indexes to support larger cartridges
// (bank_read variant)
.macro bank_adjust_wraparound_rw reg_bh, reg_bx
#if BIOS_BANK_ROM_FORCE_COUNT > 0
    test \reg_bh, 0x80
    jz 1f // SRAM - skip

    or \reg_bx, (0xFFFF - BIOS_BANK_ROM_FORCE_COUNT)
1:
#endif
.endm

// bank_get_map/bank_set_map helpers
#ifdef BIOS_BANK_MAPPER_2003
.macro bank_map_dx
    xor dh, dh
    add dx, dx
    add dx, 0x00D0
    cmp dx, 0x00D4
    ja 1f
.endm
.macro bank_map_read_ax_dx
    in ax, dx
.endm
.macro bank_map_write_ax_dx
    out dx, ax
.endm
#else
.macro bank_map_dx
    xor dh, dh
    add dx, 0x00C1
    cmp dx, 0x00C3
    ja 1f
.endm
.macro bank_map_read_ax_dx
    in al, dx
.endm
.macro bank_map_write_ax_dx
    out dx, al
.endm
#endif
