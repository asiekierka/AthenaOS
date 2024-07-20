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

import argparse
import sys

parser = argparse.ArgumentParser(
    prog = 'concat_roms',
    description = 'Concatenates .RAW images to a ROM file.'
)
parser.add_argument('system')
parser.add_argument('soft')
parser.add_argument('output')

args = parser.parse_args()
system_data = None
soft_data = None

with open(args.system, "rb") as fin:
    system_data = fin.read()
with open(args.soft, "rb") as fin:
    soft_data = fin.read()
with open(args.output, "wb") as fout:
    fout.write(bytes([0xFF] * (384 * 1024)))
    fout.write(bytes(soft_data))
    fout.write(bytes([0xFF] * (65536 - len(soft_data))))
    fout.write(bytes(system_data))
    fout.write(bytes([0xFF] * (65536 - len(system_data))))

