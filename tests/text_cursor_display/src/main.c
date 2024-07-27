// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <string.h>
#include <wonderful.h>
#include <ws.h>
#include <sys/bios.h>

uint8_t cur_y = 1;
uint8_t cur_rate = 0;
uint8_t cur_on = 1;

static void update_cursor(void) {
	cursor_display(cur_on);
	cursor_set_location(1, cur_y, 12, 1);
	cursor_set_type(1, cur_rate);
}

void main(void) {
	text_set_mode(0);
	text_screen_init();

	update_cursor();

	text_put_string(1, 1, " Highlight  ");
	text_put_string(1, 3, "No highlight");

	text_put_string(1, 13, "X1 - Toggle Y position");
	text_put_string(1, 14, "X2 - Toggle cursor blink");
	text_put_string(1, 15, "X3 - Toggle cursor on/off");
	text_put_string(2, 16,  "B - Exit");

	uint16_t key_in;
	while (true) {
		key_in = key_wait();
		if (key_in == KEY_B) break;

		if (key_in == KEY_X1) cur_y = 4 - cur_y;
		if (key_in == KEY_X2) cur_rate = 30 - cur_rate;
		if (key_in == KEY_X3) cur_on = 1 - cur_on;
		update_cursor();
	}
}

