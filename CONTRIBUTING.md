# Contributing

There are a few ways to contribute to AthenaOS.

## Writing documentation

If there's a bug or unimplemented feature in AthenaOS, chances are it has not been documented as part of
FreyaBIOS/FreyaOS's behaviour, or the existing documentation is incorrect.

Once you've documented a difference or corrected a mistake, make sure to contribute it to publicly
available documentation. The best place to do so is the [WSdev Wiki](https://ws.nesdev.org/wiki/). However,
it requires manual account verification - contact Fiskbit or asie to get your account verified. In addition,
NESdev Wiki accounts can be used.

Note that documentation should focus on the *public API surface* - that is, calls and information available to
and made use of by user programs, and those implementation details which are known to affect said software. For
example, we care that an interrupt call fills a screen rectangle with a specified tile, but information on which
order it does so in may be unnecessary for implementing a compatible implementation. For more information, see
"A note on reverse engineering" below.

## Creating test programs

Instead of or in addition to writing documentation, one can create a test program which demonstrates the
operation of a given FreyaBIOS or FreyaOS functionality.

[Wonderful](https://wonderful.asie.pl/wiki/doku.php?id=wswan:index)) provides an open source WonderWitch development
kit which can be used to create such programs in C or assembly, though it's not entirely stable - caveat emptor.

## A note on reverse engineering

The recommended way to document FreyaBIOS/FreyaOS behaviour is to create example programs which demonstrate
it, as described above. This avoids any copyright infringement, allows documentation by mere observation,
and may also allow features such as automated regression testing in the future.

While binary disassembly can be an effective way to obtain knowledge, it can endanger the project's copyright
status if done improperly. In addition, some jurisdictions may prohibit its use as part of the development
process. As such, it is highly discouraged. Users nonetheless engaging in it should abstain from contributing
code to AthenaOS, except where such code has no relation to the code being disassembled.

In particular, **it is prohibited to share decompiled or disassembled code as part of any AthenaOS development process.**
This includes contributing decompiled or disassembled code, as well as transcribing such code into pseudocode.
Doing so could lead to the unintentional creation of derivative works of FreyaOS, which would as a result be
incompatibly licensed. As we cannot take chances on this, violators of this rule will be banned from
contributing to the project.

To get a good idea on where AthenaOS stands with regards to reverse engineering activities, studying the
[Asahi Linux copyright and reverse engineering guidelines](https://asahilinux.org/copyright/) is recommended
as an illustrative example.

Please note that neither the AthenaOS project nor any of its contributors can provide legal advice - if you're
worried something may lead to endangering the project's legal status, it is advised not to do it.

## Contributing patches

Another way to contribute is to write patches and code for missing functionality or bugfixes.

Note that your patch must not be based on FreyaBIOS/FreyaOS code, decompiled or otherwise. It should be
based on publicly available documentation, reproduction examples, et cetera.

To submit a patch, make a pull request on GitHub.

## Testing

Finally, you can test existing WonderWitch software to let us know if it is compatible or not:

1. Compile AthenaBIOS and AthenaOS (see the main README).
2. Run `python tools/build_rom.py output.wsc dist/AthenaBIOS*.raw dist/AthenaOS*.raw [.fx files...]` to build a ROM image for testing.
3. Run `output.wsc` in your emulator of choice - for debugging, one option is [wf-mednafen](https://github.com/WonderfulToolchain/wf-mednafen/releases).
