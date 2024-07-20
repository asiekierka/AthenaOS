/**
 * Copyright (c) 2024 Adrian "asie" Siekierka
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution.
*/

#include <stdint.h>
#include <wonderful.h>

#define SJIS(row, column) ((((((row) + 1) >> 1) + 112) << 8) | (((row) & 1) ? ((column) + 31 + ((column) / 96)) : (column) + 126))
__attribute__((section(".text")))
const uint16_t text_ank_sjis_table[] = {
    SJIS(0x21, 0x21), // 
    SJIS(0x21, 0x2A), // !
    SJIS(0x21, 0x49), // "
    SJIS(0x21, 0x74), // #
    SJIS(0x21, 0x70), // $
    SJIS(0x21, 0x73), // %
    SJIS(0x21, 0x75), // &
    SJIS(0x21, 0x47), // '
    SJIS(0x21, 0x4A), // (
    SJIS(0x21, 0x4B), // )
    SJIS(0x21, 0x76), // *
    SJIS(0x21, 0x5C), // +
    SJIS(0x21, 0x24), // ,
    SJIS(0x21, 0x3E), // -
    SJIS(0x21, 0x25), // .
    SJIS(0x21, 0x73), // /
    SJIS(0x23, '0'),
    SJIS(0x23, '1'),
    SJIS(0x23, '2'),
    SJIS(0x23, '3'),
    SJIS(0x23, '4'),
    SJIS(0x23, '5'),
    SJIS(0x23, '6'),
    SJIS(0x23, '7'),
    SJIS(0x23, '8'),
    SJIS(0x23, '9'),
    SJIS(0x21, 0x27), // :
    SJIS(0x21, 0x28), // ;
    SJIS(0x21, 0x63), // <
    SJIS(0x21, 0x61), // =
    SJIS(0x21, 0x64), // >
    SJIS(0x21, 0x29), // ?
    SJIS(0x21, 0x77), // @
    SJIS(0x23, 'A'),
    SJIS(0x23, 'B'),
    SJIS(0x23, 'C'),
    SJIS(0x23, 'D'),
    SJIS(0x23, 'E'),
    SJIS(0x23, 'F'),
    SJIS(0x23, 'G'),
    SJIS(0x23, 'H'),
    SJIS(0x23, 'I'),
    SJIS(0x23, 'J'),
    SJIS(0x23, 'K'),
    SJIS(0x23, 'L'),
    SJIS(0x23, 'M'),
    SJIS(0x23, 'N'),
    SJIS(0x23, 'O'),
    SJIS(0x23, 'P'),
    SJIS(0x23, 'Q'),
    SJIS(0x23, 'R'),
    SJIS(0x23, 'S'),
    SJIS(0x23, 'T'),
    SJIS(0x23, 'U'),
    SJIS(0x23, 'V'),
    SJIS(0x23, 'W'),
    SJIS(0x23, 'X'),
    SJIS(0x23, 'Y'),
    SJIS(0x23, 'Z'),
    SJIS(0x21, 0x4E), // [
    SJIS(0x21, 0x6F),
    SJIS(0x21, 0x4F), // ]
    SJIS(0x21, 0x30), // ^
    SJIS(0x21, 0x32), // _
    SJIS(0x21, 0x2E), // `
    SJIS(0x23, 'a'),
    SJIS(0x23, 'b'),
    SJIS(0x23, 'c'),
    SJIS(0x23, 'd'),
    SJIS(0x23, 'e'),
    SJIS(0x23, 'f'),
    SJIS(0x23, 'g'),
    SJIS(0x23, 'h'),
    SJIS(0x23, 'i'),
    SJIS(0x23, 'j'),
    SJIS(0x23, 'k'),
    SJIS(0x23, 'l'),
    SJIS(0x23, 'm'),
    SJIS(0x23, 'n'),
    SJIS(0x23, 'o'),
    SJIS(0x23, 'p'),
    SJIS(0x23, 'q'),
    SJIS(0x23, 'r'),
    SJIS(0x23, 's'),
    SJIS(0x23, 't'),
    SJIS(0x23, 'u'),
    SJIS(0x23, 'v'),
    SJIS(0x23, 'w'),
    SJIS(0x23, 'x'),
    SJIS(0x23, 'y'),
    SJIS(0x23, 'z'),
    SJIS(0x21, 0x50), // {
    SJIS(0x21, 0x43), // |
    SJIS(0x21, 0x51), // }
    SJIS(0x21, 0x31)
};
