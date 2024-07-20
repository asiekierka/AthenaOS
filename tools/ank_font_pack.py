#!/usr/bin/env python3
#
# Copyright (c) 2023 Adrian "asie" Siekierka
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from PIL import Image
import argparse
import struct
import sys

parser = argparse.ArgumentParser(
    prog = 'ank_font_pack',
    description = 'PNG to WonderWitch-format ASCII font converter'
)
parser.add_argument('input')
parser.add_argument('output')
args = parser.parse_args()

glyph_count = 128

# Read PNG glyph data.
glyphs = []

im = Image.open(args.input).convert("RGBA")
glyph_width = int(im.size[0] / 8)

with open(args.output, "wb") as fout:
    for i in range(0, glyph_count):
        ix = int(i % glyph_width)
        iy = int(i / glyph_width)
        row_data = []
        for gy in range(0, 8):
            b = 0
            for gx in range(0, 8):
                pxl = im.getpixel((ix*8+gx, iy*8+gy))
                if pxl[0] < 128:
                    b = b | (0x80 >> gx)
            row_data.append(b)

        fout.write(bytes(row_data))