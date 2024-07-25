// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <wonderful.h>
#include <sys/bios.h>

const char str_header[] = "text_put_numeric test:";

void main(void) {
	text_screen_init();

	text_put_string(0, 0, str_header);
	for (int i = 0; i < 16; i++) {
		text_put_numeric(0, i+2, 8, i, 1234);
		text_put_numeric(9, i+2, 8, i, -2345);
		text_put_numeric(18, i+2, 0, i, 3456);
	}

	while(key_wait() != KEY_B);
}
