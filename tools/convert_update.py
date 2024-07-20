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

# Special thanks to trap15's WSMan for documenting the algorithm.

import argparse
import sys

parser = argparse.ArgumentParser(
    prog = 'convert_update',
    description = 'WonderWitch binary (.raw) to/from update (.bin) converter'
)
parser.add_argument('input')
parser.add_argument('output')
parser.add_argument('-d', '--decrypt', action='store_true')

args = parser.parse_args()

with open(args.input, "rb") as fin:
    with open(args.output, "wb") as fout:
        i = 0
        prev_b = 0xFF
        while True:
            if (i & 0x7F) == 0:
                prev_b = 0xFF
            b = fin.read(1)
            if not b:
                break
            b = b[0]

            if args.decrypt:
                new_b = b ^ prev_b
                prev_b = b
                b = new_b
            else:
                b = b ^ prev_b
                prev_b = b
            
            fout.write(bytes([b]))
            i += 1



