// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <string.h>
#include <wonderful.h>
#include <ws.h>
#include <sys/bios.h>

static const char __wf_rom text_mode_str0[] = "   ASCII   ";
static const char __wf_rom text_mode_str1[] = "ASCII/シフトジス";
static const char __wf_rom text_mode_str2[] = "   シフトジス   ";
static const char __wf_rom* __wf_rom text_mode_str[] = {
	text_mode_str0,
	text_mode_str1,
	text_mode_str2
};

void main(void) {
	int curr_mode = 0;

	while(1) {
		text_set_mode(curr_mode);
		text_screen_init();
		text_put_string(
			(28 - 11) >> 1,
			1,
			text_mode_str[curr_mode]
		);

		for (uint16_t ch = 32; ch < 127; ch++) {
			text_put_char(
				((28 - 16) >> 1) + (ch & 0xF),
				((18 - 6) >> 1) + (ch >> 4) - 2,
				ch
			);
		}

		while (true) {
			uint16_t k = key_wait();
			if (k == KEY_A) break;
			if (k == KEY_B) return;
		}

		curr_mode = (curr_mode + 1) % 3;
	}
}

